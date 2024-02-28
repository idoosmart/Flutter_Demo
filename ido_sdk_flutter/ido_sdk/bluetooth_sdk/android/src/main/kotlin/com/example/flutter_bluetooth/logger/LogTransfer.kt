package com.example.flutter_bluetooth.logger

import android.app.Activity
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.example.flutter_bluetooth.utils.Constants
import io.flutter.plugin.common.MethodChannel

/**
 * @author tianwei
 * @date 2023/1/4
 * @time 15:26
 * 用途:
 */
class LogTransfer private constructor() {

    private var channel: MethodChannel? = null
    private val handler: Handler = Handler(Looper.getMainLooper())

    companion object {
        val instance = LogTransfer()
    }

    fun init(channel: MethodChannel?) {
        this.channel = channel
    }

    fun destroy() {
        channel = null
    }


    fun writeLog(className: String, methodName: String, details: String) {
        val result = hashMapOf<String, Any?>()
        result["platform"] = 2
        result["className"] = className
        result["method"] = methodName
        result["detail"] = details
        channel?.let {
            handler.post {
                try {
                    it.invokeMethod(Constants.ResponseMethod.WRITE_LOG, result)
                } catch (_: Exception) {
                }
            }
        }

    }
}