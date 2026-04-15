import 'package:pigeon/pigeon.dart';

/// 设备信息
class DeviceInfo {
  /// 设备模式 0：运动模式，1：睡眠模式
  int? deviceMode;

  /// 电量状态 0:正常, 1:正在充电, 2:充满, 3:电量低
  int? battStatus;

  /// 电量级别 0～100
  int? battLevel;

  /// 是否重启 0:未重启 1:重启
  int? rebootFlag;

  /// 绑定状态 0:未绑定 1:已绑定
  int? bindState;

  /// 绑定类型 0:默认 1:单击 2:长按 3:屏幕点击 横向确认和取消,确认在左边 4:屏幕点击 横向确认和取消,确认在右边
  /// 5:屏幕点击 竖向确认和取消,确认在上边 6:屏幕点击 竖向确认和取消,确认在下边 7:点击(右边一个按键)
  int? bindType;

  /// 绑定超时 最长为15秒,0表示不超时
  int? bindTimeout;

  /// 设备平台 0:nordic, 10:realtek 8762x, 20:cypress psoc6, 30:Apollo3, 40:汇顶, 50:nordic+泰凌微,
  /// 60:泰凌微+5340+no nand flash, 70:汇顶+富瑞坤, 80:5340
  int? platform;

  /// 设备形状类型 0：无效；1：圆形；2：方形的； 3：椭圆
  int? deviceShapeType;

  /// 设备类型 0：无效；1：手环；2：手表
  int? deviceType;

  /// 自定义表盘主版本 从1开始 0:不支持对应的自定义表盘功能
  int? dialMainVersion;

  /// 固件绑定时候显示勾ui界面 0:不需要 1:需要
  int? showBindChoiceUi;

  /// 设备id
  int? deviceId;

  /// 设备固件主版本号
  int? firmwareVersion;

  /// 设备SN
  String? sn;

  /// BtName
  String? btName;

  /// GPS芯片平台 0：无效 1：索尼 sony 2：洛达 Airoh 3：芯与物 icoe
  int? gpsPlatform;

  // 扩展信息

  /// （SDK 内部专用， 外部慎用！！！）
  /// 当前设备mac地址 - 无冒号
  String? macAddress;

  /// （SDK 内部专用， 外部慎用！！！）
  /// 当前设备mac地址 - 带冒号
  String? macAddressFull;

  /// （SDK 内部专用， 外部慎用！！！）
  /// 注意：该名称是由调用 libManager.markConnectedDevice(...)传入，sdk不会主去刷新该值
  /// 需要获取最新值可以使用 CmdEvtType.getDeviceName 指令
  String? deviceName;

  /// （SDK 内部专用， 外部慎用！！！）
  /// OTA模式
  bool? otaMode;

  /// （（SDK 内部专用， 外部慎用！！！）
  /// UUID ios专用
  String? uuid;

  /// BT macAddress - 带冒号
  String? macAddressBt;

  // 三级版本

  /// 固件版本version1
  int? fwVersion1;

  /// 固件版本version2
  int? fwVersion2;

  /// 固件版本version3
  int? fwVersion3;

  /// BT版本生效标志位 0：无效 1：说明固件有对应的BT固件
  int? fwBtFlag;

  /// BT的版本version1
  int? fwBtVersion1;

  /// BT的版本version2
  int? fwBtVersion2;

  /// BT的版本version3
  int? fwBtVersion3;

  /// BT的所需要匹配的版本version1
  int? fwBtMatchVersion1;

  /// BT的所需要匹配的版本version2
  int? fwBtMatchVersion2;

  /// BT的所需要匹配的版本version3
  int? fwBtMatchVersion3;
}

@HostApi()
abstract class DeviceDelegate {
  /// 设备信息变更通知
  void listenDeviceChanged(DeviceInfo deviceInfo);

  /// 绑定时获取的设备信息通知(绑定专用)
  void listenDeviceOnBind(DeviceInfo deviceInfo);
}

@FlutterApi()
abstract class Device {
  /// 刷新设备信息（SDK内部使用）
  @async
  bool refreshDeviceInfo(bool forced);

  /// 刷新设备信息 绑定前使用（SDK内部使用）
  @async
  bool refreshDeviceInfoBeforeBind(bool forced);

  /// 刷新设备三级版本（SDK内部使用）
  @async
  bool refreshFirmwareVersion(bool forced);

  /// 刷新设备扩展信息（SDK内部使用）
  @async
  bool refreshDeviceExtInfo();

  /// 设置设备BT MacAddress（SDK内部使用）
  void setDeviceBtMacAddress(String macAddressBt);

  /// 清理数据 (SDK内部使用)
  void cleanDataOnMemory();
}
