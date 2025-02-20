import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:archive/archive_io.dart';
import 'logger_config.dart';
import 'logger_manager.dart';

const String fileName = "bluetooth_log";
class IDOBluetoothLogger {
  static final IDOBluetoothLogger _instance = IDOBluetoothLogger._();
  factory IDOBluetoothLogger() => _instance;
  IDOBluetoothLogger._();
  late LoggerManager logger;
  late LoggerManager loggerNative;
  String? loggerPath;

  register({bool outputToConsole = false, required String? logDir}) async {
    if (logDir != null) {
      loggerPath = '$logDir/$fileName';
      logger = LoggerManager(config: await flutterConfig(outputToConsole: outputToConsole));
      loggerNative = LoggerManager(config: await nativeConfig(outputToConsole: outputToConsole));
    }else {
      throw ErrorDescription("logDir is null");
    }
  }

  writeLog(Map event) {
    int platform = event['platform']; //1 ios  2 android 3 flutter;
    //String className = event['className'];
    String method = event['method'];
    String detail = event['detail'];
    //final str = '[$className-$method]   >>>   $detail';
    final str = '[$method] >>> $detail';
    if (platform == 1 || platform == 2) {
      loggerNative.i(str);
    }else if (platform == 3) {
      logger.i(str);
    }
  }

  Future<LoggerConfig> flutterConfig({bool outputToConsole = false}) async {
    final path = '$loggerPath/bluetooth_logs/flutter';
    return LoggerConfig(
        dirPath: path,
        writeToFile: true,
        outputToConsole: outputToConsole);
  }

  Future<LoggerConfig> nativeConfig({bool outputToConsole = false}) async {
    String native = 'ios';
    if (Platform.isAndroid) {
      native = 'android';
    }
    final path = '$loggerPath/bluetooth_logs/$native';
    return LoggerConfig(
        dirPath: path,
        writeToFile: true,
        outputToConsole: outputToConsole);
  }

  /// 导出数据库 返回压缩后日志zip文件绝对路径
  static Future<String?> exportDbPath() async {
    if (IDOBluetoothLogger().loggerPath == null) {
      return null;
    }
    return await compute(_doZip, IDOBluetoothLogger().loggerPath!);
  }

  static Future<String?> _doZip(String path) async {
    try {
      final logPath = '$path/bluetooth_logs';
      final dir = Directory(logPath);
      if (await dir.exists()) {
        final zipPath = '$path/$fileName.zip';
        final zipFile = File(zipPath);
        if (await zipFile.exists()) {
          await File(zipPath).delete();
        }
        zipFile.createSync();
        final encoder = ZipFileEncoder();
        encoder.create(zipPath);
        encoder.addDirectory(dir);
        encoder.close();
        return zipFile.existsSync() ? zipPath : null;
      }
      return null;
    } catch (e) {
      IDOBluetoothLogger().logger.i(e.toString());
      return null;
    }
  }
}
