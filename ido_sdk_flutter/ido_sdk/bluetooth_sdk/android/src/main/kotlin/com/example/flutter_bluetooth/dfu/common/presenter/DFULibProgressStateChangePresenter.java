package com.example.flutter_bluetooth.dfu.common.presenter;


import com.example.flutter_bluetooth.dfu.BleDFUConstants;
import com.example.flutter_bluetooth.logger.Logger;

import java.util.Timer;
import java.util.TimerTask;

/**
 * Created by zhouzj on 2018/6/14.
 *
 */

public class DFULibProgressStateChangePresenter implements IDFULibProgressStateChange {

    private long mLastChangeTimeMs = 0;
    private Timer mTimer;
    private TimerTask mTimerTask;
    private IDFULibProgressStateTimeOutListener mTimeOutListener;

    @Override
    public void onStart(IDFULibProgressStateTimeOutListener listener) {
        //先清除
        clearTimeOutCheckTask();

        mTimer = new Timer();
        mTimeOutListener = listener;
        mLastChangeTimeMs = System.currentTimeMillis();
        startTimeOutCheckTask();
    }

    @Override
    public void onStateChange() {
        mLastChangeTimeMs = System.currentTimeMillis();
    }

    @Override
    public void onEnd() {
        Logger.p(BleDFUConstants.LOG_TAG, "[check no response state]------------end-----------");
        finished();
    }

    private void checkTimeOut(){
        Logger.p(BleDFUConstants.LOG_TAG, "[check no response state]------------check-----------");
        if (System.currentTimeMillis() - mLastChangeTimeMs > 1000*45){
            Logger.e(BleDFUConstants.LOG_TAG, "[check no response state]--------------time--out-----------");
            finished();
            mTimeOutListener.onTimeOut();
        }
    }

    private void startTimeOutCheckTask(){
        mTimerTask = new TimerTask() {
            @Override
            public void run() {
                checkTimeOut();
            }
        };
        mTimer.schedule(mTimerTask, 0, 1000);
    }

    private void clearTimeOutCheckTask(){
        endTimeOutCheckTask();
    }

    private void endTimeOutCheckTask(){
        if (mTimerTask != null){
            mTimerTask.cancel();
        }
        if (mTimer != null) {
            mTimer.cancel();
        }
    }

    private void finished(){
        mLastChangeTimeMs = 0;
        endTimeOutCheckTask();
    }

    public interface IDFULibProgressStateTimeOutListener {
        void onTimeOut();
    }

}
