import 'dart:async';

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
/// 数据类型 1:步数 2:心率 3:睡眠 4:血压 5:血氧 6:压力 7:噪音 8:皮温 9:呼吸率 10:身体电量 11:HRV 12:多运动 13:GPS 14:游泳
/// 15: V2步数 16: V2睡眠 17: V2心率 18: V2血压 19: V2 GPS 20: V2多运动
enum SyncDataType {
  nullType,
  stepCount,
  heartRate,
  sleep,
  bloodPressure,
  bloodOxygen,
  pressure,
  noise,
  piven,
  respirationRate,
  bodyPower,
  HRV,
  activity,
  GPS,
  swim,
  v2StepCount,
  v2Sleep,
  v2HeartRate,
  v2BloodPressure,
  v2GPS,
  v2Activity
}

/// 同步整体进度 0-100
typedef CallbackSyncProgress = void Function(double progress);
/// 不同类型JSON数据同步回调
typedef CallbackSyncData = void Function(SyncDataType type,String jsonStr,int errorCode);
/// 所有数据同步完成
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
