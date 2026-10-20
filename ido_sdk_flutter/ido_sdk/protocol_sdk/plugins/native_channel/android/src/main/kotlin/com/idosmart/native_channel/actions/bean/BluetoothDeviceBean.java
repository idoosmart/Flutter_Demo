package com.idosmart.native_channel.actions.bean;

import android.bluetooth.BluetoothDevice;

public class BluetoothDeviceBean {
    public BluetoothDevice device;
    public boolean isConnected;
    public ConnectType state;

    public BluetoothDevice getDevice() {
        return device;
    }

    public void setDevice(BluetoothDevice device) {
        this.device = device;
    }

    public boolean isConnected() {
        return isConnected;
    }

    public void setConnected(boolean connected) {
        isConnected = connected;
    }

    public ConnectType getState() {
        return state;
    }

    public void setState(ConnectType state) {
        this.state = state;
    }

    public enum ConnectType {
        unConnect, Connecting
    }
}
