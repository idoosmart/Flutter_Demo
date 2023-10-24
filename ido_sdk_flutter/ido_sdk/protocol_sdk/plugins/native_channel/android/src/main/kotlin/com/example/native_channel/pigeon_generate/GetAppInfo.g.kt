// Autogenerated from Pigeon (v10.1.6), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package com.example.native_channel.api_get_app_info

import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  if (exception is FlutterError) {
    return listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    return listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()

/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface ApiGetAppInfo {
  /**
   * 读取所有安装的APP信息
   * Map => {type: $type, iconFilePath: $iconFilePath, appName: $appName, pkgName: $pkgName}
   * 邮件、未接电话、日历、短信 （名称使用默认英语）
   */
  fun readInstallAppInfoList(force: Boolean, callback: (Result<List<Map<Any, Any?>>>) -> Unit)
  /**
   * 读取默认的APP信息
   * Map => {type: $type, iconFilePath: $iconFilePath, appName: $appName, pkgName: $pkgName}
   */
  fun readDefaultAppList(callback: (Result<List<Map<Any, Any?>>>) -> Unit)
  /**
   * 根据事件类型获取当前APP信息
   * Map => {type: $type, iconFilePath: $iconFilePath, appName: $appName, pkgName: $pkgName}
   * 邮件、未接电话、日历、短信 （名称使用默认英语）
   */
  fun readCurrentAppInfo(type: Long, callback: (Result<Map<Any, Any?>?>) -> Unit)
  /** 事件号获取包名 */
  fun convertEventType2PackageName(type: Long, callback: (Result<String?>) -> Unit)
  /** 包名获取事件号 */
  fun convertEventTypeByPackageName(name: String, callback: (Result<Long>) -> Unit)
  /** 判断是否为默认app */
  fun isDefaultApp(packageName: String, callback: (Result<Boolean>) -> Unit)

  companion object {
    /** The codec used by ApiGetAppInfo. */
    val codec: MessageCodec<Any?> by lazy {
      StandardMessageCodec()
    }
    /** Sets up an instance of `ApiGetAppInfo` to handle messages through the `binaryMessenger`. */
    @Suppress("UNCHECKED_CAST")
    fun setUp(binaryMessenger: BinaryMessenger, api: ApiGetAppInfo?) {
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.native_channel.ApiGetAppInfo.readInstallAppInfoList", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val forceArg = args[0] as Boolean
            api.readInstallAppInfoList(forceArg) { result: Result<List<Map<Any, Any?>>> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.native_channel.ApiGetAppInfo.readDefaultAppList", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            api.readDefaultAppList() { result: Result<List<Map<Any, Any?>>> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.native_channel.ApiGetAppInfo.readCurrentAppInfo", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val typeArg = args[0].let { if (it is Int) it.toLong() else it as Long }
            api.readCurrentAppInfo(typeArg) { result: Result<Map<Any, Any?>?> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.native_channel.ApiGetAppInfo.convertEventType2PackageName", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val typeArg = args[0].let { if (it is Int) it.toLong() else it as Long }
            api.convertEventType2PackageName(typeArg) { result: Result<String?> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.native_channel.ApiGetAppInfo.convertEventTypeByPackageName", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val nameArg = args[0] as String
            api.convertEventTypeByPackageName(nameArg) { result: Result<Long> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.native_channel.ApiGetAppInfo.isDefaultApp", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val packageNameArg = args[0] as String
            api.isDefaultApp(packageNameArg) { result: Result<Boolean> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}
