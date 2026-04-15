package com.idosmart.native_channel.nordic

import android.os.Handler
import android.os.Looper
import com.idosmart.native_channel.NativeChannelPlugin
import com.idosmart.native_channel.pigeon_generate.api_nordic.ApiNordicFlutter
import com.idosmart.native_channel.pigeon_generate.api_nordic.NordicDFUState

/**
 * Nordic DFU 原生到 Flutter 的回调桥接 | Nordic DFU native-to-Flutter callback bridge
 * 参照 SicheToFlutterImpl 模式 | Follows the SicheToFlutterImpl pattern
 */
object NordicToFlutterImpl {

    private val mainHandler = Handler(Looper.getMainLooper())

    private fun apiNordicFlutter(): ApiNordicFlutter? {
        return NativeChannelPlugin.instance().apiNordicFlutter
    }

    private fun runOnMainThread(action: () -> Unit) {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            action()
        } else {
            mainHandler.post(action)
        }
    }

    /**
     * 升级状态变更 | Upgrade state changed
     */
    fun onDFUStateChanged(state: NordicDFUState, errorMessage: String) {
        runOnMainThread {
            apiNordicFlutter()?.onDFUStateChanged(state, errorMessage) {}
        }
    }

    /**
     * 升级进度变更 | Upgrade progress changed
     * progress: 进度值 (0 ~ 100) | Progress value (0 ~ 100)
     * speed: 速度描述 | Speed description
     */
    fun onDFUProgress(progress: Double, speed: String) {
        runOnMainThread {
            apiNordicFlutter()?.onDFUProgress(progress, speed) {}
        }
    }

    /**
     * 日志输出 | Log output
     */
    fun log(logMsg: String) {
        runOnMainThread {
            apiNordicFlutter()?.log(logMsg) {}
        }
    }
}
