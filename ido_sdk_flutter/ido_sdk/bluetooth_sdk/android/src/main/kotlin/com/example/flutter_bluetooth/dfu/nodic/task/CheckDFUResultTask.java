package com.example.flutter_bluetooth.dfu.nodic.task;

import android.os.Handler;
import android.os.Looper;

import com.example.flutter_bluetooth.dfu.BLEDevice;
import com.example.flutter_bluetooth.dfu.BleDFUConstants;
import com.example.flutter_bluetooth.logger.Logger;


/**
 * Created by Zhouzj on 2017/12/22.
 * 检测升级是否成功(主要判断，设备是否重启)
 */

public class CheckDFUResultTask {

    private IResult iResult;
    private String macAddress;
    private int reCheckTimes = 0;
//    private int notFindDeviceTimes = 0;
    private boolean mIsDoing = false;
    private Handler timeOutHandler = new Handler(Looper.getMainLooper());
    private static final int MAX_RETRY_TIMES = 2;

    private static final int STATE_NULL = 0;
    private static final int STATE_NORMAL = 1;
    private static final int STATE_DFU = 2;
    private static final int STATE_CAN_NOT_CHECK = 3;
    private int latestState = STATE_NULL;

    private Handler getTimeOutHandler(){
        if (timeOutHandler == null){
            timeOutHandler = new Handler(Looper.getMainLooper());
        }
        return timeOutHandler;
    }
    private void reCheck(){
//        if (notFindDeviceTimes >= MAX_RETRY_TIMES){
//            Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[CheckDFUResultTask] can not check device status!");
//            finished();
//            if (iResult != null) {
//                iResult.onCannotCheckDeviceStatus();
//            }
//            iResult = null;
//            return;
//        }

        if (reCheckTimes >= MAX_RETRY_TIMES){
            Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[CheckDFUResultTask] out of max retry times, failed!");
            finished();
            if (iResult != null) {
//                iResult.onUpgradeFailed();
                if (STATE_CAN_NOT_CHECK == latestState){
                    iResult.onCannotCheckDeviceStatus();
                }else if (STATE_DFU == latestState){
                    iResult.onDeviceInDfuState();
                }
            }
            iResult = null;
            return;
        }

        Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[CheckDFUResultTask] rechecking...");

        reCheckTimes ++;
        check();
    }
    public void start(IResult result, String macAddress){
        if (mIsDoing){
            Logger.e(BleDFUConstants.LOG_TAG_NODIC, "[CheckDFUResultTask] is in doing state, ignore this action");
            return;
        }
        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[CheckDFUResultTask] start");
        this.iResult = result;
        this.macAddress = macAddress;
        check();
        mIsDoing = true;
    }

    private void check(){
        new ScanTargetDFUDeviceTask().start(new ScanTargetDFUDeviceTask.IResult() {
            @Override
            public void onNotFind() {
//                notFindDeviceTimes ++;
                latestState = STATE_CAN_NOT_CHECK;
                getTimeOutHandler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        reCheck();
                    }
                }, 5000);
            }

            @Override
            public void onFindAndInDfuMode(BLEDevice bleDevice) {
                latestState = STATE_DFU;
                getTimeOutHandler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        reCheck();
                    }
                }, 5000);

            }

            @Override
            public void onFindButHasConnectedToPhone(BLEDevice bleDevice) {
                latestState = STATE_NORMAL;
                finished();
                if (iResult != null) {
//                    iResult.onUpgradeSuccess();
                    iResult.onDeviceInNormalState();
                }
                iResult = null;
            }

            @Override
            public void onFindButNotInDfuMode(BLEDevice bleDevice) {
                latestState = STATE_NORMAL;
                finished();
                if (iResult != null) {
//                    iResult.onUpgradeSuccess();
                    iResult.onDeviceInNormalState();
                }
                iResult = null;

            }
        }, macAddress, 1);
    }

    public void stop(){
        if (!mIsDoing){
            return;
        }
        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[CheckDFUResultTask] stop task");
        release();
    }
    private void finished(){
        Logger.p(BleDFUConstants.LOG_TAG_NODIC, "[CheckDFUResultTask] finished");
        release();
    }

    private void release(){
        if (timeOutHandler != null) {
            timeOutHandler.removeCallbacksAndMessages(null);
        }
        timeOutHandler = null;
        reCheckTimes = 0;
//        notFindDeviceTimes = 0;
        mIsDoing = false;

    }

    public interface IResult{
//        void onUpgradeSuccess();
//        void onUpgradeFailed();

        /**
         * 正常状态
         */
        void onDeviceInNormalState();

        /**
         * 处于升级模式
         */
        void onDeviceInDfuState();
        /**
         * 无法检测手环的状态
         */
        void onCannotCheckDeviceStatus();
    }
}
