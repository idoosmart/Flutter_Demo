package com.example.flutter_bluetooth.ble.callback;


/**
 * Created by asus on 2018/1/17.
 */

interface IConnectOperator {
    void toConnectDevice(boolean isDueToPhoneBluetoothSwitch);

    void toConnectDevice();

    void toConnectDevice(long timeoutMills);

    void toDisconnectDevice();

    boolean isConnectedToDevice();

    boolean isConnecting();

    void writeDataToDevice(byte[] bytes);

    String getCurrentConnectedMacAddress();
}
