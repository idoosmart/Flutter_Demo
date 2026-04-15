package com.idosmart.pigeon_implement

import com.idosmart.pigeongen.api_device_log.DeviceLogDelegate
import com.idosmart.protocol_sdk.BlockLogProgress

internal class DeviceLogDelegateImpl: DeviceLogDelegate {

    companion object {
        @Volatile
        private var instance: DeviceLogDelegateImpl? = null
        fun instance(): DeviceLogDelegateImpl {
            return instance ?: synchronized(this) {
                instance ?: DeviceLogDelegateImpl().also { instance = it }
            }
        }
    }

    var logStatus: Boolean = false
    var logDirPath: String = ""
    var callbackProgress: BlockLogProgress? = null

    override fun listenLogStatus(status: Boolean) {
        logStatus = status
    }

    override fun listenLogDirPath(dirPath: String) {
        logDirPath = dirPath
    }

    override fun callbackLogProgress(progress: Double) {
        callbackProgress?.let {
            it(progress)
        }
    }

}