package com.example.flutter_bluetooth.dfu;

public enum ConnectFailedReason {
    /**
     * mac地址错误
     */
    MAC_ADDRESS_INVALID,
    /**
     * 设备与App未绑定
     */
    NOT_IN_BIND_STATUS,
    /**
     * 蓝牙开关关闭
     */
    BLUETOOTH_SWITCH_CLOSED,
    /**
     * 正在升级中
     */
    IN_UPGRADING_STATUS,
    /**
     * 系统GATT错误
     */
    SYSTEM_GATT_ERROR,
    /**
     * 发现服务失败
     */
    DISCOVER_SERVICE_FAILED,
    /**
     * 使能通知失败
     */
    ENABLE_NOTIFY_FAILED,
    /**
     * 鉴权失败
     */
    ENCRYPTED_FAILED,
    /**
     * 其他
     */
    ERROR_OTHER
}
