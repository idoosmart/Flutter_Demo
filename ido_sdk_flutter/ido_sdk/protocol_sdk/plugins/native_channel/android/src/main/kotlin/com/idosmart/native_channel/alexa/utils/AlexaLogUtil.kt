package com.idosmart.native_channel.alexa.utils

import android.os.Handler
import android.os.Looper
import android.util.Log
import com.idosmart.native_channel.pigeon_generate.api_alexa.ApiAlexaFlutter

/**
 * @author tianwei
 * @date 2023/9/22
 * @time 20:40
 * 用途:
 */
object AlexaLogUtil {
    private var apiAlexaFlutter: ApiAlexaFlutter? = null
    private var mainHandler: Handler? = null

    fun setApiAlexaFlutter(apiAlexaFlutter: ApiAlexaFlutter?, mainHandler: Handler?) {
        AlexaLogUtil.apiAlexaFlutter = apiAlexaFlutter
        AlexaLogUtil.mainHandler = mainHandler
    }

    @JvmStatic
    fun printAndSave(text: String, tag: String = "AlexaLogUtil") {
        Log.d(tag, text)
        sendLog("[AlexaLogUtil]:$text")
    }

    @JvmStatic
    fun d(text: String) {
        Log.d("AlexaLogUtil", text)
        sendLog("[AlexaLogUtil]:$text")
    }

    @JvmStatic
    fun d(tag: String = "AlexaLogUtil", text: String) {
        Log.d(tag, text)
        sendLog("[$tag]:$text")
    }

    @JvmStatic
    fun e(text: String, tag: String = "AlexaLogUtil") {
        Log.d(tag, text)
        sendLog("[$tag]:$text")
    }

    @JvmStatic
    fun p(text: String, tag: String = "AlexaLogUtil") {
        Log.d(tag, text)
        sendLog("[$tag]:$text")
    }

    private fun sendLog(message: String) {
        if (apiAlexaFlutter == null) return
        if (Looper.myLooper() != Looper.getMainLooper()) {
            mainHandler?.post {
                apiAlexaFlutter?.log(message) {

                }
            }
        } else {
            apiAlexaFlutter?.log(message) {

            }
        }
    }
}