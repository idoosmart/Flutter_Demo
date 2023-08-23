class DeviceInfoExtModel {
  final String macAddress;

  String? macAddressFull;

  bool otaMode = false;

  /// UUID ios用用
  String uuid;

  String deviceName;

  /// 最后更新时间 毫秒
  int updateTime;

  /// BT macAddress
  String? macAddressBt;

  String formatTime(int millisecondsSince) {
    return DateTime.fromMicrosecondsSinceEpoch(millisecondsSince).toString();
  }

  DeviceInfoExtModel(
      {required this.macAddress,
      required this.macAddressFull,
      this.uuid = '',
      this.deviceName = '',
      required this.otaMode,
      required this.updateTime,
      this.macAddressBt});

  factory DeviceInfoExtModel.fromJson(Map<String, dynamic> json) =>
      DeviceInfoExtModel(
          macAddress: json['macAddress'] as String,
          macAddressFull: json['macAddressFull'] as String?,
          macAddressBt: json['macAddressBt'] as String?,
          uuid: json['uuid'] as String,
          deviceName: json['deviceName'] as String,
          otaMode: json['otaMode'] as bool,
          updateTime: json['updateTime'] as int);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'macAddress': macAddress,
        'macAddressFull': macAddressFull,
        'uuid': uuid,
        'deviceName': deviceName,
        'otaMode': otaMode,
        'updateTime': updateTime,
        'macAddressBt': macAddressBt,
      };
}
