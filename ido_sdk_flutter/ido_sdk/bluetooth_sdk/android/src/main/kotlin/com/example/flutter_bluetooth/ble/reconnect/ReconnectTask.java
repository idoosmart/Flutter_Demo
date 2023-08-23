package com.example.flutter_bluetooth.ble.reconnect;

import android.os.Handler;
import android.os.Looper;

import com.example.flutter_bluetooth.logger.Logger;


/**
 * 重连：已经扫描到设备，但在连接该设备时，连接失败;或者已经连接上了 ，但后来被断开了
 */
class ReconnectTask {
    private static ReconnectTask mTask;

    private static final int MAX_RETRY_TIMES = Integer.MAX_VALUE;
    private int mReTryTimes = 0;
    private boolean isStopTask = false;
    private IStateChangeListener mIStateChangeListener;


    private Handler mHandler = new Handler(Looper.getMainLooper());

    public static boolean cancelDelay() {
        if (mTask != null) {
            mTask.cancelDelayTimer();
            return true;
        }
        return false;
    }

    private ReconnectTask() {

    }

    private void setListener(IStateChangeListener iStateChangeListener) {
        mIStateChangeListener = iStateChangeListener;
    }

    public static void start(IStateChangeListener iStateChangeListener) {
        if (mTask == null) {
            mTask = new ReconnectTask();
        }
        mTask.setListener(iStateChangeListener);
        mTask.startTask();
    }

    public static void stop() {
        if (mTask != null) {
            mTask.stopTask();
            mTask = null;
        }
    }

    private void cancelDelayTimer() {
        Logger.p("[ReconnectTask] cancelDelayTimer. ");
        mHandler.removeCallbacksAndMessages(null);
        if (mIStateChangeListener != null) {
            mIStateChangeListener.onTry(mReTryTimes);
        }
    }

    private void startTask() {
        mHandler.removeCallbacksAndMessages(null);

        mReTryTimes++;

        Logger.p("[ReconnectTask] startTask(), mReTryTimes = " + mReTryTimes);

//        mIStateChangeListener.onOutOfMaxRtyTimes();

        long delay;
        if (mReTryTimes < 2) {
            delay = 300;
        } else if (mReTryTimes < 5) {
            delay = 1000 * 2;
        } else if (mReTryTimes < 10) {
            delay = 1000 * 5;
        } else if (mReTryTimes < 15) {
            delay = 1000 * 15;
        } else {
            delay = 1000 * 30;
        }

        Logger.p("[ReconnectTask] will start after " + delay + "ms ");

        mHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                if (mTask == null) {
                    Logger.e("[ReconnectTask] mTask = null");
                    return;
                }
                if (isStopTask) {
                    Logger.e("[ReconnectTask] isStopTask = true");
                    return;
                }

                Logger.p("[ReconnectTask] to try");
                mIStateChangeListener.onTry(mReTryTimes);
            }
        }, delay);

    }

    public interface IStateChangeListener {
        void onTry(int count);

        void onOutOfMaxRtyTimes();
    }

    private void stopTask() {
        Logger.p("[ReconnectTask] stopTask()");
        isStopTask = true;
        mReTryTimes = 0;
        mHandler.removeCallbacksAndMessages(null);
    }


}
