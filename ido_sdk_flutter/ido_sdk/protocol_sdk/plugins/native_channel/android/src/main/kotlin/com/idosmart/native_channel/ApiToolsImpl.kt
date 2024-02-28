package com.idosmart.native_channel

import android.content.Context
import android.os.Environment
import android.util.Log
import com.idosmart.native_channel.pigeon_generate.api_tools.ApiTools
import io.flutter.BuildConfig
import io.flutter.embedding.engine.plugins.FlutterPlugin
import java.util.TimeZone

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
        NativeChannelPlugin.instance().tools?.getNativeLog("android getAppName: $appName"){}
        return appName ?: "-"
    }

    override fun getCurrentTimeZone(): String {
        val timeZone = TimeZone.getDefault()
        return timeZone.id
    }

    override fun getDocumentPath(): String? {
        return _context?.filesDir?.parent
    }
}