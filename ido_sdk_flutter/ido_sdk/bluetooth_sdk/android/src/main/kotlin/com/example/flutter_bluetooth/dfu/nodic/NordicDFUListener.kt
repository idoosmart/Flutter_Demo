package com.example.flutter_bluetooth.dfu.nodic

import com.example.flutter_bluetooth.ble.callback.EnterDfuModeCallback.DfuError
import com.example.flutter_bluetooth.dfu.BleDFUState
import com.example.flutter_bluetooth.dfu.common.presenter.IBaseDFUListener

/**
 * @author tianwei
 * @date 2023/2/7
 * @time 15:54
 * 用途:
 */
class NordicDFUListener(
    private val deviceAddress: String,
    private val outListener: BleDFUState.IListener?
) : IBaseDFUListener {
    override fun onPrepare() {
        outListener?.onDfuPrepare(deviceAddress)
    }

    override fun onDeviceInDFUMode() {
        outListener?.onDfuModeEnter(deviceAddress)
    }

    override fun onFailedByEnterDFUModeFailed(error: DfuError) {
        if (error == DfuError.LOW_BATTERY) {
            outListener?.onDfuFailed(BleDFUState.FailReason.DEVICE_IN_LOW_BATTERY, deviceAddress)
        } else {
            outListener?.onDfuFailed(BleDFUState.FailReason.ENTER_DFU_MODE_FAILED, deviceAddress)
        }
    }

    override fun onFailedByEnterDFUModeTimeout() {
        outListener?.onDfuFailed(BleDFUState.FailReason.ENTER_DFU_MODE_FAILED, deviceAddress)
    }

    override fun onFailedByNotFindTargetDFUDevice() {
        outListener?.onDfuFailed(BleDFUState.FailReason.NOT_FIND_TARGET_DEVICE, deviceAddress)
    }

    override fun onFailedByFileError() {
        outListener?.onDfuFailed(BleDFUState.FailReason.FILE_ERROR, deviceAddress)
    }

    override fun onFailedByPhoneBluetoothError() {
        outListener?.onDfuFailed(BleDFUState.FailReason.PHONE_BLUETOOTH_ERROR, deviceAddress)
    }

    override fun onOtherErrorOccurred(error: Int, errorMsg: String) {}
    override fun onFailedByConfigParaError() {
        outListener?.onDfuFailed(BleDFUState.FailReason.CONFIG_PARAS_ERROR, deviceAddress)
    }

    override fun onFailedByOutOfMaxRetryTimes() {
        outListener?.onDfuFailed(BleDFUState.FailReason.OTHER, deviceAddress)
    }

    override fun onFailedByOperationFailed() {
        outListener?.onDfuFailed(BleDFUState.FailReason.OPERATION_FAILED, deviceAddress)
    }

    override fun onFailedByNotPermitted() {
        outListener?.onDfuFailed(BleDFUState.FailReason.OPERATION_NOT_PERMITTED, deviceAddress)
    }

    override fun onFailedByOther() {
        outListener?.onDfuFailed(BleDFUState.FailReason.OTHER, deviceAddress)
    }

    override fun onFailedByDeviceNotReboot() {
        outListener?.onDfuFailed(BleDFUState.FailReason.DEVICE_NOT_REBOOT, deviceAddress)
    }

    override fun onRestart(index: Int) {
        outListener?.onDfuRetry(index, deviceAddress)
    }

    override fun onCancel() {
        outListener?.onDfuCanceled(deviceAddress)
    }

    override fun onSuccess() {
        outListener?.onDfuSuccess(deviceAddress)
    }

    override fun onSuccessAndNeedToPromptUser() {
        outListener?.onDfuSuccessAndNeedToPromptUser(deviceAddress)
    }

    override fun onProgress(progress: Int) {
        outListener?.onDfuProgress(progress, deviceAddress)
    }

    override fun onDeviceConnecting() {
        outListener?.onDfuStatusChanged(BleDFUState.DfuStatus.connecting, deviceAddress)
    }

    override fun onDeviceConnected() {
//        outListener?.onDfuStatusChanged(BleDFUState.DfuStatus.connecting)
    }

    override fun onDfuProcessStarting() {
        outListener?.onDfuStatusChanged(BleDFUState.DfuStatus.starting, deviceAddress)
    }

    override fun onDfuProcessStarted() {
//        outListener?.onDfuStatusChanged(BleDFUState.DfuStatus.connecting)
    }

    override fun onEnablingDfuMode() {
        outListener?.onDfuStatusChanged(BleDFUState.DfuStatus.enablingDfuMode, deviceAddress)
    }

    override fun onFirmwareValidating() {
        outListener?.onDfuStatusChanged(BleDFUState.DfuStatus.validating, deviceAddress)
    }

    override fun onDeviceDisconnecting() {
        outListener?.onDfuStatusChanged(BleDFUState.DfuStatus.disconnecting, deviceAddress)
    }

    override fun onDeviceDisconnected() {
//        outListener?.onDfuStatusChanged(BleDFUState.DfuStatus.connecting)
    }
}