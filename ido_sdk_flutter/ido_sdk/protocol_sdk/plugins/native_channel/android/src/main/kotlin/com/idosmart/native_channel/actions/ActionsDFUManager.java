package com.idosmart.native_channel.actions;


import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;

import com.idosmart.native_channel.siche.Config;
import com.idosmart.native_channel.common.BleDFUConfig;
import com.idosmart.native_channel.common.BleDFUConstants;
import com.idosmart.native_channel.actions.aticonsota.OTAManager;
import com.idosmart.native_channel.actions.aticonsota.OtaStatus;
import com.idosmart.native_channel.actions.ibluz.device.bluzdevice.BluzDeviceBle;
import com.idosmart.native_channel.actions.ibluz.device.scan.ScanState;
import com.idosmart.native_channel.actions.ibluz.device.scan.SimpleScanCallback;
import com.idosmart.native_channel.actions.ibluz.device.scan.ble.BleScanner;
import com.idosmart.native_channel.actions.ibluz.factory.BluzDeviceFactory;
import com.idosmart.native_channel.actions.ibluz.factory.IBluzDevice;
import com.idosmart.native_channel.actions.ibluz.util.ErrorCode;
import com.idosmart.native_channel.actions.ibluz.util.RemoteStatus;
import com.idosmart.native_channel.actions.labelparsing.LabelUtils;
import com.idosmart.native_channel.common.presenter.DFULibProgressStateChangePresenter;
import com.idosmart.native_channel.common.presenter.IDFULibProgressStateChange;
import com.idosmart.native_channel.common.LogTool;
import com.idosmart.native_channel.common.utils.BroadcastReceiverCompat;
import com.idosmart.native_channel.pigeon_generate.api_actions.ActionsOTAState;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.UUID;

public class ActionsDFUManager {
    // IDW29蓝牙集合
    // OTA
    public final String OTA_SPP_UUID = "00006666-0000-1000-8000-00805F9B34FB";
    public final String OTA_BLE_UUID_SERVICE = "e49a25f8-f69a-11e8-8eb2-f2801f1b9fd1";
    public final String OTA_BLE_UUID_SERVICE_WRITE = "e49a25e0-f69a-11e8-8eb2-f2801f1b9fd1";
    public final String OTA_BLE_UUID_SERVICE_READ = "e49a28e1-f69a-11e8-8eb2-f2801f1b9fd1";

    private final String TAG = BleDFUConstants.LOG_TAG_ACTIONS;
    private static ActionsDFUManager instance;
    private boolean mIsDoing = false;
    private BleDFUConfig mBleDfuConfig;
    private Handler delayTimeHandler = new Handler(Looper.getMainLooper());
    private IDFULibProgressStateChange mIDFULibProgressStateChange;
    int progress = 0;
    private int retryTimes = 3;
    private int currentTimes = 0;
    private int currentConnectTimes = 0;
    private int connectRetryTimes = 2;

    private String mType = BluzDeviceFactory.ConnectionType.BLE;
    private static IBluzDevice mBluzConnector;
    private BluetoothDevice mDevice;
    private BluetoothGatt mGatt;
    private volatile boolean mIsPerparing; // 用于兼容个别设备
    private boolean mIsMutiStressing;
    private volatile OTAManager mOTAManager;
    private OtaStatus mOtaStatus;
    private long mStartTime;
    private RemoteStatus mRemoteStatus;
    private String mOTAVersion;
    private boolean mIsStart;
    private BleScanner mScanner;
    private static final int PREPARING_RECONNECT_TIME = 2000;
    private Handler timeOutHandler = new Handler(Looper.getMainLooper());
    private int discoverServiceTimes = 0;
    private Handler discoverServiceTimeOutHandler = new Handler(Looper.getMainLooper());
    private BroadcastReceiver mBluetoothStatusReceiver;
    private boolean isOnTiming = false;

    public static ActionsDFUManager getManager(){
        if (instance == null){
            instance = new ActionsDFUManager();
        }
        return instance;
    }

