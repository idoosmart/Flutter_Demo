import 'package:native_channel/pigeon_generate/get_tools.g.dart';
import 'dart:async';

abstract class ToolsImpl {
  factory ToolsImpl() => _ToolsImpl();

  /// 获取appName， 返回形如："VeryFit"
  Future<String> getAppName();

  /// 获取当前时区， 返回形如："Asia/Shanghai"
  Future<String> getCurrentTimeZone();

  /// 获取Document目录路径, 返回形如：/xx/.../
  Future<String?> getDocumentPath();

  /// 获取Native日志， 返回形如："2021-06-01 10:00:00.000000000 +0800"
  Stream<String> listenNativeLog();

  /// 获取平台设备信息, 返回：
  /// ```dart
  /// {
  ///   "model": "String",          手机型号
  ///   "systemVersion": "String",  系统版本
  ///   "isJailbroken": false       是否越狱
  /// }
  /// ```
  Future<Map?> getPlatformDeviceInfo();
}

class _ToolsImpl extends ToolsDelegate implements ToolsImpl {
  late final tools = ApiTools();
  late final _streamLog = StreamController<String>.broadcast();

  static _ToolsImpl? _instance;
  factory _ToolsImpl() => _instance ??= _ToolsImpl._internal();
  _ToolsImpl._internal() {
    ToolsDelegate.setup(this);
  }

  @override
  Future<String> getAppName() async {
    return tools.getAppName();
  }

  @override
  Future<String> getCurrentTimeZone() async {
    return tools.getCurrentTimeZone();
  }

  @override
  Future<String?> getDocumentPath() {
    return tools.getDocumentPath();
  }

  @override
  void getNativeLog(String msg) {
    _streamLog.add(msg);
  }

  @override
  Stream<String> listenNativeLog() {
    return _streamLog.stream;
  }

  @override
  Future<Map?> getPlatformDeviceInfo() {
    return tools.getPlatformDeviceInfo();
  }
}
