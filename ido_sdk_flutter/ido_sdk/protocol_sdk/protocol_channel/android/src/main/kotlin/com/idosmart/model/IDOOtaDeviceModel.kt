package com.idosmart.model

import com.idosmart.enums.IDODeviceStateType
import com.idosmart.model.IDOBleDeviceModel

open class IDOOtaDeviceModel(
    /// rssi
    val rssi: Int,
    /// 设备名称
    val name: String?,
    /// uuid
    val uuid: String?,
    /// mac address
    val macAddress: String?,
    /// ota mac address
    val otaMacAddress: String?,
    /// bt mac address
    val btMacAddress: String?,
    /// 设备ID
    val deviceId: Int,
    /// 设备类型 0:无效 1: 手表 2: 手环
    val deviceType: Int,
    /// 是否ota模式
    val isOta: Boolean,
    /// 是否泰凌微ota
    val isTlwOta: Boolean,
    /// bt版本号
    val bltVersion: Int,
    /// 配对状态（Android）
    val isPair: Boolean,
    /// 平台 98, 99
    val platform: Int
) {

//    fun updateValues(newDevice: OtaDeviceModel) {
//        // Swift中的 `guard macAddress != nil && macAddress == newDevice.macAddress else` 翻译为 Kotlin 的 if 语句。
//        if (macAddress == null || macAddress != newDevice.macAddress) {
//            //print("swift 收到bleModel属性变更，macAddress不相同 return")
//            return
//        }
//
//        (this as IDOOtaDeviceModel).rssi = newDevice.rssi ?: -1 // 假设 OtaDeviceModel.rssi 是 Int?
//        (this as IDOOtaDeviceModel).name = newDevice.name
//        (this as IDOOtaDeviceModel).uuid = newDevice.uuid
//        (this as IDOOtaDeviceModel).macAddress = newDevice.macAddress
//        (this as IDOOtaDeviceModel).otaMacAddress = newDevice.otaMacAddress
//        (this as IDOOtaDeviceModel).btMacAddress = newDevice.btMacAddress
//        (this as IDOOtaDeviceModel).deviceId = newDevice.deviceId ?: 0 // 假设 OtaDeviceModel.deviceId 是 Int?
//        (this as IDOOtaDeviceModel).deviceType = newDevice.deviceType ?: 0 // 假设 OtaDeviceModel.deviceType 是 Int?
//        (this as IDOOtaDeviceModel).isOta = newDevice.isOta ?: false
//        (this as IDOOtaDeviceModel).isTlwOta = newDevice.isTlwOta ?: false
//        (this as IDOOtaDeviceModel).bltVersion = newDevice.bltVersion ?: 0 // 假设 OtaDeviceModel.bltVersion 是 Int?
//        (this as IDOOtaDeviceModel).isPair = newDevice.isPair ?: false
//    }

    override fun toString(): String {
        // Swift 的 `description` 属性在 Kotlin 中对应 `toString()` 方法。
        // 字符串插值语法略有不同：Swift 使用 `\(variable)`，Kotlin 使用 `${variable}` 或 `$variable`。
        return "IDOOtaDeviceModel(macAddress: ${macAddress ?: ""}, isPair: $isPair, isTlwOta: $isTlwOta, isOta: $isOta, name: ${name ?: ""}, rssi: $rssi, uuid: ${uuid ?: ""} deviceId: $deviceId, deviceType: $deviceType, bltVersion: $bltVersion)"
    }

    fun toDeviceModel(): IDOBleDeviceModel {
        return IDOBleDeviceModel(
            rssi = rssi,
            name = name,
            state = IDODeviceStateType.DISCONNECTED,
            uuid = uuid,
            macAddress = macAddress,
            otaMacAddress = otaMacAddress,
            btMacAddress = btMacAddress,
            deviceId = deviceId,
            deviceType = deviceType,
            isOta = isOta,
            isTlwOta = isTlwOta,
            bltVersion = bltVersion,
            isPair = isPair
        )
    }
}