    public void initBroadcast() {
        if(mBluetoothStatusReceiver == null){
            IntentFilter filter = new IntentFilter();
            filter.addAction(BluetoothAdapter.ACTION_STATE_CHANGED);
            mBluetoothStatusReceiver = new BroadcastReceiver() {
                @Override
                public void onReceive(Context context, Intent intent) {
                    String action = intent.getAction();
                    if (TextUtils.isEmpty(action)){
                        return;
                    }
                    if (action.equals(BluetoothAdapter.ACTION_STATE_CHANGED)) {
                        int state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.STATE_OFF);
                        if (state == BluetoothAdapter.STATE_OFF) {
                            LogTool.p(BleDFUConstants.LOG_TAG_ACTIONS, "bluetooth switch is turn off mIsDoing = " + mIsDoing + " , " + isOnTiming);
                        } else if (state == BluetoothAdapter.STATE_ON) {
                            LogTool.p(BleDFUConstants.LOG_TAG_ACTIONS, "bluetooth switch is turn on isOnTiming = " + isOnTiming);
                            if (mBleDfuConfig != null) {
                                if(isOnTiming){
                                    start(getContext(), mBleDfuConfig);
                                }
                            }
                        }
                    }
                }
            };
            BroadcastReceiverCompat.register(
                    Config.getApplication().getApplicationContext(), mBluetoothStatusReceiver, filter);
        }

    }

    public boolean start(BleDFUConfig dfuConfig) {
        currentConnectTimes = 0;
        discoverServiceTimes = 0;
        currentTimes = 0;
        initBroadcast();
        return start(getContext(), dfuConfig);
    }
    private Context getContext(){
        return Config.getApplication().getApplicationContext();
    }
    public boolean start(Context context,BleDFUConfig dfuConfig){
        LogTool.p(BleDFUConstants.LOG_TAG_ACTIONS, " ----start--------------> dfuConfig ： " + dfuConfig);
        if (mIsDoing){
            LogTool.p(BleDFUConstants.LOG_TAG_ACTIONS, "is doing ,ignore this action.");
            return false;
        }
        ActionsToFlutterImpl.INSTANCE.onOTAStateChanged(ActionsOTAState.PREPARE, "");
        if (!checkParas(dfuConfig)){
            ActionsToFlutterImpl.INSTANCE.onOTAStateChanged(ActionsOTAState.FAILED, "Config parameter error");
            return false;
        }
        mBleDfuConfig = dfuConfig;
        if(mIDFULibProgressStateChange != null){
            mIDFULibProgressStateChange.onEnd();
        }
        mIDFULibProgressStateChange = new DFULibProgressStateChangePresenter();
        onStart();
        try {
            startUpgrade();
        } catch (RuntimeException e) {
            LogTool.e(BleDFUConstants.LOG_TAG_ACTIONS, "start failed: " + e);
            ActionsToFlutterImpl.INSTANCE.onOTAStateChanged(
                    ActionsOTAState.FAILED, e.getMessage() != null ? e.getMessage() : "start failed");
            ActionsToFlutterImpl.INSTANCE.log("[Actions OTA] start failed: " + e);
            onTimeEnd();
            release();
            return false;
        }
        return true;
    }
    private void startUpgrade() {
        mIsDoing = true;
        progress = 0;
        upgrade();
    }
    private void upgrade(){
        initBluzDevice();
    }

    private boolean checkParas(BleDFUConfig dfuConfig) {
        if (dfuConfig == null){
            LogTool.p(BleDFUConstants.LOG_TAG_ACTIONS, "mDfuConfig is null");
            return false;
        }

        LogTool.p(BleDFUConstants.LOG_TAG_ACTIONS, "mDfuConfig is " + dfuConfig.toString());

        if (TextUtils.isEmpty(dfuConfig.getFilePath())){
            LogTool.e(BleDFUConstants.LOG_TAG_ACTIONS, "file path is null");
            return false;
        }

        if (TextUtils.isEmpty(dfuConfig.getMacAddress())){
            LogTool.e(BleDFUConstants.LOG_TAG_ACTIONS, "mac address is null");
            return false;
        }

        return true;
    }

    private void initBluzDevice() {
        LogTool.p(TAG, "initBluzDevice");
        if (mBluzConnector != null) {
            mBluzConnector.release();
            mBluzConnector = null;
        }
        mBluzConnector = BluzDeviceFactory.getDevice(getContext(), mType);
        if (mType.equals(BluzDeviceFactory.ConnectionType.BLE)) {
            LogTool.p(TAG, "initBluzDevice BLE");
            mBluzConnector.setAutoConnectDataChanel(false);
        }

        mBluzConnector.setOnConnectStateListener(new IBluzDevice.OnConnectStateListener() {
            @Override
            public void onConnectSuccess(BluetoothGatt gatt) {
//                if (mIsConnectService) {
//                    connectServiceBle(gatt, position);
//                } else {
//                    setConnectItemIcon(position);
                    mGatt = gatt;
//                }
                initData();
                startPrepare();
            }

            @Override
            public void onConnectSuccess(BluetoothDevice device) {
                mDevice = device;
                initData();
                startPrepare();
            }

            @Override
            public void onEdrConnectSuccess(BluetoothGatt gatt) {
                mGatt = gatt;
                initData();
                clickPrepare();
            }

            @Override
            public void onConnectFail() {
                Log.e(TAG, "onConnectFail");
                mGatt = null;
                mDevice = null;
            }
        });
//        String mac = SPDataUtils.getInstance().getRandomMacIfExists(mBleDfuConfig.getMacAddress());
//        if (!TextUtils.isEmpty(mac) && !mac.equalsIgnoreCase(mBleDfuConfig.getMacAddress())) {
//            if(!PairedDeviceUtils.isPaired(mac) && !PairedDeviceUtils.isPaired(mBleDfuConfig.getMacAddress())){
//                LogTool.p(TAG, "PRA address exist ,but not pair, use " + mBleDfuConfig.getMacAddress());
//                mBleDfuConfig.setMacAddress(mBleDfuConfig.getMacAddress());
//            }else{
//                LogTool.p(TAG, "PRA address exist , use " + mac);
//                mBleDfuConfig.setMacAddress(mac);
//            }
//        }
        BluetoothDevice mSelectDevice = BluetoothAdapter.getDefaultAdapter().getRemoteDevice(mBleDfuConfig.getMacAddress());
        mBluzConnector.connect(mSelectDevice);
    }

    public void startPrepare() {
        LogTool.p(TAG, "prepare");
        mBluzConnector.setOnConnectStateListener(mStateListener);
        clickPrepare();
    }

    private void prepare() {
        LogTool.p(TAG, "prepare r");
        if (/*mType == BluetoothType.BLE &&*/ !((BluzDeviceBle)mBluzConnector).isConnected(mGatt)) {
            return ;
        }

        String path = "";
        path = mBleDfuConfig.getFilePath();
        boolean readFile = mOTAManager.setOTAFile(path);
        mOTAManager.setOTAListener(mOtaListener);
        mOTAVersion = mOTAManager.getOTAVersion();
        if (mOTAVersion == null || TextUtils.equals(mOTAVersion, LabelUtils.ERROR_CODE)) {
//            mBinding.tvOtaStatus.setText("OTA升级文件有误");
            LogTool.e(TAG,"OTA升级文件有误");
        } else {
            mOTAManager.prepare();
        }
    }

    private IBluzDevice.OnConnectStateListener mStateListener =  new IBluzDevice.OnConnectStateListener() {

        @Override
        public void onConnectSuccess(BluetoothGatt gatt) {
            LogTool.p(TAG, "onConnectSuccess gatt:" + gatt.getDevice().getName());
            mGatt = gatt;
            initData();
            clickPrepare();
        }

        @Override
        public void onConnectSuccess(BluetoothDevice device) {
            LogTool.p(TAG, "onConnectSuccess dev:" + device.getName());
            mDevice = device;
            initData();
            clickPrepare();
        }

        @Override
        public void onEdrConnectSuccess(BluetoothGatt gatt) {
            mGatt = gatt;
            initData();
            clickPrepare();
        }

        @Override
        public void onConnectFail() {
            LogTool.p(TAG, "otaView disconnect");
            runOnMainThread(new Runnable() {
                @Override
                public void run() {
                    disconnect();
                }
            });
        }
    };

    private Runnable mPreparingReconnect = new Runnable() {
        @Override
        public void run() {
            if (!mIsPerparing) {
                return;
            }

            if (mBluzConnector != null) {
                mBluzConnector.closeNotify();
                mBluzConnector.release();
                mBluzConnector = null;
            }

//            BluetoothType btType = mModel.getBlueTypeFromSP(mContext);
//
//            if (btType == BluetoothType.BLE) {
//                mBinding.tvOtaStatus.setText(mContext.getString(R.string.ota_status_preparing));

            mBluzConnector = BluzDeviceFactory.getDevice(getContext(), BluzDeviceFactory.ConnectionType.BLE);
            mScanner = new BleScanner(getContext(), new SimpleScanCallback() {
                @SuppressLint("MissingPermission")
                @Override
                public void onScan(BluetoothDevice device, int rssi, byte[] scanRecord) {
                    LogTool.p(TAG, "onScan:" + device.getName() + " , address = " + device.getAddress());
                    if (TextUtils.equals(device.getAddress(), mGatt.getDevice().getAddress())) {
                        timeOutHandler.removeCallbacksAndMessages(null);
                        connectDevice(device);
                    }
                }

                @Override
                public void onScanFailed(ScanState scanState) {
                    LogTool.p(TAG, "onScanFailed:" + scanState + " try connect = " + mGatt.getDevice().getAddress());
                    BluetoothDevice device = BluetoothAdapter.getDefaultAdapter().getRemoteDevice(mGatt.getDevice().getAddress());
                    connectDevice(device);
                }
            });
            mScanner.startBleScan();
            timeOutHandler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    LogTool.p(TAG, "scan timeout , try connect = " + mGatt.getDevice().getAddress());
                    BluetoothDevice device = BluetoothAdapter.getDefaultAdapter().getRemoteDevice(mGatt.getDevice().getAddress());
                    connectDevice(device);
                }
            }, 15 * 1000);
        }
    };

    private void connectDevice(BluetoothDevice device) {
        mScanner.stopBleScan();
        mBluzConnector.setOnConnectStateListener(new IBluzDevice.OnConnectStateListener() {
            @SuppressLint("MissingPermission")
            @Override
            public void onConnectSuccess(BluetoothGatt gatt) {
                LogTool.p(TAG, "onConnectSuccess gatt:" + gatt.getDevice().getName());
                mGatt = gatt;
                clickPrepare();
            }

            @Override
            public void onConnectSuccess(BluetoothDevice device) {
                LogTool.p(TAG, "onConnectSuccess device:" + device.getAddress());
            }

            @Override
            public void onEdrConnectSuccess(BluetoothGatt gatt) {
                LogTool.p(TAG, "onEdrConnectSuccess device:"+ gatt.getDevice().getAddress());
            }

            @Override
            public void onConnectFail() {
                LogTool.e(TAG,"actions onConnectFail " + currentConnectTimes + " , " + connectRetryTimes + " , mIsDoing : " + mIsDoing);
                if(currentConnectTimes < connectRetryTimes && mIsDoing){
                    currentConnectTimes ++;
                    cancel();
                    if(mBleDfuConfig != null){
                        start(getContext(),mBleDfuConfig);
                    }
                }else{
                    currentConnectTimes = 0;
                    if(mIsDoing){
                        onFailed(0,"actions onConnectFail");
                    }else{
                        LogTool.p(TAG, "not in ota state , ignore");
                    }
                }
            }
        });
        mBluzConnector.connect(device);
    }

    public void disconnect() {
        if (mIsPerparing) {
            // 重连
            LogTool.p(TAG, "disconnect:" + mIsPerparing);
            new Handler().postDelayed(mPreparingReconnect, PREPARING_RECONNECT_TIME);

        } else {
            mIsStart = false;
            mIsMutiStressing = false;
            mIsPerparing = false;
            LogTool.p(TAG, "muti false");
            mOTAManager = null;

            if (mBluzConnector != null) {
                if (mGatt != null) {
                    Log.e(TAG, "closeNotify");
                    mBluzConnector.closeNotify();
                    mBluzConnector.disconnect(mGatt.getDevice());
                }
                if (mDevice != null) {
                    mBluzConnector.disconnect(mDevice);
                }
            }
        }
    }

    private void initData() {
        mIsStart = false;
//        mIsHarman = false;
    }

    private void clickPrepare() {
        String path;

        mIsPerparing = true;

//        if (mIsMutiStressing) {
//            path = mMutiPaths.get(mCurFileNum);
//        } else {
//            path = SPUtil.getInstance().getString(mContext, ActionsSP.SP_PATH, ActionsSP.SP_OTA_FILE_PATH, "");
//        }
        path = mBleDfuConfig.getFilePath();

        if (path.isEmpty()) {
            LogTool.p(TAG,"file path is null");
            return;
        }

        Thread connectThread = new Thread() {
            @Override
            public void run() {
                super.run();
                connectService();
            }
        };
        connectThread.start();
    }

    // 通过gatt连接服务
    private void connectService() {
        LogTool.p(TAG, "connectService");
        if (mBluzConnector == null) {
            LogTool.p(TAG, "请重连蓝牙后，再点击PrePare");
            return;
        }
//        mType = mModel.getBlueTypeFromSP(mContext);
//        if (mType == BluetoothType.BLE) {
            connectServiceBle(mGatt);
//        } else if (mType == BluetoothType.SPP) {
//            connectServiceSpp(mDevice);
//        } else if (mType == BluetoothType.EDR) {
//            connectServiceEdr(mGatt);
//        }
    }

    private void connectServiceBle(BluetoothGatt gatt) {
        LogTool.p(TAG, "connectServiceBle:" + gatt.getDevice().getName() + " , mac = " + gatt.getDevice().getAddress());
        String bleServiceUUID = OTA_BLE_UUID_SERVICE;
        String bleReadUUID = OTA_BLE_UUID_SERVICE_READ;
        String bleWriteUUID = OTA_BLE_UUID_SERVICE_WRITE;

        HashMap<String, UUID> uuids = new HashMap<>();
        uuids.put(BluzDeviceFactory.KeyUUIDS.keyServiceUUID, UUID.fromString(bleServiceUUID));
        uuids.put(BluzDeviceFactory.KeyUUIDS.keyReadCharacteristicUUID, UUID.fromString(bleReadUUID));
        uuids.put(BluzDeviceFactory.KeyUUIDS.keyWriteCharacteristicUUID, UUID.fromString(bleWriteUUID));
        mBluzConnector.setUUID(uuids);
        mBluzConnector.setOnServiceConnectListener(new IBluzDevice.OnServiceConnectListener() {
            @Override
            public void onServiceConnected() {
                LogTool.p(TAG, "discoverServices onServiceConnected");
                discoverServiceTimeOutHandler.removeCallbacksAndMessages(null);
                discoverServiceTimes = 0;
                runOnMainThread(new Runnable() {
                    @Override
                    public void run() {
                        mBluzConnector.cancelDiscovery();
                        initOTAManager();
                        try {
                            Thread.sleep(1500);
                            prepare();
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                            Log.e(TAG, "sleep ble:" + e);
                        }
                    }
                });
            }

            @Override
            public void onServiceConnectFail() {
                LogTool.p(TAG, "onServiceConnectFail");
                initOTAManager();
                onFailed(0,"discoverServices onServiceConnectFail");
            }
        });
        discoverServiceTimeOutHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                LogTool.p(TAG, "discoverServices timeout discoverServiceTimes = " + discoverServiceTimes);
                if(discoverServiceTimes < 5){
                    cancel();
                    if(mBleDfuConfig != null){
                        start(getContext(),mBleDfuConfig);
                    }
                }else{
                    discoverServiceTimes = 0;
                    onFailed(-1,"discoverServices fail");
                }
            }
        },15 * 1000);
        if(!isNoNeedRefreshGattCache()){
            refreshDeviceCache(gatt);
        }
        new Handler(Looper.getMainLooper()).postDelayed(new Runnable() {
            @Override
            public void run() {
                boolean result = mGatt.discoverServices();
                LogTool.p(TAG, "discoverServices result = " + result + " , gatt = " + mGatt);
                discoverServiceTimes ++;
            }
        }, 1000);

    }

    private void refreshDeviceCache(BluetoothGatt gatt) {
        if (!BluetoothAdapter.getDefaultAdapter().isEnabled()) {
            return;
        }
        try {
            final Method refresh = gatt.getClass().getMethod("refresh");
            //noinspection ConstantConditions
            final boolean success = (Boolean) refresh.invoke(gatt);
            LogTool.p(TAG, " refreshDeviceCache..." + success);
        } catch (Exception e) {
            LogTool.p(TAG, " refreshDeviceCache." + e.getMessage());
        }
    }

    private OTAManager.OTAListener mOtaListener = new OTAManager.OTAListener() {
        @Override
        public void onStatus(OtaStatus state) {
            diaplayConnectStatus(state);
        }

        @Override
        public void onAudioDataReceived(int psn, int len, byte[] data) {

        }

        @Override
        public void onRemoteStatusReceived(RemoteStatus status) {
            LogTool.p(TAG, "onRemoteStatusReceived status = " + status);
            mRemoteStatus = status;

//            mActivity.runOnUiThread(new Runnable() {
//                @Override
//                public void run() {
//                    mBinding.btnInfo.setEnabled(true);
//                }
//            });
        }

        @Override
        public void onProgress(int currentProgress, int total) {
            onProgressNotify(currentProgress,total);
        }

        @Override
        public void onError(int errcode, String errmsg) {
            LogTool.p(TAG,"onError currentTimes = " + currentTimes + " , retryTimes = " + retryTimes + " , errcode = " + errcode + " , msg = " + errmsg);
            onFailed(errcode,errmsg);
        }

        @Override
        public void onWriteBytes(int count) {
            final long currentTime = System.currentTimeMillis();
            runOnMainThread(new Runnable() {
                @Override
                public void run() {
                    long spendTime = (currentTime-mStartTime)/1000;
                    float speed = 0;
                    if (spendTime > 0)
                        speed = ((float)(count) / spendTime);
//                    mBinding.tvTime.setText(Utils.getInstance().formatSecondsDuration(spendTime));
//                    mBinding.tvSpeed.setText(Utils.getInstance().formatSpeed(speed));
                }
            });
        }
    };
    private void initOTAManager() {
        mOTAManager = new OTAManager(getContext(), mBluzConnector.getIO());
        mOTAManager.setOTAListener(mOtaListener);
        if (!mBluzConnector.isEnabled()) {
            mBluzConnector.enable();
        }
    }

    private void diaplayConnectStatus(OtaStatus status) {
        mOtaStatus = status;
        if (status == OtaStatus.STATE_TRANSFERRED) {
//            if (mType == BluetoothType.BLE || mType == BluetoothType.EDR) {
//                mOtaListener = null;
                mOTAManager = null;
                LogTool.p(TAG, "diaplayConnectStatus: close notify");
                mBluzConnector.closeNotify();
                if (mGatt != null) {
                    mBluzConnector.disconnect(mGatt.getDevice());
                }
//            }
        }
        runOnMainThread(new Runnable() {
            @Override
            public void run() {
                switch (status) {
                    case STATE_UNKNOWN:
                        mBluzConnector.setIsRunning(false);
                        LogTool.p(TAG,"status : STATE_UNKNOWN");
//                        mBinding.tvOtaStatus.setText(mContext.getString(R.string.ota_status_unknown));
                        // 如果是压测，则重连
//                        if (mIsStress || mIsMutiStressing) {
//                            reconnectAndStress();
//                        }
                        break;
                    case STATE_IDLE:
                        LogTool.p(TAG,"status : STATE_IDLE");
//                        mBinding.tvOtaStatus.setText(mContext.getString(R.string.ota_status_idle));
                        break;
                    case STATE_PREPARING:
                        LogTool.p(TAG,"status : STATE_PREPARING");
//                        mBinding.tvOtaStatus.setText(mContext.getString(R.string.ota_status_preparing));
                        break;
                    case STATE_PREPARED:
                        mIsPerparing = false;
                        LogTool.p(TAG,"status : STATE_PREPARED");
//                        mBinding.tvOtaStatus.setText(mContext.getString(R.string.ota_status_prepared));
//                        if (SPUtil.getInstance().getBool(mContext, ActionsSP.SP_PATH, ActionsSP.SP_MUTI_UPDATA, false)) {
//                            mBinding.btnMutiStress.setEnabled(true);
//                            mBluzConnector.setIsRunning(true);
//                            if (mIsMutiStressing) {
//                                mutiStress();
//                            }
//                        } else {
//                            mBinding.btnStart.setEnabled(true);
//                            mBinding.btnStress.setEnabled(true);
//                            mBinding.btnStressOne.setEnabled(true);

                            mBluzConnector.setIsRunning(true);

//                            Log.e(TAG, "STATE_PREPARE：" + mIsStressing);
//                            if (mIsStressing) {
//                                stress();
//                            }
//                        }
                        startOta();
                        break;
                    case STATE_TRANSFERRING:
                        LogTool.p(TAG,"status : STATE_TRANSFERRING");
//                        mBinding.tvOtaStatus.setText(mContext.getString(R.string.ota_status_transferring));
                        mStartTime = System.currentTimeMillis();
//                        mBinding.tvTime.setText(Utils.getInstance().formatSecondsDuration(0));
//                        if (mIsStress) {
//                            mBinding.btnStress.setText(R.string.ota_cancel);
//                            mBinding.btnStressOne.setEnabled(false);
//                            mBinding.btnStart.setEnabled(false);
//                            mBinding.btnInfo.setEnabled(false);
//                        }
//                        if (mIsOneStress) {
//                            mBinding.btnStressOne.setText(R.string.ota_cancel);
//                            mBinding.btnStress.setEnabled(false);
//                            mBinding.btnStart.setEnabled(false);
//                            mBinding.btnInfo.setEnabled(false);
//                        }
//                        if (mIsMutiStressing) {
//                            mBinding.btnMutiStress.setText("CANCEL");
//                        }
                        break;
                    case STATE_TRANSFERRED:
                        LogTool.p(TAG,"status : STATE_TRANSFERRED");
//                        if (mIsMutiStressing) {
//                            mBinding.btnMutiStress.setText("STRESS MUTI");
//                        } else {
//                            mBinding.btnStart.setText(mContext.getString(R.string.ota_start_btn));
//                            mBinding.btnStress.setText(mContext.getString(R.string.ota_stress_btn));
//                            mBinding.btnStressOne.setText(mContext.getString(R.string.ota_stress_one_bin_btn));
//                        }
//                        mBinding.tvOtaStatus.setText(mContext.getString(R.string.ota_status_transferred));
//                        mBinding.seekbar.setProgressValue(100);
//                        mBinding.seekbar.invalidate();

                        mBluzConnector.setIsRunning(false);
                        onSuccess();
//                        Toast.makeText(mContext, mContext.getText(R.string.ota_toast_finish), Toast.LENGTH_SHORT).show();
//                        LogTool.p(TAG, "mIsStress || mIsOneStress:" + (mIsStress || mIsOneStress));
//                        if (mIsMutiStressing) {
//                            stressNextMutiFile();
//                            reconnectAndStress();
//                        } else {
//                            if (mIsStress || mIsOneStress) {
//                                if (mIsOneStress) {
//                                    stressNextOTAFile();
//                                }
//                                reconnectAndStress();
//                            }
//                        }
                        break;
                }
            }
        });
    }


    public void startOta() {
        LogTool.p(TAG, "start");
//        if (mIsHarman) {
//            startHarman();
//        } else {
            if (mIsStart) {
                // 暂停
//                mBinding.btnStart.setText(mContext.getText(R.string.ota_start_btn));
                mIsStart = false;
                if (mOTAManager != null) {
                    mOTAManager.cancel();
                }
                mBluzConnector.release();
                onFailed(-1,"蓝牙已断开，如需更新请重连！");
            } else {
                // 开始
//                mBinding.btnStart.setText(mContext.getText(R.string.ota_cancel));
                mIsStart = true;
                start();
            }
        }

    private void start() {
        if (mOTAManager != null) {
            mOTAManager.upgrade();
            mBluzConnector.setStressMode(false); // 设置压力测试状态为false
        } else {
            onFailed(0,"OTA状态错误，请重连蓝牙后重试");
//            Toast.makeText(mContext, "OTA状态错误，请重连蓝牙后重试！", Toast.LENGTH_SHORT).show();
        }
    }

    public void cancelByCloseBluetooth(){
        LogTool.e(BleDFUConstants.LOG_TAG_ACTIONS, "cancelByCloseBluetooth ");
        onTimeEnd();
        ActionsToFlutterImpl.INSTANCE.onOTAStateChanged(ActionsOTAState.FAILED, "Bluetooth closed");
        ActionsToFlutterImpl.INSTANCE.log("[Actions OTA] cancelByCloseBluetooth");
        release();
    }
    public void cancel(){
        ActionsToFlutterImpl.INSTANCE.onOTAStateChanged(ActionsOTAState.CANCELLED, "");
        ActionsToFlutterImpl.INSTANCE.log("[Actions OTA] cancel");
        onTimeEnd();
        release();
    }

    private void onStart(){
        isOnTiming = true;
        mIDFULibProgressStateChange.onStart(new DFULibProgressStateChangePresenter.IDFULibProgressStateTimeOutListener() {
            @Override
            public void onTimeOut() {
                isOnTiming = false;
                onFailed(2,"Actions dfu  time out , failed");
            }
        });
    }
    private void onSuccess(){
        discoverServiceTimes = 0;
        LogTool.e(BleDFUConstants.LOG_TAG_ACTIONS, "upgrade onSuccess");
        mIsDoing = false;
        onTimeEnd();
        ActionsToFlutterImpl.INSTANCE.onOTAStateChanged(ActionsOTAState.COMPLETED, "");
        ActionsToFlutterImpl.INSTANCE.log("[Actions OTA] onSuccess");
        release();
    }

    private void onTimeEnd() {
        LogTool.e(BleDFUConstants.LOG_TAG_ACTIONS, "onTimeEnd");
        isOnTiming = false;
        if (mIDFULibProgressStateChange != null) {
            mIDFULibProgressStateChange.onEnd();
        }
        try {
            if(mBluetoothStatusReceiver != null){
                Config.getApplication().getApplicationContext().unregisterReceiver(mBluetoothStatusReceiver);
            }
        }catch (Exception e){
            LogTool.e(BleDFUConstants.LOG_TAG_ACTIONS, "unregisterReceiver e " + e);
        }

    }

    private void onFailed(int errcode,String msg){
        LogTool.e(BleDFUConstants.LOG_TAG_ACTIONS, "upgrade onFailed, errcode = " + errcode + " , msg = " + msg + " , currentTimes = " + currentTimes + " , retryTimes = " + retryTimes);
        if (currentTimes < retryTimes) {
            release();
            currentTimes++;
            if (mBleDfuConfig != null) {
                start(getContext(), mBleDfuConfig);
            }
        } else {
            onTimeEnd();
            ActionsToFlutterImpl.INSTANCE.onOTAStateChanged(ActionsOTAState.FAILED, msg);
            ActionsToFlutterImpl.INSTANCE.log("[Actions OTA] onFailed errcode=" + errcode + " msg=" + msg);
            release();
        }
    }
    private void onProgressNotify(int current,int total){
        int curProgress = (int) (((double)current / total) * 100);
        LogTool.p(BleDFUConstants.LOG_TAG_ACTIONS,"currentSize: " + current + " , total = " + total + " , curProgress = " + curProgress);
        if(progress != curProgress){
            progress = curProgress;
            mIDFULibProgressStateChange.onStateChange();
            ActionsToFlutterImpl.INSTANCE.onOTAProgress((double) progress, "");
        }
    }

    private void release() {
        mIsDoing = false;
        if (mGatt != null) {
            if(mBluzConnector != null){
                mBluzConnector.closeNotify();
                mBluzConnector.disconnect(mGatt.getDevice());
            }
            if (mScanner != null) {
                mScanner.stopBleScan();
            }
        } else {
            if (mDevice != null && mBluzConnector != null) {
                mBluzConnector.setOnDiscoveryListener(null);
                mBluzConnector.disconnect(mDevice);
            }
        }
        if(mBluzConnector != null){
            mBluzConnector.release();
        }
        if (mOTAManager != null) {
            mOTAManager.cancel();
        }
        mIsMutiStressing = false;
        mIsPerparing = false;
//        if(mIDFULibProgressStateChange != null){
//            mIDFULibProgressStateChange.onEnd();
//        }
        discoverServiceTimeOutHandler.removeCallbacksAndMessages(null);
    }

    public boolean isUpdate(){
        return mIsDoing;
    }

    public boolean isNoNeedRefreshGattCache() {
        //售后发现，待补充：SM-A556E
        String model = Build.MODEL;
        return "SM-A5360".equalsIgnoreCase(model) || "SM-A556E".equalsIgnoreCase(model);
    }


    /**
     * 保证所有的回调，都是在主线程执行的
     */
    private Handler mainHandler = new Handler(Looper.getMainLooper());
    public void runOnMainThread(Runnable runnable){
        if (Looper.myLooper() == Looper.getMainLooper()) {
            runnable.run();
        } else {
            getMainHandler().post(runnable);
        }
    }

    /**
     * 在极端情况下，可能会被回收，所以在这里重新初始化一下
     */
    private Handler getMainHandler(){
        if (mainHandler == null){
            mainHandler = new Handler(Looper.getMainLooper());
        }
        return mainHandler;
    }
}
