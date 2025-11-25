package com.example.flutter_bluetooth.ble.device;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCallback;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattDescriptor;
import android.bluetooth.BluetoothGattService;
import android.bluetooth.BluetoothProfile;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;

import com.example.flutter_bluetooth.Config;
import com.example.flutter_bluetooth.ble.config.BLEGattAttributes;
import com.example.flutter_bluetooth.ble.config.UUIDConfig;
import com.example.flutter_bluetooth.ble.callback.BluetoothCallback;
import com.example.flutter_bluetooth.ble.callback.UserCloseBluetoothCallBack;
import com.example.flutter_bluetooth.bt.HIDConnectManager;
import com.example.flutter_bluetooth.bt.LePairConnectManager;
import com.example.flutter_bluetooth.timer.ITimeOutPresenter;
import com.example.flutter_bluetooth.timer.TimeOutPresenter;
import com.example.flutter_bluetooth.utils.ByteDataConvertUtil;
import com.example.flutter_bluetooth.utils.CommonUtils;
import com.example.flutter_bluetooth.logger.Logger;
import com.example.flutter_bluetooth.utils.PairedDeviceUtils;
import com.example.flutter_bluetooth.utils.PhoneInfoUtil;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;

import kotlin.Unit;
import kotlin.jvm.functions.Function1;

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
    private final static long DEFAULT_READ_CHARACTERISTIC_TIME_OUT = 5 * 1000;

    private final static int WHAT_ENABLE_NOTIFICATION = 1;
    private final static long ENABLE_NOTIFICATION_TIMEOUT = 2000L;

    /**
     * 连接状态
     */
    private int mState = STATE_NOT_CONNECT;
    private static final int STATE_NOT_CONNECT = 1;
    private static final int STATE_CONNECTING = 2;
    private static final int STATE_CONNECTED = 3;

    private static int current_reytime  = 0;//当前重试次数

    private boolean mIsConnectedAndReady = false;
    private boolean mIsCanSendData = false;

    private BluetoothGatt mBluetoothGatt;

    private ITimeOutPresenter mITimeOutPresenter;


    //发现服务是否超时
    private AtomicBoolean mIsDiscoveryServiceTimeout = new AtomicBoolean(false);


    private final Handler mHandler = new Handler(Looper.getMainLooper());

    private String mDeviceAddress;

    private boolean mIsNeedHandGattCallback = true;
    private int current_read_characteristic_times = 0;

    protected int platform;

    private boolean alreadyCallbackPairSuccess = false;
    private int pair_flag = 0;
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
                    DeviceBusinessManager.checkBindState(gatt.getDevice().getAddress(), new Function1<Boolean, Unit>() {
                        @Override
                        public Unit invoke(Boolean aBoolean) {
                            Logger.p("[BaseConnect:onConnectionStateChange()] BindState = " + aBoolean + " , current_reytime = " + current_reytime);
                            if(!aBoolean && current_reytime < 2){
                                if(status == 133 || status == 147 || status == 62){
                                    Logger.p("[BaseConnect:onConnectionStateChange()] onConnectionStateChange retry connect reytime = " + current_reytime);
                                    closeConnect();
                                    mHandler.postDelayed(new Runnable() {
                                        @Override
                                        public void run() {
                                            Logger.p("[BaseConnect:onConnectionStateChange()] 延时重连 mDeviceAddress = " + mDeviceAddress);
                                            connect(DEFAULT_CONNECT_TIME_OUT,mDeviceAddress); //需要调用这个，connect 里面有重置次数
                                        }
                                    },1600);
                                    current_reytime++;
                                }else {
                                    connectionStateChange(gatt, status, newState);
                                }
                            }else{
                                connectionStateChange(gatt, status, newState);
                            }
                            return null;
                        }
                    });
