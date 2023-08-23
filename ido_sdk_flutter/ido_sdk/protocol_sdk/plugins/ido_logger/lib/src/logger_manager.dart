import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import 'file_output.dart' as f;
import 'custom_printer.dart';
import 'logger_config.dart';

class LoggerManager {
  final LoggerConfig config;
  Logger? _logger;

  static final Map<LoggerModule, LoggerManager> _cache =
      <LoggerModule, LoggerManager>{};

  factory LoggerManager.f({required LoggerConfig config}) {
    var t = _cache[config.module];
    if (t == null) {
      t = LoggerManager(config: config);
    }
    return t;
  }

  LoggerManager({
    required this.config,
  }) {
    if (config.dirPath.isEmpty) {
      throw UnsupportedError('dirPath is empty');
    }

    if (config.isEnable && config.dirPath.isNotEmpty || !kDebugMode) {
      final listOutput = <LogOutput>[];

      if (config.outputToConsole && kDebugMode) {
        listOutput.add(ConsoleOutput());
      }

      if (config.writeToFile || !kDebugMode) {
        final file = _getFile(); //File('${config.dirPath}/${_fileName()}');
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
              noBoxingByDefault: config.noBoxingByDefault,
              isDebug: kDebugMode),
          output: MultiOutput(listOutput),
          level: config.level.cast());
      wtf('config.level:${config.level}');
    }
  }

  v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger?.v(message, error, stackTrace);
  }

  d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger?.d(message, error, stackTrace);
  }

  i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger?.i(message, error, stackTrace);
  }

  w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger?.w(message, error, stackTrace);
  }

  e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger?.e(message, error, stackTrace);
  }

  wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger?.wtf(message, error, stackTrace);
  }
}

// 处理日志文件滚动管理
extension _LoggerManagerExt on LoggerManager {
  String _fileName() {
    final date = DateTime.now();
    final hm =
        '${date.hour.toString().padLeft(2, '0')}${date.minute.toString().padLeft(2, '0')}';
    final name = '${date.year}-${date.month}-${date.day}_$hm.log';
    return name;
  }

  /// 获取需要的文件
  File _getFile() {
    final dir = Directory(config.dirPath);
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
        return File('${config.dirPath}/${_fileName()}');
      }

      //print('按时间降序前：\n${list.map((e) => e.path).toList()}');
      // 按文件修改时间降序
      list.sort((a, b) {
        final aStat = a.statSync();
        final bStat = b.statSync();
        return bStat.modified.millisecondsSinceEpoch -
            aStat.modified.millisecondsSinceEpoch;
      });
      //print('按时间降序后：\n${list.map((e) => e.path).toList()}');
      // 控制文件数量
      if (fileCount > config.maximumNumberOfLogFiles) {
        final start = fileCount - config.maximumNumberOfLogFiles + 1;
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
      if (list.first.statSync().size < config.maximumFileSize) {
        return File(list.first.path);
      }

      // 返回新文件
      return File('${config.dirPath}/${_fileName()}');
    } catch (e) {
      // 返回新文件
      return File('${config.dirPath}/${_fileName()}');
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
