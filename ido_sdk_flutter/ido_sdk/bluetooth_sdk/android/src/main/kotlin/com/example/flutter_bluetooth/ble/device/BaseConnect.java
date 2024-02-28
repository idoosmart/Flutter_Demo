package com.example.flutter_bluetooth.ble.device;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCallback;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattDescriptor;
import android.bluetooth.BluetoothProfile;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;

import com.example.flutter_bluetooth.ble.config.BLEGattAttributes;
import com.example.flutter_bluetooth.ble.config.UUIDConfig;
import com.example.flutter_bluetooth.ble.callback.BluetoothCallback;
import com.example.flutter_bluetooth.ble.callback.UserCloseBluetoothCallBack;
import com.example.flutter_bluetooth.bt.HIDConnectManager;
import com.example.flutter_bluetooth.timer.ITimeOutPresenter;
import com.example.flutter_bluetooth.timer.TimeOutPresenter;
import com.example.flutter_bluetooth.utils.CommonUtils;
import com.example.flutter_bluetooth.logger.Logger;
import com.example.flutter_bluetooth.utils.PairedDeviceUtils;
import com.example.flutter_bluetooth.utils.PhoneInfoUtil;

import java.lang.reflect.Method;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Created by zhouzj on 2018/1/16.
 * 一个完整的连接流程如下：
 * 1. 连接设备
 * 2. 发现服务
 * 3. 开始通知
 * <p>
 * 只有这3步都成功了，才算真正的连接成功
 */
@SuppressLint("MissingPermission")
abstract class BaseConnect implements BluetoothCallback {

    private final static long DEFAULT_DISCONNECT_TIME_OUT = 3 * 1000;
    private final static long DEFAULT_CONNECT_TIME_OUT = 35 * 1000;
    private final static long DEFAULT_DISCOVER_SERVICES_TIME_OUT = 20 * 1000;

    private final static int WHAT_ENABLE_NOTIFICATION = 1;
    private final static long ENABLE_NOTIFICATION_TIMEOUT = 2000L;

    /**
     * 连接状态
     */
    private int mState = STATE_NOT_CONNECT;
    private static final int STATE_NOT_CONNECT = 1;
    private static final int STATE_CONNECTING = 2;
    private static final int STATE_CONNECTED = 3;

    private boolean mIsConnectedAndReady = false;
    private boolean mIsCanSendData = false;

    private BluetoothGatt mBluetoothGatt;

    private ITimeOutPresenter mITimeOutPresenter;


    //发现服务是否超时
    private AtomicBoolean mIsDiscoveryServiceTimeout = new AtomicBoolean(false);


    private final Handler mHandler = new Handler(Looper.getMainLooper());

    private String mDeviceAddress;

    private boolean mIsNeedHandGattCallback = true;

    BaseConnect(String deviceAddress) {
        mDeviceAddress = deviceAddress;
        init();
    }

    class GattCallback extends BluetoothGattCallback {
        @Override
        public void onConnectionStateChange(final BluetoothGatt gatt, final int status, final int newState) {
            // status 用于返回操作是否成功,会返回异常码。  newState 用于连接成功与否，返回连接码
            mITimeOutPresenter.stopConnectTimeOutTask();
            mITimeOutPresenter.stopDisconnectTimeOutTask();
            Logger.e("onConnectionStateChange: status = " + status + ", newState = " + newState);
            if (!mIsNeedHandGattCallback) {
                Logger.e("[BaseConnect:onConnectionStateChange()] onConnectionStateChange is called, but mIsNeedHandGattCallback is false");
                return;
            }
            CommonUtils.runOnMainThread(new Runnable() {
                @Override
                public void run() {
                    connectionStateChange(gatt, status, newState);
                }
            });

        }


        @Override
        public void onServicesDiscovered(final BluetoothGatt gatt, int status) {
            mITimeOutPresenter.stopDiscoverServicesTimeOutTask();
            //超时走了discoverServicesFailed()，此处需要拦截
            if (mIsDiscoveryServiceTimeout.getAndSet(false)) {
                Logger.p("[BaseConnect:servicesDiscovered()] discoverServices already timeout, should intercept");
                return;
            }
            if (status == BluetoothGatt.GATT_SUCCESS) {
                Logger.p("[BaseConnect:servicesDiscovered()] discoverServices ok!");
                disCoverServicesSuccess(gatt);
            } else {
                Logger.e("[BaseConnect:servicesDiscovered()] discoverServices failed");
                discoverServicesFailed();
            }
        }

