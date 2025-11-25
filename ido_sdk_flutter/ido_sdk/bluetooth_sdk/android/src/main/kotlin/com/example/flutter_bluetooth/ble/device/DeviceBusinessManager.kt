package com.example.flutter_bluetooth.ble.device

import android.os.Handler
import android.os.Looper
import com.example.flutter_bluetooth.logger.Logger
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec

/**
 * @author tianwei
 * @date 2025/6/19 15:37
 * @description:
 */
object DeviceBusinessManager {
    private const val TAG = "DeviceBindManager"
    private const val METHOD_CHANNEL_DEVICE_BIND = "method_channel_device_bind"
    private const val METHOD_CHANNEL_INTERCEPT_AUTO_CONNECT = "method_channel_intercept_auto_connect"
    private var bindStateChannel: BasicMessageChannel<Any>? = null
    private var autoConnectInterceptChannel: BasicMessageChannel<Any>? = null
    private val mHandler = Handler(Looper.getMainLooper())
    private var bindStateTimeoutRunnable: TimeoutRunnable? = null
    private var autoConnectInterceptTimeoutRunnable: TimeoutRunnable? = null

    fun init(messenger: BinaryMessenger) {
        bindStateChannel = BasicMessageChannel(messenger, METHOD_CHANNEL_DEVICE_BIND, StandardMessageCodec.INSTANCE)
        autoConnectInterceptChannel = BasicMessageChannel(messenger, METHOD_CHANNEL_INTERCEPT_AUTO_CONNECT, StandardMessageCodec.INSTANCE)
    }

    private class TimeoutRunnable(val tag:String,val callback: (Boolean) -> Unit,val defaultValue: Boolean) : Runnable {

        override fun run() {
            Logger.e(TAG, "$tag timeout")
            callback(defaultValue)
        }
    }

    @JvmStatic
    fun autoConnectIntercept(macAddress: String, callback: (Boolean) -> Unit) {
        autoConnectInterceptTimeoutRunnable?.let {
            mHandler.removeCallbacks(it)
            autoConnectInterceptTimeoutRunnable = null
        }
        autoConnectInterceptTimeoutRunnable = TimeoutRunnable("auto connect intercept check",callback,false)
        mHandler.postDelayed(autoConnectInterceptTimeoutRunnable!!, 3000)
        runOnUiThread {
            autoConnectInterceptChannel?.send(mapOf(Pair("mac", macAddress))) { reply ->
                Logger.p(TAG, "autoConnectIntercept reply: $reply")
                autoConnectInterceptTimeoutRunnable?.let {
                    mHandler.removeCallbacks(it)
                }
                if (reply is Boolean) {
                    callback(reply)
                } else {
                    callback(false)
                }
            }
        }
    }

    @JvmStatic
    fun checkBindState(macAddress: String, callback: (Boolean) -> Unit) {
        if (bindStateTimeoutRunnable != null) {
            mHandler.removeCallbacks(bindStateTimeoutRunnable!!)
            bindStateTimeoutRunnable = null
        }
        bindStateTimeoutRunnable = TimeoutRunnable("bind state check ", callback, false)
        mHandler.postDelayed(bindStateTimeoutRunnable!!, 5000)
        runOnUiThread {
            bindStateChannel?.send(mapOf(Pair("mac", macAddress))) { reply ->
                Logger.p("DeviceBindManager", "checkBindState reply: $reply")
                bindStateTimeoutRunnable?.let {
                    mHandler.removeCallbacks(it)
                }
                if (reply is Boolean) {
                    callback(reply)
                } else {
                    callback(false)
                }
            }
        }
    }

    private fun runOnUiThread(callback: () -> Unit) {
        val isMainThread = Looper.myLooper() == Looper.getMainLooper()
        if (isMainThread) {
            callback()
        } else {
            mHandler.post {
                callback()
            }
        }
    }
}