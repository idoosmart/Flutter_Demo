import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import 'file_output.dart' as f;
import 'custom_printer.dart';
import 'logger_config.dart';

final dLog = LoggerSingle();

class LoggerSingle {
  LoggerConfig? _config;
  Logger? _logger;

  static final _instance = LoggerSingle._internal();
  factory LoggerSingle() => _instance;

  static void configLogger({required LoggerConfig config}) {
    _instance._config = config;
    _instance._setup();
  }
  LoggerSingle._internal();

  /// 存放日志文件的目录绝对路径
  String? get dirPath => _config?.dirPath;
  LoggerConfig? get config => _config;

  v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _log?.v(message, error, stackTrace);
  }

  d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _log?.d(message, error, stackTrace);
  }

  i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _log?.i(message, error, stackTrace);
  }

  w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _log?.w(message, error, stackTrace);
  }

  e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _log?.e(message, error, stackTrace);
  }

  wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _log?.wtf(message, error, stackTrace);
  }
}

// 处理日志文件滚动管理
extension _LoggerSingleExt on LoggerSingle {

  Logger? get _log {
    assert(_logger != null, 'You need to call LoggerSingle.configLogger(...)');
    return _logger;
  }

  _setup() {
    if(_config == null) {
      throw FlutterError('_config is null');
    }

    if(_config!.dirPath.isEmpty) {
      throw FlutterError('dirPath is empty');
    }

    if (_config!.isEnable) {
      final listOutput = <LogOutput>[];

      if (_config!.outputToConsole) {
        listOutput.add(ConsoleOutput());
      }

      if (_config!.writeToFile) {
        final file = _getFileToday(); // _getFile();
        if (!file.existsSync()) {
          file.createSync(recursive: true);
        }
        listOutput.add(f.LogFileOutput(
            file: file, overrideExisting: false, encoding: utf8));
      }

      _logger = Logger(
          filter: kDebugMode ? DevelopmentFilter() : ProductionFilter(),
          printer: CustomPrinter(
              methodCount: 0,
              errorMethodCount: 8,
              lineLength: 120,
              colors: stdout.supportsAnsiEscapes,
              printEmojis: false,
              printTime: true,
              noBoxingByDefault: _config!.noBoxingByDefault,
              isDebug: kDebugMode),
          output: MultiOutput(listOutput),
          level: _config!.level.cast());
    }
  }

  String _fileName() {
    final date = DateTime.now();
    final hm =
        '${date.hour.toString().padLeft(2, '0')}${date.minute.toString().padLeft(2, '0')}';
    final name = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}_$hm.log';
    return name;
  }

  /// 获取需要的文件（按天分）
  File _getFileToday() {
    final dir = Directory(_config!.dirPath);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    final date = DateTime.now();
    final fileName = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}.log';

    try {
      final list = dir
          .listSync(recursive: false, followLinks: false)
          .where((e) => e.path.endsWith('.log'))
          .toList();

      // 删除历史数据yyyy-MM-dd_HHmm.log
      list.removeWhere((e) => e.uri.pathSegments.last.length > "yyyy-MM-dd.log".length);

      final fileCount = list.length;
      if (list.length < _config!.maximumNumberOfLogFiles) {
        return File('${_config!.dirPath}/$fileName');
      }
      //print('按文件名降序前：\n${list.map((e) => e.uri.pathSegments.last).toList()}');
      list.sort((a, b) {
        return b.uri.pathSegments.last.compareTo(a.uri.pathSegments.last); // 按文件名降序
      });
      //print('按文件名降序后：\n${list.map((e) => e.uri.pathSegments.last).toList()}');
      // 控制文件数量
      if (fileCount > _config!.maximumNumberOfLogFiles) {
        final start = fileCount - _config!.maximumNumberOfLogFiles + 1;
        final end = fileCount;
        // 删除对应文件
        list.getRange(start, end).forEach((e) {
          //print('删除: ${e.path}');
          File(e.path).deleteSync();
        });
        list.removeRange(start, end);
        //print('删除后：\n${list.map((e) => e.path).toList()}');
      }
      // 返回新文件
      return File('${_config!.dirPath}/$fileName');
    } catch (e) {
      // 返回新文件
      return File('${_config!.dirPath}/$fileName');
    }
  }

  /// 获取需要的文件（按文件大小分）
  File _getFile() {
    final dir = Directory(_config!.dirPath);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    try {
      final list = dir
          .listSync(recursive: false, followLinks: false)
          .where((e) => e.path.endsWith('.log'))
          .toList();
      final fileCount = list.length;
      if (list.isEmpty) {
        return File('${_config!.dirPath}/${_fileName()}');
      }

      // print('按文件名降序前：\n${list.map((e) => e.uri.pathSegments.last).toList()}');
      list.sort((a, b) {
        return b.uri.pathSegments.last.compareTo(a.uri.pathSegments.last); // 按文件名降序
      });
      // print('按文件名降序后：\n${list.map((e) => e.uri.pathSegments.last).toList()}');
      // 控制文件数量
      if (fileCount > _config!.maximumNumberOfLogFiles) {
        final start = fileCount - _config!.maximumNumberOfLogFiles + 1;
        final end = fileCount;
        // 删除对应文件
        list.getRange(start, end).forEach((e) {
          //print('删除: ${e.path}');
          File(e.path).deleteSync();
        });
        list.removeRange(start, end);
        //print('删除后：\n${list.map((e) => e.path).toList()}');
      }

      // 未超出单个文件大小，返回该文件
      if (list.first.statSync().size < _config!.maximumFileSize) {
        return File(list.first.path);
      }

      // 返回新文件
      return File('${_config!.dirPath}/${_fileName()}');
    } catch (e) {
      // 返回新文件
      return File('${_config!.dirPath}/${_fileName()}');
    }
  }
}

extension _LoggerLevelMapping on LoggerLevel {
  Level cast() {
    switch (this) {
      case LoggerLevel.verbose:
        return Level.verbose;
      case LoggerLevel.debug:
        return Level.debug;
      case LoggerLevel.info:
        return Level.info;
      case LoggerLevel.warning:
        return Level.warning;
      case LoggerLevel.error:
        return Level.error;
      case LoggerLevel.wtf:
        return Level.wtf;
      case LoggerLevel.nothing:
        return Level.nothing;
    }
  }
}