        @Override
        public void onDescriptorWrite(BluetoothGatt gatt, BluetoothGattDescriptor descriptor, int status) {
            Logger.p("[BaseConnect:onDescriptorWrite] status:"+status+", descriptor:"+descriptor.getUuid());
            if (status == BluetoothGatt.GATT_SUCCESS) {
                if (UUIDConfig.CLIENT_CHARACTERISTIC_CONFIG_UUID.equals(descriptor.getUuid())) {
                    Logger.p("[BaseConnect:onDescriptorWrite] getvalue:" + descriptor.getValue()[0] + ", characteristicuuid:" + descriptor.getCharacteristic().getUuid());
                    //TODO 此处需解释
                    if (descriptor.getValue()[0] == 1) {
                        if (UUIDConfig.NOTIFY_UUID_NORMAL.equals(descriptor.getCharacteristic().getUuid())) {
                            enableHealthNotify(gatt);
                        } else if (UUIDConfig.NOTIFY_UUID_HEALTH.equals(descriptor.getCharacteristic().getUuid())) {
                            connectedAndReady();
                        }
                    } else {
                        enableNormalNotifyFailed();
                    }
                }
            } else {
                enableNormalNotifyFailed();
            }

        }

        @Override
        public void onCharacteristicWrite(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic, int status) {
            callOnCharacteristicWrite(gatt, characteristic, status);


        }

        @Override
        public void onCharacteristicChanged(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic) {
            callOnCharacteristicChanged(gatt, characteristic);
        }
    }

    private void init() {
        mITimeOutPresenter = new TimeOutPresenter();
    }

    protected void connect(long timeoutMills) {

        checkPhoneEnvInfo(mDeviceAddress);

        if (timeoutMills < DEFAULT_CONNECT_TIME_OUT) {
            timeoutMills = DEFAULT_CONNECT_TIME_OUT;
        }
//        if (bleDevice.mIsInDfuMode) {
//            Logger.e("[BaseConnect] device in dfu mode, not to connect , address is " + mDeviceAddress);
//            handleInDfuMode();
//            return;
//        }
        Logger.p("[BaseConnect] connect() , address is " + mDeviceAddress);

        checkThread();

        if (!BluetoothAdapter.checkBluetoothAddress(mDeviceAddress)) {
            Logger.e("[BaseConnect] connect() is refused, address is invalid");
            callOnConnectFailedByErrorMacAddress();
            return;
        }

        if (!BluetoothAdapter.getDefaultAdapter().isEnabled()) {
            Logger.e("[BaseConnect] connect() is refused, bluetooth is closed");
            callOnConnectFailedByBluetoothSwitchClosed();
            return;
        }
        if (!PhoneInfoUtil.hasPhoneBluetoothPermission()) {
            Logger.e("[ScanManager] hasPhoneBluetoothPermission false.");
            Logger.e("[ScanManager] " + PhoneInfoUtil.getPhoneBluetoothAndGPSInfo());
            callOnConnectFailedByErrorMacAddress();
            return;
        }
        if (mState == STATE_CONNECTING || mState == STATE_CONNECTED) {
            Logger.e("[BaseConnect] connect() is refused, state = " + mState);
            callOnConnecting();
            return;
        }

        Logger.p("[BaseConnect] start to connect " + mDeviceAddress);

        callOnConnectStart();

        BluetoothDevice bluetoothDevice = BluetoothAdapter.getDefaultAdapter().getRemoteDevice(mDeviceAddress);

        mITimeOutPresenter.startConnectTimeOutTask(new Runnable() {
            @Override
            public void run() {
                callConnectMethodSystemNoRespond();
            }
        }, timeoutMills);
        mIsNeedHandGattCallback = true;
        //连接双通道(BLE、经典)蓝牙必须设置
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && bluetoothDevice.getType() == BluetoothDevice.DEVICE_TYPE_DUAL) {
            mBluetoothGatt = bluetoothDevice.connectGatt(CommonUtils.getAppContext(), false, new GattCallback(), BluetoothDevice.TRANSPORT_LE);
        } else {
            mBluetoothGatt = bluetoothDevice.connectGatt(CommonUtils.getAppContext(), false, new GattCallback());
        }

