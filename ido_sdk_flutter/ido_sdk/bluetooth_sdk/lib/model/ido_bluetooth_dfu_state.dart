class IDOBluetoothDfuState {
  static const DEFAULT = -1;

  //一切准备就绪，开始进入dfu升级流程
  static const PREPARE = 0;

  //设备成功进入dfu模式
  static const DEVICE_ENTER_DFU_MODE = 1;

  //进度
  static const PROGRESS = 2;

  //升级完成，并已检测到手环已重启并处于正常状态
  static const SUCCESS = 3;

  //升级完成，但无法检测手环处于什么状态，这个时候，你需提示用户“如果手环未重启，请重启手机蓝牙，重启app再尝试升级”
  static const SUCCESS_BUT_UNKNOWN = 4;

  //升级失败，具体原因参考FailReason
  static const FAILED = 5;

  //取消了升级，设备取消或主动调用取消
  static const CANCEL = 6;

  //重试中，会返回当前重试次数
  static const RETRY = 7;

  ///设备的ble地址
  String? macAddress;

  String? uuid;

  ///状态
  ///[DEFAULT]
  ///[PREPARE]
  ///[DEVICE_ENTER_DFU_MODE]
  ///[PROGRESS]
  ///[SUCCESS]
  ///[SUCCESS_BUT_UNKNOWN]
  ///[FAILED]
  ///[CANCEL]
  ///[RETRY]
  int state = DEFAULT;

  ///附带参数
  ///[state]==[PROGRESS]：进度值，数值类型
  ///[state]==[FAILED]：失败类型的index，数值类型，具体含义见[FailReason]
  ///[state]==[RETRY]：重试次数，数值类型
  dynamic data;

  IDOBluetoothDfuState({
    this.macAddress,
    this.uuid,
    this.state = DEFAULT,
    this.data,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['macAddress'] = macAddress;
    map['uuid'] = uuid;
    map['state'] = state;
    map['data'] = data;
    return map;
  }

  IDOBluetoothDfuState.fromJson(Map json) {
    macAddress = json['macAddress'];
    uuid = json['uuid'];
    state = json['state'];
    data = json['data'];
  }

  static String getStateDesc(int? state) {
    switch (state) {
      case PREPARE:
        return "PREPARE";
      case DEVICE_ENTER_DFU_MODE:
        return "DEVICE_ENTER_DFU_MODE";
      case PROGRESS:
        return "PROGRESS";
      case SUCCESS:
        return "SUCCESS";
      case SUCCESS_BUT_UNKNOWN:
        return "SUCCESS_BUT_UNKNOWN";
      case FAILED:
        return "FAILED";
      case CANCEL:
        return "CANCEL";
      case RETRY:
        return "RETRY";
    }
    return "";
  }

  static String getFailDesc(int error) {
    if (error < FailReason.values.length) {
      return FailReason.values[error].name;
    }
    return "unknown";
  }
}

enum FailReason {
  ///手环无法进入升级模式
  ENTER_DFU_MODE_FAILED,

  /// 设备低电量，无法进入升级模式
  DEVICE_IN_LOW_BATTERY,

  /// 无法找到设备
  NOT_FIND_TARGET_DEVICE,

  /// 升级配置参数错误
  CONFIG_PARAS_ERROR,

  /// 升级包错误
  FILE_ERROR,

  /// 手机系统蓝牙错误
  PHONE_BLUETOOTH_ERROR,

  /// After the upgrade, the device did not restart
  DEVICE_NOT_REBOOT,

  /// 其他错误
  OTHER,

  /// 固件错误（设备ID、版本号不匹配）
  OPERATION_FAILED,

  /// 断点续传异常，必须要用另一个包升级了
  OPERATION_NOT_PERMITTED;
}
