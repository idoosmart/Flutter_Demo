package com.idosmart.native_channel.actions.ibluz.device;

import android.bluetooth.BluetoothDevice;

public interface IBluzDeviceA2dp {
    void connect(BluetoothDevice device);

    void connectWithProfileConnected(BluetoothDevice device);

    void disconnect(BluetoothDevice device);

    void release();

    BluetoothDevice getConnectedDevice();

    void setListener(IA2dpListener listener);
}
