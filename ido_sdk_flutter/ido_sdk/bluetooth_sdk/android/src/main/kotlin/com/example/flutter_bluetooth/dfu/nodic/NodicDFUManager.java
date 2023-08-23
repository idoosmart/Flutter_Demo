package com.example.flutter_bluetooth.dfu.nodic;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.Intent;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;


import com.example.flutter_bluetooth.Config;
import com.example.flutter_bluetooth.ble.DeviceManager;
import com.example.flutter_bluetooth.ble.callback.DeviceUpgradeEventListener;
import com.example.flutter_bluetooth.ble.callback.EnterDfuModeCallback;
import com.example.flutter_bluetooth.dfu.BLEDevice;
import com.example.flutter_bluetooth.dfu.BleDFUConfig;
import com.example.flutter_bluetooth.dfu.BleDFUConstants;
import com.example.flutter_bluetooth.dfu.BleDFUState;
import com.example.flutter_bluetooth.dfu.DFUService;
import com.example.flutter_bluetooth.dfu.common.presenter.DFULibProgressStateChangePresenter;
import com.example.flutter_bluetooth.dfu.common.presenter.IBaseDFUListener;
import com.example.flutter_bluetooth.dfu.common.presenter.IDFULibProgressStateChange;
import com.example.flutter_bluetooth.dfu.common.task.DFUConnectTask;
import com.example.flutter_bluetooth.dfu.common.task.DFUDisconnectTask;
import com.example.flutter_bluetooth.dfu.common.utils.ReOpenPhoneBluetoothSwitchTask;
import com.example.flutter_bluetooth.dfu.nodic.task.CheckDFUResultTask;
import com.example.flutter_bluetooth.dfu.nodic.task.EnterDFUModeTask;
import com.example.flutter_bluetooth.dfu.nodic.task.ScanTargetDFUDeviceTask;
import com.example.flutter_bluetooth.dfu.nodic.task.TempProgressUpdateTask;
import com.example.flutter_bluetooth.logger.Logger;
import com.example.flutter_bluetooth.utils.CommonUtils;
import com.example.flutter_bluetooth.utils.GsonUtil;
import com.example.flutter_bluetooth.utils.PairedDeviceUtils;

import java.lang.reflect.Method;

import no.nordicsemi.android.dfu.DfuBaseService;
import no.nordicsemi.android.dfu.DfuProgressListener;
import no.nordicsemi.android.dfu.DfuServiceInitiator;
import no.nordicsemi.android.dfu.DfuServiceListenerHelper;
import no.nordicsemi.android.error.LegacyDfuError;
import no.nordicsemi.android.error.SecureDfuError;


/**
 * Created by Zhouzj on 2017/12/22.
 * 设备升级管理
 * <p>
 * //先断开连接
 * //扫描目标设备，看设备处于什么状态：如果处于dfu，则直接升级；如果不处于dfu，则先连接设备，再让设备进入dfu模式
 * <p>
 * //1.让设备进入DFU模式
 * //2.扫描设备，看设备是否出于DFU模式
 * //3.开始升级
 * //4.处理升级过程中出现的异常
 * //5.升级完成
 * //6.检测升级结果（升级完成之后，设备会重启，并处于非DFU模式）
 */

public class NodicDFUManager {
    private final static int MAX_RETRY_TIMES = 6;
    //    private static NodicDFUManager instance;
    private boolean mIsDoing = false;
    private BleDFUConfig mDfuConfig;
    private IBaseDFUListener mIBaseDfuListener;
    private int mRetryTimes = 0, mTryToConnectDirectTimes = 0;
    private int mLastProgress = 0;
    /**
     * 是否强制重新发送initPack文件
     */
    private boolean mForceSendInitFile = false;
    /**
     * ota文件是否传输完成
     */
    private boolean mOtaFileHasTranFinished = false;
    private int mServiceNotFindTimes = 0;
    private CheckDFUResultTask mCheckDFUResultTask;
    private IDFULibProgressStateChange mIDFULibProgressStateChange;

    /**
     * 是否是 nodic-dfu库自身调用了cancel接口
     */
    private boolean isCanceledByNodicDfuLib = true;


