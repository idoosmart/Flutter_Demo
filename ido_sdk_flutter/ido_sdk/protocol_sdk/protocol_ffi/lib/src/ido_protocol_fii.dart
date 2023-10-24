import 'dart:ffi' as ffi;

import 'package:ido_logger/ido_logger.dart';
import 'package:protocol_ffi/protocol_ffi.dart';
import 'dart:io';

import 'ffi/ido_timer_ffi.dart';
import 'logger/logger.dart';

export 'module/callback/define_callback.dart';
export 'module/callback/register_callback.dart';
export 'module/base_func.dart';
export 'module/file_operation.dart';
export 'module/activity_settings.dart';
export 'module/sync_health.dart';
export 'module/sync_activity.dart';
export 'module/sync_other.dart';
export 'module/timer_init.dart';
export 'module/trans_data.dart';
export 'module/flash_log.dart';
export 'module/alexa.dart';

/// 封装c库接口调用
class IDOProtocolAPI {
  late final IDOProtocolFfiBindings _bindings;
  // static bool _writeToFile = false;
  // static bool _outputToConsole = false;
  // static String _pathSDK = '';
  // bool isInitLog = false;

  // 单例
  IDOProtocolAPI._internal() {
    _loadDynamicLibrary();
  }
  static final _instance = IDOProtocolAPI._internal();
  factory IDOProtocolAPI() => _instance;

  // 加载C库
  _loadDynamicLibrary() {
    const String libName = 'protocol_c';

    /// The dynamic library in which the symbols for [ProtocolFfiBindings] can be found.
    final ffi.DynamicLibrary dylib = () {
      if (Platform.isMacOS || Platform.isIOS) {
        return ffi.DynamicLibrary.open('$libName.framework/$libName');
      }
      if (Platform.isAndroid || Platform.isLinux) {
        return ffi.DynamicLibrary.open('lib$libName.so');
      }
      if (Platform.isWindows) {
        return ffi.DynamicLibrary.open('$libName.dll');
      }
      throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
    }();

    /// The bindings to the native functions in [_dylib].
    _bindings = IDOProtocolFfiBindings(dylib);
  }

  IDOProtocolFfiBindings get bindings => _bindings;

  Future<void> initLogs({bool outputToConsoleClib = false}) async {
    final log = LoggerSingle();
    assert(log.config != null, 'You need to call LoggerSingle.configLogger(...)');
    if (log.config != null) {
      final config = log.config!;
      final dirClibLog = Directory('${config.dirPath}/../protocol_c/');
      await dirClibLog.create(recursive: true);
      // 配置c库log
      enableLog(
          isPrintConsole: outputToConsoleClib,
          isWriteFile: config.writeToFile,
          filePath: dirClibLog.path);
      logger = log;
    }
  }

  // _initLogs() async {
  //   if ((_writeToFile || _outputToConsole) &&
  //       _pathSDK.isNotEmpty &&
  //       !isInitLog) {
  //     final dirClibLog = Directory('$_pathSDK/../protocol_c/');
  //     await dirClibLog.create(recursive: true);
  //     // 配置c库log
  //     enableLog(
  //         isPrintConsole: _outputToConsole,
  //         isWriteFile: _writeToFile,
  //         filePath: dirClibLog.path);
  //     isInitLog = true;
  //   }
  // }
  //
  // /// 注入logger实例（日志合并）
  // static void setLogger(LoggerManager? aLogger) {
  //   if (aLogger != null) {
  //     final config = aLogger.config;
  //     IDOProtocolAPI._pathSDK = config.dirPath;
  //     IDOProtocolAPI._writeToFile = config.writeToFile;
  //     IDOProtocolAPI._outputToConsole = config.outputToConsole;
  //     IDOProtocolAPI()._initLogs();
  //   }
  //   logger = aLogger;
  // }
}
