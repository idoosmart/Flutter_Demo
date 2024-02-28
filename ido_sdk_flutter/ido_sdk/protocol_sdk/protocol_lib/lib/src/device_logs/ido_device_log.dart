import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:protocol_core/protocol_core.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'package:protocol_lib/src/private/logger/logger.dart';
import 'package:rxdart/rxdart.dart';

import '../ido_protocol_lib.dart';
import '../private/local_storage/local_storage.dart';

part 'part/device_log_impl.dart';

/// 日志类型
/// 1: 旧的重启日志 2: 通用日志 3: 复位日志
/// 4: 硬件日志 5: 算法日志 6: 新重启日志 7:电池日志 8: 过热日志
enum IDOLogType {
  init,
  reboot,
  general,
  reset,
  hardware,
  algorithm,
  restart,
  battery,
  heat
}

/// 日志进度 0 ~ 100
typedef DeviceLogProgressCallback = void Function(int progress);

abstract class IDODeviceLog {
  factory IDODeviceLog() => _IDODeviceLog();

  /// 判断是否获取日志中
  bool get getLogIng;

  /// 监听获取日志状态
  Stream<bool> listenLogIng();

  /// 获取所有日志目录地址，每个日志目录下存放以时间戳命名的文件
  /// flash 日志目录 =>  Flash
  /// 电池日志目录 => Battery
  /// 过热日志目录 => Heat
  /// 旧的重启日志目录 => Reboot
  Future<String> get logDirPath;

  /// 监听日志存放目录地址
  Stream<String> listenLogDirPath();

  /// 开始获取日志
  /// types 日志类型
  /// timeOut 最大获取日志时长 (单位秒，默认60秒)
  Stream<bool> startGet(
      {required List<IDOLogType> types,
      int timeOut = 60,
        DeviceLogProgressCallback? progressCallback});

  /// 取消
  void cancel();
}
