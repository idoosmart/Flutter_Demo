package com.example.flutter_bluetooth.ble.reconnect;

import android.bluetooth.BluetoothDevice;

public abstract class BaseLeScanner {
    public abstract void startLeScan();

    public abstract void stopLeScan();

    public abstract void callbackOnLeScan(final BluetoothDevice device, final int rssi, final byte[] scanRecord);
}
