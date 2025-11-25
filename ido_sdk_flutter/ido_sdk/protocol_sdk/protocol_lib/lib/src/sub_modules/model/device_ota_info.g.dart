// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_ota_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IDODeviceOtaInfo _$IDODeviceOtaInfoFromJson(Map<String, dynamic> json) =>
    IDODeviceOtaInfo(
      macAddress: json['macAddress'] as String? ?? '',
      otaTimestamp: (json['otaTimestamp'] as num?)?.toInt() ?? 0,
      epoUpdateTimestamp: (json['epoUpdateTimestamp'] as num?)?.toInt() ?? 0,
      agpsOnLineTimestamp: (json['agpsOnLineTimestamp'] as num?)?.toInt() ?? 0,
      agpsOffLineTimestamp:
          (json['agpsOffLineTimestamp'] as num?)?.toInt() ?? 0,
      gpsErrorTimestamp: (json['gpsErrorTimestamp'] as num?)?.toInt() ?? 0,
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
