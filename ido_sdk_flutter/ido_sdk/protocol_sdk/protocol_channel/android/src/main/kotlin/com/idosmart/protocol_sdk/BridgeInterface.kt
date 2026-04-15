package com.idosmart.protocol_sdk

import com.idosmart.model.*
import com.idosmart.enums.*
import com.idosmart.pigeon_implement.logNative
import com.idosmart.pigeongen.api_bridge.OtaDeviceModel

interface IDOBridgeDelegate {

    /**
     * 监听协议状态变化 | Monitor protocol status changes
     *
     * @param status 协议状态 | Protocol status
     */
    fun listenStatusNotification(status: IDOStatusNotification)

    /**
     * 监听设备连接状态变化 | Monitor device connection status changes
     *
     * @param status 设备连接状态 | Device connection status
     */
    fun listenDeviceNotification(status: IDODeviceNotificationModel)

    /**
     * 根据设备macAddress查询绑定状态 | Query binding status by device macAddress
     *
     * @param macAddress 设备mac地址 | Device mac address
     * @return true: 已绑定,false:未绑定 | true: bound, false: not bound
     */
    fun checkDeviceBindState(macAddress: String): Boolean

    /**
     * 监听OTA设备 | Monitor OTA device
     *
     * @param otaDevice OTA设备 | OTA device
     */
    fun listenWaitingOtaDevice(otaDevice: IDOOtaDeviceModel) {}
}

private interface IDOBridgePipeDelegate {

    /**
     * 写数据到蓝牙设备 | Write data to the Bluetooth device
     *
     * @param request 写入的数据请求 | Write data request
     */
    fun writeDataToBle(request: IDOBleDataRequest)
}

interface BridgeInterface {

    /**
     * 注册,程序开始运行调用 | Register, call when the program starts running
     *
     * @param delegate 代理 | Delegate
     * @param logType 日志等级 | Log level
     */
    fun setupBridge(delegate: IDOBridgeDelegate, logType: IDOLogType)

    /**
     * 标记为OTA模式
     *
     * @param macAddress 设备macAddress
     * @param platform 设备平台
     * 0: Nordic,
     * 10: Realtek 8762x,
     * 20: Cypress PSoC6,
     * 30: Apollo3,
     * 40: 汇顶,
     * 50: Nordic + 泰凌微,
     * 60: 泰凌微 + 5340 (无 nand flash),
     * 70: 汇顶 + 富瑞坤,
     * 80: 5340,
     * 90: 炬芯,
     * 97: 恒玄,
     * 98: 思澈1,
     * 99: 思澈2 (注意：目前只支持98)
     * @param deviceId 设备id
     * @param completion 一个回调函数，操作成功返回 `true`，否则返回 `false`。
     */
    fun markOtaMode(
        macAddress: String,
        platform: Int,
        deviceId: Int,
        completion: (Boolean) -> Unit
    )
}

private interface BridgePipeInterface {
    @Deprecated(
        "use markConnectedDevice(uniqueId: String, otaType: IDOOtaType, isBinded: Boolean, deviceName: String?, completion: (Boolean) -> Unit)",
        replaceWith = ReplaceWith("markConnectedDevice(uniqueId, otaType, isBinded, deviceName) { /* handle result */ }")
    )
    fun markConnectedDevice(uniqueId: String, otaType: IDOOtaType, isBinded: Boolean, deviceName: String?) {
        markConnectedDevice(uniqueId, otaType, isBinded, deviceName, completion = {
            logNative("Warning: Called deprecated markConnectedDevice. Result was $it")
        })
    }

    /**
     * 标记设备已连接 | Mark the device as connected
     *
     * @param uniqueId 当前连接设备的mac地址 | The mac address of the currently connected device
     * @param otaType 当前设备OTA升级类型 | The current device OTA upgrade type
     * @param isBinded 绑定状态 | Binding status
     * @param deviceName 设备名称 | Device name
     * @param completion 回调 | Callback
     */
    fun markConnectedDevice(uniqueId: String, otaType: IDOOtaType, isBinded: Boolean, deviceName: String?, completion: (Boolean) -> Unit)

    @Deprecated(
        "use fun markDisconnectedDevice(macAddress: String? = null, uuid: String? = null, completion: (Boolean) -> Unit)",
        replaceWith = ReplaceWith("markDisconnectedDevice(macAddress, uuid) { /* handle result */ }")
    )
    fun markDisconnectedDevice(macAddress: String? = null, uuid: String? = null) {
        markDisconnectedDevice(macAddress, uuid) {
            logNative("Warning: Called deprecated markDisconnectedDevice. Result was $it")
        }
    }

    /**
     * 标记设备已断开 | Mark the device as disconnected
     *
     * @param macAddress MAC地址 | MAC address
     * @param uuid UUID
     */
    fun markDisconnectedDevice(macAddress: String? = null, uuid: String? = null, completion: (Boolean) -> Unit)

    /**
     * 蓝牙响应数据总入口 | Bluetooth response data entry
     *
     * @param data 数据 | Data
     * @param macAddress MAC地址 | MAC address
     * @param useSPP 使用SPP | Use SPP
     */
    fun receiveDataFromBle(data: ByteArray, macAddress: String? = null, useSPP: Boolean)

    /**
     * 发送蓝牙数据完成 | Send Bluetooth data complete
     */
    fun writeDataComplete()
}