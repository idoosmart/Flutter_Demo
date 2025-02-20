// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceInfoModel _$DeviceInfoModelFromJson(Map<String, dynamic> json) =>
    DeviceInfoModel(
      battStatus: json['batt_status'] as int?,
      bindConfirmMethod: json['bind_confirm_method'] as int?,
      bindConfirmTimeout: json['bind_confirm_timeout'] as int?,
      bootloadVersion: json['bootload_version'] as int?,
      btName: json['bt_name'],
      cloudClockDialVersion: json['cloud_clock_dial_version'] as int?,
      deivceId: json['deivce_id'] as int?,
      devType: json['dev_type'] as int?,
      energe: json['energe'] as int?,
      firmwareVersion: json['firmware_version'] as int?,
      mode: json['mode'] as int?,
      pairFlag: json['pair_flag'] as int?,
      platform: json['platform'] as int?,
      reboot: json['reboot'] as int?,
      shape: json['shape'] as int?,
      showBindChoiceUi: json['show_bind_choice_ui'] as int?,
      userDefinedDialMainVersion:
          json['user_defined_dial_main_version'] as int?,
      sn: json['sn'],
      gpsPlatform: json['gps_platform'] as int?,
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
