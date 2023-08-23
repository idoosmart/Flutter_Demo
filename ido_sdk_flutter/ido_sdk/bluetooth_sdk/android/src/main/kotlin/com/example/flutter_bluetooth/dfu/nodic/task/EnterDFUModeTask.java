package com.example.flutter_bluetooth.dfu.nodic.task;


import android.util.Log;

import com.example.flutter_bluetooth.ble.DeviceManager;
import com.example.flutter_bluetooth.ble.callback.EnterDfuModeCallback;
import com.example.flutter_bluetooth.dfu.BleDFUConstants;
import com.example.flutter_bluetooth.logger.Logger;
import com.example.flutter_bluetooth.timer.TimeOutTaskManager;


/**
 * Created by Zhouzj on 2017/12/22.
 * 让设备进入DFU模式
 */

public class EnterDFUModeTask {
    private static boolean isDoing = false;

    private static final int MAX_RETRY_TIMES = 5;
    private int retryTimes = 0;
    private IResult iResult;
    private int mTimeoutTaskId = -1;
    private String deviceAddress;

    private EnterDfuModeCallback.ICallBack iCallBack = new EnterDfuModeCallback.ICallBack() {
        @Override
        public void onSuccess() {
            success();
        }

        @Override
        public void onError(EnterDfuModeCallback.DfuError error) {
            Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[EnterDFUModeTask] error is " + error);
            failed(error);
        }
    };

    public EnterDFUModeTask(String deviceAddress) {
        this.deviceAddress = deviceAddress;
    }


    public void start(IResult iResult) {
        if (isDoing) {
            Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[EnterDFUModeTask] is doing, ignore this action!");
            return;
        }

        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[EnterDFUModeTask] start...");
        this.iResult = iResult;

        isDoing = true;

        if (DeviceManager.isConnected(deviceAddress)) {
            startTimeOutTask();
            DeviceManager.enterDfuMode(deviceAddress, iCallBack);
        } else {
            finished();
            iResult.onConnectBreak();
        }


    }


    private void restart() {
        if (retryTimes > MAX_RETRY_TIMES) {
            Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[EnterDFUModeTask] out of max retry times.");
            retryButAllTimeout();
            return;
        }

        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[EnterDFUModeTask] restart...");
        retryTimes++;

        if (DeviceManager.isConnected(deviceAddress)) {
            startTimeOutTask();
            DeviceManager.enterDfuMode(deviceAddress, iCallBack);
        } else {
            finished();
            iResult.onConnectBreak();

        }

    }


    private void success() {
        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[EnterDFUModeTask] enter dfu mode success!");
        finished();
        iResult.onSuccess();

    }

    private void failed(EnterDfuModeCallback.DfuError errorMsg) {
        Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[EnterDFUModeTask] enter dfu mode failed!");
        finished();
        iResult.onFailed(errorMsg);

    }

    private void retryButAllTimeout() {
        finished();
        iResult.onRetryButAllTimeOut();
    }

    public void stop() {
        if (!isDoing) {
            return;
        }
        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[EnterDFUModeTask] stop task!");
        release();
    }

    private void finished() {
        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[EnterDFUModeTask] finished!");
        TimeOutTaskManager.stopTask(mTimeoutTaskId);
        release();
    }

    private void release() {
        isDoing = false;
//        CallBackManager.getManager().unregisterEnterDfuModeCallBack(iCallBack);
        DeviceManager.cancelEnterDfuMode(deviceAddress);
    }

    private void startTimeOutTask() {
        mTimeoutTaskId = TimeOutTaskManager.startTask(new TimeOutTaskManager.ITimeOut() {
            @Override
            public void onTimeOut() {
                Log.e(BleDFUConstants.LOG_TAG_NODIC, "[EnterDFUModeTask] onTimeOut, retry...");
                restart();

            }
        }, 10000);
    }

    public interface IResult {
        void onSuccess();

        void onFailed(EnterDfuModeCallback.DfuError errorMsg);

        void onRetryButAllTimeOut();

        void onConnectBreak();
    }
}
