import 'dart:async';
import 'dart:convert';

import 'package:protocol_core/protocol_core.dart';
import 'package:protocol_lib/src/private/logger/logger.dart';
import 'package:protocol_lib/src/private/notification/notification.dart';
import 'package:rxdart/rxdart.dart';

import '../../protocol_lib.dart';
import 'module/sync_calculate_progress.dart';
import 'module/sync_data_handle.dart';
import 'module/sync_fast_operation.dart';

part 'part/sync_data_impl.dart';

/// 状态
enum SyncStatus {
  init, ///初始化
  syncing, /// 同步中
  finished, /// 同步完成
  canceled, /// 同步取消
  stopped, /// 同步停止
  timeout, /// 同步超时
  error /// 同步错误
}

/// 同步数据类型
enum SyncDataType {
  /// 无类型
  nullType,
  /// 步数
  stepCount,
  /// 心率
  heartRate,
  /// 睡眠
  sleep,
  /// 血压
  bloodPressure,
  /// 血氧
  bloodOxygen,
  /// 压力
  pressure,
  /// 噪音
  noise,
  /// 皮温
  piven,
  /// 呼吸率
  respirationRate,
  /// 身体电量
  bodyPower,
  /// HRV
  HRV,
  /// 多运动
  activity,
  /// GPS
  GPS,
  /// 游泳
  swim,
  /// v2 步数
  v2StepCount,
  /// V2 睡眠
  v2Sleep,
  /// V2 心率
  v2HeartRate,
  /// V2 血压
  v2BloodPressure,
  /// V2 GPS
  v2GPS,
  /// V2 多运动
  v2Activity
}

/// 同步整体进度 0-100
typedef CallbackSyncProgress = void Function(double progress);
/// 不同类型JSON数据同步回调
///
/// ```dart
///  0 Successful command
///  1 SVC handler is missing
///  2 SoftDevice has not been enabled
///  3 Internal Error
///  4 No Memory for operation
///  5 Not found
///  6 Not supported
///  7 Invalid Parameter
///  8 Invalid state, operation disallowed in this state
///  9 Invalid Length
///  10 Invalid Flags
///  11 Invalid Data
///  12 Invalid Data size
///  13 Operation timed out
///  14 Null Pointer
///  15 Forbidden Operation
///  16 Bad Memory Address
///  17 Busy
///  18 Maximum connection count exceeded.
///  19 Not enough resources for operation
///  20 Bt Bluetooth upgrade error
///  21 Not enough space for operation
///  22 Low Battery
///  23 Invalid File Name/Format
///  24 空间够但需要整理
///  25 空间整理中
///
///  当指令发出前异常时:
/// -1 取消
/// -2 失败
/// -3 指令已存在队列中
/// -4 设备断线
/// -5 ota模式
/// ```
typedef CallbackSyncData = void Function(SyncDataType type,String jsonStr,int errorCode);
/// 所有数据同步完成
///
/// ```dart
///  0 Successful command
///  1 SVC handler is missing
///  2 SoftDevice has not been enabled
///  3 Internal Error
///  4 No Memory for operation
///  5 Not found
///  6 Not supported
///  7 Invalid Parameter
///  8 Invalid state, operation disallowed in this state
///  9 Invalid Length
///  10 Invalid Flags
///  11 Invalid Data
///  12 Invalid Data size
///  13 Operation timed out
///  14 Null Pointer
///  15 Forbidden Operation
///  16 Bad Memory Address
///  17 Busy
///  18 Maximum connection count exceeded.
///  19 Not enough resources for operation
///  20 Bt Bluetooth upgrade error
///  21 Not enough space for operation
///  22 Low Battery
///  23 Invalid File Name/Format
///  24 空间够但需要整理
///  25 空间整理中
///
///  当指令发出前异常时:
/// -1 取消
/// -2 失败
/// -3 指令已存在队列中
/// -4 设备断线
/// -5 ota模式
/// ```
typedef CallbackSyncCompleted = void Function(int errorCode);

abstract class IDOSyncData {

  factory IDOSyncData() => _IDOSyncData();

  /// 同步状态
  SyncStatus get syncStatus;

  /// 开始同步所有数据
  Stream<bool> startSync({
    required CallbackSyncProgress funcProgress,
    required CallbackSyncData funcData,
    required CallbackSyncCompleted funcCompleted
  });

  /// 停止同步所有数据
  void stopSync();

}
