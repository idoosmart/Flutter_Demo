package com.example.native_channel
import android.content.Context
import com.example.native_channel.api_get_app_info.ApiGetAppInfo
import io.flutter.embedding.engine.plugins.FlutterPlugin

class GetAppInfoImpl: ApiGetAppInfo {

    companion object {
        @Volatile
        private var instance: GetAppInfoImpl? = null
        fun instance(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding): GetAppInfoImpl {
            return instance ?: synchronized(this) {
                instance ?: GetAppInfoImpl(flutterPluginBinding).also { instance = it }
            }
        }
    }

    private var _context : Context? = null

    constructor(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        _context = flutterPluginBinding.applicationContext
        NoticeAppUtility.init(flutterPluginBinding.applicationContext)
    }

    override fun readInstallAppInfoList(
        force: Boolean,
        callback: (Result<List<Map<Any, Any?>>>) -> Unit
    ) {
         if (NoticeAppUtility.loadFinish && !force) {
             callback(Result.success(readInstalledAppList()))
         }else {
             NoticeAppUtility.setLoadAppListener(object : LoadAppListener{
                 override fun loadFinish() {
                     callback(Result.success(readInstalledAppList()))
                     NoticeAppUtility.setLoadAppListener(null)
                 }
             })
             if (force) { //强制刷新名字和图标
                 if (_context != null) {
                     NoticeAppUtility.init(_context!!)
                 }
             }
         }
    }

    override fun readDefaultAppList(callback: (Result<List<Map<Any, Any?>>>) -> Unit) {
        callback(Result.success(readDefaultAppList()))
    }

    override fun readCurrentAppInfo(type: Long, callback: (Result<Map<Any, Any?>?>) -> Unit) {
        callback(Result.success(readOneAppInfo(type.toInt())))
    }

    override fun convertEventType2PackageName(type: Long, callback: (Result<String?>) -> Unit) {
        val packageName = NoticeAppUtility.convertType2Pkg(type.toInt())
        callback(Result.success(packageName))
    }

    override fun convertEventTypeByPackageName(name: String, callback: (Result<Long>) -> Unit) {
        val eventType = NoticeAppUtility.getTypeByPkg(name)
        callback(Result.success(eventType.toLong()))
    }

    override fun isDefaultApp(packageName: String, callback: (Result<Boolean>) -> Unit) {
        callback(Result.success(isDefaultApp(packageName)))
    }

    /**
     * 读取本地安装的应用信息
     */
    private fun readInstalledAppList(): List<Map<Any, Any?>> {
        val appInfoList = mutableListOf<MutableMap<Any, Any>>()
        val list = NoticeAppUtility.getInstalledAppList()
        val defaultList = NoticeAppUtility.getDefaultApp()
        if (list.isNotEmpty()) {
            for (itemAppInfo in list) {
                val isDefault = defaultList.containsKey(itemAppInfo.pkgName)
                appInfoList.add(
                    mutableMapOf(
                        Pair("type", itemAppInfo.type),
                        Pair("iconFilePath", itemAppInfo.mIconFilePath),
                        Pair("appName", itemAppInfo.appName),
                        Pair("pkgName", itemAppInfo.pkgName),
                        Pair("isDefault",isDefault)
                    )
                )
            }
        }
        return appInfoList
    }

    /**
     * 读取默认的应用信息
     */
    private fun readDefaultAppList(): List<Map<Any, Any?>> {
        val appInfoList = mutableListOf<MutableMap<Any, Any>>()
        val list = NoticeAppUtility.getDefaultApp().values
        if (list.isNotEmpty()) {
            for (itemAppInfo in list) {
                appInfoList.add(
                    mutableMapOf(
                        Pair("type", itemAppInfo.type),
                        Pair("iconFilePath", itemAppInfo.mIconFilePath),
                        Pair("appName", itemAppInfo.appName),
                        Pair("pkgName", itemAppInfo.pkgName),
                        Pair("isDefault",true)
                    )
                )
            }
        }
        return appInfoList
    }

    /**
     * 根据事件类型获取APP信息
     */
    private fun readOneAppInfo(type: Int): Map<Any, Any?>? {
        val appInfo = mutableMapOf<Any, Any>()
        val list = NoticeAppUtility.getInstalledAppList()
        val defaultList = NoticeAppUtility.getDefaultApp()
        if (list.isNotEmpty()) {
            for (itemAppInfo in list) {
                if (itemAppInfo.type == type) {
                    val isDefault = defaultList.containsKey(itemAppInfo.pkgName)
                    appInfo["type"] = itemAppInfo.type
                    appInfo["iconFilePath"] = itemAppInfo.mIconFilePath
                    appInfo["appName"] = itemAppInfo.appName
                    appInfo["pkgName"] = itemAppInfo.pkgName
                    appInfo["isDefault"] = isDefault
                }
            }
        }
        return appInfo
    }

    /**
     * 判断是否默认app
     */
    private fun  isDefaultApp(name: String): Boolean {
        val list = NoticeAppUtility.getDefaultApp().values
        if (list.isNotEmpty()) {
            for (itemAppInfo in list) {
                if (itemAppInfo.pkgName == name) {
                    return true
                }
            }
        }
        return false
    }

}