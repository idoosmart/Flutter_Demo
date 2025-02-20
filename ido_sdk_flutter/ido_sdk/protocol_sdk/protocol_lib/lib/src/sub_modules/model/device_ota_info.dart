import 'package:json_annotation/json_annotation.dart';

part 'device_ota_info.g.dart';

@JsonSerializable()
class IDODeviceOtaInfo {
  String macAddress;

  /// 一般升级检测时间 24小时检测一次
  int otaTimestamp = 0;

  /// epo的最后一次检测时间，24小时检测一次
  int epoUpdateTimestamp = 0;

  /// agps online 4小时更新一次
  int agpsOnLineTimestamp = 0;

  /// agps offline 24小时更新一次
  int agpsOffLineTimestamp = 0;

  /// gps异常 一次检测一次
  int gpsErrorTimestamp = 0;

  IDODeviceOtaInfo({
    this.macAddress = '',
    this.otaTimestamp = 0,
    this.epoUpdateTimestamp = 0,
    this.agpsOnLineTimestamp = 0,
    this.agpsOffLineTimestamp = 0,
    this.gpsErrorTimestamp = 0,
  });

  factory IDODeviceOtaInfo.fromJson(Map<String, dynamic> json) =>
      _$IDODeviceOtaInfoFromJson(json);

  Map<String, dynamic> toJson() => _$IDODeviceOtaInfoToJson(this);

}
