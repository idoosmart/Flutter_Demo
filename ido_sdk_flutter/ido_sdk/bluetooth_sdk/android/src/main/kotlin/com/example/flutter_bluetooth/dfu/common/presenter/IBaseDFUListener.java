package com.example.flutter_bluetooth.dfu.common.presenter;


import com.example.flutter_bluetooth.ble.callback.EnterDfuModeCallback;

/**
 * Created by Zhouzj on 2017/12/26.
 *
 */

public interface IBaseDFUListener {
    void onPrepare();
    void onDeviceInDFUMode();
    void onFailedByEnterDFUModeFailed(EnterDfuModeCallback.DfuError error);
    void onFailedByEnterDFUModeTimeout();
    void onFailedByNotFindTargetDFUDevice();
    void onFailedByFileError();
    void onFailedByPhoneBluetoothError();
    void onOtherErrorOccurred(int error, String errorMsg);
    void onFailedByConfigParaError();
    void onFailedByOutOfMaxRetryTimes();
    void onFailedByOperationFailed();
    void onFailedByNotPermitted();
    void onFailedByOther();
    void onFailedByDeviceNotReboot();
    void onRestart(int index);
    void onCancel();
    void onSuccess();
    void onSuccessAndNeedToPromptUser();
    void onProgress(int progress);

    void onDeviceConnecting();
    void onDeviceConnected();
    void onDfuProcessStarting();
    void onDfuProcessStarted();
    void onEnablingDfuMode();
    void onFirmwareValidating();
    void onDeviceDisconnecting();
    void onDeviceDisconnected();
}
