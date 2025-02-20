// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_ota_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IDODeviceOtaInfo _$IDODeviceOtaInfoFromJson(Map<String, dynamic> json) =>
    IDODeviceOtaInfo(
      macAddress: json['macAddress'] as String? ?? '',
      otaTimestamp: json['otaTimestamp'] as int? ?? 0,
      epoUpdateTimestamp: json['epoUpdateTimestamp'] as int? ?? 0,
      agpsOnLineTimestamp: json['agpsOnLineTimestamp'] as int? ?? 0,
      agpsOffLineTimestamp: json['agpsOffLineTimestamp'] as int? ?? 0,
      gpsErrorTimestamp: json['gpsErrorTimestamp'] as int? ?? 0,
    );

Map<String, dynamic> _$IDODeviceOtaInfoToJson(IDODeviceOtaInfo instance) =>
    <String, dynamic>{
      'macAddress': instance.macAddress,
      'otaTimestamp': instance.otaTimestamp,
      'epoUpdateTimestamp': instance.epoUpdateTimestamp,
      'agpsOnLineTimestamp': instance.agpsOnLineTimestamp,
      'agpsOffLineTimestamp': instance.agpsOffLineTimestamp,
      'gpsErrorTimestamp': instance.gpsErrorTimestamp,
    };
