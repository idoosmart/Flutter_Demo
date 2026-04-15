package com.idosmart.pigeon_implement

import com.idosmart.pigeongen.api_device.DeviceDelegate
import com.idosmart.pigeongen.api_device.DeviceInfo
import com.idosmart.protocol_sdk.DeviceInterface

internal class DeviceDelegateImpl: DeviceDelegate {

    companion object {
        @Volatile
        private var instance: DeviceDelegateImpl? = null
        fun instance(): DeviceDelegateImpl {
            return instance ?: synchronized(this) {
                instance ?: DeviceDelegateImpl().also { instance = it }
            }
        }
    }

    private var _deviceInfo: DeviceInfo? = null

    var callbackDeviceInfo: ((DeviceInterface) -> Unit)? = null

    val deviceInfo: DeviceInfo? get() {
        return _deviceInfo
    }

    override fun listenDeviceChanged(deviceInfo: DeviceInfo) {
        _deviceInfo = deviceInfo
    }

    override fun listenDeviceOnBind(deviceInfo: DeviceInfo) {
        val device = IDODevice(deviceInfo)
        callbackDeviceInfo?.invoke(device)
        callbackDeviceInfo = null
    }

}