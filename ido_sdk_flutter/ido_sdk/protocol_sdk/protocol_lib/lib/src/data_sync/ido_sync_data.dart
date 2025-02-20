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
/// -4 执行快速配置中，指令忽略
/// -5 设备处于ota模式
/// -6 未连接设备
/// -7 执行中的指令被中断(由于发出的指令不能被实际取消，故存在修改指令被中断后可能还会导致设备修改生效的情况)
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
/// -4 执行快速配置中，指令忽略
/// -5 设备处于ota模式
/// -6 未连接设备
/// -7 执行中的指令被中断(由于发出的指令不能被实际取消，故存在修改指令被中断后可能还会导致设备修改生效的情况)
/// ```
typedef CallbackSyncCompleted = void Function(int errorCode);

abstract class IDOSyncData {

  factory IDOSyncData() => _IDOSyncData();

  /// 同步状态
  SyncStatus get syncStatus;

  /// 监听同步状态
  Stream<SyncStatus> listenSyncStatus();

  /// 开始同步数据
  ///
  /// 注：不指定types时同步所有数据
  Stream<bool> startSync({
    List<SyncDataType>? types,
    required CallbackSyncProgress funcProgress,
    required CallbackSyncData funcData,
    required CallbackSyncCompleted funcCompleted
  });

  /// 停止同步所有数据
  void stopSync();

  /// 获取支持的同步数据类型
  List<SyncDataType> getSupportSyncDataTypeList();

}

/// SyncDataType映射到单项数据同步类型
extension SyncDataTypeExt on List<SyncDataType> {
  /// 1 同步血氧
  /// 2 同步压力
  /// 3 同步心率(v3)
  /// 4 同步多运动数据(v3)
  /// 5 同步GPS数据(v3)
  /// 6 同步游泳数据
  /// 7 同步眼动睡眠数据
  /// 8 同步运动数据
  /// 9 同步噪音数据
  /// 10 同步温度数据
  /// 12 同步血压数据
  /// 14 同步呼吸频率数据
  /// 15 同步身体电量数据
  /// 16 同步HRV(心率变异性水平)数据
  List<int> get mappingValues {
    final list = <int>[];
    for (var element in this) {
      switch (element) {
        case SyncDataType.nullType:
          break;
        case SyncDataType.stepCount:
          list.add(8); // 8 同步运动数据
          break;
        case SyncDataType.heartRate:
          list.add(3); // 3 同步心率(v3)
          break;
        case SyncDataType.sleep:
          list.add(7); // 7 同步眼动睡眠数据
          break;
        case SyncDataType.bloodPressure:
          list.add(12); // 12 同步血压数据
          break;
        case SyncDataType.bloodOxygen:
          list.add(1); // 1 同步血氧
          break;
        case SyncDataType.pressure:
          list.add(2); // 2 同步压力
          break;
        case SyncDataType.noise:
          list.add(9); // 9 同步噪音数据
          break;
        case SyncDataType.piven:
          list.add(10); // 10 同步温度数据
          break;
        case SyncDataType.respirationRate:
          list.add(14); // 14 同步呼吸频率数据
          break;
        case SyncDataType.bodyPower:
          list.add(15); // 15 同步身体电量数据
          break;
        case SyncDataType.HRV:
          list.add(16); // 16 同步HRV(心率变异性水平)数据
          break;
        case SyncDataType.activity:
          list.add(4); // 4 同步多运动数据(v3)
          break;
        case SyncDataType.GPS:
          list.add(5); // 5 同步GPS数据(v3)
          break;
        case SyncDataType.swim:
          list.add(6); // 6 同步游泳数据
          break;
        case SyncDataType.v2StepCount:
          break;
        case SyncDataType.v2Sleep:
          break;
        case SyncDataType.v2HeartRate:
          break;
        case SyncDataType.v2BloodPressure:
          break;
        case SyncDataType.v2GPS:
          break;
        case SyncDataType.v2Activity:
          break;
      }
    }
    return list;
  }
}

/// 单项数据同步类型映射到SyncDataType
extension IntToSyncDataTypeExt on List<int> {
  /// 1 同步血氧
  /// 2 同步压力
  /// 3 同步心率(v3)
  /// 4 同步多运动数据(v3)
  /// 5 同步GPS数据(v3)
  /// 6 同步游泳数据
  /// 7 同步眼动睡眠数据
  /// 8 同步运动数据
  /// 9 同步噪音数据
  /// 10 同步温度数据
  /// 12 同步血压数据
  /// 14 同步呼吸频率数据
  /// 15 同步身体电量数据
  /// 16 同步HRV(心率变异性水平)数据
  List<SyncDataType> get mappingValues {
    final list = <SyncDataType>[];
    for (var e in this) {
      switch (e) {
        case 8:
          list.add(SyncDataType.stepCount); // 8 同步运动数据
          break;
        case 3:
          list.add(SyncDataType.heartRate); // 3 同步心率(v3)
          break;
        case 7:
          list.add(SyncDataType.sleep); // 7 同步眼动睡眠数据
          break;
        case 12:
          list.add(SyncDataType.bloodPressure); // 12 同步血压数据
          break;
        case 1:
          list.add(SyncDataType.bloodOxygen); // 1 同步血氧
          break;
        case 2:
          list.add(SyncDataType.pressure); // 2 同步压力
          break;
        case 9:
          list.add(SyncDataType.noise); // 9 同步噪音数据
          break;
        case 10:
          list.add(SyncDataType.piven); // 10 同步温度数据
          break;
        case 14:
          list.add(SyncDataType.respirationRate); // 14 同步呼吸频率数据
          break;
        case 15:
          list.add(SyncDataType.bodyPower); // 15 同步身体电量数据
          break;
        case 16:
          list.add(SyncDataType.HRV); // 16 同步HRV(心率变异性水平)数据
          break;
        case 4:
          list.add(SyncDataType.activity); // 4 同步多运动数据(v3)
          break;
        case 5:
          list.add(SyncDataType.GPS); // 5 同步GPS数据(v3)
          break;
        case 6:
          list.add(SyncDataType.swim); // 6 同步游泳数据
      }
    }
    return list;
  }
}

