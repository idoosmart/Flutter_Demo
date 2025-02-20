package com.example.flutter_bluetooth.logger

import android.text.TextUtils
import android.util.Log
import com.example.flutter_bluetooth.BuildConfig

object Logger {
    var enableLogPrint = true

    @JvmStatic
    fun d(message: String?) {
        if (TextUtils.isEmpty(message)) return
        val trace = Throwable().stackTrace[1]
        LogTransfer.instance.writeLog(trace.className, trace.methodName, message!!)
        if (enableLogPrint && BuildConfig.DEBUG) {
            Log.d(trace.fileName, message)
        }
    }

    @JvmStatic
    fun e(message: String) {
        val trace = Throwable().stackTrace[1]
        LogTransfer.instance.writeLog(trace.className, trace.methodName, message)
        if (enableLogPrint && BuildConfig.DEBUG) {
            Log.e(trace.fileName, message)
        }
    }

    @JvmStatic
    fun e(tag: String, message: String?) {
        if (TextUtils.isEmpty(message)) return
        val trace = Throwable().stackTrace[1]
        LogTransfer.instance.writeLog(tag, trace.methodName, message!!)
        if (enableLogPrint && BuildConfig.DEBUG) {
            Log.e(tag, message)
        }
    }

    @JvmStatic
    fun i(message: String) {
        Log.i(Throwable().stackTrace[1].fileName, message)
    }

    @JvmStatic
    fun i(tag: String, message: String?) {
        if (TextUtils.isEmpty(message)) return
        val trace = Throwable().stackTrace[1]
        LogTransfer.instance.writeLog(tag, trace.methodName, message!!)
        if (enableLogPrint && BuildConfig.DEBUG) {
            Log.i(tag, message!!)
        }
    }

    @JvmStatic
    fun v(message: String) {
        Log.v(Throwable().stackTrace[1].fileName, message)
    }

    @JvmStatic
    fun p(message: String?) {
        if (TextUtils.isEmpty(message)) return
        val trace = Throwable().stackTrace[1]
        LogTransfer.instance.writeLog(trace.className, trace.methodName, message!!)
        if (enableLogPrint && BuildConfig.DEBUG) {
            Log.v(trace.fileName, message)
        }
    }

    @JvmStatic
    fun p(tag: String, message: String?) {
        if (TextUtils.isEmpty(message)) return
        val trace = Throwable().stackTrace[1]
        LogTransfer.instance.writeLog(tag, trace.methodName, message!!)
        if (enableLogPrint && BuildConfig.DEBUG) {
            Log.v(tag, message)
        }
    }
}