package com.idosmart.native_channel.actions.ibluz.device.bluzdevice;

public enum BleScanState {

    BLUETOOTH_OFF(-1, "BLUETOOTH_OFF"),
    SCAN_SUCCESS(0, "SCAN_SUCCESS"),
    SCAN_FAILED_ALREADY_STARTED(1, "SCAN_FAILED_ALREADY_STARTED"),
    SCAN_FAILED_APPLICATION_REGISTRATION_FAILED(2, "SCAN_FAILED_APPLICATION_REGISTRATION_FAILED"),
    SCAN_FAILED_INTERNAL_ERROR(3, "SCAN_FAILED_INTERNAL_ERROR"),
    SCAN_FAILED_FEATURE_UNSUPPORTED(4, "SCAN_FAILED_FEATURE_UNSUPPORTED"),
    SCAN_FAILED_OUT_OF_HARDWARE_RESOURCES(5, "SCAN_FAILED_OUT_OF_HARDWARE_RESOURCES");


    private int code;
    private String message;
    BleScanState(int code, String message) {
        this.code = code;
        this.message = message;
    }

    public static BleScanState newInstance(int code) {
        switch (code) {
            case -1:
                return BleScanState.BLUETOOTH_OFF;
            case 1:
                return BleScanState.SCAN_FAILED_ALREADY_STARTED;
            case 2:
                return BleScanState.SCAN_FAILED_APPLICATION_REGISTRATION_FAILED;
            case 3:
                return BleScanState.SCAN_FAILED_INTERNAL_ERROR;
            case 4:
                return BleScanState.SCAN_FAILED_FEATURE_UNSUPPORTED;
            case 5:
                return BleScanState.SCAN_FAILED_OUT_OF_HARDWARE_RESOURCES;
            default:
                return BleScanState.SCAN_SUCCESS;
        }
    }

    public int getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }
}