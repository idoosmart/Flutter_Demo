// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firmware_version_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirmwareVersionModel _$FirmwareVersionModelFromJson(
        Map<String, dynamic> json) =>
    FirmwareVersionModel(
      firmwareVersion1: (json['firmware_version1'] as num?)?.toInt(),
      firmwareVersion2: (json['firmware_version2'] as num?)?.toInt(),
      firmwareVersion3: (json['firmware_version3'] as num?)?.toInt(),
      btFlag: (json['BT_flag'] as num?)?.toInt(),
      btVersion1: (json['BT_version1'] as num?)?.toInt(),
      btVersion2: (json['BT_version2'] as num?)?.toInt(),
      btVersion3: (json['BT_version3'] as num?)?.toInt(),
      btMatchVersion1: (json['BT_match_version1'] as num?)?.toInt(),
      btMatchVersion2: (json['BT_match_version2'] as num?)?.toInt(),
      btMatchVersion3: (json['BT_match_version3'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FirmwareVersionModelToJson(
        FirmwareVersionModel instance) =>
    <String, dynamic>{
      'firmware_version1': instance.firmwareVersion1,
      'firmware_version2': instance.firmwareVersion2,
      'firmware_version3': instance.firmwareVersion3,
      'BT_flag': instance.btFlag,
      'BT_version1': instance.btVersion1,
      'BT_version2': instance.btVersion2,
      'BT_version3': instance.btVersion3,
      'BT_match_version1': instance.btMatchVersion1,
      'BT_match_version2': instance.btMatchVersion2,
      'BT_match_version3': instance.btMatchVersion3,
    };
