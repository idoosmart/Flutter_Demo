import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../../../protocol_lib.dart';
import '../../private/logger/logger.dart';
import '../../private/local_storage/local_storage.dart';
import '../extension/datatime_ext.dart';
import '../model/device_ota_info.dart';

part 'private/epo_manager_impl.dart';
part 'private/epo_listener.dart';
part 'private/epo_enum.dart';
part 'private/status_model.dart';
part 'private/epo_download.dart';

abstract class IDOEPOManager {
  factory IDOEPOManager() => _IDOEPOManager();

  /// 启用自动epo升级，默认为 关
  ///
  /// ```dart
  /// 触发条件：
  /// 1、每次快速配置完成后倒计时1分钟；
  /// 2、数据同步完成后立即执行；
  /// ```
  bool get enableAutoUpgrade;
  set enableAutoUpgrade(bool value);

  /// 当前升级状态
  EpoUpgradeStatus get status;

  /// 是否支持epo升级
  bool get isSupported;

  /// app提供当前手机gps信息，用于设备快速定位
  IDOEPOManagerDelegate? delegateGetGps;

  /// 获取最后一次更新的时间戳，单位：毫秒
  ///
  /// 无记录则返回0
  Future<int> lastUpdateTimestamp();

  /// 是否需要更新
  Future<bool> shouldUpdateForEPO({bool isForce = false});

  /// 启动升级任务
  ///
  /// ```dart
  /// isForce 是否强制更新
  /// retryCount 重试次数，默认3次
  /// ```
  void willStartInstall({bool isForce = false, int retryCount = 3});

  /// 停止升级任务
  ///
  /// 注：只支持下载中和发送中的任务，不支持正在升级的任务
  void stop();

  /// 监听epo升级回调
  ///
  /// ```dart
  /// funcStatus 升级状态
  /// downProgress 下载进度
  /// sendProgress 发送进度
  /// funcComplete 升级完成
  /// ```
  StreamSubscription listenEPOStatusChanged(
      void Function(EpoUpgradeStatus status) funcStatus,
      void Function(double progress)? downProgress,
      void Function(double progress)? sendProgress,
      void Function(int errorCode) funcComplete);
}


abstract class IDOEPOManagerDelegate {

  /// 提供当前手机gps信息用于加快设备定位（仅限支持的设备）
  ///
  /// ```dart
  /// latitude 纬度
  /// longitude 经度
  /// altitude 高度
  /// ```
  Future<OTAGpsInfo?> getAppGpsInfo();

}

/// EPO升级状态
enum EpoUpgradeStatus {
  /// 空闲
  idle,
  /// 准备更新
  ready,
  /// 下载中
  downing,
  /// 制作中
  making,
  /// 发送中
  sending,
  /// 安装中
  installing,
  /// 成功
  success,
  /// 失败
  failure,
}