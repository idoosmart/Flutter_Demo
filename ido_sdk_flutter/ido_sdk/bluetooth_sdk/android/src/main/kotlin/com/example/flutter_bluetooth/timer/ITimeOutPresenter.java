package com.example.flutter_bluetooth.timer;

public interface ITimeOutPresenter {
    void startConnectTimeOutTask(Runnable runnable, long delayTime);

    void stopConnectTimeOutTask();

    void startDisconnectTimeOutTask(Runnable runnable, long delayTime);

    void stopDisconnectTimeOutTask();

    void startDiscoverServicesTimeOutTask(Runnable runnable, long delayTime);

    void stopDiscoverServicesTimeOutTask();

    void stopAllTimerTask();

    void startReadCharacteristicTimeOutTask(Runnable runnable, long delayTime);
    void stopReadCharacteristicTimeOutTask();

    void startLEPairResultWaitTimeOutTask(Runnable runnable, long delayTime);
    void stopLEPairResultWaitTimeOutTask();

    void startLEPairTimeOutTask(Runnable runnable, long delayTime);
    void stopLEPairTimeOutTask();

    void startEnableNotifyTimeOutTask(Runnable runnable, long delayTime);
    void stopEnableNotifyOutTask();
}
