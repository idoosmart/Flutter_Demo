import 'dart:async';
import 'dart:convert';
import '../../../protocol_lib.dart';
import '../../private/logger/logger.dart';

part 'private/measure_manager_impl.dart';

/// 测量类型
enum IDOMeasureType {
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
enum IDOMeasureStatus {
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
class IDOMeasureResult {
  /// 状态
  final IDOMeasureStatus status;
  
  /// 收缩压 (高压)
  final int systolicBp;
  
  /// 舒张压 (低压)
  final int diastolicBp;
  
  /// 值 (心率/血氧/压力)
  final int value;
  
  /// 一键测量-心率
  final int oneClickHr;
  
  /// 一键测量-压力
  final int oneClickStress;
  
  /// 一键测量-血氧
  final int oneClickSpo2;
  
  /// 体温值 (单位摄氏度,该值扩大了10倍, 如 366 表示 36.6度)
  final int temperatureValue;

  IDOMeasureResult({
    required this.status,
    this.systolicBp = 0,
    this.diastolicBp = 0,
    this.value = 0,
    this.oneClickHr = 0,
    this.oneClickStress = 0,
    this.oneClickSpo2 = 0,
    this.temperatureValue = 0,
  });

  factory IDOMeasureResult.fromJson(Map<String, dynamic> json) {
    return IDOMeasureResult(
      status: _mapStatus(json['status'] as int? ?? 0),
      systolicBp: json['systolic_bp'] as int? ?? 0,
      diastolicBp: json['diastolic_bp'] as int? ?? 0,
      value: json['value'] as int? ?? 0,
      oneClickHr: json['one_click_measure_hr'] as int? ?? 0,
      oneClickStress: json['one_click_measure_stress'] as int? ?? 0,
      oneClickSpo2: json['one_click_measure_spo2'] as int? ?? 0,
      temperatureValue: json['temperature_value'] as int? ?? 0,
    );
  }

  static IDOMeasureStatus _mapStatus(int status) {
    /*
    0x00：不支持
    0x01：正在测量
    0x02：测量成功
    0x03：测量失败
    0x04：设备正在运动模式
	  0x05：返回测量中数据
    */
    switch (status) {
      case 0x00: return IDOMeasureStatus.notSupport;
      case 0x01: return IDOMeasureStatus.measuring;
      case 0x02: return IDOMeasureStatus.success;
      case 0x03: return IDOMeasureStatus.failed;
      case 0x04: return IDOMeasureStatus.deviceInSportMode;
      case 0x05: return IDOMeasureStatus.measuringData;
      default: return IDOMeasureStatus.failed;
    }
  }

  @override
  String toString() {
    return 'IDOMeasureResult(status: $status, bp: $systolicBp/$diastolicBp, value: $value, oneClick: {hr:$oneClickHr, stress:$oneClickStress, spo2:$oneClickSpo2}, temp: ${temperatureValue/10})';
  }
}

/// 测量管理接口
abstract class IDOMeasureManager {
  factory IDOMeasureManager() => _IDOMeasureManager();

  /// 开始测量
  /// 
  /// 如果 `libManager.funTable.supportDevReturnMeasuringValue` 为 true 且为心率/血氧，
  /// 则每2秒发起一次获取数据请求分发给 [listenProcessMeasureData]。
  /// 
  /// [type] 测量类型
  /// 拦截逻辑：如果正在进行同类型测量，忽略；如果正在进行不同类型测量，返回 false。
  Future<bool> startMeasure(IDOMeasureType type);

  /// 停止测量
  Future<bool> stopMeasure(IDOMeasureType type);

  /// 获取当前测量数据
  /// 
  /// 可在收到测量成功通知（90）后调用，或者在测量过程中手动调用获取。
  Future<IDOMeasureResult> getMeasureData(IDOMeasureType type);
  
  /// 监听测量过程数据和结果（心率/血氧 测量有效）
  ///
  /// 如果 `libManager.funTable.supportDevReturnMeasuringValue` 为 true 且为心率/血氧，
  /// 则每2秒发起一次获取数据，并在获取到结果后返回。
  /// 逻辑：
  /// 1. 自动包含轮询获取的过程值。
  /// 2. 自动监听设备通知（72: 未佩戴, 89: 失败, 90: 成功）。
  /// 3. 处理异常情况（超时、断开等）。
  Stream<IDOMeasureResult> listenProcessMeasureData();
  
  /// 当前是否正在测量
  bool get isMeasuring;

  /// 当前测量类型
  IDOMeasureType? get currentType;
}
