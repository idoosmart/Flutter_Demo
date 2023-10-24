// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voicealarm_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoiceAlarmModel _$VoiceAlarmModelFromJson(Map<String, dynamic> json) =>
    VoiceAlarmModel(
      status: json['status'] as int?,
      year: json['year'] as int?,
      month: json['month'] as int?,
      day: json['day'] as int?,
      hour: json['hour'] as int?,
      minute: json['minute'] as int?,
      alarmId: json['alarm_id'] as int?,
      repeat: json['repeat'] as int?,
    );

Map<String, dynamic> _$VoiceAlarmModelToJson(VoiceAlarmModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'year': instance.year,
      'month': instance.month,
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'alarm_id': instance.alarmId,
      'repeat': instance.repeat,
    };

AlexaAlarmModel _$AlexaAlarmModelFromJson(Map<String, dynamic> json) =>
    AlexaAlarmModel(
      alarmId: json['alarmId'] as int?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$AlexaAlarmModelToJson(AlexaAlarmModel instance) =>
    <String, dynamic>{
      'alarmId': instance.alarmId,
      'token': instance.token,
    };
