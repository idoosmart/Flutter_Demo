package com.idosmart.native_channel.actions

import android.os.Handler
import android.os.Looper
import com.idosmart.native_channel.NativeChannelPlugin
import com.idosmart.native_channel.pigeon_generate.api_actions.ActionsOTAState
import com.idosmart.native_channel.pigeon_generate.api_actions.ApiActionsFlutter

/**
 * Actions OTA 原生到 Flutter 的回调桥接 | Actions OTA native-to-Flutter callback bridge
 * 参照 NordicToFlutterImpl / SicheToFlutterImpl 模式
 */
object ActionsToFlutterImpl {

    private val mainHandler = Handler(Looper.getMainLooper())

    private fun apiActionsFlutter(): ApiActionsFlutter? {
        return NativeChannelPlugin.instance().apiActionsFlutter
    }

    private fun runOnMainThread(action: () -> Unit) {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            action()
        } else {
            mainHandler.post(action)
        }
    }

    /** 升级状态变更 | Upgrade state changed */
    fun onOTAStateChanged(state: ActionsOTAState, errorMessage: String) {
        runOnMainThread {
            apiActionsFlutter()?.onOTAStateChanged(state, errorMessage) {}
        }
    }

    /**
     * 升级进度变更 | Upgrade progress changed
     * progress: 进度值 (0 ~ 100)
     */
    fun onOTAProgress(progress: Double, message: String) {
        runOnMainThread {
            apiActionsFlutter()?.onOTAProgress(progress, message) {}
        }
    }

    /** 日志输出 | Log output */
    fun log(logMsg: String) {
        runOnMainThread {
            apiActionsFlutter()?.log(logMsg) {}
        }
    }
}
