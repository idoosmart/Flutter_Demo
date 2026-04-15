package com.idosmart.model

import com.idosmart.enums.*
import com.idosmart.pigeongen.api_bluetooth.DeviceModel
import java.io.Serializable

class IDOBleDeviceModel : Serializable{
    /// rssi
    var rssi: Int? = 0
        internal set
    /// 设备名称
    var name: String? = ""
        internal set
    /// 设备状态
    var state: IDODeviceStateType? = IDODeviceStateType.DISCONNECTED
        internal set
    /// uuid
    var uuid: String? = ""
        internal set
    /// mac address
    var macAddress: String? = ""
        internal set
    /// ota mac address
    var otaMacAddress: String? = ""
        internal set
    /// bt mac address
    var btMacAddress: String? = ""
        internal set
    /// 设备ID
    var deviceId: Int? = 0
        internal set
    /// 设备类型 0:无效 1: 手表 2: 手环
    var deviceType: Int? = 0
        internal set
    /// 是否ota模式
    var isOta: Boolean? = false
        internal set
    /// 是否泰凌微ota
    var isTlwOta: Boolean? = false
        internal set
    /// bt版本号
    var bltVersion: Int? = 0
        internal set
    /// 配对状态（Android）
    var isPair: Boolean? = false
        internal set

    var platform: Int = 0
        internal set

    constructor(rssi: Int? = 0,
                name: String? = "",
                state: IDODeviceStateType? = IDODeviceStateType.DISCONNECTED,
                uuid: String? = "",
                macAddress: String? = "",
                otaMacAddress: String? = "",
                btMacAddress: String? = "",
                deviceId: Int? = 0,
                deviceType: Int? = 0,
                isOta: Boolean? = false,
                isTlwOta: Boolean? = false,
                bltVersion: Int? = 0,
                isPair: Boolean? = false) {
        this.rssi = rssi
        this.name = name
        this.state = state
        this.uuid = uuid
        this.macAddress = macAddress
        this.otaMacAddress = otaMacAddress
        this.btMacAddress = btMacAddress
        this.deviceId = deviceId
        this.deviceType = deviceType
        this.isOta = isOta
        this.isTlwOta = isTlwOta
        this.bltVersion = bltVersion
        this.isPair = isPair
    }

    constructor(rssi: Int? = 0,
                name: String? = "",
                state: IDODeviceStateType? = IDODeviceStateType.DISCONNECTED,
                uuid: String? = "",
                macAddress: String? = "",
                otaMacAddress: String? = "",
                btMacAddress: String? = "",
                deviceId: Int? = 0,
                deviceType: Int? = 0,
                isOta: Boolean? = false,
                isTlwOta: Boolean? = false,
                bltVersion: Int? = 0,
                isPair: Boolean? = false,
                platform: Int = 0) {
        this.rssi = rssi
        this.name = name
        this.state = state
        this.uuid = uuid
        this.macAddress = macAddress
        this.otaMacAddress = otaMacAddress
        this.btMacAddress = btMacAddress
        this.deviceId = deviceId
        this.deviceType = deviceType
        this.isOta = isOta
        this.isTlwOta = isTlwOta
        this.bltVersion = bltVersion
        this.isPair = isPair
        this.platform = platform
    }

    internal fun updateValues(newDevice: DeviceModel) {
        if(macAddress != null && macAddress != newDevice.macAddress) {
            //println("kotlin 收到bleModel属性变更，macAddress不相同 return")
            return
        }
        //println("kotlin 收到bleModel属性变更，对外实体属性更新 btMacAddress:${btMacAddress} isPair:${newDevice.isPair}")
        rssi = newDevice.rssi?.toInt()
        name = newDevice.name
        state = IDODeviceStateType.values()[newDevice.state?.raw ?:0]
        uuid = newDevice.uuid
        macAddress = newDevice.macAddress
        otaMacAddress = newDevice.otaMacAddress
        btMacAddress = newDevice.btMacAddress
        deviceId = newDevice.deviceId?.toInt()
        deviceType = newDevice.deviceType?.toInt()
        isOta = newDevice.isOta
        isTlwOta = newDevice.isTlwOta
        bltVersion = newDevice.bltVersion?.toInt()
        isPair = newDevice.isPair
        platform = newDevice.platform?.toInt() ?: 0
    }
}

/// 蓝牙状态
class IDOBluetoothStateModel {
    var type: IDOBluetoothStateType? = IDOBluetoothStateType.UNKNOWN
    var scanType: IDOBluetoothScanType? = IDOBluetoothScanType.STOP
}

///设备状态
class IDODeviceStateModel {
    var uuid: String? = ""
    var macAddress: String? = ""
    var state: IDODeviceStateType? = IDODeviceStateType.DISCONNECTED
    var errorState: IDOConnectErrorType? = IDOConnectErrorType.NONE
}

class IDOWriteStateModel {
    /// 写入状态是否成功
    var state: Boolean? = false
    /// uuid
    var uuid: String? = ""
    /// mac address
    var macAddress: String? = ""
    /// 写入类型
    var type: IDOWriteType? = IDOWriteType.ERROR
}

/// 设备升级
class IDODfuConfig {
    /// ota文件包路径
    var filePath: String? = ""
    /// 设备的uuid, iOS使用
    var uuid: String? = ""
    /// 设备的ble地址 安卓使用
    var macAddress: String? = ""
    /// 设备的id
    var deviceId: String? = ""
    /// 平台，默认为nordic，目前只支持nordic
    var platform: Int? = 0
    /// 设备是否支持配对，根据功能表V3_dev_support_pair_each_connect  安卓使用
    var isDeviceSupportPairedWithPhoneSystem: Boolean? = false
    /// 每次接受到包数，可不填
    var prn: Int? = 0
    /// 在重试过程中，如果多次升级失败，是否需要重启蓝牙
    var isNeedReOpenBluetoothSwitchIfFailed: Boolean? = false
    /// 最大重试次数
    var maxRetryTime: Int? = 0
    /// RTK平台的OTA，在升级之前是否需要授权
    var isNeedAuth: Boolean? = false
    /// RTK平台的OTA，模式
    var otaWorkMode: Int? = 0
}

/// 蓝牙响应数据对象
class IDOReceiveData {
    /// 蓝牙字节数据
    var data: ByteArray? = ByteArray(0)
    /// uuid
    var uuid: String? = ""
    /// mac address
    var macAddress: String? = ""
    /// spp
    var spp: Boolean? = false
    /** 0 爱都, 1 恒玄, 2 VC */
    var platform: Long = 0
}

///spp状态
class IDOSppStateModel {
    var type: IDOSppStateType? = IDOSppStateType.ONSTART
}