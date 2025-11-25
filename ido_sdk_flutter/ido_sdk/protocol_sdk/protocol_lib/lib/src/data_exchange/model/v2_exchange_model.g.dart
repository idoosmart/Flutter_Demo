// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v2_exchange_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IDOV2ExchangeModel _$IDOV2ExchangeModelFromJson(Map<String, dynamic> json) =>
    IDOV2ExchangeModel(
      day: (json['day'] as num?)?.toInt() ?? 0,
      hour: (json['hour'] as num?)?.toInt() ?? 0,
      minute: (json['minute'] as num?)?.toInt() ?? 0,
      second: (json['second'] as num?)?.toInt() ?? 0,
      sportType: (json['sportType'] as num?)?.toInt() ?? 0,
      operate: (json['operate'] as num?)?.toInt() ?? 0,
      targetValue: (json['targetValue'] as num?)?.toInt() ?? 0,
      targetType: (json['targetType'] as num?)?.toInt() ?? 0,
      forceStart: (json['forceStart'] as num?)?.toInt() ?? 0,
      retCode: (json['retCode'] as num?)?.toInt() ?? 0,
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      distance: (json['distance'] as num?)?.toInt() ?? 0,
      durations: (json['durations'] as num?)?.toInt() ?? 0,
      step: (json['step'] as num?)?.toInt() ?? 0,
      avgHr: (json['avgHr'] as num?)?.toInt() ?? 0,
      maxHr: (json['maxHr'] as num?)?.toInt() ?? 0,
      curHr: (json['curHr'] as num?)?.toInt() ?? 0,
      hrSerial: (json['hrSerial'] as num?)?.toInt() ?? 0,
      burnFatMins: (json['burnFatMins'] as num?)?.toInt() ?? 0,
      aerobicMins: (json['aerobicMins'] as num?)?.toInt() ?? 0,
      limitMins: (json['limitMins'] as num?)?.toInt() ?? 0,
      isSave: json['isSave'] as bool? ?? false,
      status: (json['status'] as num?)?.toInt() ?? 0,
      interval: (json['interval'] as num?)?.toInt() ?? 0,
      hrValues: (json['hrValues'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$IDOV2ExchangeModelToJson(IDOV2ExchangeModel instance) =>
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