    private Handler delayTimeHandler = new Handler(Looper.getMainLooper());
    private ScanTargetDFUDeviceTask mScanTargetDFUDeviceTask;
    private DFUConnectTask mDfuConnectTask;
    private EnterDFUModeTask mEnterDFUModeTask;
    private DFUDisconnectTask mDfuDisconnectTask;
    private DfuProgressListener mDfuProgressListener;
    private String updateMac;//升级的mac, 默认为传过来的地址
    private boolean findDecive = false; //是否搜到了设备

    private class ProgressListener implements DfuProgressListener {

        @Override
        public void onDeviceConnecting(String deviceAddress) {
            Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager:DfuProgressListener] onDeviceConnecting");
            mIDFULibProgressStateChange.onStateChange();
            mIBaseDfuListener.onDeviceConnecting();
        }

        @Override
        public void onDeviceConnected(String deviceAddress) {
            Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager:DfuProgressListener] onDeviceConnected");
            mIDFULibProgressStateChange.onStateChange();
            mIBaseDfuListener.onDeviceConnected();
        }

        @Override
        public void onDfuProcessStarting(String deviceAddress) {
            Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager:DfuProgressListener] onDfuProcessStarting");
            mIDFULibProgressStateChange.onStateChange();
            mIBaseDfuListener.onDfuProcessStarting();
        }

        @Override
        public void onDfuProcessStarted(String deviceAddress) {
            Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager:DfuProgressListener] onDfuProcessStarted");
            mIDFULibProgressStateChange.onStateChange();
            mIBaseDfuListener.onDfuProcessStarted();
        }

        @Override
        public void onEnablingDfuMode(String deviceAddress) {
            Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager:DfuProgressListener] onEnablingDfuMode");
            mIDFULibProgressStateChange.onStateChange();
            mIBaseDfuListener.onEnablingDfuMode();
        }

        @Override
        public void onProgressChanged(String deviceAddress, int percent, float speed, float avgSpeed, int currentPart, int partsTotal) {
            Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager:DfuProgressListener] onProgressChanged, progress = " + percent);

            DeviceUpgradeEventListener.NODIC_onProgress(percent);

            if (percent <= 99) {
                updateRealProgress(percent);
            }

            if (percent == 100) {
                mOtaFileHasTranFinished = true;
            }

            mIDFULibProgressStateChange.onStateChange();
        }

        @Override
        public void onFirmwareValidating(String deviceAddress) {
            Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager:DfuProgressListener] onFirmwareValidating");
            mIDFULibProgressStateChange.onStateChange();
            mIBaseDfuListener.onFirmwareValidating();
        }

        @Override
        public void onDeviceDisconnecting(String deviceAddress) {
            Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager:DfuProgressListener] onDeviceDisconnecting");
            mIDFULibProgressStateChange.onStateChange();
            mIBaseDfuListener.onDeviceDisconnecting();
        }

        @Override
        public void onDeviceDisconnected(String deviceAddress) {
            Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager:DfuProgressListener] onDeviceDisconnected");
            mIDFULibProgressStateChange.onStateChange();
            mIBaseDfuListener.onDeviceDisconnected();
        }

        @Override
        public void onDfuCompleted(String deviceAddress) {
            Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager:DfuProgressListener] onDfuCompleted");
            updateRealProgress(100);

            mIDFULibProgressStateChange.onEnd();

            //dfu库这边，已提示升级完成，则先注销监听
            DfuServiceListenerHelper.unregisterProgressListener(CommonUtils.getAppContext(), mDfuProgressListener);
            //加上下面的逻辑，是因为有的时候升级完成了，但设备却没有重启
            //checkDfuResult(deviceAddress);
            checkDfuResult(mDfuConfig.getMacAddress());
        }

        @Override
        public void onDfuAborted(String deviceAddress) {
            //有的时候，我们没有主动调用cancel方法，它内部也会回调此接口(目的是重启服务再次尝试升级)
            if (isCanceledByNodicDfuLib) {
                Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager:DfuProgressListener] onDfuAborted by nodic-dfu-lib");
                mIDFULibProgressStateChange.onEnd();

                prepareToRestart(false);

            } else {
                Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager:DfuProgressListener] onDfuAborted");
                receiveCancelNotify();
            }
        }

        @Override
        public void onError(String deviceAddress, int error, int errorType, String message) {
            Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager:DfuProgressListener] error=" + error + ", errorType=" + errorType + "," + message);
            mIDFULibProgressStateChange.onEnd();
            handleError(error, errorType, message);
        }
    }

    ;

    public NodicDFUManager() {
    }

