package com.example.flutter_bluetooth.ble.callback;

public class DeviceUpgradeEventListener {
    public interface IListener{
        void NODIC_onProgress(int progress);
        void APOLLO_onSOLibError(int error);
    }

    public static void NODIC_onProgress(final int progress){
    }

    public static void APOLLO_onSOLibError(final int error){
    }
}
