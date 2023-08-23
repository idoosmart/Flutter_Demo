package com.example.flutter_bluetooth.ble.callback;

/**
 * Created by Zhouzj on 2017/12/18.
 */

public class EnterDfuModeCallback {

    public interface ICallBack {
        void onSuccess();

        void onError(DfuError error);
    }

    public enum DfuError {
        LOW_BATTERY,
        DEVICE_NOT_SUPPORT,
        PARA_ERROR,
        PARA_OTHER
    }

}
