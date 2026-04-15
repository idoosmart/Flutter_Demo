import 'package:pigeon/pigeon.dart';

/// 同步数据类型
/// 数据类型 1:步数 2:心率 3:睡眠 4:血压 5:血氧 6:压力 7:噪音 8:皮温 9:呼吸率 10:身体电量 11:HRV 12:多运动 13:GPS 14:游泳
/// 15: V2步数 16: V2睡眠 17: V2心率 18: V2血压 19: V2 GPS 20: V2多运动
enum ApiSyncDataType {
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
  v2Activity,
  /// 情绪健康
  emotionHealth,
  /// 多运动/游泳/跑步课程/跑步计划/跑后拉伸数据回调
  activityMerge,
  /// 宠物睡眠数据
  petSleep
}

/// 状态
enum ApiSyncStatus {
  initialized, ///初始化
  syncing, /// 同步中
  finished, /// 同步完成
  canceled, /// 同步取消
  stopped, /// 同步停止
  timeout, /// 同步超时
  error /// 同步错误
}

@HostApi()
abstract class SyncDataDelegate {
  /// 同步整体进度 0-100
  void callbackSyncProgress(double progress);

  /// 不同类型JSON数据同步回调
  void callbackSyncData(
      ApiSyncDataType type, String jsonStr, int errorCode);

  /// 所有数据同步完成
  void callbackSyncCompleted(int errorCode);

  /// 监听同步状态
  void listenSyncStatus(ApiSyncStatus status);
}

@FlutterApi()
abstract class SyncData {
  /// 同步状态
  ApiSyncStatus syncStatus();

  /// 开始同步所有数据
  @async
  bool startSync();

  /// 开始同步指定数据
  @async
  bool startSyncWithTypes(List<int> types);

  /// 获取支持的同步数据类型
  List<int> getSupportSyncDataTypeList();

  /// 停止同步所有数据
  void stopSync();
}
