package com.example.flutter_bluetooth.timer;

public interface ITimeOutPresenter {
    void startConnectTimeOutTask(Runnable runnable, long delayTime);

    void stopConnectTimeOutTask();

    void startDisconnectTimeOutTask(Runnable runnable, long delayTime);

    void stopDisconnectTimeOutTask();

    void startDiscoverServicesTimeOutTask(Runnable runnable, long delayTime);

    void stopDiscoverServicesTimeOutTask();

    void stopAllTimerTask();
}
