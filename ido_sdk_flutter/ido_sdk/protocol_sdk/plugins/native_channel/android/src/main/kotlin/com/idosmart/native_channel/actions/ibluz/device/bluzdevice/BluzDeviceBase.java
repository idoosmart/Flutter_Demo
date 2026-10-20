package com.idosmart.native_channel.actions.ibluz.device.bluzdevice;

import android.Manifest;
import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothProfile;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Log;


import com.idosmart.native_channel.actions.ibluz.device.BluzDeviceA2dp;
import com.idosmart.native_channel.actions.ibluz.device.BluzDeviceA2dpBase;
import com.idosmart.native_channel.actions.ibluz.device.BluzDeviceA2dpCompat;
import com.idosmart.native_channel.actions.ibluz.device.GetConnectedDeviceList;
import com.idosmart.native_channel.actions.ibluz.device.IA2dpListener;
import com.idosmart.native_channel.actions.ibluz.factory.BluzDeviceFactory;
import com.idosmart.native_channel.actions.ibluz.factory.IBluzDevice;
import com.idosmart.native_channel.actions.ibluz.factory.IBluzIO;
import com.idosmart.native_channel.actions.ibluz.util.Utils;
import com.idosmart.native_channel.common.utils.BroadcastReceiverCompat;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

@SuppressLint("MissingPermission")
public abstract class BluzDeviceBase implements IBluzDevice, IBluzIO, IA2dpListener {
    private String TAG = "BluzDeviceBase";
    private static final String DATA_DISCONNECT_INTENT = "com.actions.ibluz.data.disconnect";
    private static final String INTENT_PACKAGE_NAME = "package-name";

    // compatability: some device's discovery time is longer than 1minute which will influent the auto-reconnect
    private static final int DISCOVERY_TIMEOUT = 20000;

    protected Context mContext = null;
    protected BluetoothAdapter mBluetoothAdapter;
    protected OnDiscoveryListener mDiscoveryListener = null;
    protected OnConnectionListener mConnectionListener = null;
    protected BluetoothDevice mBluetoothDevice = null;
    protected BluetoothDevice mDeviceConnected = null;
    protected boolean mConnecting = false;
    protected BluzDeviceA2dpBase mDeviceA2dp = null;
    private BluetoothDevice mDeviceRetry = null;
    private boolean mAtuoConnect = true;
    private boolean mRegisterReceiver = false;
    // TranSport使用
    protected OnWriteListener mWriteListener = null;
    // 获取service连接状态
    protected OnServiceConnectListener mServiceConnectListener;
    // 蓝牙连接状态监听
    protected OnConnectStateListener mConnectListener;
    // 蓝牙连接状态
    protected OnBleConnectListener mBleConnectListener;

    private volatile boolean mIsScaning = false;

    protected volatile boolean mIsStress = false;

    public volatile boolean mIsRunning = false;

    private Handler mHandler = new Handler(Looper.getMainLooper());
    private Runnable mDiscoveryTimeoutCallback = new Runnable() {
        @Override
        public void run() {
            Log.v(TAG, "Bluetooth discovery timeout");
            cancelDiscovery();
            if (mDiscoveryListener != null) {
                mDiscoveryListener.onFoundBoundedTimeout();
            }
        }
    };

    private Runnable mRetryCallback = new Runnable() {
        @Override
        public void run() {
            /* while connect fail, the retry will be called right after connect(), if we put the assignment behind, there will be conflicted */
            BluetoothDevice device = mDeviceRetry;
            mDeviceRetry = null;
            connect(device);
        }
    };

    private volatile String mCurAction = "";