//                    connectionStateChange(gatt, status, newState);
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
            Logger.p("[BaseConnect:onDescriptorWrite] status:" + status + ", descriptor:" + descriptor.getUuid());
            if (status == BluetoothGatt.GATT_SUCCESS) {
                if (UUIDConfig.CLIENT_CHARACTERISTIC_CONFIG_UUID.equals(descriptor.getUuid())) {
                    Logger.p("[BaseConnect:onDescriptorWrite] getvalue:" + descriptor.getValue()[0] + "characteristicuuid:" + descriptor.getCharacteristic().getUuid());
                    //TODO 此处需解释
                    if (descriptor.getValue()[0] == 1) {
                        if (UUIDConfig.NOTIFY_UUID_NORMAL.equals(descriptor.getCharacteristic().getUuid())) {
                            if (mBondStateBroadcastReceiver != null) {
                                Config.getApplication().unregisterReceiver(mBondStateBroadcastReceiver);
                                mBondStateBroadcastReceiver = null;
                                bondCallBack = null;
                            }
                            mITimeOutPresenter.stopEnableNotifyOutTask();
                            mITimeOutPresenter.stopLEPairResultWaitTimeOutTask();
                            alreadyCallbackPairSuccess = true;
                            enableHealthNotify(gatt);
                            // enableHenxuanNotify(gatt);
                        } else if (UUIDConfig.NOTIFY_UUID_HEALTH.equals(descriptor.getCharacteristic().getUuid())) {
                            if (BLEGattAttributes.isContainsHenxuanService(gatt)) {
                                BLEGattAttributes.platform = BLEGattAttributes.PLATFORM_HENXUAN;
                                enableHenxuanNotify(gatt);
                            } else if (BLEGattAttributes.isContainsVCService(gatt)) {
                                BLEGattAttributes.platform = BLEGattAttributes.PLATFORM_VC;
                                enableVCNotify(gatt);
                            } else {
                                BLEGattAttributes.platform = BLEGattAttributes.PLATFORM_IDO;
                                connectedAndReady();
                            }
                            Logger.p("[BaseConnect:onDescriptorWrite] BLEGattAttributes.platform:" + BLEGattAttributes.platform);
                        } else if (UUIDConfig.NOTIFY_UUID_HENXUAN.equals(descriptor.getCharacteristic().getUuid()) || UUIDConfig.NOTIFY_UUID_VC.equals(descriptor.getCharacteristic().getUuid())) {
                            connectedAndReady();
                        }else if(UUIDConfig.NOTIFY_UUID_ENCRYPT_BGC.equals(descriptor.getCharacteristic().getUuid())){
                            Logger.p("[BaseConnect:onDescriptorWrite] enable bond character complete!" );
                            if (LePairConnectManager.isNeedCreateLePair(gatt,pair_flag)) {
                                Logger.p("[BaseConnect:pair] start pair ");
                                mITimeOutPresenter.startLEPairTimeOutTask(new Runnable() {
                                    @Override
                                    public void run() {
                                        Logger.p("[BaseConnect:pair] LEPair time out ");
                                        callOnEnableNormalNotifyFailed();
                                    }
                                },35 * 1000);
                                LePairConnectManager.getManager().connect(gatt.getDevice(), new LePairConnectManager.IBondStateListener() {
                                    @Override
                                    public void onBonded(String macAddress) {
                                        Logger.p("[BaseConnect:pair] onBonded = " + macAddress );
                                        mITimeOutPresenter.stopLEPairTimeOutTask();
                                        enableNormalNotify(gatt);
                                    }

                                    @Override
                                    public void onBondFailed(String macAddress) {
                                        Logger.p("[BaseConnect:pair] onBondFailed = " + macAddress );
                                    }
                                });
                            }else{
                                Logger.p("[BaseConnect:pair] don't need pair , start enable normal notify ");
                                enableNormalNotify(gatt);
                            }
//                            //0af8使能成功，
//                            enableNormalNotify(gatt);
                        }
                    } else {
                        callOnEnableNormalNotifyFailed();
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
            if (UUIDConfig.NOTIFY_UUID_ENCRYPT_BGC.equals(characteristic.getUuid())){
                Logger.e("[BaseConnect:onCharacteristicChanged] ble pair notification, value:" + ByteDataConvertUtil.bytesToHexString(characteristic.getValue())+", alreadyCallbackPairSuccess = "+alreadyCallbackPairSuccess);
                BLEPairData pairData = new BLEPairData(characteristic.getValue());
                //此处的回调主要是处理配对失败的情况，比如用户取消、超时、输错 pin 码等
                if (pairData.isValidLEPairData()) {
                    if (!pairData.isLEPaired()) {
                        Logger.e("[BaseConnect:onCharacteristicChanged] ble pair failed");
                        enableNormalNotifyFailed();
                    } else {
                        Logger.e("[BaseConnect:onCharacteristicChanged] ble pair success, wait other character" +
                                " notify enable result!");
                        if (!alreadyCallbackPairSuccess) {
                            mITimeOutPresenter.stopLEPairResultWaitTimeOutTask();
                            mITimeOutPresenter.startLEPairResultWaitTimeOutTask(new Runnable() {
                                @Override
                                public void run() {
                                    Logger.e("[BaseConnect:onCharacteristicChanged] ble pair success, but no response from onDescriptorWrite， isPaired = "+PairedDeviceUtils.isPaired(mDeviceAddress));
                                    PairedDeviceUtils.cancelBondProcess(gatt.getDevice());
                                    enableNormalNotify(gatt);
                                }
                            },15000);
                        }
                    }
                }
            }else {
                Logger.e("[BytesDataConnect] receive <= 收到数据, " + this);
                callOnCharacteristicChanged(gatt, characteristic);
            }
        }

        @Override
        public void onCharacteristicRead(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic, int status) {
            super.onCharacteristicRead(gatt, characteristic, status);
            Logger.p("[BaseConnect] onCharacteristicRead uuid =" + characteristic.getUuid() + ", value = " +
                    ByteDataConvertUtil.bytesToHexString(characteristic.getValue()) + " , status = " + status);
            if (UUIDConfig.NOTIFY_UUID_ENCRYPT_BGC.equals(characteristic.getUuid())) {
                mITimeOutPresenter.stopReadCharacteristicTimeOutTask();
                CommonUtils.runOnMainThread(() -> {
                    if (status == BluetoothGatt.GATT_SUCCESS) {
                        handleEncryptData(gatt, characteristic.getValue());
                    } else {
                        enableNormalNotify(gatt);
                    }
                });
            }
        }
    }

    private void handleEncryptData(BluetoothGatt gatt, byte[] value) {
        if (value.length > 6) {
            int enc_enable = value[0] & 0xff;
            pair_flag = value[5] & 0xff;
            int is_support_repeat_pair = value[6] & 0xff;
            boolean isLEPaired = false;
            if (value.length > 7) {
                isLEPaired = (value[7] & 0xff) == 0x01;
            }
            Logger.p("[BaseConnect] handleEncryptData enc_enable = " + enc_enable + ", pair_flag = " +
                    pair_flag + " , is_support_repeat_pair = " + is_support_repeat_pair+", isLEPaired = "+isLEPaired);
            boolean finalIsLEPaired = isLEPaired;
            DeviceBusinessManager.checkBindState(gatt.getDevice().getAddress(), new Function1<Boolean, Unit>() {
                @Override
                public Unit invoke(Boolean isBind) {
                    Logger.p("[BaseConnect] checkBindState = " + isBind);
                    //确定是否使用ble配对功能 0x147258369:有效数据 其他：无效数据
                    if ((value[1] & 0xff) == 0x36 && (value[2] & 0xff) == 0x58 && (value[3] & 0xff) == 0x72 && (value[4] & 0xff) == 0x14) {
                        //绑定状态 0：未绑定 1：已绑定
                        if (pair_flag == 0) {
                            //设备未绑定
                            if (isBind) {
                                //如果APP已经绑定该设备，删除绑定记录
                                Logger.e("[BaseConnect]device not in bind status , callOnDeviceHasBeenReset");
                                callOnDeviceHasBeenReset();
                            } else {
                                //如果未绑定，走下一步使能通知
                                enableLEPairNotify(gatt, finalIsLEPaired);
                            }
                        } else {
                            //已绑定
                            if (isBind) {
                                enableLEPairNotify(gatt, finalIsLEPaired);
                            } else {
                                //是否支持重复绑定 0：不支持重复绑定 1：支持重复绑定
                                if (is_support_repeat_pair == 1) {
                                    enableLEPairNotify(gatt, finalIsLEPaired);
                                } else {
                                    //弹出不支持重复绑定
                                    Logger.e("[BaseConnect] device already in bind state, not support repeat pair callOnDeviceAlreadyBindAndNotSupportRebind");
                                    callOnDeviceAlreadyBindAndNotSupportRebind();
                                    disConnect(0);
                                    closeConnect();
                                }
                            }
                        }
                    } else {
                        //使用老的方式 ble不配对
                        enableNormalNotify(gatt);
                    }
                    return null;
                }
            });
        } else {
            enableNormalNotify(gatt);
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
        Logger.p("[BaseConnect] bluetoothDevice type = " + bluetoothDevice.getType());
        mITimeOutPresenter.startConnectTimeOutTask(new Runnable() {
            @Override
            public void run() {
                callConnectMethodSystemNoRespond();
            }
        }, timeoutMills);
        mIsNeedHandGattCallback = true;
        alreadyCallbackPairSuccess = false;
        //连接双通道(BLE、经典)蓝牙必须设置
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Logger.p("[BaseConnect] connectGatt TRANSPORT_LE");
            mBluetoothGatt = bluetoothDevice.connectGatt(CommonUtils.getAppContext(), false, new GattCallback(), BluetoothDevice.TRANSPORT_LE);
        } else {
            Logger.p("[BaseConnect] connectGatt TRANSPORT_AUTO");
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
    protected void connect(long timeoutMills, String mDeviceAddress) {

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
        current_reytime = 0;
        connect(DEFAULT_CONNECT_TIME_OUT);
    }

    protected void connect(String mac) {
        current_reytime = 0;
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
            callOnConnectBreakByGATT(status, newState,platform);

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
            callOnConnectFailedByGATT(status, newState,platform);
        }


    }

    private void handleConnectFailedState(int status, int newState) {
        closeConnect();
        Logger.e("[BaseConnect:connectionStateChange()] connect failed");
        callOnConnectFailedByGATT(status, newState,platform);
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
        List<String> uuids = new ArrayList<>();
        List<BluetoothGattService> services = gatt.getServices();
        if(services!=null && services.size()>0){
            for(BluetoothGattService service :services){
                uuids.add(service.getUuid().toString());
            }
            callOnServices(uuids);
        }

        startCheckEncryptBgc(gatt);
    }

    private void startHIDOrEnableNormal(BluetoothGatt gatt) {
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
            enableNormalNotify(gatt);
        }
    }

    private void startCheckEncryptBgc(BluetoothGatt gatt) {
        try {
            BluetoothGattService service = gatt.getService(UUIDConfig.SERVICE_UUID);
            if (service != null) {
                BluetoothGattCharacteristic encryptBGC = service.getCharacteristic(UUIDConfig.NOTIFY_UUID_ENCRYPT_BGC);
                if (encryptBGC != null) {
                    Logger.p( "[BaseConnect] disCoverServicesSuccess start read encryptBGC");
                    gatt.readCharacteristic(encryptBGC);
                    mITimeOutPresenter.startReadCharacteristicTimeOutTask(new Runnable() {
                        @Override
                        public void run() {
                            readCharacteristicFailed(gatt);
                        }
                    }, DEFAULT_READ_CHARACTERISTIC_TIME_OUT);
                } else {
                    Logger.p("[BaseConnect] not support read encryptBGC , startEnableNotify");
                    startHIDOrEnableNormal(gatt);
                }
            } else {
                Logger.p("[BaseConnect] service is null");
                enableNormalNotifyFailed();
            }
        } catch (Exception e) {
            Logger.p("[BaseConnect] readCharacteristic encryptBGC = " + e);
            readCharacteristicFailed(gatt);
        }
    }

    private boolean isSupportEncryptBgc(BluetoothGatt gatt) {
        boolean isSupportEncryptBgc = false;
        try {
            BluetoothGattService service = gatt.getService(UUIDConfig.SERVICE_UUID);
            if (service != null) {
                BluetoothGattCharacteristic encryptBGC = service.getCharacteristic(UUIDConfig.NOTIFY_UUID_ENCRYPT_BGC);
                if (encryptBGC != null) {
                    isSupportEncryptBgc = true;
                }
            }
        } catch (Exception e) {
            Logger.p("[BaseConnect] isSupportEncryptBgc e = " + e);
        }
        return isSupportEncryptBgc;
    }

    private void startEnableNotify(BluetoothGatt gatt) {
        mHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                enableNormalNotify(gatt);
            }
        }, 100);
    }
    private void readCharacteristicFailed(BluetoothGatt gatt) {
        Logger.p("[BaseConnect:connectionStateChange()] readCharacteristicFailed failed current_read_characteristic_times = " + current_read_characteristic_times);
        mITimeOutPresenter.stopReadCharacteristicTimeOutTask();
        if (current_read_characteristic_times < DEFAULT_READ_CHARACTERISTIC_TIME_OUT) {
            current_read_characteristic_times++;
            startCheckEncryptBgc(gatt);
        } else {
            current_read_characteristic_times = 0;
            CommonUtils.runOnMainThread(new Runnable() {
                @Override
                public void run() {
                    disConnect(0);
                    closeConnect();
                    callOnEnableNormalNotifyFailed();
                }
            });
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

    private void enableLEPairNotify(final BluetoothGatt gatt, boolean isLEPaired) {
//        if (isLEPaired) {
//            Logger.e("[BaseConnect] le already paired");
//            enableNormalNotify(gatt);
//        } else {
            enableLEPairNotify(gatt);
//        }
    }

    private void enableLEPairNotify(final BluetoothGatt gatt) {
        try {
            Logger.e("[BaseConnect] start to enablePeerDeviceNotifyLEBond...");
            boolean notifyNormal = BLEGattAttributes.enablePeerDeviceNotifyLEPair(gatt, true);
            if (notifyNormal) {
                Logger.e("[BaseConnect] enablePeerDeviceNotifyLEBond ok");
            } else {
                Logger.e("[BaseConnect] enablePeerDeviceNotifyLEBond failed, retry...");
                mHandler.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        //开启“正常”通知
                        boolean notifyNormal = BLEGattAttributes.enablePeerDeviceNotifyLEPair(gatt, true);
                        if (!notifyNormal) {
                            enableNormalNotify(gatt);
                            Logger.e("[BaseConnect] enablePeerDeviceNotifyLEBond reEnable failed");
                        } else {
                            Logger.e("[BaseConnect] enablePeerDeviceNotifyLEBond reEnable ok");
                        }
                    }
                }, 200);
            }
        } catch (Exception e) {
            Logger.e("[BaseConnect] enablePeerDeviceNotifyNormal Exception:" + e.getMessage());
        }
    }

    private void enableHenxuanNotify(final BluetoothGatt gatt) {
        Logger.e("[BaseConnect] start to enableHenxuanNotify...");
        boolean enable = BLEGattAttributes.enableHenxuanDeviceNotifyHealth(gatt, true);
        if (enable) {
            Logger.e("[BaseConnect] enableHenxuanNotify ok");
        } else {
            Logger.e("[BaseConnect] enableHenxuanNotify failed, retry...");
            mHandler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    boolean enable = BLEGattAttributes.enableHenxuanDeviceNotifyHealth(gatt, true);
                    if (!enable) {
                        Logger.e("[BaseConnect] enableHenxuanNotify reEnable failed");
                        //enableHealthNotifyFailed();
                    } else {
                        Logger.e("[BaseConnect] enableHenxuanNotify reEnable ok");
                    }
                }
            }, 200);
        }
    }

    private void enableVCNotify(final BluetoothGatt gatt) {
        Logger.e("[BaseConnect] start to enableVCNotify...");
        boolean enable = BLEGattAttributes.enableVCDeviceNotifyHealth(gatt, true);
        if (enable) {
            Logger.e("[BaseConnect] enableVCNotify ok");
        } else {
            Logger.e("[BaseConnect] enableVCNotify failed, retry...");
            mHandler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    boolean enable = BLEGattAttributes.enableVCDeviceNotifyHealth(gatt, true);
                    if (!enable) {
                        Logger.e("[BaseConnect] enableVCNotify reEnable failed");
                        //enableHealthNotifyFailed();
                    } else {
                        Logger.e("[BaseConnect] enableVCNotify reEnable ok");
                    }
                }
            }, 200);
        }
    }

    private void enableNormalNotify(final BluetoothGatt gatt) {
        Logger.p("[BaseConnect] start to enablePeerDeviceNotifyNormal...");
        boolean notifyNormal = BLEGattAttributes.enablePeerDeviceNotifyNormal(gatt, true);
        if (notifyNormal) {
            Logger.p("[BaseConnect] enablePeerDeviceNotifyNormal ok");
            startEnableNotifyTimeout();
            if (isSupportEncryptBgc(gatt)) {
                mBondStateBroadcastReceiver = listen(gatt.getDevice());
            }
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
                        startEnableNotifyTimeout();
                    }
                }
            }, 50);
        }
    }

    private void startEnableNotifyTimeout() {
        mITimeOutPresenter.stopEnableNotifyOutTask();
        mITimeOutPresenter.startEnableNotifyTimeOutTask(new Runnable() {
            @Override
            public void run() {
                enableNormalNotifyFailed();
            }
        },30000);
    }

    BroadcastReceiver mBondStateBroadcastReceiver;
    BondCallBack bondCallBack;

    private BroadcastReceiver listen(BluetoothDevice device) {
        final IntentFilter bondFilter = new IntentFilter(BluetoothDevice.ACTION_BOND_STATE_CHANGED);
        bondFilter.addAction(BluetoothDevice.ACTION_PAIRING_REQUEST);
        bondCallBack = new BondCallBack() {
            @Override
            public void onBondSuccess() {
                Logger.p("[BaseConnect] onBondSuccess");
            }

            @Override
            public void onBondFailed() {
                Logger.p("[BaseConnect] onBondFailed");
//                if (mBondStateBroadcastReceiver != null) {
//                    Config.getApplication().unregisterReceiver(mBondStateBroadcastReceiver);
//                    mBondStateBroadcastReceiver = null;
//                }
//                enableHealthNotifyFailed();
            }
        };
        BroadcastReceiver mBondStateBroadcastReceiver = new BondStateBroadcast(device.getAddress(), bondCallBack);
        Config.getApplication().registerReceiver(mBondStateBroadcastReceiver, bondFilter);
        return mBondStateBroadcastReceiver;
    }

    interface BondCallBack {
        void onBondSuccess();

        void onBondFailed();
    }

    public class BondStateBroadcast extends BroadcastReceiver {
        private String mac = "";
        private BondCallBack bondCallBack;

        public BondStateBroadcast(String mac, BondCallBack bondCallBack) {
            this.mac = mac;
            this.bondCallBack = bondCallBack;
        }

        @Override
        public void onReceive(final Context context, final Intent intent) {
            final BluetoothDevice tempDevice = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
            int bondState = intent.getIntExtra(BluetoothDevice.EXTRA_BOND_STATE, -1);
            String action = intent.getAction();
            int variant = intent.getIntExtra(BluetoothDevice.EXTRA_PAIRING_VARIANT, BluetoothDevice.ERROR);
            Logger.p("[BaseConnect] onReceive mac is " + tempDevice +
                    " , action= " + action + " , bondState = " + bondState + " , current mac =" + mac + " , variant = " + variant);
            if (action.equals(BluetoothDevice.ACTION_BOND_STATE_CHANGED) && mac != null && tempDevice != null && mac.equals(tempDevice.getAddress())) {
                if (bondState == BluetoothDevice.BOND_BONDED) {
                    if (bondCallBack != null) {
                        bondCallBack.onBondSuccess();
                    }
                } else if (bondState == BluetoothDevice.BOND_NONE) {
                    if (bondCallBack != null) {
                        bondCallBack.onBondFailed();
                    }
                }
            } else if (action.equals(BluetoothDevice.ACTION_PAIRING_REQUEST)) {
                variant = intent.getIntExtra(BluetoothDevice.EXTRA_PAIRING_VARIANT, BluetoothDevice.ERROR);
            }
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
        try {
            platform = BLEGattAttributes.isContainsHenxuanService(mBluetoothGatt) ? BLEGattAttributes.PLATFORM_HENXUAN : BLEGattAttributes.PLATFORM_IDO;
        } catch (Exception e) {
            platform = BLEGattAttributes.PLATFORM_IDO;
        }
        callOnConnectedAndReady(platform);
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
            mITimeOutPresenter.stopReadCharacteristicTimeOutTask();
            mITimeOutPresenter.stopLEPairResultWaitTimeOutTask();
            mITimeOutPresenter.stopLEPairTimeOutTask();
            mITimeOutPresenter.stopEnableNotifyOutTask();
        }

        mState = STATE_NOT_CONNECT;
        mIsConnectedAndReady = false;
        mIsCanSendData = false;
        mHandler.removeCallbacksAndMessages(null);

        if (mBondStateBroadcastReceiver != null) {
            Config.getApplication().unregisterReceiver(mBondStateBroadcastReceiver);
            mBondStateBroadcastReceiver = null;
        }

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
        callOnConnectBreakByGATT(0xff, 0xff,platform);
    }

}
