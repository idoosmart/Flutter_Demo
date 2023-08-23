package com.example.flutter_bluetooth.dfu.common.task;

import android.text.TextUtils;

import com.example.flutter_bluetooth.ble.DeviceManager;
import com.example.flutter_bluetooth.ble.callback.ConnectCallBack;
import com.example.flutter_bluetooth.dfu.BLEDevice;
import com.example.flutter_bluetooth.dfu.BleDFUConstants;
import com.example.flutter_bluetooth.dfu.ConnectFailedReason;
import com.example.flutter_bluetooth.logger.Logger;

/**
 * Created by Zhouzj on 2017/12/26.
 * 连接任务
 */

public class DFUConnectTask {

    private IResult iResult;
    private boolean isDoing = false;
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
            Logger.p(BleDFUConstants.LOG_TAG, "[DFUConnectTask] onConnectSuccess");
            finished();
            iResult.onConnectSuccess();

        }

        @Override
        public void onConnectFailed(ConnectFailedReason reason) {
            Logger.e(BleDFUConstants.LOG_TAG, "[DFUConnectTask] onConnectFailed");
            finished();
            iResult.onConnectFailed();

        }

        @Override
        public void onConnectBreak() {
            Logger.e(BleDFUConstants.LOG_TAG, "[DFUConnectTask] onConnectBreak");
            finished();
            iResult.onConnectFailed();
        }

        @Override
        public void onInDfuMode() {
            Logger.e(BleDFUConstants.LOG_TAG, "[DFUConnectTask] onInDfuMode");
            finished();
            iResult.onAlreadyInDfuMode();

        }
    };

    public void start(IResult iResult, BLEDevice bleDevice) {
        if (isDoing) {
            Logger.e(BleDFUConstants.LOG_TAG, "[DFUConnectTask] is in doing state, ignore this action");
            return;
        }
        if (bleDevice == null || TextUtils.isEmpty(bleDevice.mDeviceAddress)) {
            if (iResult != null) {
                iResult.onConnectFailed();
            }
            Logger.e(BleDFUConstants.LOG_TAG, "[DFUConnectTask] empty address!");
            return;
        }
        Logger.p(BleDFUConstants.LOG_TAG, "[DFUConnectTask] start");
        this.iResult = iResult;
        isDoing = true;
        deviceAddress = bleDevice.mDeviceAddress;
        DeviceManager.dfuConnect(bleDevice.mDeviceAddress, iCallBack);

    }

    public void stop() {
        if (!isDoing) {
            return;
        }
        Logger.p(BleDFUConstants.LOG_TAG, "[DFUConnectTask] stop");
        release();
    }


    private void finished() {
        Logger.p(BleDFUConstants.LOG_TAG, "[DFUConnectTask] finished");
        release();

    }

    private void release() {
        isDoing = false;
        DeviceManager.cancelDufConnect(deviceAddress, iCallBack);
    }

    public interface IResult {
        void onConnectSuccess();

        void onConnectFailed();

        void onAlreadyInDfuMode();
    }
}
