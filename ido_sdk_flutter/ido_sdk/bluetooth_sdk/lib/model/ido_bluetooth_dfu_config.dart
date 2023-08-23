class IDOBluetoothDfuConfig {
  static const int PLATE_FORM_AUTO = -1;
  static const int PLATFORM_NORDIC = 0;
  static const int PLATFORM_REALTEK = 10;
  static const int PLATFORM_CYPRESS = 20;
  static const int PLATFORM_APOLLO3 = 30;

  static const int OTA_MODE_NORMAL_FUNCTION = 0;
  static const int OTA_MODE_SILENT_FUNCTION = 16;
  static const int OTA_MODE_SILENT_EXTEND_FLASH = 17;
  static const int OTA_MODE_SILENT_NO_TEMP = 18;
  static const int OTA_MODE_AUTOMATIC = 255;

  /// ota文件包路径
  String? filePath;

  ///设备的uuid, iOS使用
  String? uuid;

  ///设备的ble地址 安卓使用
  String? macAddress;

  ///设备的id
  String? deviceId;

  ///平台，默认为nordic，目前只支持nordic
  int platform;

  ///设备是否支持配对，根据功能表V3_dev_support_pair_each_connect  安卓使用
  bool isDeviceSupportPairedWithPhoneSystem;

  ///每次接受到包数，可不填
  int PRN;

  ///在重试过程中，如果多次升级失败，是否需要重启蓝牙
  bool isNeedReOpenBluetoothSwitchIfFailed;

  ///最大重试次数
  int maxRetryTime;

  ///RTK平台的OTA，在升级之前是否需要授权
  bool isNeedAuth;

  ///RTK平台的OTA，模式
  int otaWorkMode;

  IDOBluetoothDfuConfig(
      {required this.filePath,
      required this.uuid,
      required this.macAddress,
      this.deviceId,
      this.PRN = 0,
      this.platform = PLATFORM_NORDIC,
      this.isNeedReOpenBluetoothSwitchIfFailed = true,
      this.maxRetryTime = 6,
      this.isNeedAuth = false,
      this.isDeviceSupportPairedWithPhoneSystem = false,
      this.otaWorkMode = OTA_MODE_NORMAL_FUNCTION});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['filePath'] = filePath;
    data['uuid'] = uuid;
    data['macAddress'] = macAddress;
    data['deviceId'] = deviceId;
    data['PRN'] = PRN;
    data['platform'] = platform;
    data['isNeedReOpenBluetoothSwitchIfFailed'] =
        isNeedReOpenBluetoothSwitchIfFailed;
    data['maxRetryTime'] = maxRetryTime;
    data['isNeedAuth'] = isNeedAuth;
    data['isDeviceSupportPairedWithPhoneSystem'] =
        isDeviceSupportPairedWithPhoneSystem;
    data['otaWorkMode'] = otaWorkMode;
    return data;
  }
}
