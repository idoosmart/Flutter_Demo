// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceInfoModel _$DeviceInfoModelFromJson(Map<String, dynamic> json) =>
    DeviceInfoModel(
      battStatus: (json['batt_status'] as num?)?.toInt(),
      bindConfirmMethod: (json['bind_confirm_method'] as num?)?.toInt(),
      bindConfirmTimeout: (json['bind_confirm_timeout'] as num?)?.toInt(),
      bootloadVersion: (json['bootload_version'] as num?)?.toInt(),
      btName: json['bt_name'],
      cloudClockDialVersion:
          (json['cloud_clock_dial_version'] as num?)?.toInt(),
      deivceId: (json['deivce_id'] as num?)?.toInt(),
      devType: (json['dev_type'] as num?)?.toInt(),
      energe: (json['energe'] as num?)?.toInt(),
      firmwareVersion: (json['firmware_version'] as num?)?.toInt(),
      mode: (json['mode'] as num?)?.toInt(),
      pairFlag: (json['pair_flag'] as num?)?.toInt(),
      platform: (json['platform'] as num?)?.toInt(),
      reboot: (json['reboot'] as num?)?.toInt(),
      shape: (json['shape'] as num?)?.toInt(),
      showBindChoiceUi: (json['show_bind_choice_ui'] as num?)?.toInt(),
      userDefinedDialMainVersion:
          (json['user_defined_dial_main_version'] as num?)?.toInt(),
      sn: json['sn'],
      gpsPlatform: (json['gps_platform'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DeviceInfoModelToJson(DeviceInfoModel instance) =>
    <String, dynamic>{
      'batt_status': instance.battStatus,
      'bind_confirm_method': instance.bindConfirmMethod,
      'bind_confirm_timeout': instance.bindConfirmTimeout,
      'bootload_version': instance.bootloadVersion,
      'bt_name': instance.btName,
      'cloud_clock_dial_version': instance.cloudClockDialVersion,
      'deivce_id': instance.deivceId,
      'dev_type': instance.devType,
      'energe': instance.energe,
      'firmware_version': instance.firmwareVersion,
      'mode': instance.mode,
      'pair_flag': instance.pairFlag,
      'platform': instance.platform,
      'reboot': instance.reboot,
      'shape': instance.shape,
      'show_bind_choice_ui': instance.showBindChoiceUi,
      'user_defined_dial_main_version': instance.userDefinedDialMainVersion,
      'sn': instance.sn,
      'gps_platform': instance.gpsPlatform,
    };
