package com.idosmart.native_channel.nordic.zephyr;

import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;

import androidx.annotation.MainThread;
import androidx.lifecycle.Observer;

import com.idosmart.native_channel.common.BleDFUConfig;
import com.idosmart.native_channel.common.BleDFUConstants;
import com.idosmart.native_channel.common.LogTool;
import com.idosmart.native_channel.common.presenter.BaseDFUPresenter;
import com.idosmart.native_channel.common.presenter.DFULibProgressStateChangePresenter;
import com.idosmart.native_channel.common.presenter.IBaseDFUPresenter;
import com.idosmart.native_channel.common.presenter.IDFULibProgressStateChange;

import io.runtime.mcumgr.exception.McuMgrException;

public class NordicZephyrDFUManager {
    private final static String TAG = BleDFUConstants.LOG_TAG_NODIC_ZEPHYR;
    private final static int MAX_RETRY_TIMES = 6;
    private boolean mIsDoing = false;
    private String updateMac;//升级的mac, 默认为传过来的地址
    private BleDFUConfig mDfuConfig;
    private IBaseDFUPresenter mIBaseDfuPresenter;
    private IDFULibProgressStateChange mIDFULibProgressStateChange;
    private NordicZephyrDFUTask dfuTask;
    private final Handler mainHandler = new Handler(Looper.getMainLooper());
    private int mRetryTimes = 0;

    private NordicZephyrDFUManager() {

    }

    private static class Holder {
        static final NordicZephyrDFUManager INSTANCE = new NordicZephyrDFUManager();
    }

    public static NordicZephyrDFUManager getInstance() {
        return Holder.INSTANCE;
    }

    private final Observer<McuMgrException> mcuMgrExceptionObserver = new Observer<McuMgrException>() {
        @Override
        public void onChanged(McuMgrException e) {
            printLog( "dfu error: " + e + ", retry times: " + mRetryTimes + ", max retry times: " + mDfuConfig.getMaxRetryTime());
            if (mRetryTimes >= mDfuConfig.getMaxRetryTime()) {
                mIBaseDfuPresenter.onFailedByOther();
                release();
            } else {
                mainHandler.postDelayed(() -> {
                    printLog( "retry upgrade, retry times: " + mRetryTimes);
                    mRetryTimes++;
                    startUpgrade();
                }, 500);
            }
        }
    };

    private final Observer<NordicZephyrDFUTask.ThroughputData> throughputDataObserver = new Observer<NordicZephyrDFUTask.ThroughputData>() {
        @Override
        public void onChanged(NordicZephyrDFUTask.ThroughputData throughputData) {
            printLog( "dfu progress: " + throughputData);
            if (throughputData != null) {
                mIBaseDfuPresenter.onProgress(throughputData.progress);
            }
        }
    };

    private final Observer<NordicZephyrDFUTask.State> stateObserver = new Observer<NordicZephyrDFUTask.State>() {
        @Override
        public void onChanged(NordicZephyrDFUTask.State state) {
            printLog( "dfu state: " + state);
            if (state == NordicZephyrDFUTask.State.COMPLETE) {
                mIBaseDfuPresenter.onSuccess();
                release();
            }
        }
    };

    private final Observer<Void> cancelEventObserver = new Observer<Void>() {
        @Override
        public void onChanged(Void unused) {
            printLog( "dfu canceled");
            mIBaseDfuPresenter.onCancel();
            release();
        }
    };

    private final Observer<Boolean> busyStateObserver = new Observer<Boolean>() {
        @Override
        public void onChanged(Boolean aBoolean) {
            printLog( "dfu busy: " + aBoolean);
        }
    };


    public boolean start(String filePath, String mac) {
        printLog( "----start-------------->");

        if (mIsDoing) {
            printLog( "is doing ,ignore this action.");
            return false;
        }
        BleDFUConfig dfuConfig = new BleDFUConfig();
        dfuConfig.setFilePath(filePath);
        dfuConfig.setMacAddress(mac);
        dfuConfig.setDeviceId(mac);
        dfuConfig.setMaxRetryTime(2);
        mIBaseDfuPresenter = new BaseDFUPresenter(dfuConfig);
        mIDFULibProgressStateChange = new DFULibProgressStateChangePresenter();

        mIBaseDfuPresenter.onPrepare();

        if (!checkParas(dfuConfig)) {
            mIBaseDfuPresenter.onFailedByConfigParaError();
            return false;
        }

        mIsDoing = true;

        //开始 dfu

        startUpgrade();
        return true;
    }

    private void startUpgrade() {
//        if (DeviceManager.isConnected(updateMac)) {
//            disconnectAndUpgrade();
//        } else {
            upgradeOnUI();
//        }
    }

    private void upgradeOnUI() {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            doUpgrade();
        } else {
            mainHandler.post(new Runnable() {
                @Override
                public void run() {
                    doUpgrade();
                }
            });
        }
    }

    @MainThread
    private void doUpgrade() {
        dfuTask = new NordicZephyrDFUTask(updateMac);
        dfuTask.getError().observeForever(mcuMgrExceptionObserver);
        dfuTask.getProgress().observeForever(throughputDataObserver);
        dfuTask.getState().observeForever(stateObserver);
        dfuTask.getCancelledEvent().observeForever(cancelEventObserver);
        dfuTask.getBusyState().observeForever(busyStateObserver);
        printLog( "dfu start...");
        dfuTask.upgrade(mDfuConfig.getFilePath());
    }

    private void disconnectAndUpgrade() {
        printLog("dfu disconnect first");
        upgradeOnUI();
    }


    private boolean checkParas(BleDFUConfig dfuConfig) {
        if (dfuConfig == null) {
            printLog( "mDfuConfig is null");
            return false;
        }

        printLog( "dfuConfig is " + dfuConfig);

        if (TextUtils.isEmpty(dfuConfig.getFilePath())) {
            printLog( "file path is null");
            return false;
        }

        if (TextUtils.isEmpty(dfuConfig.getMacAddress())) {
            printLog( "mac address is null");
            return false;
        }

        if (TextUtils.isEmpty(dfuConfig.getDeviceId())) {
            printLog( "device_id is null");
            return false;
        }
        mDfuConfig = dfuConfig;
        updateMac = dfuConfig.getMacAddress();
        if (mDfuConfig.getMaxRetryTime() == 0) {
            mDfuConfig.setMaxRetryTime(MAX_RETRY_TIMES);
        }
        return true;
    }

    private void release() {
        printLog( "dfu release");
        dfuTask.getError().removeObserver(mcuMgrExceptionObserver);
        dfuTask.getProgress().removeObserver(throughputDataObserver);
        dfuTask.getState().removeObserver(stateObserver);
        dfuTask.getCancelledEvent().removeObserver(cancelEventObserver);
        dfuTask.getBusyState().removeObserver(busyStateObserver);
        dfuTask.cancel();
        mainHandler.removeCallbacksAndMessages(null);
        mIsDoing = false;

    }


    private static void printLog(String log){
        LogTool.p(TAG,log);
    }
}
