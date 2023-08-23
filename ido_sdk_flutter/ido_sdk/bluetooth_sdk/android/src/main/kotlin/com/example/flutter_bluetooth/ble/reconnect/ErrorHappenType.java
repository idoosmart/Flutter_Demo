package com.example.flutter_bluetooth.ble.reconnect;

public enum ErrorHappenType {
    /**
     * 未扫描到设备
     */
    NOT_FIND_DEVICE,
    /**
     * 扫描到了设备，但连接设备时系统返回错误
     */
    GATT_ERROR_FIND_DEVICE,
    /**
     * 未扫描到设备直连设备、连接不存在的设备系统报的错
     */
    GATT_ERROR_OTHER,
    /**
     * 发现服务失败
     */
    DISCOVER_SERVICE_FAILED,
    /**
     * 使能通知失败
     */
    ENABLE_NOTIFY_FAILED,
    /**
     * 连接成功后，但鉴权失败
     */
    ENCRYPTED_FAILED
}