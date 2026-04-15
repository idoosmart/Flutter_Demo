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

  /// 生成自定义表盘文件，数据采用大端模式 （杰里平台）
  ///
  /// [dialFilePath] 表盘文件保存路径
  /// [bgPath] 背景图片路径
  /// [previewPath] 预览图图片路径，覆盖在背景图上方，透明只带时间组件
  /// [color] 字体颜色
  /// [baseBinPath] 基础bin包文件路径
  Future<bool> makeJieLiDialFile(
      String dialFilePath,
      String bgPath,
      String previewPath,
      int color,
      String baseBinPath,
      );

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

  @override
  Future<bool> makeJieLiDialFile(String dialFilePath, String bgPath, String previewPath, int color, String baseBinPath) {
    return tools.makeJieLiDialFile(dialFilePath, bgPath, previewPath, color, baseBinPath);
  }
}
