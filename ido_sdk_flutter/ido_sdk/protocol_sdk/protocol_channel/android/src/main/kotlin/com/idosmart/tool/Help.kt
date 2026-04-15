package com.idosmart.tool

import com.idosmart.pigeongen.api_bluetooth.DeviceModel
import com.idosmart.pigeongen.api_bluetooth.DeviceStateType
import com.idosmart.pigeongen.api_bluetooth.DfuConfig
import com.idosmart.model.*
import com.idosmart.enums.*

internal class Help {

    companion object {
        /**
        设备集合转换
         */
        fun getDeviceList(devices: List<DeviceModel>): List<IDOBleDeviceModel> {
            var deviceList = mutableListOf<IDOBleDeviceModel>()
            for (device in devices) {
                val bleDevice = getPublicDevice(device)
                deviceList.add(bleDevice)
            }
            return deviceList
        }

        /**
        获取公开的设备模型
         */
        fun getPublicDevice(device: DeviceModel?): IDOBleDeviceModel {
            if (device == null) {
                return IDOBleDeviceModel()
            }
            val pubDevice = IDOBleDeviceModel()
            pubDevice.rssi = (device.rssi ?: 0).toInt()
            pubDevice.name = device.name ?: ""
            pubDevice.deviceType = (device.deviceType ?: 0).toInt()
            pubDevice.uuid = device.uuid ?: ""
            pubDevice.macAddress = device.macAddress ?: ""
            pubDevice.deviceId = (device.deviceId ?: 0).toInt()
            pubDevice.otaMacAddress = device.otaMacAddress ?:""
            pubDevice.btMacAddress = device.btMacAddress ?:""
            pubDevice.isOta = device.isOta ?: false
            pubDevice.isTlwOta = device.isTlwOta ?: false
            pubDevice.isPair = device.isPair ?: false
            pubDevice.bltVersion = (device.bltVersion ?: 0).toInt()
            pubDevice.state = IDODeviceStateType.values()[device.state?.raw ?: 0]
            pubDevice.platform = (device.platform ?: 0).toInt()
            return pubDevice
        }

        /**
        获取api设备模型
         */
        fun getApiDevice(device: IDOBleDeviceModel?): DeviceModel {
            if (device == null) {
                return DeviceModel()
            }
            val rssi = (device.rssi ?: 0).toLong()
            val name = device.name ?: ""
            val deviceType = (device.deviceType ?: 0).toLong()
            val uuid = device.uuid ?: ""
            val macAddress = device.macAddress ?: ""
            val deviceId = (device.deviceId ?: 0).toLong()
            val otaMacAddress = device.otaMacAddress ?:""
            val btMacAddress = device.btMacAddress ?:""
            val isOta = device.isOta ?: false
            val isTlwOta = device.isTlwOta ?: false
            val isPair = device.isPair ?: false
            val bltVersion = (device.bltVersion ?: 0).toLong()
            val state = DeviceStateType.values()[device.state?.raw ?: 0]
            val platform = (device.platform ?: 0).toLong()
            return DeviceModel(rssi, name, state, uuid, macAddress, otaMacAddress, btMacAddress,
                deviceId, deviceType, isOta, isTlwOta, bltVersion, isPair, platform)
        }

        /**
         * 获取升级配置模型
         */
        fun getApiDfuConfig(config:IDODfuConfig): DfuConfig {
            val filePath: String? = config.filePath
            val uuid: String? = config.uuid
            val macAddress: String? = config.macAddress
            val deviceId: String? = config.deviceId
            val platform: Long? = config.platform?.toLong()
            val isDeviceSupportPairedWithPhoneSystem: Boolean? = config.isDeviceSupportPairedWithPhoneSystem
            val prn: Long? = config.prn?.toLong()
            val isNeedReOpenBluetoothSwitchIfFailed: Boolean? = config.isNeedReOpenBluetoothSwitchIfFailed
            val maxRetryTime: Long? = config.maxRetryTime?.toLong()
            val isNeedAuth: Boolean? = config.isNeedAuth
            val otaWorkMode: Long? = config.otaWorkMode?.toLong()
            return DfuConfig(filePath, uuid, macAddress, deviceId, platform, isDeviceSupportPairedWithPhoneSystem,
                prn, isNeedReOpenBluetoothSwitchIfFailed, maxRetryTime, isNeedAuth, otaWorkMode)
        }


    }

}