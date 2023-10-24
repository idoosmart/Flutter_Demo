package com.example.native_channel

import androidx.annotation.NonNull
import com.example.native_channel.api_get_app_info.ApiGetAppInfo
import com.example.native_channel.api_get_file_info.ApiGetFileInfo
import io.flutter.embedding.engine.plugins.FlutterPlugin

/** NativeChannelPlugin */
class NativeChannelPlugin: FlutterPlugin {

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
     ApiGetAppInfo.setUp(flutterPluginBinding.binaryMessenger,GetAppInfoImpl.instance(flutterPluginBinding))
     ApiGetFileInfo.setUp(flutterPluginBinding.binaryMessenger,GetFileInfoImpl.instance())
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {

  }
}
