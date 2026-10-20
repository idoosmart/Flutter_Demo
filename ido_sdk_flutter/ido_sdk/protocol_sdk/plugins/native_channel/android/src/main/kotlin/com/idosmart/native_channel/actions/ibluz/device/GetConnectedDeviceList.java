package com.idosmart.native_channel.actions.ibluz.device;

import android.bluetooth.BluetoothDevice;

import java.util.List;

public interface GetConnectedDeviceList {
    void onGetDeviceList(List<BluetoothDevice> devices);
}