        mState = STATE_CONNECTING;
        Logger.p("[BaseConnect] connecting " + mDeviceAddress);
        callOnConnecting();
    }

    /**
     * 连接指定mac地址，一般情况不会用到该方法，因为调用连接肯定是已经知道了mac
     * 注意：该方法主要用于当前设备连不上时，连接一个自定义的不存在的mac地址，用于切换设备
     * 注意：该方法主要用于当前设备连不上时，连接一个自定义的不存在的mac地址，用于切换设备
     * 注意：该方法主要用于当前设备连不上时，连接一个自定义的不存在的mac地址，用于切换设备
     * @param timeoutMills
     * @param mDeviceAddress
     */
    protected void connect(long timeoutMills,String mDeviceAddress) {

        checkPhoneEnvInfo(mDeviceAddress);

        if (timeoutMills < DEFAULT_CONNECT_TIME_OUT) {
            timeoutMills = DEFAULT_CONNECT_TIME_OUT;
        }
//        if (bleDevice.mIsInDfuMode) {
//            Logger.e("[BaseConnect] device in dfu mode, not to connect , address is " + mDeviceAddress);
//            handleInDfuMode();
//            return;
//        }
        Logger.p("[BaseConnect][" + this.mDeviceAddress + "] connect() , address is " + mDeviceAddress);

        checkThread();

        if (!BluetoothAdapter.checkBluetoothAddress(mDeviceAddress)) {
            Logger.e("[BaseConnect][" + this.mDeviceAddress + "] connect() is refused, address is invalid");
            callOnConnectFailedByErrorMacAddress();
            return;
        }

        if (!BluetoothAdapter.getDefaultAdapter().isEnabled()) {
            Logger.e("[BaseConnect][" + this.mDeviceAddress + "]  connect() is refused, bluetooth is closed");
            callOnConnectFailedByBluetoothSwitchClosed();
            return;
        }
        if (!PhoneInfoUtil.hasPhoneBluetoothPermission()) {
            Logger.e("[ScanManager][" + this.mDeviceAddress + "]  hasPhoneBluetoothPermission false.");
            Logger.e("[ScanManager][" + this.mDeviceAddress + "]  " + PhoneInfoUtil.getPhoneBluetoothAndGPSInfo());
            callOnConnectFailedByErrorMacAddress();
            return;
        }
        if (mState == STATE_CONNECTING || mState == STATE_CONNECTED) {
            Logger.e("[BaseConnect][" + this.mDeviceAddress + "]  connect() is refused, state = " + mState);
            callOnConnecting();
            return;
        }

        Logger.p("[BaseConnect][" + this.mDeviceAddress + "]  start to connect " + mDeviceAddress);

        callOnConnectStart();

        BluetoothDevice bluetoothDevice = BluetoothAdapter.getDefaultAdapter().getRemoteDevice(mDeviceAddress);

        mITimeOutPresenter.startConnectTimeOutTask(new Runnable() {
            @Override
            public void run() {
                callConnectMethodSystemNoRespond();
            }
        }, timeoutMills);
        mIsNeedHandGattCallback = true;
        //连接双通道(BLE、经典)蓝牙必须设置
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && bluetoothDevice.getType() == BluetoothDevice.DEVICE_TYPE_DUAL) {
            mBluetoothGatt = bluetoothDevice.connectGatt(CommonUtils.getAppContext(), false, new GattCallback(), BluetoothDevice.TRANSPORT_LE);
        } else {
            mBluetoothGatt = bluetoothDevice.connectGatt(CommonUtils.getAppContext(), false, new GattCallback());
        }

        mState = STATE_CONNECTING;
        Logger.p("[BaseConnect][" + this.mDeviceAddress + "]  connecting " + mDeviceAddress);
        callOnConnecting();
    }

    /**
     * 打印与手机配对信息
     */
    private void checkPhoneEnvInfo(String macAddress) {
        BluetoothDevice pairedDevice = PairedDeviceUtils.getPairedDevice(macAddress);

        if (pairedDevice == null) {
            Logger.p("[BaseConnect] printPhoneEnvInfo, not paired!");
        } else {
            boolean isConnectedByPhone = PairedDeviceUtils.isConnected(pairedDevice);
            Logger.p("[BaseConnect] printPhoneEnvInfo, has paired, isConnectedByPhone=" + isConnectedByPhone);
//            if (CustomConfig.getConfig().isNeedRemoveBondBeforeConnect()) {
//                //如果设备支持与手机系统蓝牙配对，则不要移除配对
//                if (!PairedDeviceUtils.isDeviceSupportPairedWithPhoneSystem()) {
//                    boolean isSuccess = PairedDeviceUtils.removeBondState(pairedDevice);
//                    Logger.p("[BaseConnect] printPhoneEnvInfo, remove bond status is =" + isSuccess);
//                }
//
//            }
        }

        String msg = PhoneInfoUtil.getPhoneBluetoothAndGPSInfo();
        if (!TextUtils.isEmpty(msg)) {
            Logger.e("[BaseConnect] printPhoneEnvInfo, " + msg);
        }
    }

    protected void connect() {
        connect(DEFAULT_CONNECT_TIME_OUT);
    }

    protected void connect(String mac) {
        connect(DEFAULT_CONNECT_TIME_OUT, mac);
    }


    private void handleConnectSuccessState(final BluetoothGatt gatt, int status, int newState) {
        if (mState == STATE_CONNECTED) {
            Logger.p("[BaseConnect:connectionStateChange()] in connected state, not do next steps!");
            return;
        }
        mState = STATE_CONNECTED;
        Logger.p("[BaseConnect:connectionStateChange()] gatt connected.");

        startToDiscoverServices(gatt);
    }

    private void handleConnectBreakState(int status, int newState) {
        //之前是连接的状态
        if (mState == STATE_CONNECTED) {
            Logger.e("[BaseConnect:connectionStateChange()] connect break");

            closeConnect();
            callOnConnectBreakByGATT(status, newState);

            boolean isBluetoothOpen = BluetoothAdapter.getDefaultAdapter().isEnabled();
            if (!isBluetoothOpen) {
                Logger.e("[BaseConnect:connectionStateChange()] user close bluetooth");
                UserCloseBluetoothCallBack.onUserCloseBluetooth();
            } else {
                Logger.e("[BaseConnect:connectionStateChange()] bluetooth is open");
            }

        } else {

            closeConnect();
            Logger.e("[BaseConnect:connectionStateChange()] connect failed");
            callOnConnectFailedByGATT(status, newState);
        }


    }

    private void handleConnectFailedState(int status, int newState) {
        closeConnect();
        Logger.e("[BaseConnect:connectionStateChange()] connect failed");
        callOnConnectFailedByGATT(status, newState);
    }

    //某些手机在关闭蓝牙开关之后，不会回调该接口
    private void connectionStateChange(final BluetoothGatt gatt, int status, int newState) {
        Logger.p("[BaseConnect:connectionStateChange()] status = " + status + ",newState = " + newState);
        //连接管理状态
        if (status == BluetoothGatt.GATT_SUCCESS) {//status=0
            //连接成功
            if (newState == BluetoothProfile.STATE_CONNECTED) {//newState=2
                handleConnectSuccessState(gatt, status, newState);
            } else {//newState!=2
                //连接断开
                handleConnectBreakState(status, newState);
            }

        } else {//status!=0
            //操作失败
            if (mState == STATE_CONNECTED) {
                handleConnectBreakState(status, newState);
            } else {
                handleConnectFailedState(status, newState);
            }

        }
    }

    private void startToDiscoverServices(final BluetoothGatt gatt) {
        Logger.p("[BaseConnect:connectionStateChange()] start to discoverServices...");
        mIsDiscoveryServiceTimeout.set(false);
        mITimeOutPresenter.startDiscoverServicesTimeOutTask(new Runnable() {
            @Override
            public void run() {
                Logger.p("[BaseConnect:connectionStateChange()] discoverServices time out");
                mIsDiscoveryServiceTimeout.set(true);
                discoverServicesFailed();
            }
        }, DEFAULT_DISCOVER_SERVICES_TIME_OUT);

        if (!gatt.discoverServices()) {
            Logger.e("[BaseConnect:connectionStateChange()] discover services failed, retry...");
            mHandler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    //再次开启服务失败
                    if (!gatt.discoverServices()) {
                        Logger.e("[BaseConnect:connectionStateChange()] discover services failed again");

                        mITimeOutPresenter.stopDiscoverServicesTimeOutTask();
                        discoverServicesFailed();
                    }
                }
            }, 50);
        }
    }

    private void discoverServicesFailed() {
        Logger.e("[BaseConnect] discoverServicesFailed..");
        CommonUtils.runOnMainThread(new Runnable() {
            @Override
            public void run() {
                disConnect(0);
                closeConnect();
                callOnDiscoverServiceFailed();
            }
        });

    }

    private void disCoverServicesSuccess(final BluetoothGatt gatt) {
        if (isInDfuMode(gatt)) {
            Logger.e("[BaseConnect] device in dfu mode");
            handleInDfuMode();
            return;
        }
        if (isInDw02DfuMode(gatt)) {
            Logger.e("[BaseConnect] device  dw02 in dfu mode");
            callOnInDfuMode();
        }
        if (HIDConnectManager.isNeedCreateBond(gatt)) {
            Logger.p("[BaseConnect] is need create bond");
            HIDConnectManager.getManager().connect(gatt.getDevice(), new HIDConnectManager.IBondStateListener() {
                @Override
                public void onBonded(String macAddress) {
                    Logger.p("[BaseConnect] create bond finished.");
                    enableNormalNotify(gatt);
                }
            });
        } else {
            mHandler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    enableNormalNotify(gatt);
                }
            }, 100);
        }


    }

    private void handleInDfuMode() {
        Logger.e("[BaseConnect] handleInDfuMode...");
        CommonUtils.runOnMainThread(new Runnable() {
            @Override
            public void run() {
//                disConnect(0);
                closeConnect();
                callOnInDfuMode();
            }
        });
    }

    private void enableNormalNotify(final BluetoothGatt gatt) {
        Logger.p("[BaseConnect] start to enablePeerDeviceNotifyNormal...");
        boolean notifyNormal = BLEGattAttributes.enablePeerDeviceNotifyNormal(gatt, true);
        if (notifyNormal) {
            Logger.p("[BaseConnect] enablePeerDeviceNotifyNormal ok");
        } else {
            Logger.p("[BaseConnect] enablePeerDeviceNotifyNormal failed, retry...");
            mHandler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    //开启“正常”通知
                    boolean notifyNormal = BLEGattAttributes.enablePeerDeviceNotifyNormal(gatt, true);
                    if (!notifyNormal) {
                        enableNormalNotifyFailed();
                        Logger.e("[BaseConnect] enablePeerDeviceNotifyNormal reEnable failed");
                    } else {
                        Logger.p("[BaseConnect] enablePeerDeviceNotifyNormal reEnable ok");
                    }
                }
            }, 50);
        }
    }

    private void enableNormalNotifyFailed() {
        Logger.e("[BaseConnect] enableNormalNotifyFailed...");
        CommonUtils.runOnMainThread(new Runnable() {
            @Override
            public void run() {
                disConnect(0);
                closeConnect();
                callOnEnableNormalNotifyFailed();
            }
        });

    }

    private void enableHealthNotify(final BluetoothGatt gatt) {
        Logger.p("[BaseConnect] start to enablePeerDeviceNotifyHealth...");
        boolean enable = BLEGattAttributes.enablePeerDeviceNotifyHealth(gatt, true);
        if (enable) {
            Logger.p("[BaseConnect] enablePeerDeviceNotifyHealth ok");

        } else {
            Logger.p("[BaseConnect] enablePeerDeviceNotifyHealth failed, retry...");
            mHandler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    boolean enable = BLEGattAttributes.enablePeerDeviceNotifyHealth(gatt, true);
                    if (!enable) {
                        Logger.e("[BaseConnect] enablePeerDeviceNotifyHealth reEnable failed");
                        enableHealthNotifyFailed();
                    } else {
                        Logger.p("[BaseConnect] enablePeerDeviceNotifyHealth reEnable ok");
                    }
                }
            }, 50);
        }
    }

    private void enableHealthNotifyFailed() {
        Logger.e("[BaseConnect] enableHealthNotifyFailed...");
        CommonUtils.runOnMainThread(new Runnable() {
            @Override
            public void run() {
                disConnect(0);
                closeConnect();
                callOnEnableHealthNotifyFailed();
            }
        });

    }


    private void connectedAndReady() {
        if (mIsConnectedAndReady) {
            Logger.e("[BaseConnect] It's already connected and ready!");
            return;
        }
        Logger.p("[BaseConnect] connected success.");
        mIsConnectedAndReady = true;
        mIsCanSendData = true;
        callOnConnectedAndReady();
    }


    private void refreshDeviceCache(BluetoothGatt gatt) {
        if (!BluetoothAdapter.getDefaultAdapter().isEnabled()) {
            return;
        }
        try {
            Method refresh = gatt.getClass().getMethod("refresh", new Class[0]);
            if (refresh != null) {
                refresh.invoke(gatt, new Object[0]);
            }
        } catch (Exception e) {
            Logger.e(e.toString());
        }
    }

    private void checkThread() {
        if (Looper.myLooper() != Looper.getMainLooper()) {
            throw new RuntimeException("you should call this method on Main-Thread.");
        }
    }

    private boolean isInDfuMode(BluetoothGatt gatt) {
        return gatt.getService(UUIDConfig.RX_UPDATE_UUID) != null || gatt.getService(UUIDConfig.RX_UPDATE_UUID_0XFE59) != null;

    }

    private boolean isInDw02DfuMode(BluetoothGatt gatt) {
        return gatt.getService(UUIDConfig.RX_UPDATE_UUID_0X0203) != null;

    }

    protected BluetoothGatt getGatt() {
        return mBluetoothGatt;
    }


    protected String getCurrentDevice() {
        return mDeviceAddress;
    }

    /**
     * 断开（必须要在主线程调用该方法）
     */
    protected void disConnect() {
        Logger.p("[BaseConnect] to disconnect(" + mDeviceAddress + ").");
        mIsConnectedAndReady = false;
        CommonUtils.runOnMainThread(new Runnable() {
            @Override
            public void run() {
                disConnect(DEFAULT_DISCONNECT_TIME_OUT);
            }
        });
    }

    private void disConnect(long delayTime) {
        checkThread();

        if (mBluetoothGatt == null) {
            Logger.p("[BaseConnect] disconnect failed, mBluetoothGatt is null.");
            callDisconnectMethodSystemNoRespond();
            return;
        }

        if (delayTime != 0) {
            mIsNeedHandGattCallback = true;
            mITimeOutPresenter.startDisconnectTimeOutTask(new Runnable() {
                @Override
                public void run() {
                    callDisconnectMethodSystemNoRespond();
                }
            }, delayTime);
        } else {
            mIsNeedHandGattCallback = false;
        }

        mBluetoothGatt.disconnect();

    }

    protected boolean isConnectedAndReady() {
        return mIsConnectedAndReady && mBluetoothGatt != null;
    }

    protected boolean isCanSendData() {
        return mIsCanSendData && mBluetoothGatt != null;
    }

    protected boolean isGattConnecting() {
        return mBluetoothGatt != null && (mState == STATE_CONNECTED || mState == STATE_CONNECTING);
    }


    private void closeConnect() {
        Logger.p("[BaseConnect] close()");

        checkThread();

        if (mITimeOutPresenter != null) {
            mITimeOutPresenter.stopConnectTimeOutTask();
            mITimeOutPresenter.stopDisconnectTimeOutTask();
            mITimeOutPresenter.stopDiscoverServicesTimeOutTask();
        }

        mState = STATE_NOT_CONNECT;
        mIsConnectedAndReady = false;
        mIsCanSendData = false;
        mHandler.removeCallbacksAndMessages(null);


        if (mBluetoothGatt != null) {
            refreshDeviceCache(mBluetoothGatt);
            mBluetoothGatt.close();
            mBluetoothGatt = null;
        }

        callOnConnectClosed();

    }

    private void callConnectMethodSystemNoRespond() {
        Logger.e("[BaseConnect] callConnectMethodSystemNoRespond()");
        closeConnect();

        callOnConnectTimeOut();
    }

    private void callDisconnectMethodSystemNoRespond() {
        Logger.e("[BaseConnect] callDisconnectMethodSystemNoRespond()");
        closeConnect();
        callOnConnectBreakByGATT(0xff, 0xff);
    }

}