//    public static NodicDFUManager getManager() {
//        if (instance == null) {
//            instance = new NodicDFUManager();
//        }
//        return instance;
//    }

    private void checkDfuResult(String deviceAddress) {
        Logger.e(BleDFUConstants.LOG_TAG_NODIC, "to check dfu result:" + deviceAddress);
        if (mCheckDFUResultTask != null) {
            mCheckDFUResultTask.stop();
        }

        mCheckDFUResultTask = new CheckDFUResultTask();
        mCheckDFUResultTask.start(new CheckDFUResultTask.IResult() {
            @Override
            public void onDeviceInNormalState() {
                Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager:mCheckDFUResultTask] onDeviceInNormalState    upgradeSuccess();\n");
                upgradeSuccess();
                mIBaseDfuListener.onSuccess();
            }

            @Override
            public void onDeviceInDfuState() {
                Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager:mCheckDFUResultTask] onDeviceInDfuState     upgradeSuccess();\n");
                upgradeSuccess();
                //有的时候手环重启比较慢；
                //有的时候扫描到设备时，发现服务是dfu，但手环其实已重启
                //所以这里改成这个回调，让用户自己检测
                mIBaseDfuListener.onSuccessAndNeedToPromptUser();
            }

            @Override
            public void onCannotCheckDeviceStatus() {
                Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager:mCheckDFUResultTask] onCannotCheckDeviceStatus     upgradeSuccess();\n");
                //这种情况下，是因为一直扫描不到设备，所有无法判断设备的状态；但升级流程已完整走完!
                upgradeSuccess();
                // 这个时候，APP那边需要提醒用户“如果设备未重启，请退出App或重启蓝牙，再次尝试升级”;
                mIBaseDfuListener.onSuccessAndNeedToPromptUser();

            }
        }, deviceAddress);
    }

    private void handleError(int error, int errorType, String message) {
        boolean isNeedScan = false;
        switch (error) {
            case DfuBaseService.ERROR_FILE_NOT_FOUND:
//            case DfuBaseService.ERROR_FILE_ERROR:
//            case DfuBaseService.ERROR_FILE_INVALID:
//            case DfuBaseService.ERROR_FILE_IO_EXCEPTION:
            case DfuBaseService.ERROR_FILE_SIZE_INVALID:
            case DfuBaseService.ERROR_FILE_TYPE_UNSUPPORTED:
                upgradeFailed();
                mIBaseDfuListener.onFailedByFileError();
                return;
            case DfuBaseService.ERROR_BLUETOOTH_DISABLED:
                upgradeFailed();
                mIBaseDfuListener.onFailedByPhoneBluetoothError();
                return;
            case DfuBaseService.ERROR_DEVICE_DISCONNECTED:
                if (!BluetoothAdapter.getDefaultAdapter().isEnabled()) {
                    handPhoneBluetoothSwitchOff();
                    return;
                }
                break;
            case DfuBaseService.ERROR_SERVICE_NOT_FOUND:
                isNeedScan = true;
                mServiceNotFindTimes++;
                if (mServiceNotFindTimes == 2) {
//                    removeBondState();
                }
                break;
            case DfuBaseService.ERROR_REMOTE_TYPE_LEGACY | LegacyDfuError.OPERATION_FAILED:
                upgradeFailed();
                mIBaseDfuListener.onFailedByOperationFailed();
                return;
            case DfuBaseService.ERROR_FILE_IO_EXCEPTION:
            case DfuBaseService.ERROR_REMOTE_TYPE_SECURE | SecureDfuError.OPERATION_NOT_PERMITTED:
                //当出现这个错误时，必须要把initPack文件重新发送，否则将永远报这个错（即使更换手机升级，也是一样报错）
                mForceSendInitFile = true;
                break;
        }

        mIBaseDfuListener.onOtherErrorOccurred(error, message);

        prepareToRestart(isNeedScan);

    }

    private void removeBondState() {
        if (mDfuConfig.isDeviceSupportPairedWithPhoneSystem()) {
            return;
        }
        BluetoothDevice device = PairedDeviceUtils.getPairedDevice(mDfuConfig.getMacAddress());
        if (device != null) {
            Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] remove bond state.");
            PairedDeviceUtils.removeBondState(device);
        }
    }

    private void prepareToRestart(final boolean isNeedScan) {
        releaseAndPrepareToRestart();
        Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] wait for restart ..." + (mRetryTimes + 1));
        // Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] removeBondState " + mDfuConfig.getMacAddress());
        // PairedDeviceUtils.removeBondState(mDfuConfig.getMacAddress());

        startTempProgressTask();

        delayTimeHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                stopDfuService();
                delayTimeHandler.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        reStart(isNeedScan);
                    }
                }, 5000);

            }
        }, 10000);
    }

    public void cancel() {
        if (!mIsDoing) {
            return;
        }
        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] start to cancel...");

        isCanceledByNodicDfuLib = false;

        cancelDfuAction();
        //有时候发送上面的取消命令， 不会收到回调
        delayTimeHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                receiveCancelNotify();
            }
        }, 10000);


    }

    private void receiveCancelNotify() {
        if (!mIsDoing) {
            return;
        }
        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] upgrade canceled, exit!");
        release();
        mIBaseDfuListener.onCancel();
        mIDFULibProgressStateChange.onEnd();

    }

    public boolean start(BleDFUConfig dfuConfig, BleDFUState.IListener listener) {
        Logger.i(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] ----start-------------->");
        if (dfuConfig == null || TextUtils.isEmpty(dfuConfig.getMacAddress())) {
            Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] dfuConfig is null!");
            return false;
        }
        if (mIsDoing) {
            Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] is doing ,ignore this action.");
            return false;
        }
