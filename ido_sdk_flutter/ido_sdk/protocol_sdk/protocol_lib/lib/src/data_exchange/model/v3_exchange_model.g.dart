// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v3_exchange_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IDOV3ExchangeModel _$IDOV3ExchangeModelFromJson(Map<String, dynamic> json) =>
    IDOV3ExchangeModel(
      year: (json['year'] as num?)?.toInt() ?? 0,
      month: (json['month'] as num?)?.toInt() ?? 0,
      day: (json['day'] as num?)?.toInt() ?? 0,
      hour: (json['hour'] as num?)?.toInt() ?? 0,
      minute: (json['minute'] as num?)?.toInt() ?? 0,
      second: (json['second'] as num?)?.toInt() ?? 0,
      sportType: (json['sportType'] as num?)?.toInt() ?? 0,
      planType: (json['planType'] as num?)?.toInt() ?? 0,
      actionType: (json['actionType'] as num?)?.toInt() ?? 0,
      version: (json['version'] as num?)?.toInt() ?? 0,
      operate: (json['operate'] as num?)?.toInt() ?? 0,
      targetValue: (json['targetValue'] as num?)?.toInt() ?? 0,
      targetType: (json['targetType'] as num?)?.toInt() ?? 0,
      forceStart: (json['forceStart'] as num?)?.toInt() ?? 0,
      retCode: (json['retCode'] as num?)?.toInt() ?? 0,
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      distance: (json['distance'] as num?)?.toInt() ?? 0,
      durations: (json['durations'] as num?)?.toInt() ?? 0,
      step: (json['step'] as num?)?.toInt() ?? 0,
      swimPosture: (json['swimPosture'] as num?)?.toInt() ?? 0,
      status: (json['status'] as num?)?.toInt() ?? 0,
      signalFlag: (json['signalFlag'] as num?)?.toInt() ?? 0,
      isSave: json['isSave'] as bool? ?? false,
      realTimeSpeed: (json['realTimeSpeed'] as num?)?.toInt() ?? 0,
      realTimePace: (json['realTimePace'] as num?)?.toInt() ?? 0,
      interval: (json['interval'] as num?)?.toInt() ?? 0,
      hrCount: (json['hrCount'] as num?)?.toInt() ?? 0,
      burnFatMins: (json['burnFatMins'] as num?)?.toInt() ?? 0,
      aerobicMins: (json['aerobicMins'] as num?)?.toInt() ?? 0,
      limitMins: (json['limitMins'] as num?)?.toInt() ?? 0,
      hrValues: (json['hrValues'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      warmUpSecond: (json['warmUpSecond'] as num?)?.toInt() ?? 0,
      anaeroicSecond: (json['anaeroicSecond'] as num?)?.toInt() ?? 0,
      fatBurnSecond: (json['fatBurnSecond'] as num?)?.toInt() ?? 0,
      aerobicSecond: (json['aerobicSecond'] as num?)?.toInt() ?? 0,
      limitSecond: (json['limitSecond'] as num?)?.toInt() ?? 0,
      avgHr: (json['avgHr'] as num?)?.toInt() ?? 0,
      maxHr: (json['maxHr'] as num?)?.toInt() ?? 0,
      curHr: (json['curHr'] as num?)?.toInt() ?? 0,
      warmUpValue: (json['warmUpValue'] as num?)?.toInt() ?? 0,
      fatBurnValue: (json['fatBurnValue'] as num?)?.toInt() ?? 0,
      aerobicValue: (json['aerobicValue'] as num?)?.toInt() ?? 0,
      limitValue: (json['limitValue'] as num?)?.toInt() ?? 0,
      anaerobicValue: (json['anaerobicValue'] as num?)?.toInt() ?? 0,
      avgSpeed: (json['avgSpeed'] as num?)?.toInt() ?? 0,
      maxSpeed: (json['maxSpeed'] as num?)?.toInt() ?? 0,
      avgStepFrequency: (json['avgStepFrequency'] as num?)?.toInt() ?? 0,
      maxStepFrequency: (json['maxStepFrequency'] as num?)?.toInt() ?? 0,
      avgStepStride: (json['avgStepStride'] as num?)?.toInt() ?? 0,
      maxStepStride: (json['maxStepStride'] as num?)?.toInt() ?? 0,
      kmSpeed: (json['kmSpeed'] as num?)?.toInt() ?? 0,
      fastKmSpeed: (json['fastKmSpeed'] as num?)?.toInt() ?? 0,
      kmSpeedCount: (json['kmSpeedCount'] as num?)?.toInt() ?? 0,
      kmSpeeds: (json['kmSpeeds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      mileCount: (json['mileCount'] as num?)?.toInt() ?? 0,
      mileSpeeds: (json['mileSpeeds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      stepsFrequencyCount: (json['stepsFrequencyCount'] as num?)?.toInt() ?? 0,
      stepsFrequencys: (json['stepsFrequencys'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      trainingEffect: (json['trainingEffect'] as num?)?.toInt() ?? 0,
      anaerobicTrainingEffect:
          (json['anaerobicTrainingEffect'] as num?)?.toInt() ?? 0,
      vo2Max: (json['vo2Max'] as num?)?.toInt() ?? 0,
      actionDataCount: (json['actionDataCount'] as num?)?.toInt() ?? 0,
      inClassCalories: (json['inClassCalories'] as num?)?.toInt() ?? 0,
      completionRate: (json['completionRate'] as num?)?.toInt() ?? 0,
      hrCompletionRate: (json['hrCompletionRate'] as num?)?.toInt() ?? 0,
      recoverTime: (json['recoverTime'] as num?)?.toInt() ?? 0,
      avgWeekActivityTime: (json['avgWeekActivityTime'] as num?)?.toInt() ?? 0,
      grade: (json['grade'] as num?)?.toInt() ?? 0,
      actionData: (json['actionData'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      trainingOffset: (json['trainingOffset'] as num?)?.toInt() ?? 0,
      countHour: (json['countHour'] as num?)?.toInt() ?? 0,
      countMinute: (json['countMinute'] as num?)?.toInt() ?? 0,
      countSecond: (json['countSecond'] as num?)?.toInt() ?? 0,
      time: (json['time'] as num?)?.toInt() ?? 0,
      lowHeart: (json['lowHeart'] as num?)?.toInt() ?? 0,
      heightHeart: (json['heightHeart'] as num?)?.toInt() ?? 0,
      paceSpeedCount: (json['paceSpeedCount'] as num?)?.toInt() ?? 0,
      paceSpeeds: (json['paceSpeeds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      realSpeedCount: (json['realSpeedCount'] as num?)?.toInt() ?? 0,
      realSpeeds: (json['realSpeeds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      intervalSecond: (json['intervalSecond'] as num?)?.toInt() ?? 0,
      gpsCount: (json['gpsCount'] as num?)?.toInt() ?? 0,
      gpsData: (json['gpsData'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      segmentItemNum: (json['segmentItemNum'] as num?)?.toInt() ?? 0,
      segmentTotalTime: (json['segmentTotalTime'] as num?)?.toInt() ?? 0,
      segmentTotalDistance:
          (json['segmentTotalDistance'] as num?)?.toInt() ?? 0,
      segmentTotalPace: (json['segmentTotalPace'] as num?)?.toInt() ?? 0,
      segmentTotalAvgHr: (json['segmentTotalAvgHr'] as num?)?.toInt() ?? 0,
      segmentTotalAvgStepFrequency:
          (json['segmentTotalAvgStepFrequency'] as num?)?.toInt() ?? 0,
      paceHiit: (json['paceHiit'] as num?)?.toInt() ?? 0,
      paceAnaerobic: (json['paceAnaerobic'] as num?)?.toInt() ?? 0,
      paceLacticAcidThreshold:
          (json['paceLacticAcidThreshold'] as num?)?.toInt() ?? 0,
      paceMarathon: (json['paceMarathon'] as num?)?.toInt() ?? 0,
      paceEasyRun: (json['paceEasyRun'] as num?)?.toInt() ?? 0,
      segmentItems: (json['segmentItems'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      cumulativeClimb: (json['cumulative_altitude_rise'] as num?)?.toInt() ?? 0,
      cumulativeDecline:
          (json['cumulative_altitude_loss'] as num?)?.toInt() ?? 0,
      altitudeCount: (json['altitude_count'] as num?)?.toInt() ?? 0,
      altitudeItems: (json['altitude_item'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$IDOV3ExchangeModelToJson(IDOV3ExchangeModel instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sportType': instance.sportType,
      'planType': instance.planType,
      'actionType': instance.actionType,
      'version': instance.version,
      'operate': instance.operate,
      'targetValue': instance.targetValue,
      'targetType': instance.targetType,
      'forceStart': instance.forceStart,
      'retCode': instance.retCode,
      'calories': instance.calories,
      'distance': instance.distance,
      'durations': instance.durations,
      'step': instance.step,
      'swimPosture': instance.swimPosture,
      'status': instance.status,
      'signalFlag': instance.signalFlag,
      'isSave': instance.isSave,
      'realTimeSpeed': instance.realTimeSpeed,
      'realTimePace': instance.realTimePace,
      'interval': instance.interval,
      'hrCount': instance.hrCount,
      'burnFatMins': instance.burnFatMins,
      'aerobicMins': instance.aerobicMins,
      'limitMins': instance.limitMins,
      'hrValues': instance.hrValues,
      'warmUpSecond': instance.warmUpSecond,
      'anaeroicSecond': instance.anaeroicSecond,
      'fatBurnSecond': instance.fatBurnSecond,
      'aerobicSecond': instance.aerobicSecond,
      'limitSecond': instance.limitSecond,
      'avgHr': instance.avgHr,
      'maxHr': instance.maxHr,
      'curHr': instance.curHr,
      'warmUpValue': instance.warmUpValue,
      'fatBurnValue': instance.fatBurnValue,
      'aerobicValue': instance.aerobicValue,
      'limitValue': instance.limitValue,
      'anaerobicValue': instance.anaerobicValue,
      'avgSpeed': instance.avgSpeed,
      'maxSpeed': instance.maxSpeed,
      'avgStepFrequency': instance.avgStepFrequency,
      'maxStepFrequency': instance.maxStepFrequency,
      'avgStepStride': instance.avgStepStride,
      'maxStepStride': instance.maxStepStride,
      'kmSpeed': instance.kmSpeed,
      'fastKmSpeed': instance.fastKmSpeed,
      'kmSpeedCount': instance.kmSpeedCount,
      'kmSpeeds': instance.kmSpeeds,
      'mileCount': instance.mileCount,
      'mileSpeeds': instance.mileSpeeds,
      'stepsFrequencyCount': instance.stepsFrequencyCount,
      'stepsFrequencys': instance.stepsFrequencys,
      'trainingEffect': instance.trainingEffect,
      'anaerobicTrainingEffect': instance.anaerobicTrainingEffect,
      'vo2Max': instance.vo2Max,
      'actionDataCount': instance.actionDataCount,
      'inClassCalories': instance.inClassCalories,
      'completionRate': instance.completionRate,
      'hrCompletionRate': instance.hrCompletionRate,
      'recoverTime': instance.recoverTime,
      'avgWeekActivityTime': instance.avgWeekActivityTime,
      'grade': instance.grade,
      'actionData': instance.actionData,
      'trainingOffset': instance.trainingOffset,
      'countHour': instance.countHour,
      'countMinute': instance.countMinute,
      'countSecond': instance.countSecond,
      'time': instance.time,
      'lowHeart': instance.lowHeart,
      'heightHeart': instance.heightHeart,
      'paceSpeedCount': instance.paceSpeedCount,
      'paceSpeeds': instance.paceSpeeds,
      'realSpeedCount': instance.realSpeedCount,
      'realSpeeds': instance.realSpeeds,
      'intervalSecond': instance.intervalSecond,
      'gpsCount': instance.gpsCount,
      'gpsData': instance.gpsData,
      'segmentItemNum': instance.segmentItemNum,
      'segmentTotalTime': instance.segmentTotalTime,
      'segmentTotalDistance': instance.segmentTotalDistance,
      'segmentTotalPace': instance.segmentTotalPace,
      'segmentTotalAvgHr': instance.segmentTotalAvgHr,
      'segmentTotalAvgStepFrequency': instance.segmentTotalAvgStepFrequency,
      'paceHiit': instance.paceHiit,
      'paceAnaerobic': instance.paceAnaerobic,
      'paceLacticAcidThreshold': instance.paceLacticAcidThreshold,
      'paceMarathon': instance.paceMarathon,
      'paceEasyRun': instance.paceEasyRun,
      'segmentItems': instance.segmentItems,
      'cumulative_altitude_rise': instance.cumulativeClimb,
      'cumulative_altitude_loss': instance.cumulativeDecline,
      'altitude_count': instance.altitudeCount,
      'altitude_item': instance.altitudeItems,
    };
