import 'dart:io';

import 'package:ido_logger/ido_logger.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'package:native_channel/native_channel.dart';

// LoggerManager? logger;
LoggerSingle? _logger;
LoggerSingle? get logger => _logger;
set logger(LoggerSingle? logger) {
  if (logger != _logger) {
    _logger = logger;
    ToolsImpl().getPlatformDeviceInfo().then((aMap) {
      logger?.v("sdk info - clib: ${libManager.getClibVersion} sdk: ${libManager
          .getSdkVersion}(${libManager.getSdkBuildNum}) os: ${Platform.isIOS ? "iOS" : "Android"}");
      if (aMap != null) {
        logger?.v(
            "phone info - model: ${aMap["model"]}, systemVersion: ${aMap["systemVersion"]}, isJailbroken: ${aMap["isJailbroken"]}");
      }
    });
    ToolsImpl().getAppName().then((appName) {
      logger?.v("app name: $appName");
    });
  }

}