//        mIBaseDfuPresenter = new BaseDFUPresenter(dfuConfig);
        mIBaseDfuListener = new NordicDFUListener(dfuConfig.getMacAddress(), listener);
        mIDFULibProgressStateChange = new DFULibProgressStateChangePresenter();
        mDfuProgressListener = new ProgressListener();

        findDecive = false;
        mIBaseDfuListener.onPrepare();

        if (!checkParas(dfuConfig)) {
//            upgradeFailed();
            mIBaseDfuListener.onFailedByConfigParaError();
            return false;
        }


        mIsDoing = true;

        startTempProgressTask();

        //如果是连接的状态，那肯定是没有进入DFU模式
        // 我们的升级核心逻辑是使用的第3方的，他们有他们自己连接逻辑；
        // 所以在升级前，我们会断开我们的连接

        // 设备处于dfu模式之后，用我们的连接逻辑，将连不上设备（主要是无法开启通知）
        if (DeviceManager.isConnected(updateMac)) {
            toEnterDfuMode();
        } else {
            scanTargetDfuDevice();
        }

        return true;

    }

    private void reStart(boolean isNeedScan) {
        if (!mIsDoing) {
            Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] is not in doing state, don't reStart.");
            return;
        }

        if (!BluetoothAdapter.getDefaultAdapter().isEnabled()) {
            Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] bluetooth switch is closed, upgrade failed, exit!");
            upgradeFailed();
            mIBaseDfuListener.onFailedByPhoneBluetoothError();
            return;
        }

        mRetryTimes++;

        if (mRetryTimes > mDfuConfig.getMaxRetryTime()) {
            Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] out of max retry times, upgrade failed, exit!");
            upgradeFailed();
            mIBaseDfuListener.onFailedByOutOfMaxRetryTimes();
            return;
        }

        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] restart, times is " + mRetryTimes);
        mIBaseDfuListener.onRestart(mRetryTimes);
        if (mRetryTimes % 2 == 0) {
            scanTargetDfuDevice();
            return;
        }
        if (mRetryTimes == 3 && mDfuConfig.isNeedReOpenBluetoothSwitchIfFailed()) {
            Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] findDecive " + findDecive + "updatemac:" + updateMac);
            if (findDecive && updateMac.equals(mDfuConfig.getMacAddress())) { //扫描到的mac==传过来的mac,说明dfu 模式的mac没有变，可以清除配对（老的升级方式），新的方式不可以清除
                PairedDeviceUtils.removeBondState(updateMac);
                Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] removeBondState " + updateMac);
            }
            //重启一下蓝牙
            new ReOpenPhoneBluetoothSwitchTask().start(new ReOpenPhoneBluetoothSwitchTask.ITaskStateListener() {
                @Override
                public void onFinished() {
                    //如果重启过蓝牙，那就必须先扫描，后续才能被正常连接上
                    realResStart(true);
                }
            });
        } else {
            realResStart(isNeedScan);
        }
    }

    private void realResStart(boolean isNeedScan) {

        if (isNeedScan) {
            //如果是连接的状态，那肯定是没有进入DFU模式
            if (DeviceManager.isConnected(updateMac)) {
                toEnterDfuMode();
            } else {
                scanTargetDfuDevice();
            }
        } else {
            upgrade();
        }

    }

    private boolean checkParas(BleDFUConfig dfuConfig) {
        if (dfuConfig == null) {
            Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] mDfuConfig is null");
            return false;
        }

        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] dfuConfig is " + GsonUtil.toJson(dfuConfig));

        if (TextUtils.isEmpty(dfuConfig.getFilePath())) {
            Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] file path is null");
            return false;
        }

        if (TextUtils.isEmpty(dfuConfig.getMacAddress())) {
            Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] mac address is null");
            return false;
        }

