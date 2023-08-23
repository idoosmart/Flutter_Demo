package com.example.flutter_bluetooth.utils

object BluetoothError {
    const val BLUETOOTH_INVALID_PARAMS = -1
    const val BLUETOOTH_UNAVAILABLE = 1
    const val NO_BLUETOOTH_PERMISSIONS = 2
    const val BLUETOOTH_SCAN_START_FAILED = 3
    const val BLUETOOTH_ERROR = 4
    const val BLUETOOTH_NOT_FOUND_DEVICE = 5

    fun parse(code: Int, msg: String = ""): String {
        return when (code) {
            BLUETOOTH_UNAVAILABLE -> "Bluetooth unavailable"
            NO_BLUETOOTH_PERMISSIONS -> "SofitbluetoothPlugin requires location permission for scanning!"
            BLUETOOTH_SCAN_START_FAILED -> "SofitbluetoothPlugin failed to start scanner, because of: $msg"
            else -> msg.ifEmpty { "error: $code" }
        }
    }
}