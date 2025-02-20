import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:protocol_lib/src/private/isolate/isolate_manager.dart';
import 'package:protocol_lib/src/private/local_storage/ido_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ido_logger/ido_logger.dart';
import 'package:protocol_core/protocol_core.dart';

import '../protocol_lib.dart';
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
    await IDOKvEngine.init();
    return await _IDOProtocolLibManager.doInitClib();
  }

  /// 标记设备已连接 （蓝牙连接时调用）
  ///
  /// ```dart
  /// uniqueId 安卓（当前连接设备的mac地址），iOS（当前连接设备的mac地址或uuid)
  /// otaMode 设置ota模式
  /// isBinded 绑定状态
  /// deviceName 设备名称
  /// iosUUID ios时，需要提供uuid， android该值忽略
  /// ```
  Future<bool> markConnectedDeviceSafe(
      {required String uniqueId,
      required IDOOtaType otaType,
      required bool isBinded,
      String? deviceName = '',
      String? iosUUID});

  /// 标记设备已断开（蓝牙断开时调用）
  Future<bool> markDisconnectedDevice({String? macAddress, String? uuid});

  /// 标记为OTA模式
  /// ```dart
  /// macAddress
  /// iosUUID ios时，需要提供uuid， android该值忽略
  /// platform 设备平台 0:nordic, 10:realtek 8762x, 20:cypress psoc6,
  ///          30:Apollo3, 40:汇顶, 50:nordic+泰凌微,
  ///          60:泰凌微+5340+no nand flash, 70:汇顶+富瑞坤,
  ///          80:5340, 90: 炬芯, 97: 恒玄, 98: 思澈1,
  ///          99: 思澈2 （注意：目前只支持98、99）
  /// deviceId 设备id
  /// ```
  Future<bool> markSiceOtaMode({
    required String macAddress,
    required String iosUUID,
    required int platform,
    required int deviceId});

  /// 基础指令调用
  Stream<CmdResponse> send({required CmdEvtType evt, String? json = '{}',
    IDOCmdPriority priority = IDOCmdPriority.normal});

  /// 蓝牙响应数据总入口
  ///
  /// type 数据类型 0:ble 1:SPP
  void receiveDataFromBle(Uint8List data, String? macAddress, int type);

  /// 写数据到蓝牙设备
  void registerWriteDataToBle(void Function(CmdRequest data) func);

  /// 发送蓝牙数据完成
  void writeDataComplete();

  /// 发送SPP数据完成
  void writeSppDataComplete();

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

  /// 当前连接的设备MAC地址
  String? get macAddressFull;

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

  /// 获取sdk build号
  ///
  /// 形如：16进制时间戳
  String get getSdkBuildNum;

  /// 代理设置
  IDOProtocolLibDelegate? delegate;

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

  /// 连接状态变更（内部使用）
  StreamSubscription listenConnectStatusChanged(void Function(bool isConnected) func);

  /// 设置persimwear ota升级中（内部使用）
  void setPersimwearOtaUpgrading(bool upgrading);
}


/// 协议库代理
abstract class IDOProtocolLibDelegate {

  /// 获取用户ID, -1或null为游客，最大14字节（超过14字节会提取后14字节）
  String? getUserId();

}