//        if (TextUtils.isEmpty(dfuConfig.getDeviceId())) {
//            Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] device_id is null");
//            return false;
//        }
        mDfuConfig = dfuConfig;
        updateMac = dfuConfig.getMacAddress();
        if (mDfuConfig.getMaxRetryTime() == 0) {
            mDfuConfig.setMaxRetryTime(MAX_RETRY_TIMES);
        }
        return true;
    }

    private void scanTargetDfuDevice() {
        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] to scan target dfu Device.");
        if (mScanTargetDFUDeviceTask != null) {
            mScanTargetDFUDeviceTask.stop();
        }

        mScanTargetDFUDeviceTask = new ScanTargetDFUDeviceTask();
        mScanTargetDFUDeviceTask.start(new ScanTargetDFUDeviceTask.IResult() {
            @Override
            public void onNotFind() {
                if (!BluetoothAdapter.getDefaultAdapter().isEnabled()) {
                    upgradeFailed();
                    mIBaseDfuListener.onFailedByPhoneBluetoothError();
                    return;
                }

                if (!isCanTryToConnectDirect()) {
                    reStart(false);
                    return;
                }

                boolean result = notFindDeviceAndTryToConnectDirect(updateMac);

                if (!result) {
                    reStart(false);
                }

            }

            @Override
            public void onFindAndInDfuMode(BLEDevice bleDevice) {
                updateMac = bleDevice.mDeviceAddress;
                findDecive = true;
                upgrade();
            }

            @Override
            public void onFindButHasConnectedToPhone(BLEDevice bleDevice) {
                if (DeviceManager.isConnected(updateMac)) {
                    toEnterDfuMode();
                } else {
                    hasFindDeviceAndToConnectDevice(bleDevice);
                }
            }

            @Override
            public void onFindButNotInDfuMode(BLEDevice bleDevice) {
                hasFindDeviceAndToConnectDevice(bleDevice);
            }


        }, mDfuConfig.getMacAddress());
    }

    private boolean isCanTryToConnectDirect() {
        mTryToConnectDirectTimes++;

        if (mTryToConnectDirectTimes > 2) {
            return false;
        }

        return true;
    }

    /**
     * 未扫描到设备，尝试直接连接（有的时候，手环其实已被当前手机连接上了，所以扫描不到，但可以直接连接成功）
     */
    private boolean notFindDeviceAndTryToConnectDirect(String macAddress) {
        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] (notFindDeviceAndTryToConnectDirect) to connect device direct");

        BLEDevice bleDevice = new BLEDevice();
        bleDevice.mDeviceAddress=macAddress;
        startDFUConnectTask(bleDevice);
        return true;
    }

    private void startDFUConnectTask(final BLEDevice bleDevice) {
        if (mDfuConnectTask != null) {
            mDfuConnectTask.stop();
        }

        mDfuConnectTask = new DFUConnectTask();


        mDfuConnectTask.start(new DFUConnectTask.IResult() {
            @Override
            public void onConnectSuccess() {
                toEnterDfuMode();
            }

            @Override
            public void onConnectFailed() {
                scanTargetDfuDevice();
            }

            @Override
            public void onAlreadyInDfuMode() {
                updateMac = bleDevice.mDeviceAddress;
                upgrade();
            }
        }, bleDevice);
    }

    private void hasFindDeviceAndToConnectDevice(BLEDevice bleDevice) {
        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] (hasFindDeviceAndToConnectDevice) to connect Device");
        startDFUConnectTask(bleDevice);
    }

    private void toEnterDfuMode() {
        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] to enter dfu mode");
        if (mEnterDFUModeTask != null) {
            mEnterDFUModeTask.stop();
        }

        mEnterDFUModeTask = new EnterDFUModeTask(updateMac);
        mEnterDFUModeTask.start(new EnterDFUModeTask.IResult() {
            @Override
            public void onSuccess() {
                mIBaseDfuListener.onDeviceInDFUMode();
                if (DeviceManager.isConnected(updateMac)) {
                    toBreakCurrentConnectAndStartToUpgrade();
                } else {
                    scanTargetDfuDevice();
                    //upgrade();
                }
            }

            @Override
            public void onFailed(EnterDfuModeCallback.DfuError error) {
                upgradeFailed();
                mIBaseDfuListener.onFailedByEnterDFUModeFailed(error);
            }

            @Override
            public void onRetryButAllTimeOut() {
                upgradeFailed();
                mIBaseDfuListener.onFailedByEnterDFUModeTimeout();
            }

            @Override
            public void onConnectBreak() {
                scanTargetDfuDevice();
            }
        });
    }

    private void toBreakCurrentConnectAndStartToUpgrade() {
        if (mDfuDisconnectTask != null) {
            mDfuDisconnectTask.stop();
        }

        mDfuDisconnectTask = new DFUDisconnectTask();
        mDfuDisconnectTask.start(new DFUDisconnectTask.IResult() {
            @Override
            public void onFinished() {
                // upgrade();
                scanTargetDfuDevice();
            }
        }, mDfuConfig.getMacAddress());
    }

    private void upgrade() {
        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] upgrade...mac:" + updateMac);
        //removeBondState();
        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] upgrade...findDecive:" + findDecive);
        if (findDecive && updateMac.equals(mDfuConfig.getMacAddress())) {
            Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] removeBondState " + mDfuConfig.getMacAddress());
            PairedDeviceUtils.removeBondState(mDfuConfig.getMacAddress());
        }
        DfuServiceListenerHelper.registerProgressListener(CommonUtils.getAppContext(), mDfuProgressListener);

        DfuServiceInitiator initiator = new DfuServiceInitiator(updateMac);
        initiator.setDisableNotification(true);
        initiator.setZip(mDfuConfig.getFilePath());
        initiator.setKeepBond(mDfuConfig.isDeviceSupportPairedWithPhoneSystem());
        setForceSendInitFile(initiator, mForceSendInitFile);
        if (mDfuConfig.getPRN() > 0) {
            initiator.setPacketsReceiptNotificationsEnabled(true);
            initiator.setPacketsReceiptNotificationsValue(mDfuConfig.getPRN());
        }


        initiator.start(CommonUtils.getAppContext(), DFUService.class);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            initiator.createDfuNotificationChannel(Config.getApplication());
        }

        mOtaFileHasTranFinished = false;
        //处理升级过程中“无响应”的场景
        mIDFULibProgressStateChange.onStart(new DFULibProgressStateChangePresenter.IDFULibProgressStateTimeOutListener() {
            @Override
            public void onTimeOut() {
                mForceSendInitFile = true;
                handleNoResponseScene();
            }

        });
    }

    /**
     * nodic平台的断点续传有时会出问题“报错，operator not permit, error =8”,一旦出现这个错误之后，
     * 必须要禁用“断点续传”才能升级成功
     */
    private void setForceSendInitFile(DfuServiceInitiator initiator, boolean force) {
        try {
            for (Method method : initiator.getClass().getMethods()) {
                //nodic-sdk1.11.1新增了这个接口“禁用断点续传”, 有的客户使用的还是旧的nodic-sdk，所以这里做兼容
                if ("disableResume".equals(method.getName()) && force) {
//                    initiator.disableResume();
                    method.invoke("disableResume");
                    Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] upgrade... initiator.disableResume()");
                    break;
                }
                //nodic官方SDk没有这个接口，这个接口是我们修改他们的源码，然后新增的(有的客户使用的是我们提供的aar包)
                if ("setForceSendInitFile".equals(method.getName())) {
                    method.invoke(initiator, force);
                    Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] upgrade... setForceSendInitFile" + force);
                    break;
                }
            }
        } catch (Exception e) {
            Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] upgrade..." + e.getMessage());
        }
    }

    private void handleNoResponseScene() {
        if (!mIsDoing) {
            Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] handleNoResponseScene, mIsDoing = false.");
            return;
        }
        if (mOtaFileHasTranFinished) {
            Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] handleNoResponseScene, mOtaFileHasTranFinished = true.");
            checkDfuResult(mDfuConfig.getMacAddress());
        } else {
            prepareToRestart(false);
        }
