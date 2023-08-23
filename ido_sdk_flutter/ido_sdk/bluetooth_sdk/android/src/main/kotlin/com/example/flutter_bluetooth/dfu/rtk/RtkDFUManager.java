//package com.example.flutter_bluetooth.dfu.rtk;
//
//import android.content.Context;
//import android.os.Handler;
//import android.os.Looper;
//import android.text.TextUtils;
//
//import com.example.flutter_bluetooth.Config;
//import com.example.flutter_bluetooth.ble.DeviceManager;
//import com.example.flutter_bluetooth.dfu.BleDFUConfig;
//import com.example.flutter_bluetooth.dfu.BleDFUConstants;
//import com.example.flutter_bluetooth.dfu.common.presenter.BaseDFUPresenter;
//import com.example.flutter_bluetooth.dfu.common.presenter.DFULibProgressStateChangePresenter;
//import com.example.flutter_bluetooth.dfu.common.presenter.IBaseDFUPresenter;
//import com.example.flutter_bluetooth.dfu.common.presenter.IDFULibProgressStateChange;
//import com.example.flutter_bluetooth.dfu.common.task.DFUDisconnectTask;
//import com.example.flutter_bluetooth.dfu.rtk.auth.RtkAuthTask;
//import com.example.flutter_bluetooth.logger.Logger;
//import com.realsil.sdk.dfu.DfuException;
//import com.realsil.sdk.dfu.image.BinFactory;
//import com.realsil.sdk.dfu.image.SubFileIndicator;
//import com.realsil.sdk.dfu.model.BinInfo;
//import com.realsil.sdk.dfu.model.DfuConfig;
//import com.realsil.sdk.dfu.model.DfuProgressInfo;
//import com.realsil.sdk.dfu.model.OtaDeviceInfo;
//import com.realsil.sdk.dfu.model.Throughput;
//import com.realsil.sdk.dfu.utils.DfuAdapter;
//import com.realsil.sdk.dfu.utils.DfuHelper;
//
//import java.io.File;
//
//public class RtkDFUManager {
//    private final static int MAX_RETRY_TIMES = 6;
//    private static RtkDFUManager instance;
//    private boolean mIsDoing = false;
//    private BleDFUConfig mBleDfuConfig;
//    private int mRetryTimes = 0;
//    private int mTempProgress = 0;
//    private int mLastTaskProgress = 0;
//    private IBaseDFUPresenter mIBaseDfuPresenter;
//    private Handler delayTimeHandler = new Handler(Looper.getMainLooper());
//    private DfuHelper mDfuHelper;
//    private RtkAuthTask mAuthTask;
//    private IDFULibProgressStateChange mIDFULibProgressStateChange;
//    private DfuHelper.DfuHelperCallback mDfuHelperCallback = new DfuAdapter.DfuHelperCallback() {
//        @Override
//        public void onStateChanged(int state) {
//            super.onStateChanged(state);
//            mIDFULibProgressStateChange.onStateChange();
//            Logger.p(BleDFUConstants.LOG_TAG_RTK, "onStateChanged = " + state);
//            if (state == DfuAdapter.STATE_INIT_OK) {
//                upgrade();
//            }
//        }
//
//        @Override
//        public void onTargetInfoChanged(OtaDeviceInfo otaDeviceInfo) {
//            super.onTargetInfoChanged(otaDeviceInfo);
//
//            mIDFULibProgressStateChange.onStateChange();
//            try {
//                BinInfo mBinInfo = BinFactory.loadImageBinInfo(mBleDfuConfig.getFilePath(), otaDeviceInfo, false);
//                if (mBinInfo != null) {
//                    Logger.p(BleDFUConstants.LOG_TAG_RTK, "onTargetInfoChanged.mBinInfo = " + mBinInfo.toString());
//                }
//            } catch (DfuException e) {
//                Logger.e(BleDFUConstants.LOG_TAG_RTK, e.getMessage());
//            }
//
//            Logger.p(BleDFUConstants.LOG_TAG_RTK, "onTargetInfoChanged.otaDeviceInfo = " + otaDeviceInfo.toString());
//        }
//
//        @Override
//        public void onError(int type, int code) {
//            super.onError(type, code);
//            mIDFULibProgressStateChange.onEnd();
//            Logger.e(BleDFUConstants.LOG_TAG_RTK, "onError, type = " + type + ",code = " + code);
//            upgradeFailed();
//            mIBaseDfuPresenter.onOtherErrorOccurred(code, "" + type);
//            mIBaseDfuPresenter.onFailedByOther();
//        }
//
//        @Override
//        public void onProcessStateChanged(int state, Throughput throughput) {
//            super.onProcessStateChanged(state, throughput);
////            String message = getContext().getString(DfuHelperImpl.getStateResId(state));
//            Logger.p(BleDFUConstants.LOG_TAG_RTK, "onProcessStateChanged, state = " + state);
//            mIDFULibProgressStateChange.onStateChange();
//            if (state == DfuAdapter.STATE_HID_PENDING_REMOVE_BOND) {
//                mIDFULibProgressStateChange.onEnd();
//                upgradeSuccess();
//                mIBaseDfuPresenter.onSuccess();
//            }
//        }
//
//        @Override
//        public void onProgressChanged(DfuProgressInfo dfuProgressInfo) {
//            super.onProgressChanged(dfuProgressInfo);
//            mIDFULibProgressStateChange.onStateChange();
//            if (mTempProgress != dfuProgressInfo.getProgress() && dfuProgressInfo.getProgress() != 0) {
//                Logger.p(BleDFUConstants.LOG_TAG_RTK, "onProgressChanged, progress = " + dfuProgressInfo.getProgress());
//
//                //升级包里只有一个升级文件
//                mIBaseDfuPresenter.onProgress(dfuProgressInfo.getProgress());
//
//                //当升级包中有三个升级文件时，用此方法计算进度
//                //calcThreeFilesProgress(dfuProgressInfo);
//                mTempProgress = dfuProgressInfo.getProgress();
//            }
//        }
//    };
//    private DFUDisconnectTask mDfuDisconnectTask;
//
//    private RtkDFUManager() {
//    }
//
//    public static RtkDFUManager getManager() {
//        if (instance == null) {
//            instance = new RtkDFUManager();
//        }
//        return instance;
//    }
//
//    private void calcThreeFilesProgress(DfuProgressInfo dfuProgressInfo) {
//        if (dfuProgressInfo.getProgress() > mTempProgress) {
//            calcProgress(dfuProgressInfo.getProgress(), false);
//        } else {
//            calcProgress(dfuProgressInfo.getProgress(), true);
//        }
//
//
//    }
//
//    private void calcProgress(int progress, boolean isNextTask) {
//        int currentProgress;
//        if (isNextTask) {
//            mLastTaskProgress += 100;
//        }
//        currentProgress = progress + mLastTaskProgress;
//
//        int p = currentProgress * 100 / 300;
//        mIBaseDfuPresenter.onProgress(p);
//    }
//
//    private void toBreakCurrentConnectAndStartToUpgrade() {
//        if (mDfuDisconnectTask != null) {
//            mDfuDisconnectTask.stop();
//        }
//
//        mDfuDisconnectTask = new DFUDisconnectTask();
//        mDfuDisconnectTask.start(new DFUDisconnectTask.IResult() {
//            @Override
//            public void onFinished() {
//                prepareUpgrade();
//            }
//        }, mBleDfuConfig.getMacAddress());
//    }
//
//
//    public boolean start(BleDFUConfig dfuConfig) {
//        Logger.p(BleDFUConstants.LOG_TAG_RTK, " ----start-------------->");
//        if (mIsDoing) {
//            Logger.e(BleDFUConstants.LOG_TAG_RTK, "is doing ,ignore this action.");
//            return false;
//        }
//        mIBaseDfuPresenter = new BaseDFUPresenter(dfuConfig);
//
//        mIBaseDfuPresenter.onPrepare();
//
//        if (!checkParas(dfuConfig)) {
//            mIBaseDfuPresenter.onFailedByConfigParaError();
//            return false;
//        }
//
//        mIDFULibProgressStateChange = new DFULibProgressStateChangePresenter();
//
//
//        mIsDoing = true;
//
//        initRTK();
//
//        if (mBleDfuConfig.isNeedAuth()) {
//            toAuth();
//        } else {
//            if (DeviceManager.isConnected(mBleDfuConfig.getMacAddress())) {
//                toBreakCurrentConnectAndStartToUpgrade();
//            } else {
//                DeviceManager.disConnect(mBleDfuConfig.getMacAddress(), null);
//                prepareUpgrade();
//            }
//        }
//
//        return true;
//    }
//
//    private boolean checkParas(BleDFUConfig dfuConfig) {
//        if (dfuConfig == null) {
//            Logger.e(BleDFUConstants.LOG_TAG_RTK, "mDfuConfig is null");
//            return false;
//        }
//
//        Logger.p(BleDFUConstants.LOG_TAG_RTK, "mDfuConfig is " + dfuConfig.toString());
//
//        if (TextUtils.isEmpty(dfuConfig.getFilePath())) {
//            Logger.e(BleDFUConstants.LOG_TAG_RTK, "file path is null");
//            return false;
//        }
//
//        if (TextUtils.isEmpty(dfuConfig.getMacAddress())) {
//            Logger.e(BleDFUConstants.LOG_TAG_RTK, "mac address is null");
//            return false;
//        }
//
//        if (TextUtils.isEmpty(dfuConfig.getDeviceId())) {
//            Logger.e(BleDFUConstants.LOG_TAG_RTK, "device_id is null");
//            return false;
//        }
//
//        if (dfuConfig.getFilePath().endsWith(".zip")) {
//            String targetFileName = dfuConfig.getFilePath().replace(".zip", ".bin");
//            File file = new File(dfuConfig.getFilePath());
//            if (!file.renameTo(new File(targetFileName))) {
//                Logger.e(BleDFUConstants.LOG_TAG_RTK, "rename failed");
//                return false;
//            }
//            dfuConfig.setFilePath(targetFileName);
//        }
//        mBleDfuConfig = dfuConfig;
//
//        return true;
//    }
//
//    private void initRTK() {
//        mDfuHelper = DfuHelper.getInstance(getContext());
////        mDfuHelper.addDfuHelperCallback(mDfuHelperCallback);
//
//
//    }
//
//    private void toAuth() {
//        Logger.p(BleDFUConstants.LOG_TAG_RTK, "[RtkDFUManager] to auth");
//        if (mAuthTask != null) {
//            mAuthTask.stop();
//        }
//
//        mAuthTask = new RtkAuthTask(mBleDfuConfig.getFilePath());
//        mAuthTask.start(new RtkAuthTask.IResult() {
//            @Override
//            public void onSuccess() {
//                if (DeviceManager.isConnected(mBleDfuConfig.getMacAddress())) {
//                    toBreakCurrentConnectAndStartToUpgrade();
//                } else {
//                    DeviceManager.disConnect(mBleDfuConfig.getMacAddress(), null);
//                    prepareUpgrade();
//                }
//            }
//
//            @Override
//            public void onFailed(String errorMsg) {
//                upgradeFailed();
//                mIBaseDfuPresenter.onFailedByOther();
//            }
//
//        });
//    }
//
//    private void release() {
//        Logger.p(BleDFUConstants.LOG_TAG_RTK, "release");
//        mIsDoing = false;
//        mRetryTimes = 0;
//        mTempProgress = 0;
//        mLastTaskProgress = 0;
//        if (delayTimeHandler != null) {
//            delayTimeHandler.removeCallbacksAndMessages(null);
//        }
//
//        if (mAuthTask != null) {
//            mAuthTask.stop();
//            mAuthTask = null;
//        }
//
//        if (mDfuHelper != null) {
//            mDfuHelper.abort();
//            mDfuHelper.close();
//        }
//    }
//
//    private void prepareUpgrade() {
//        startTimeoutTask();
//        delayTimeHandler.postDelayed(new Runnable() {
//            @Override
//            public void run() {
//                mDfuHelper.initialize(mDfuHelperCallback);
//            }
//        }, 3000);
//    }
//
//    private void upgrade() {
//        Logger.p(BleDFUConstants.LOG_TAG_RTK, "upgrade...");
//
//
//        DfuConfig dfuConfig = new DfuConfig();
//        dfuConfig.setAddress(mBleDfuConfig.getMacAddress());
//        dfuConfig.setFileIndicator(SubFileIndicator.INDICATOR_FULL);
//        dfuConfig.setAutomaticActiveEnabled(true);
//        dfuConfig.setBatteryCheckEnabled(true);
//        dfuConfig.setOtaWorkMode(mBleDfuConfig.getOtaWorkMode());
//        dfuConfig.setFilePath(mBleDfuConfig.getFilePath());
//        if (!mDfuHelper.startOtaProcess(dfuConfig)) {
//            Logger.e(BleDFUConstants.LOG_TAG_RTK, "mDfuHelper.startOtaProcess return false.");
//            upgradeFailed();
//            mIBaseDfuPresenter.onFailedByConfigParaError();
//        }
//
//    }
//
//    private void startTimeoutTask() {
//        //处理RTK-SDK升级过程中“无响应”的场景
//        mIDFULibProgressStateChange.onStart(new DFULibProgressStateChangePresenter.IDFULibProgressStateTimeOutListener() {
//            @Override
//            public void onTimeOut() {
//                handleNoResponseScene();
//            }
//
//
//        });
//    }
//
//    private void handleNoResponseScene() {
//        mIBaseDfuPresenter.onFailedByOther();
//        timeout();
//    }
//
//    private Context getContext() {
//        return Config.getApplication().getApplicationContext();
//    }
//
//    private void upgradeSuccess() {
//        Logger.p(BleDFUConstants.LOG_TAG_RTK, "upgrade success");
//        release();
//    }
//
//    private void upgradeFailed() {
//        Logger.e(BleDFUConstants.LOG_TAG_RTK, "upgrade failed, exit!");
//        release();
//    }
//
//    private void timeout() {
//        Logger.e(BleDFUConstants.LOG_TAG_RTK, "timeout, upgrade failed!");
//        release();
//    }
//
//
//}
