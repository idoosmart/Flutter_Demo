package com.example.flutter_bluetooth.utils

import android.bluetooth.BluetoothProfile

object Constants {
    object RequestMethod {
        const val START_SCAN = "startScan"
        const val STOP_SCAN = "stopScan"
        const val CONNECT = "connect"
        const val SEND_DATA = "sendData"
        const val SEND_SPP_DATA = "sendSppData"
        const val STATE = "state"
        const val DISCONNECT = "cancelConnect"
        const val GET_DEVICE_STATE = "getDeviceState"
        const val START_PAIR = "startPair"
        const val CANCEL_PAIR = "cancelPair"
        const val CONNECT_SPP = "connectSPP"
        const val DISCONNECT_SPP = "disconnectSPP"
        const val START_DFU = "startNordicDFU"
        const val AUTO_CONNECT = "autoConnect"
        const val GET_A2DP_STATE = "getMediaState"
        const val GET_SPP_STATE = "getSppState"
        const val GET_DOCUMENT_PATH = "getDocumentPath"
    }

    object ResponseMethod {
        const val SCAN_RESULT = "scanResult"
        const val DEVICE_STATE = "deviceState"
        const val CHARACTERISTIC = "characteristic"
        const val SERVICES_UUID = "servicesUUID"
        const val SEND_STATE = "sendState"
        const val RECEIVE_DATA = "receiveData"
        const val BLUETOOTH_STATE = "bluetoothState"
        const val IS_OTA_WITH_SERVICES = "isOtaWithServices"
        const val PAIR_STATE = "pairState"
        const val SPP_WRITE_COMPLETE = "writeSPPCompleteState"
        const val SPP_STATE = "SPPState"
        const val WRITE_LOG = "writeLog"
        const val DFU_STATE = "dfuProgress"
        const val A2DP_STATE = "mediaState"


        const val ON_BOND_STATE_CHANGED = ""
    }

    /**
     * 设备连接状态
     */
    object BleConnectState {
        const val STATE_DISCONNECTED = BluetoothProfile.STATE_DISCONNECTED
        const val STATE_CONNECTING = BluetoothProfile.STATE_CONNECTING
        const val STATE_CONNECTED = BluetoothProfile.STATE_CONNECTED
        const val STATE_DISCONNECTING = BluetoothProfile.STATE_DISCONNECTING

        fun getName(state: Int): String {
            return when (state) {
                STATE_DISCONNECTED -> "DISCONNECTED"
                STATE_CONNECTING -> "CONNECTING"
                STATE_CONNECTED -> "CONNECTED"
                STATE_DISCONNECTING -> "DISCONNECTING"
                else -> ""
            }
        }
    }

    /**
     * 连接失败原因:
    默认
    UUID或Mac地址异常
    蓝牙关闭
    主动断开连接
    连接失败
    连接超时
    发现服务失败
    发现特征失败
     */
    enum class BleConnectFailedError {
        DEFAULT,
        WRONG_MAC_ADDRESS,//错误的mac地址
        BLE_SWITCH_CLOSED,//蓝牙关闭
        CONNECT_BREAK,//主动断开连接
        CONNECT_FAILED,//连接异常，包括gatt异常、
        TIMEOUT, //超时
        DISCOVER_SERVICE_FAILED,//发现服务失败
        DISCOVER_CHARACTERISTIC_FAILED,//发现特征失败
        GATT_ERROR,//gatt异常，需要重启蓝牙
    }

    /**
     * 未知，
    系统服务重启中，
    不支持，
    未授权，
    蓝牙关闭，
    蓝牙打开
     */
    enum class BluetoothState {
        UNKNOWN, SERVICE_RESTART, NOT_SUPPORT, NO_PERMISSION, OFF, ON
    }

    /**
     * 数据发送状态
     * RESPONSE：需要等待发送结果
     * NO_RESPONSE：无需等待发送结果
     */
    enum class WriteType {
        RESPONSE, NO_RESPONSE
    }

    /**
     *指令类型
     */
    enum class CommandType {
        NORMAL, HEALTH
    }

    /**
     * spp连接状态
     */
    object SPPConnectState {
        const val START = 0
        const val SUCCESS = 1
        const val FAILED = 2
        const val BREAK = 3
    }

    /**
     * 发送的数据类型
     */
    enum class SendDataType {
        BLE, SPP
    }
}