import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ido_logger/ido_logger.dart';
import 'package:protocol_core/protocol_core.dart';

import '../protocol_lib.dart';
import 'message_icon/ido_message_icon.dart';
import 'device_info/model/device_info_ext_model.dart';
import 'private/logger/logger.dart';
import 'private/local_storage/local_storage.dart';
import 'private/notification/notification.dart';
part 'private/protocol_lib_impl.dart';
part 'private/extension/event_type_ext.dart';

final libManager = IDOProtocolLibManager();

/// 协议库入口类
abstract class IDOProtocolLibManager {
  factory IDOProtocolLibManager() => _IDOProtocolLibManager();

  /// 注册协议库（需在使用libManager前注册）
  /// ```
  /// outputToConsole sdk log打印到控制台
  /// outputToConsoleClib c库log打印到控制台
  /// isReleaseClib c库运行模式(release只打印重要log)
  /// ```
  static Future<bool> register(
      {bool outputToConsole = false,
      bool outputToConsoleClib = false,
      bool isReleaseClib = true}) async {
    await _IDOProtocolLibManager.initLog(
        writeToFile: true,
        outputToConsole: outputToConsole,
        outputToConsoleClib: outputToConsoleClib,
        isReleaseClib: isReleaseClib,
        logLevel: LoggerLevel.verbose);
    return _IDOProtocolLibManager.doInitClib();
  }

  /// 标记设备已连接 （蓝牙连接时调用）
  ///
  /// ```dart
  /// uniqueId 安卓（当前连接设备的mac地址），iOS（当前连接设备的mac地址或uuid)
  /// otaMode 设置ota模式
  /// isBinded 绑定状态
  /// deviceName 设备名称
  /// ```
  Future<bool> markConnectedDeviceSafe(
      {required String uniqueId,
      required IDOOtaType otaType,
      required bool isBinded,
      String? deviceName = ''});

  /// 标记设备已断开（蓝牙断开时调用）
  Future<bool> markDisconnectedDevice({String? macAddress, String? uuid});

  /// 基础指令调用
  Stream<CmdResponse> send({required CmdEvtType evt, String? json = '{}'});

  /// 蓝牙响应数据总入口
  ///
  /// type 数据类型 0:ble 1:SPP
  void receiveDataFromBle(Uint8List data, String? macAddress, int type);

  /// 写数据到蓝牙设备
  void registerWriteDataToBle(void Function(CmdRequest data) func);

  /// 发送蓝牙数据完成
  void writeDataComplete();

  /// 清除所有待执行任务
  void dispose();

  /// 停止快速配置 (SDK内部使用)
  void stopSyncConfig();

  /// 已连接 (SDK内部使用）
  bool get isConnected;

  /// 连接中（切换设备会受限制）
  bool get isConnecting;

  /// 绑定中 (切换设备会受到限制）
  bool get isBinding;

  /// 执行快速配置 (执行快速配置期间，外部指令将直接返回失败）
  bool get isFastSynchronizing;

  /// ota类型
  IDOOtaType get otaType;

  /// 当前连接的设备MAC地址
  /// 注意：未标记为已连接时，将固定返回"UNKNOWN"
  ///
  String get macAddress;

  /// 功能表
  IDOFunctionTable get funTable;

  /// 文件传输
  IDOFileTransfer get transFile;

  /// 数据同步
  IDOSyncData get syncData;

  /// 设备信息
  IDODeviceInfo get deviceInfo;

  /// 设备绑定
  IDODeviceBind get deviceBind;

  /// 更新消息图标及名称
  IDOMessageIcon get messageIcon;

  /// 运动数据交换
  IDOExchangeData get exchangeData;

  /// 设备日志
  IDODeviceLog get deviceLog;

  /// c库工具
  IDOTool get tools;

  /// 来电提醒、消息提醒
  IDOCallNotice get callNotice;

  /// 缓存
  IDOCache get cache;

  /// 获取C库版本信息
  ///
  /// release_string clib版本号 三位表示release版本 四位表是develop版本
  String get getClibVersion;

  /// 获取sdk版本信息
  ///
  /// 形如：1.0.0
  String get getSdkVersion;

  /// 监听状态通知（SDK)
  ///
  /// Example:
  /// ```dart
  /// final ss = libManager.listenStatusNotification((status) {
  ///    ...
  /// });
  /// ss.cancel(); 注：不使用时，需要取消监听
  /// ```
  StreamSubscription listenStatusNotification(
      void Function(IDOStatusNotification status) func);

  /// 监听设备主动通知/控制事件 (设备)
  StreamSubscription listenDeviceNotification(
      void Function(IDODeviceNotificationModel model) func);

  /// 关联alexa（内部使用）
  AlexaOperator joinAlexa(AlexaDelegate delegate);
}
