// ignore_for_file: constant_identifier_names

/// 文件传输进度 1 ~ 100
typedef FileTranProgressCallback = void Function(double progress);

/// 文件传输状态变更
typedef FileTranStatusCallback = void Function(int error, int errorVal);

/// 设备传文件 -> app 请求确认
typedef FileTranRequestCallback = void Function(String json);

/// 同步进度 0 ~ 100
typedef SyncProgressCallback = void Function(int progress, SyncType type);

/// 日志进度 0 ~ 100
typedef LogProgressCallback = void Function(int progress);

/// 同步回调数据
typedef SyncDataCallback = void Function(
    SyncJsonType type, String jsonStr, int errorCode);

/// 指令错误码
enum CmdCode {
  /// 成功
  successful(code: 0),

  /// 取消
  canceled(code: -1),

  /// 失败
  failed(code: -2),

  /// 指令已存在队列中
  taskAlreadyExists(code: -3),

  /// 设备断线
  disconnect(code: -4),

  /// 超时
  timeout(code: 13),

  /// Invalid Parameter
  invalidParam(code: 7),

  /// Invalid state, operation disallowed in this state
  invalidState(code: 8);

  const CmdCode({required this.code});

  final int code;
}

/// 指令优先级
enum CmdPriority { veryHigh, high, normal, low}

/// 同步数据类型
/// 数据类型 1:步数 2:心率 3:睡眠 4:血压 5:血氧 6:压力 7:噪音 8:皮温 9:呼吸率 10:身体电量 11:HRV 12:多运动 13:GPS 14:游泳
/// 15: V2步数 16: V2睡眠 17: V2心率 18: V2血压 19: V2 GPS 20: V2多运动
enum SyncJsonType {
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

/// 同步类型 1:v2健康 2:v2多运动 3:v2 gps 4: v3数据
enum SyncType {
  init,
  v2Health,
  v2Activity,
  v2Gps,
  v3Data,
}

/// 日志类型
/// 1:旧的重启日志 2: 通用日志 3: 复位日志
/// 4: 硬件日志 5: 算法日志 6: 新重启日志 7:电池日志 8: 过热日志
enum LogType {
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

/// 以下为C库和固件定义的错误码
abstract class ErrorCode {
  /// Successful command
  static const success = 0;

  /// SVC handler is missing
  static const svc_handler_missing = 1;

  /// SoftDevice has not been enabled
  static const softdevice_not_enabled = 2;

  /// Internal Error
  static const internal = 3;

  /// No Memory for operation
  static const no_mem = 4;

  /// Not found
  static const not_found = 5;

  /// Not supported
  static const not_supported = 6;

  /// Invalid Parameter
  static const invalid_param = 7;

  /// Invalid state, operation disallowed in this state
  static const invalid_state = 8;

  /// Invalid Length
  static const invalid_length = 9;

  /// Invalid Flags
  static const invalid_flags = 10;

  /// Invalid Data
  static const invalid_data = 11;

  /// Invalid Data size
  static const data_size = 12;

  /// Operation timed out
  static const timeout = 13;

  /// Null Pointer
  static const nullPointer = 14;

  /// Forbidden Operation
  static const forbidden = 15;

  /// Bad Memory Address
  static const invalid_addr = 16;

  /// Busy
  static const busy = 17;

  /// Maximum connection count exceeded.
  static const conn_count = 18;

  /// Not enough resources for operation
  static const resources = 19;

  /// Bt Bluetooth upgrade error
  static const bt_ota = 20;

  /// Not enough space for operation
  static const no_space = 21;

  /// Low Battery
  static const low_battery = 22;

  /// Invalid File Name/Format
  static const invalid_file_name = 23;

  ///空间够但需要整理
  static const error_space_organization = 24;

  ///空间整理中
  static const error_space_organization_ing = 25;

  // 以下为协议库扩展，非c库和固件定义

  /// 取消
  static const canceled = -1;

  /// 失败
  static const failed = -2;

  /// 指令已存在队列中
  static const task_already_exists = -3;

  /// 执行快速配置中，指令忽略
  static const onFastSynchronizing = -4;

  /// 设备处于ota模式
  static const ota_mode = -5;

  /// 未连接设备
  static const no_connected_device = -6;

  /// 执行中的指令被中断
  /// 注：由于发出的指令不能被实际取消，故存在修改指令被中断后还会实际修改的情况
  static const task_interrupted = -7;

}
