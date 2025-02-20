package com.idosmart.native_channel

import android.content.Context
import android.os.Environment
import android.util.Log
import com.idosmart.native_channel.pigeon_generate.api_tools.ApiTools
import io.flutter.BuildConfig
import io.flutter.embedding.engine.plugins.FlutterPlugin
import java.util.TimeZone
import android.os.Build
import java.io.File

class ApiToolsImpl : ApiTools {

    companion object {
        @Volatile
        private var instance: ApiToolsImpl? = null
        fun instance(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding): ApiToolsImpl {
            return instance ?: synchronized(this) {
                instance ?: ApiToolsImpl(flutterPluginBinding).also { instance = it }
            }
        }
    }

    private var _context : Context? = null

    constructor(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        _context = flutterPluginBinding.applicationContext
        NoticeAppUtility.init(flutterPluginBinding.applicationContext,false)
    }

    override fun getAppName(): String {
        val packageManager = _context?.packageManager
        val applicationInfo = packageManager?.getApplicationInfo(_context?.packageName!!, 0)
        var appName: String? = null
        if (applicationInfo != null) {
            appName = packageManager.getApplicationLabel(applicationInfo).toString()
        }
        NativeChannelPlugin.instance().androidLog("android getAppName: $appName")
        return appName ?: "-"
    }

    override fun getCurrentTimeZone(): String {
        val timeZone = TimeZone.getDefault()
        return timeZone.id
    }

    override fun getDocumentPath(): String? {
        return _context?.filesDir?.parent
    }

    override fun getPlatformDeviceInfo(): Map<Any, Any?>? {
        val devInfo = DeviceInfoManager.getDeviceInfo()
        return mapOf("model" to devInfo.model, "systemVersion" to devInfo.systemVersion, "isRooted" to devInfo.isRooted)
    }
}

private data class DeviceInfo(
    val model: String,
    val systemVersion: String,
    val isRooted: Boolean
)

private object DeviceInfoManager {
     fun getDeviceInfo(): DeviceInfo {
        val model = Build.MODEL
        val systemVersion = Build.VERSION.RELEASE
        val isRooted = checkRoot()

        return DeviceInfo(model, systemVersion, isRooted)
    }

    private fun checkRoot(): Boolean {
        val paths = arrayOf(
            "/system/app/Superuser.apk",
            "/sbin/su",
            "/system/bin/su",
            "/system/xbin/su",
            "/data/local/xbin/su",
            "/data/local/bin/su",
            "/system/sd/xbin/su",
            "/system/bin/failsafe/su",
            "/data/local/su"
        )

        for (path in paths) {
            if (File(path).exists()) {
                return true
            }
        }

        return false
    }
}