    private BroadcastReceiver mBluetoothReceiver = new BroadcastReceiver() {
         // 用于解决部分机器搜索
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (!TextUtils.equals(BluetoothDevice.ACTION_FOUND, action) && TextUtils.equals(action, mCurAction)) {
                return;     // 广播总会返回多次相同命令，无用且容易影响流程，禁掉多余广播信息
            } else {
                mCurAction = action;
            }
            if (BluetoothAdapter.ACTION_DISCOVERY_STARTED.equals(action)) {
                if (mIsScaning == false) {
                    mIsScaning = true;
                    Log.v(TAG, "Bluetooth discovery started!");
                    if (mHandler != null) {
                        mHandler.removeCallbacks(mDiscoveryTimeoutCallback);
                        mHandler.postDelayed(mDiscoveryTimeoutCallback, DISCOVERY_TIMEOUT);
                        if (mDiscoveryListener != null) {
                            mDiscoveryListener.onDiscoveryStarted();
                            retrieveConnectedDevice();
                        }

                        if (mDeviceRetry != null) {
                            mHandler.removeCallbacks(mRetryCallback);
                            mHandler.post(mRetryCallback);
                        } else if (mDeviceA2dp != null) {
                            //auto reconnect spp at connected a2dp device
                            if (mAtuoConnect)
                                connect();
                        }
                    }
                }
            } else if (BluetoothDevice.ACTION_FOUND.equals(action)) {
                BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                if (isValidType(device) && mDiscoveryListener != null) {
                    mDiscoveryListener.onFound(device, BluzDeviceFactory.DiscoveryType.DISCOVERY_NORMAL);
                }
            } else if (BluetoothAdapter.ACTION_DISCOVERY_FINISHED.equals(action)) {
                Log.v(TAG, "Bluetooth discovery finished!");
                mHandler.removeCallbacks(mDiscoveryTimeoutCallback);
                if (mDiscoveryListener != null) {
                    mDiscoveryListener.onDiscoveryFinished();
//                    mDiscoveryListener = null;
                } else {
                    Log.i(TAG, "mDiscoveryListener == null");
                }
                if (mIsScaning == true) {
                    mIsScaning = false;
                }
            } else if (DATA_DISCONNECT_INTENT.equals(action)) {
                Log.v(TAG, "data disconnect");
                String packageName = intent.getStringExtra(INTENT_PACKAGE_NAME);
                if (!packageName.equals(mContext.getPackageName())) {
                    Log.v(TAG, "data disconnect packageName = " + packageName);
                    disconnect();
                }
            } else if ("android.bluetooth.device.action.PAIRING_REQUEST".equals(action)) {
                Log.e(TAG, "pairing!!!!!!!!!!!!");
            }
        }
    };

    public void setBleConnectListener (OnBleConnectListener listener) {
        this.mBleConnectListener = listener;
    }

    public BluzDeviceBase() {

    }

    public BluzDeviceBase(Context context, boolean a2dp, boolean removeBound) {
        init(context, a2dp, removeBound);
    }

    private void init(Context context, boolean a2dp, boolean removeBound) {
        Log.i(TAG, "Create with a2dp:" + a2dp);
        mRegisterReceiver = false;
        if (a2dp) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
                mDeviceA2dp = new BluzDeviceA2dp(context, removeBound);
            } else {
                mDeviceA2dp = new BluzDeviceA2dpCompat(context);
            }

            mDeviceA2dp.setListener(this);
        }

        mContext = context;
        registerReceiver();
    }

    // --------------------------------- 设置压测环境 ------------------------------ //
    public void setStressMode(boolean isStress) {
        Log.i(TAG, "setStressMode" + isStress);
        this.mIsStress = isStress;
    }

    // --------------------------------- registerReceiver -------------------------------- //

    protected void registerReceiver() {
        Log.i(TAG, "registerReceiver");
        IntentFilter filter = new IntentFilter();
        filter.addAction(BluetoothAdapter.ACTION_DISCOVERY_STARTED);
        filter.addAction(BluetoothAdapter.ACTION_DISCOVERY_FINISHED);
        filter.addAction(BluetoothDevice.ACTION_FOUND);
        filter.addAction(DATA_DISCONNECT_INTENT);
        BroadcastReceiverCompat.register(mContext, mBluetoothReceiver, filter);
        mRegisterReceiver = true;
    }

    protected void unregisterReceiver() {
        try {
            if (mRegisterReceiver) {
                if(mBluetoothReceiver != null){
                    mContext.unregisterReceiver(mBluetoothReceiver);
                }
                mRegisterReceiver = false;
            }
        }catch (Exception e){
            Log.i(TAG, "unregisterReceiver e" + e);
        }

    }

    public void removeTime() {
        mHandler.removeCallbacks(mDiscoveryTimeoutCallback);
    }

    // ----------------------------------------------------------------------------------- //
    @Override
    public void cancelDiscovery() {
        if (mBluetoothAdapter != null && mBluetoothAdapter.isDiscovering()) {
            mBluetoothAdapter.cancelDiscovery();
        }
    }

    private void retrieveConnectedDevice() {
        int a2dp = mBluetoothAdapter.getProfileConnectionState(BluetoothProfile.A2DP);
        if (a2dp != BluetoothProfile.STATE_CONNECTED) {
            return;
        }

        Log.v(TAG, "retrieveConnectedDevice");
        mBluetoothAdapter.getProfileProxy(mContext, new BluetoothProfile.ServiceListener() {

            @Override
            public void onServiceDisconnected(int profile) {
                Log.i(TAG, "onServiceDisconnected");
            }

            @Override
            public void onServiceConnected(int profile, BluetoothProfile proxy) {
                List<BluetoothDevice> mDevices = proxy.getConnectedDevices();
                if (mDevices != null && mDevices.size() > 0) {
                    for (BluetoothDevice device : mDevices) {
                        Log.i(TAG, "onServiceConnected: " + device.getName());
                        if (isValidType(device) && mDiscoveryListener != null) {
                            if (mDeviceA2dp != null)
                                mDiscoveryListener.onFound(device, BluzDeviceFactory.DiscoveryType.DISCOVERY_A2DP);
                        }
                    }
                } else {
                    Log.i("W", "onServiceConnected null");
                }
            }
        }, BluetoothProfile.A2DP);
    }

    @SuppressLint("NewApi")
    private boolean isValidType(BluetoothDevice device) {
        if (device == null) {
            return false;
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
            int type = device.getType();
            if (type != BluetoothDevice.DEVICE_TYPE_LE) {
                return true;
            }
        }
        return true;
    }

    // --------------------------------------------------------------------------------- //

    protected void updateConnectionState(int state) {
        if (state == BluzDeviceFactory.ConnectionState.A2DP_FAILURE) {
            // if A2DP connect fail, then the next spp/ble will not procceed
            mConnecting = false;
        }
        if (mDiscoveryListener != null) {
            mDiscoveryListener.onConnectionStateChanged(mBluetoothDevice, state);
        }
    }

    private void sendDisconnectIntent() {
        Intent intent = new Intent(DATA_DISCONNECT_INTENT);
        intent.putExtra(INTENT_PACKAGE_NAME, mContext.getPackageName());
        mContext.sendBroadcast(intent);
    }

    protected void handleException(Exception e, String msg) {
        Log.e(TAG, msg + e);
        disconnect();
    }

    protected boolean checkLocationPermission() {
        return checkPermission(Manifest.permission.ACCESS_COARSE_LOCATION) || checkPermission(Manifest.permission.ACCESS_FINE_LOCATION);
    }

    private boolean checkPermission(final String permission) {
        return mContext.checkPermission(permission, android.os.Process.myPid(), android.os.Process.myUid()) == PackageManager.PERMISSION_GRANTED;
    }

    // ------------------------------------ override ----------------------------------- //
    @Override
    public IBluzIO getIO() {
        return this;
    }

    @Override
    public void updateConnectionState(BluetoothDevice device, int state) {
        mBluetoothDevice = device;
        updateConnectionState(state);
    }

    @Override
    public void setOnConnectionListener(OnConnectionListener listener) {
        mConnectionListener = listener;
    }

    @Override
    public void setOnDiscoveryListener(OnDiscoveryListener listener) {
        mDiscoveryListener = listener;
    }

    @Override
    public void setOnWriteListener(OnWriteListener listener){
        this.mWriteListener = listener;
    }

    @Override
    public void retry(BluetoothDevice device) {
        mDeviceRetry = device;
        /* after connect fail, restart may do some favor, very tricky(4.0.4) */
        startDiscovery();
    }

    @Override
    public void connect(BluetoothDevice device) {
        if (device == null) {
            return;
        } else if (mDeviceConnected != null) {
            if (device.equals(mDeviceConnected)) {
                Log.i(TAG, "already connected");
                disconnect(device);
                mDeviceConnected = null;
                return;
            } else {
                Log.i(TAG, "replace device");
                disconnect(null);
            }
        } else if (mBluetoothDevice != null && device.equals(mBluetoothDevice) && mConnecting) {
            Log.i(TAG, "in connecting");
            return;
        }

        mConnecting = true;
        mBluetoothDevice = device;

        cancelDiscovery();
        if (mDeviceA2dp != null) {
            Log.i(TAG, "mDeviceA2dp != null");
            mDeviceA2dp.connect(device);
        } else {
            Log.i(TAG, "mDeviceA2dp == null");
            connect();
        }
    }

    @Override
    public void connect() {
        if (mDeviceA2dp == null) {
            /** only data connect */
            sendDisconnectIntent();

            mDeviceConnected = null;
            //return from super method but will continue in subclass method
            //
            return;
        }
        //SPP_ONLY and BLE won't call below
        //set mBluetoothDevice to null in some case so that it won't be connected in subclass(BluzDeviceBle, BluzDeviceSpp )
        BluetoothDevice device = getConnectedA2dpDevice();
        if (device == null || (mDeviceConnected != null && device.getAddress().equals(mDeviceConnected.getAddress()))) {
            Log.v(TAG, "device null or already connected, device:" + device+ "device==null?:"+(device==null));
            //don't connect if no a2dpdevice is connected or spp is already connected
//			mDeviceA2dp.updateA2dpConnectionState(A)
            mBluetoothDevice = null;
        } else if (!Utils.isAppForeground(mContext)) {
            Log.v(TAG, "Deactivated");
            //app is not in foreground
            mBluetoothDevice = null;
        } else {
            // disconnect other app's spp connection
            sendDisconnectIntent();

            //reconnect spp to connected a2dp device
            mBluetoothDevice = device;
            mDeviceConnected = null;
        }
    }

    @Override
    public void disconnect(BluetoothDevice device) {
        Log.i(TAG, "disconnect all");
        // close data connection
        if (mDeviceA2dp != null) {
            mDeviceA2dp.disconnect(device == null ? mDeviceA2dp.getConnectedDevice() : device);
        }
    }

    @Override
    public BluetoothDevice getConnectedDevice() {
        return mDeviceConnected;
    }

    @Override
    public Set<BluetoothDevice> getBoundedDevices(){
        return mBluetoothAdapter.getBondedDevices();
    }

    @Override
    public void release() {
        Log.i(TAG, "release");
        unregisterReceiver();
        disconnect();
        if (mBluetoothAdapter != null) {
            cancelDiscovery();
//            disable();
        }

        /* make sure that when the activity is not alive, their will be no broadcast receiver */
        if (mDeviceA2dp != null) {
            mDeviceA2dp.release();
        }
    }

    @Override
    public BluetoothDevice getConnectedA2dpDevice() {
        if (mDeviceA2dp != null) {
            //fix samsung galaxy s7 disconnect bluetooth manual then auto reconnect
            if (Build.MODEL.contains("SM-G9308")){
                try {
                    Thread.sleep(500);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            return mDeviceA2dp.getConnectedDevice();
        } else {
            return null;
        }
    }

    @Override
    public boolean isEnabled() {
        return mBluetoothAdapter.isEnabled();
    }

    @Override
    public boolean enable() {
        BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        if (!bluetoothAdapter.isEnabled()) {
            return bluetoothAdapter.enable();
        } else {
            return true;
        }
    }

    @Override
    public boolean disable() {
        BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        if (bluetoothAdapter.isEnabled()) {
            return bluetoothAdapter.disable();
        } else {
            return true;
        }
    }

    @Override
    public void startDiscovery() {
        if (Build.VERSION.SDK_INT >= 23 && !checkLocationPermission()) {
            Log.d(TAG, "startDiscovery fail: need Permission ACCESS_COARSE_LOCATION or ACCESS_FINE_LOCATION");
        }
        cancelDiscovery();
        Handler handler = new Handler();
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                mBluetoothAdapter.startDiscovery();
            }
        }, 500);
    }

    @Override
    public void getConnectedList(GetConnectedDeviceList listener) {
        BluetoothAdapter adapter = BluetoothAdapter.getDefaultAdapter();
        adapter.getProfileProxy(mContext, new BluetoothProfile.ServiceListener() {
            @SuppressLint("MissingPermission")
            @Override
            public void onServiceConnected(int profile, BluetoothProfile proxy) {
                List<BluetoothDevice> devices = proxy.getConnectedDevices();
                listener.onGetDeviceList(devices);
            }

            @Override
            public void onServiceDisconnected(int profile) {

            }
        }, BluetoothProfile.A2DP);
    }

    @Override
    public void setAutoConnectDataChanel(boolean enable){
        Log.i(TAG, "setAutoConnectDataChanel " + enable);
        mAtuoConnect = enable;
        if (mDeviceA2dp != null){
            mDeviceA2dp.setAutoConnectDataChanel(enable);
        }
    }

    public void setOnServiceConnectListener(OnServiceConnectListener listener) {
        Log.i(TAG, "setOnServiceConnectListener");
        this.mServiceConnectListener = listener;
    }

    @Override
    public void setOnConnectStateListener(OnConnectStateListener listener) {
        mConnectListener = listener;
    }

    @Override
    public void setUUID(Map<String, UUID> uuids) {

    }

    @Override
    public void setUUID(UUID uuid) {

    }

    @Override
    public void closeNotify() {

    }

    @Override
    public void connectSpp(BluetoothDevice device){

    }

    @Override
    public void connectBle(BluetoothGatt gatt) {

    }

    public void connectEdr(BluetoothGatt gatt) {
        
    }

    @Override
    public void connectServiceAndCharacteristic(HashMap<String, UUID> uuids, BluetoothGatt gatt, OnServiceConnectListener serviceConnectListener) {

    }

    @Override
    public void setIsRunning(boolean isRunning) {
        mIsRunning = isRunning;
    }

    public void readIndicator(BluetoothGattCharacteristic characteristic) {

    }

    public void setMtu(int mtu) {

    }

    public void onWrite(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic, int status) {

    }

}
