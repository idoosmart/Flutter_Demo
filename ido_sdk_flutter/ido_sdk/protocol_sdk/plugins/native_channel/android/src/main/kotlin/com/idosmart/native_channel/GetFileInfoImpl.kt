package com.idosmart.native_channel

import com.idosmart.native_channel.pigeon_generate.api_get_file_info.ApiGetFileInfo
import java.io.File

class GetFileInfoImpl: ApiGetFileInfo {

    companion object {
        @Volatile
        private var instance: GetFileInfoImpl? = null
        fun instance(): GetFileInfoImpl {
            return instance ?: synchronized(this) {
                instance ?: GetFileInfoImpl().also { instance = it }
            }
        }
    }

    override fun readFileInfo(path: String, callback: (Result<Map<Any, Any?>?>) -> Unit) {
//        println("readFileInfo === $path")
       val file = File(path)
        if (file.exists() && file.isFile) {
            val map = GetFileInfoTool.getFileAttributes(path)
            NativeChannelPlugin.instance().androidLog("android get file info == $map")
            callback(Result.success(map) as Result<Map<Any, Any?>?>)
        }else {
            callback(Result.success(mutableMapOf(
                Pair("createSeconds", 0),
                Pair("changeSeconds", 0)
            )))
        }
    }

}