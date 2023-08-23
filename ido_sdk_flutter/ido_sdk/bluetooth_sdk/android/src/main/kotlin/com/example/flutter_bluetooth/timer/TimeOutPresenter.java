package com.example.flutter_bluetooth.timer;


import com.example.flutter_bluetooth.utils.CommonUtils;
import com.example.flutter_bluetooth.logger.Logger;

/**
 * Created by zhouzj on 2018/1/16.
 */

public class TimeOutPresenter implements ITimeOutPresenter {

    private int mConnectTimeOutTaskId = -1, mDisconnectTimeoutTaskId = -1, mDiscoverServicesTimeOutTaskId = -1;

    public TimeOutPresenter() {
    }

    @Override
    public void startConnectTimeOutTask(final Runnable runnable, long delayTime) {
        if (mConnectTimeOutTaskId >= 0) {
            return;
        }

        mConnectTimeOutTaskId = TimeOutTaskManager.startTask(() -> {
            if (mConnectTimeOutTaskId < 0) {
                return;
            }

            CommonUtils.runOnMainThread(() -> {
                Logger.e("[TimeOutPresenter] connect task time out, task id = " + mDiscoverServicesTimeOutTaskId);
                runnable.run();
                mConnectTimeOutTaskId = -1;
            });
        }, delayTime);

        Logger.p("[TimeOutPresenter] start connect timeout task , task id = " + mConnectTimeOutTaskId);
    }

    @Override
    public void stopConnectTimeOutTask() {
        if (mConnectTimeOutTaskId < 0) {
            return;
        }
        Logger.p("[TimeOutPresenter] stop connect timeout task , task id = " + mConnectTimeOutTaskId);
        TimeOutTaskManager.stopTask(mConnectTimeOutTaskId);
        mConnectTimeOutTaskId = -1;
    }

    @Override
    public void startDisconnectTimeOutTask(final Runnable runnable, long delayTime) {
        if (mDisconnectTimeoutTaskId >= 0) {
            return;
        }

        mDisconnectTimeoutTaskId = TimeOutTaskManager.startTask(() -> {
            if (mDisconnectTimeoutTaskId < 0) {
                return;
            }

            CommonUtils.runOnMainThread(() -> {
                Logger.e("[TimeOutPresenter] disconnect task time out, task id = " + mDiscoverServicesTimeOutTaskId);
                runnable.run();
                mDisconnectTimeoutTaskId = -1;
            });


        }, delayTime);
        Logger.p("[TimeOutPresenter] start disconnect timeout task , task id = " + mDisconnectTimeoutTaskId);
    }

    @Override
    public void stopDisconnectTimeOutTask() {
        if (mDisconnectTimeoutTaskId < 0) {
            return;
        }

        Logger.p("[TimeOutPresenter] stop disconnect timeout task , task id = " + mDisconnectTimeoutTaskId);
        TimeOutTaskManager.stopTask(mDisconnectTimeoutTaskId);
        mDisconnectTimeoutTaskId = -1;

    }

    @Override
    public void startDiscoverServicesTimeOutTask(final Runnable runnable, long delayTime) {
        if (mDiscoverServicesTimeOutTaskId >= 0) {
            return;
        }

        mDiscoverServicesTimeOutTaskId = TimeOutTaskManager.startTask(new TimeOutTaskManager.ITimeOut() {
            @Override
            public void onTimeOut() {
                if (mDiscoverServicesTimeOutTaskId < 0) {
                    return;
                }

                CommonUtils.runOnMainThread(new Runnable() {
                    @Override
                    public void run() {
                        Logger.e("[TimeOutPresenter] discover services task time out, task id = " + mDiscoverServicesTimeOutTaskId);
                        runnable.run();
                        mDiscoverServicesTimeOutTaskId = -1;
                    }
                });


            }
        }, delayTime);
        Logger.p("[TimeOutPresenter] start discover services timeout task , task id = " + mDiscoverServicesTimeOutTaskId);
    }

    @Override
    public void stopDiscoverServicesTimeOutTask() {
        if (mDiscoverServicesTimeOutTaskId < 0) {
            return;
        }

        Logger.p("[TimeOutPresenter] stop discover services timeout task , task id = " + mDiscoverServicesTimeOutTaskId);
        TimeOutTaskManager.stopTask(mDiscoverServicesTimeOutTaskId);
        mDiscoverServicesTimeOutTaskId = -1;
    }

    @Override
    public void stopAllTimerTask() {
         stopConnectTimeOutTask();
         stopDisconnectTimeOutTask();
         stopDiscoverServicesTimeOutTask();
    }
}
