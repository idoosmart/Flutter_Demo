package com.idosmart.pigeon_implement

import com.idosmart.pigeongen.api_device_log.DeviceLog
import com.idosmart.protocol_channel.plugin
import com.idosmart.protocol_sdk.DeviceLogInterface
import com.idosmart.enums.*
import com.idosmart.protocol_channel.innerRunOnMainThread
import com.idosmart.protocol_sdk.BlockLogProgress

internal class DeviceLogImpl: DeviceLogInterface {

    private fun deviceLog(): DeviceLog? {
        return plugin.deviceLog()
    }

    override val getLogIng: Boolean
        get() = DeviceLogDelegateImpl.instance().logStatus
    override val logDirPath: String
        get() = DeviceLogDelegateImpl.instance().logDirPath

    override fun startGet(
        types: List<IDODeviceLogType>,
        timeOut: Int,
        progress: BlockLogProgress,
        completion: (result: Boolean) -> Unit
    ) {
        var logTypes = mutableListOf<Long>()
        types.map {
            logTypes.add(it.raw.toLong())
        }
        DeviceLogDelegateImpl.instance().callbackProgress = progress
        innerRunOnMainThread {
            deviceLog()?.startGet(logTypes, timeOut.toLong(), completion)
        }
    }

    override fun cancel(completion: () -> Unit) {
        innerRunOnMainThread {
            deviceLog()?.cancel(completion)
        }
    }

}