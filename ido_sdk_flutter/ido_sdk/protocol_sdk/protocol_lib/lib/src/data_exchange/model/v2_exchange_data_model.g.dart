// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v2_exchange_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IDOV2ExchangeModel _$V2ExchangeModelFromJson(Map<String, dynamic> json) =>
    IDOV2ExchangeModel(
          day: json['day'] as int?,
          hour: json['hour'] as int?,
          minute: json['minute'] as int?,
          second: json['second'] as int?,
          sportType: json['sportType'] as int?,
          operate: json['operate'] as int?,
          targetValue: json['targetValue'] as int?,
          targetType: json['targetType'] as int?,
          forceStart: json['forceStart'] as int?,
          retCode: json['retCode'] as int?,
          calories: json['calories'] as int?,
          distance: json['distance'] as int?,
          durations: json['durations'] as int?,
          step: json['step'] as int?,
          avgHr: json['avgHr'] as int?,
          maxHr: json['maxHr'] as int?,
          curHr: json['curHr'] as int?,
          hrSerial: json['hrSerial'] as int?,
          burnFatMins: json['burnFatMins'] as int?,
          aerobicMins: json['aerobicMins'] as int?,
          limitMins: json['limitMins'] as int?,
          isSave: json['isSave'] as bool?,
          status: json['status'] as int?,
          interval: json['interval'] as int?,
          hrValues:
          (json['hrValues'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$V2ExchangeModelToJson(IDOV2ExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sportType': instance.sportType,
      'operate': instance.operate,
      'targetValue': instance.targetValue,
      'targetType': instance.targetType,
      'forceStart': instance.forceStart,
      'retCode': instance.retCode,
      'calories': instance.calories,
      'distance': instance.distance,
      'durations': instance.durations,
      'step': instance.step,
      'avgHr': instance.avgHr,
      'maxHr': instance.maxHr,
      'curHr': instance.curHr,
      'hrSerial': instance.hrSerial,
      'burnFatMins': instance.burnFatMins,
      'aerobicMins': instance.aerobicMins,
      'limitMins': instance.limitMins,
      'isSave': instance.isSave,
      'status': instance.status,
      'interval': instance.interval,
      'hrValues': instance.hrValues,
    };
