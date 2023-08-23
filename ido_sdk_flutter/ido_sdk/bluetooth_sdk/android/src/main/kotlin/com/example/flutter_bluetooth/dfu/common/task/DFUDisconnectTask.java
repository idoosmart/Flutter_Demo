package com.example.flutter_bluetooth.dfu.common.task;


import android.text.TextUtils;

import com.example.flutter_bluetooth.ble.DeviceManager;
import com.example.flutter_bluetooth.ble.callback.ConnectCallBack;
import com.example.flutter_bluetooth.dfu.BleDFUConstants;
import com.example.flutter_bluetooth.dfu.ConnectFailedReason;
import com.example.flutter_bluetooth.logger.Logger;
import com.example.flutter_bluetooth.timer.TimeOutTaskManager;

/**
 * Created by asus on 2018/1/19.
 */

public class DFUDisconnectTask {

    private IResult iResult;
    private boolean isDoing = false;
    private int mTimeoutTaskId = -1;
    private String deviceAddress;
    private final ConnectCallBack iCallBack = new ConnectCallBack() {
        @Override
        public void onConnectStart() {

        }

        @Override
        public void onConnecting() {

        }

        @Override
        public void onRetry(int count) {

        }

        @Override
        public void onConnectSuccess() {

        }

        @Override
        public void onConnectFailed(ConnectFailedReason reason) {


        }

        @Override
        public void onConnectBreak() {
            Logger.p(BleDFUConstants.LOG_TAG, "[DFUDisconnectTask] onConnectBreak");
            TimeOutTaskManager.stopTask(mTimeoutTaskId);
            finished();
            Logger.p(BleDFUConstants.LOG_TAG, "[DFUDisconnectTask] onConnectBreak, delay 1s to notify!");
            TimeOutTaskManager.startTask(new TimeOutTaskManager.ITimeOut() {
                @Override
                public void onTimeOut() {
                    Logger.p(BleDFUConstants.LOG_TAG, "[DFUDisconnectTask] onConnectBreak, onFinished");
                    iResult.onFinished();
                }
            }, 1000);

        }

        @Override
        public void onInDfuMode() {

        }
    };

    public void start(IResult iResult, String deviceAddress) {
        if (TextUtils.isEmpty(deviceAddress)) {
            Logger.e(BleDFUConstants.LOG_TAG, "[DFUDisconnectTask] empty deviceAddress!");
            return;
        }
        if (isDoing) {
            Logger.e(BleDFUConstants.LOG_TAG, "[DFUDisconnectTask] is in doing state, ignore this action");
            return;
        }
        Logger.p(BleDFUConstants.LOG_TAG, "[DFUDisconnectTask] start");
        this.iResult = iResult;
        isDoing = true;
        startTimeOutTask();
        this.deviceAddress = deviceAddress;
        DeviceManager.disConnect(deviceAddress, iCallBack);

    }

    private void startTimeOutTask() {
        mTimeoutTaskId = TimeOutTaskManager.startTask(new TimeOutTaskManager.ITimeOut() {
            @Override
            public void onTimeOut() {
                Logger.e(BleDFUConstants.LOG_TAG, "[DFUDisconnectTask] onTimeOut");
                finished();
                iResult.onFinished();

            }
        }, 5000);
    }

    public void stop() {
        if (!isDoing) {
            return;
        }
        Logger.p(BleDFUConstants.LOG_TAG, "[DFUDisconnectTask] stop");
        TimeOutTaskManager.stopTask(mTimeoutTaskId);
        release();
    }


    private void finished() {
        Logger.p(BleDFUConstants.LOG_TAG, "[DFUDisconnectTask] finished");
        release();
    }

    private void release() {
        isDoing = false;
        DeviceManager.cancelDisconnect(deviceAddress, iCallBack);
    }

    public interface IResult {
        void onFinished();
    }
}