//        prepareToRestart(false);
    }

    private void handPhoneBluetoothSwitchOff() {
        Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] handPhoneBluetoothSwitchOff");
        if (!mIsDoing) {
            Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] handPhoneBluetoothSwitchOff, mIsDoing = false.");
            return;
        }

        upgradeFailed();
        mIBaseDfuListener.onFailedByPhoneBluetoothError();
    }

    private void upgradeSuccess() {
        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] upgrade success");
        release();
    }

    private void upgradeFailed() {
        Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] upgrade failed, exit!");
        release();
    }

    private void releaseAndPrepareToRestart() {
        Logger.i(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] release to prepare to restart");

        stopAllTask();
        DfuServiceListenerHelper.unregisterProgressListener(CommonUtils.getAppContext(), mDfuProgressListener);

        cancelDfuAction();
//        stopDfuService();

    }

    private int mTmpProgress = 0;

    private void startTempProgressTask() {
        TempProgressUpdateTask.getTask().start(new TempProgressUpdateTask.ITempProgressListener() {
            @Override
            public void onTempProgress(int progress) {
//                mTmpProgress = progress;
//                updateTempProgress(progress);
            }
        });
    }

    private void updateTempProgress(int progress) {
        mIBaseDfuListener.onProgress(progress);
    }

    private void updateRealProgress(int progress) {
        TempProgressUpdateTask.getTask().stop();
        if (progress > mTmpProgress) {
            mIBaseDfuListener.onProgress(progress);
        }
    }

    private void release() {
        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] release");
        TempProgressUpdateTask.getTask().stop();
        mIsDoing = false;
        mRetryTimes = 0;
        mLastProgress = 0;
        mTryToConnectDirectTimes = 0;
        mTmpProgress = 0;
        delayTimeHandler.removeCallbacksAndMessages(null);
        isCanceledByNodicDfuLib = true;
        mServiceNotFindTimes = 0;
        mOtaFileHasTranFinished = false;
        mForceSendInitFile = false;

        stopAllTask();

        DfuServiceListenerHelper.unregisterProgressListener(CommonUtils.getAppContext(), mDfuProgressListener);
        stopDfuService();
    }

    private void stopAllTask() {
        if (mCheckDFUResultTask != null) {
            mCheckDFUResultTask.stop();
            mCheckDFUResultTask = null;
        }

        if (mDfuConnectTask != null) {
            mDfuConnectTask.stop();
            mDfuConnectTask = null;
        }

        if (mEnterDFUModeTask != null) {
            mEnterDFUModeTask.stop();
            mEnterDFUModeTask = null;
        }

        if (mScanTargetDFUDeviceTask != null) {
            mScanTargetDFUDeviceTask.stop();
            mScanTargetDFUDeviceTask = null;
        }

        if (mDfuDisconnectTask != null) {
            mDfuDisconnectTask.stop();
            mDfuDisconnectTask = null;
        }

    }

    private void stopDfuService() {
        final Intent intent = new Intent(CommonUtils.getAppContext(), DFUService.class);
        CommonUtils.getAppContext().stopService(intent);
    }

    private void cancelDfuAction() {
        Logger.i(BleDFUConstants.LOG_TAG_NODIC, "[NodicDFUManager] cancelDfuAction");
        final Intent pauseAction = new Intent(DFUService.BROADCAST_ACTION);
        pauseAction.putExtra(DFUService.EXTRA_ACTION, DFUService.ACTION_ABORT);
        CommonUtils.getAppContext().sendBroadcast(pauseAction);
    }

    /**
     * 是否正在升级中
     *
     * @return
     */
    public boolean isDoing() {
        return mIsDoing;
    }
}
