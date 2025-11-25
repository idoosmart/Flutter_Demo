package com.example.flutter_bluetooth.timer;


import com.example.flutter_bluetooth.utils.CommonUtils;
import com.example.flutter_bluetooth.logger.Logger;

/**
 * Created by zhouzj on 2018/1/16.
 */

public class TimeOutPresenter implements ITimeOutPresenter {

    private int mConnectTimeOutTaskId = -1, mDisconnectTimeoutTaskId = -1, mDiscoverServicesTimeOutTaskId = -1,mReadCharacteristicTimeOutTaskId, mLEPairResultWaitTimeOutTaskId = -1
            ,mLEPairTimeOutTaskId = -1,mEnableNotifyTimeOutTaskId = -1;;

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

    @Override
    public void startReadCharacteristicTimeOutTask(Runnable runnable, long delayTime) {
        if (mReadCharacteristicTimeOutTaskId >= 0){
            return;
        }

        mReadCharacteristicTimeOutTaskId = TimeOutTaskManager.startTask(new TimeOutTaskManager.ITimeOut() {
            @Override
            public void onTimeOut() {
                if (mReadCharacteristicTimeOutTaskId < 0){
                    return;
                }

                CommonUtils.runOnMainThread(new Runnable() {
                    @Override
                    public void run() {
                        Logger.p("[TimeOutPresenter] startReadCharacteristicTimeOutTask task time out, task id = " + mReadCharacteristicTimeOutTaskId);
                        runnable.run();
                        mReadCharacteristicTimeOutTaskId = -1;
                    }
                });
            }
        }, delayTime);
        Logger.p("[TimeOutPresenter] startReadCharacteristicTimeOutTask timeout task , task id = " + mReadCharacteristicTimeOutTaskId);

    }

    @Override
    public void stopReadCharacteristicTimeOutTask() {
        if (mReadCharacteristicTimeOutTaskId < 0){
            return;
        }

        Logger.p("[TimeOutPresenter] stopReadCharacteristicTimeOutTask timeout task , task id = " + mReadCharacteristicTimeOutTaskId);
        TimeOutTaskManager.stopTask(mReadCharacteristicTimeOutTaskId);
        mReadCharacteristicTimeOutTaskId = -1;
    }


    @Override
    public void startLEPairResultWaitTimeOutTask(Runnable runnable, long delayTime) {
        if (mLEPairResultWaitTimeOutTaskId >= 0){
            return;
        }

        mLEPairResultWaitTimeOutTaskId = TimeOutTaskManager.startTask(new TimeOutTaskManager.ITimeOut() {
            @Override
            public void onTimeOut() {
                if (mLEPairResultWaitTimeOutTaskId < 0){
                    return;
                }

                CommonUtils.runOnMainThread(new Runnable() {
                    @Override
                    public void run() {
                        Logger.p("[TimeOutPresenter] startLEPairResultWaitTimeOutTask task time out, task id = " + mLEPairResultWaitTimeOutTaskId);
                        runnable.run();
                        mLEPairResultWaitTimeOutTaskId = -1;
                    }
                });
            }
        }, delayTime);
        Logger.p("[TimeOutPresenter] startLEPairResultWaitTimeOutTask timeout task , task id = " + mLEPairResultWaitTimeOutTaskId);

    }

    @Override
    public void stopLEPairResultWaitTimeOutTask() {
        if (mLEPairResultWaitTimeOutTaskId < 0){
            return;
        }

        Logger.p("[TimeOutPresenter] stopLEPairResultWaitTimeOutTask timeout task , task id = " + mLEPairResultWaitTimeOutTaskId);
        TimeOutTaskManager.stopTask(mLEPairResultWaitTimeOutTaskId);
        mLEPairResultWaitTimeOutTaskId = -1;
    }


    @Override
    public void startLEPairTimeOutTask(Runnable runnable, long delayTime) {
        if (mLEPairTimeOutTaskId >= 0){
            return;
        }

        mLEPairTimeOutTaskId = TimeOutTaskManager.startTask(new TimeOutTaskManager.ITimeOut() {
            @Override
            public void onTimeOut() {
                if (mLEPairTimeOutTaskId < 0){
                    return;
                }

                CommonUtils.runOnMainThread(new Runnable() {
                    @Override
                    public void run() {
                        Logger.p("[TimeOutPresenter] startLEPairTimeOutTask task time out, task id = " + mLEPairTimeOutTaskId);
                        runnable.run();
                        mLEPairTimeOutTaskId = -1;
                    }
                });
            }
        }, delayTime);
        Logger.p("[TimeOutPresenter] startLEPairTimeOutTask timeout task , task id = " + mLEPairTimeOutTaskId);

    }

    @Override
    public void stopLEPairTimeOutTask() {
        if (mLEPairTimeOutTaskId < 0){
            return;
        }

        Logger.p("[TimeOutPresenter] stopLEPairTask timeout task , task id = " + mLEPairTimeOutTaskId);
        TimeOutTaskManager.stopTask(mLEPairTimeOutTaskId);
        mLEPairTimeOutTaskId = -1;
    }

    @Override
    public void startEnableNotifyTimeOutTask(Runnable runnable, long delayTime) {
        if (mEnableNotifyTimeOutTaskId >= 0){
            return;
        }

        mEnableNotifyTimeOutTaskId = TimeOutTaskManager.startTask(new TimeOutTaskManager.ITimeOut() {
            @Override
            public void onTimeOut() {
                if (mEnableNotifyTimeOutTaskId < 0){
                    return;
                }

                CommonUtils.runOnMainThread(new Runnable() {
                    @Override
                    public void run() {
                        Logger.p("[TimeOutPresenter] startEnableNotifyTimeOutTask task time out, task id = " + mEnableNotifyTimeOutTaskId);
                        runnable.run();
                        mEnableNotifyTimeOutTaskId = -1;
                    }
                });
            }
        }, delayTime);
        Logger.p("[TimeOutPresenter] startEnableNotifyTimeOutTask timeout task , task id = " + mEnableNotifyTimeOutTaskId);
    }

    @Override
    public void stopEnableNotifyOutTask() {
        if (mEnableNotifyTimeOutTaskId < 0){
            return;
        }

        Logger.p("[TimeOutPresenter] stopEnableNotifyOutTask timeout task , task id = " + mEnableNotifyTimeOutTaskId);
        TimeOutTaskManager.stopTask(mEnableNotifyTimeOutTaskId);
        mEnableNotifyTimeOutTaskId = -1;
    }
}
