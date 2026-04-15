package com.idosmart.bluetooth.bt;

import android.bluetooth.BluetoothDevice;

public interface IBTScanListener {
    void onFind(BluetoothDevice device);
    void onNotFind();
}
