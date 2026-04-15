import 'package:pigeon/pigeon.dart';

/// 测量类型
enum MeasureType {
  /// 血压
  bloodPressure,
  /// 心率
  heartRate,
  /// 血氧
  spo2,
  /// 压力
  stress,
  /// 一键测量
  oneClick,
  /// 体温
  temperature,
  /// 身体成分
  bodyComposition,
}

/// 测量状态
enum MeasureStatus {
  /// 不支持
  notSupport,
  /// 正在测量
  measuring,
  /// 测量成功
  success,
  /// 测量失败
  failed,
  /// 设备正在运动模式
  deviceInSportMode,
  /// 返回测量中数据
  measuringData,
  /// 超时 (APP)
  timeout,
  /// 停止 (APP)
  stopped,
  /// 断连 (APP)
  disconnected,
  /// 未佩戴 (设备通知 72)
  unworn,
}

/// 测量结果模型
class MeasureResult {
  /// 状态
  MeasureStatus? status;

  /// 收缩压 (高压)
  int? systolicBp;

  /// 舒张压 (低压)
  int? diastolicBp;

  /// 值 (心率/血氧/压力)
  int? value;

  /// 一键测量-心率
  int? oneClickHr;

  /// 一键测量-压力
  int? oneClickStress;

  /// 一键测量-血氧
  int? oneClickSpo2;

  /// 体温值 (单位摄氏度,该值扩大了10倍, 如 366 表示 36.6度)
  int? temperatureValue;
}

@HostApi()
abstract class MeasureDelegate {
  /// 测量结果监听
  void listenMeasureResult(MeasureResult result);
}

@FlutterApi()
abstract class Measure {
  /// 开始测量
  @async
  bool startMeasure(MeasureType type);

  /// 停止测量
  @async
  bool stopMeasure(MeasureType type);

  /// 获取当前测量数据
  @async
  MeasureResult getMeasureData(MeasureType type);
}
