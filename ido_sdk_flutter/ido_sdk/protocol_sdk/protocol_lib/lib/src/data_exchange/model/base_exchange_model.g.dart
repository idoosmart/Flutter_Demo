// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_exchange_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IDOAppStartExchangeModel _$IDOAppStartExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOAppStartExchangeModel(
      targetValue: (json['target_value'] as num?)?.toInt(),
      targetType: (json['target_type'] as num?)?.toInt(),
      forceStart: (json['force_start'] as num?)?.toInt(),
      vo2max: (json['vo2max'] as num?)?.toInt(),
      recoverTime: (json['recover_time'] as num?)?.toInt(),
      avgWeekActivityTime: (json['avg_week_activity_time'] as num?)?.toInt(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOAppStartExchangeModelToJson(
        IDOAppStartExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'target_type': instance.targetType,
      'target_value': instance.targetValue,
      'force_start': instance.forceStart,
      'vo2max': instance.vo2max,
      'recover_time': instance.recoverTime,
      'avg_week_activity_time': instance.avgWeekActivityTime,
    };

IDOAppStartReplyExchangeModel _$IDOAppStartReplyExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOAppStartReplyExchangeModel(
      retCode: (json['ret_code'] as num?)?.toInt(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOAppStartReplyExchangeModelToJson(
        IDOAppStartReplyExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'ret_code': instance.retCode,
    };

IDOAppEndExchangeModel _$IDOAppEndExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOAppEndExchangeModel(
      duration: (json['duration'] as num?)?.toInt(),
      calories: (json['calories'] as num?)?.toInt(),
      distance: (json['distance'] as num?)?.toInt(),
      isSave: (json['is_save'] as num?)?.toInt(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOAppEndExchangeModelToJson(
        IDOAppEndExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'duration': instance.duration,
      'calories': instance.calories,
      'distance': instance.distance,
      'is_save': instance.isSave,
    };

IDOAppEndReplyExchangeModel _$IDOAppEndReplyExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOAppEndReplyExchangeModel(
      errorCode: (json['err_code'] as num?)?.toInt(),
      calories: (json['calories'] as num?)?.toInt(),
      distance: (json['distance'] as num?)?.toInt(),
      step: (json['step'] as num?)?.toInt(),
      avgHr: (json['avg_hr_value'] as num?)?.toInt(),
      maxHr: (json['max_hr_value'] as num?)?.toInt(),
      burnFatMins: (json['burn_fat_mins'] as num?)?.toInt(),
      aerobicMins: (json['aerobic_mins'] as num?)?.toInt(),
      limitMins: (json['limit_mins'] as num?)?.toInt(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOAppEndReplyExchangeModelToJson(
        IDOAppEndReplyExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'err_code': instance.errorCode,
      'calories': instance.calories,
      'distance': instance.distance,
      'step': instance.step,
      'avg_hr_value': instance.avgHr,
      'max_hr_value': instance.maxHr,
      'burn_fat_mins': instance.burnFatMins,
      'aerobic_mins': instance.aerobicMins,
      'limit_mins': instance.limitMins,
    };

IDOAppIngExchangeModel _$IDOAppIngExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOAppIngExchangeModel(
      calories: (json['calories'] as num?)?.toInt(),
      distance: (json['distance'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOAppIngExchangeModelToJson(
        IDOAppIngExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'duration': instance.duration,
      'calories': instance.calories,
      'distance': instance.distance,
      'status': instance.status,
    };

IDOAppIngReplyExchangeModel _$IDOAppIngReplyExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOAppIngReplyExchangeModel(
      calories: (json['calories'] as num?)?.toInt(),
      distance: (json['distance'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      step: (json['step'] as num?)?.toInt(),
      currentHr: (json['cur_hr_value'] as num?)?.toInt(),
      interval: (json['interval_second'] as num?)?.toInt(),
      hrSerial: (json['hr_value_serial'] as num?)?.toInt(),
      hrJson: (json['hr_value'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOAppIngReplyExchangeModelToJson(
        IDOAppIngReplyExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'calories': instance.calories,
      'distance': instance.distance,
      'status': instance.status,
      'step': instance.step,
      'cur_hr_value': instance.currentHr,
      'interval_second': instance.interval,
      'hr_value_serial': instance.hrSerial,
      'hr_value': instance.hrJson,
    };

IDOAppPauseExchangeModel _$IDOAppPauseExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOAppPauseExchangeModel(
      pauseHour: (json['sport_hour'] as num?)?.toInt(),
      pauseMinute: (json['sport_minute'] as num?)?.toInt(),
      pauseSecond: (json['sport_second'] as num?)?.toInt(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOAppPauseExchangeModelToJson(
        IDOAppPauseExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'sport_hour': instance.pauseHour,
      'sport_minute': instance.pauseMinute,
      'sport_second': instance.pauseSecond,
    };

IDOAppPauseReplyExchangeModel _$IDOAppPauseReplyExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOAppPauseReplyExchangeModel(
      errCode: (json['err_code'] as num?)?.toInt(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOAppPauseReplyExchangeModelToJson(
        IDOAppPauseReplyExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'err_code': instance.errCode,
    };

IDOAppRestoreExchangeModel _$IDOAppRestoreExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOAppRestoreExchangeModel()
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOAppRestoreExchangeModelToJson(
        IDOAppRestoreExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
    };

IDOAppRestoreReplyExchangeModel _$IDOAppRestoreReplyExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOAppRestoreReplyExchangeModel(
      errCode: (json['err_code'] as num?)?.toInt(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOAppRestoreReplyExchangeModelToJson(
        IDOAppRestoreReplyExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'err_code': instance.errCode,
    };

IDOAppIngV3ExchangeModel _$IDOAppIngV3ExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOAppIngV3ExchangeModel(
      version: (json['version'] as num?)?.toInt(),
      signal: (json['signal_flag'] as num?)?.toInt(),
      distance: (json['distance'] as num?)?.toInt(),
      speed: (json['real_time_speed'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      calories: (json['calories'] as num?)?.toInt(),
      gpsInfoCount: (json['gps_info_count'] as num?)?.toInt(),
      gps: (json['gps'] as List<dynamic>?)
          ?.map((e) => Map<String, int>.from(e as Map))
          .toList(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOAppIngV3ExchangeModelToJson(
        IDOAppIngV3ExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'version': instance.version,
      'signal_flag': instance.signal,
      'distance': instance.distance,
      'real_time_speed': instance.speed,
      'duration': instance.duration,
      'calories': instance.calories,
      'gps_info_count': instance.gpsInfoCount,
      'gps': instance.gps,
    };

IDOAppIngV3ReplyExchangeModel _$IDOAppIngV3ReplyExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOAppIngV3ReplyExchangeModel(
      version: (json['version'] as num?)?.toInt(),
      heartRate: (json['heart_rate'] as num?)?.toInt(),
      distance: (json['distance'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      realTimeCalories: (json['real_time_calories'] as num?)?.toInt(),
      realTimeSpeed: (json['real_time_speed'] as num?)?.toInt(),
      kmSpeed: (json['km_speed'] as num?)?.toInt(),
      steps: (json['steps'] as num?)?.toInt(),
      swimPosture: (json['swim_posture'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      realTimeSpeedPace: (json['real_time_speed_pace'] as num?)?.toInt(),
      trainingEffect: (json['te'] as num?)?.toInt(),
      anaerobicTrainingEffect: (json['tean'] as num?)?.toInt(),
      actionType: (json['action_type'] as num?)?.toInt(),
      countHour: (json['count_hour'] as num?)?.toInt(),
      countMinute: (json['count_minute'] as num?)?.toInt(),
      countSecond: (json['count_second'] as num?)?.toInt(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOAppIngV3ReplyExchangeModelToJson(
        IDOAppIngV3ReplyExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'version': instance.version,
      'heart_rate': instance.heartRate,
      'distance': instance.distance,
      'duration': instance.duration,
      'real_time_calories': instance.realTimeCalories,
      'real_time_speed': instance.realTimeSpeed,
      'km_speed': instance.kmSpeed,
      'steps': instance.steps,
      'swim_posture': instance.swimPosture,
      'status': instance.status,
      'real_time_speed_pace': instance.realTimeSpeedPace,
      'te': instance.trainingEffect,
      'tean': instance.anaerobicTrainingEffect,
      'action_type': instance.actionType,
      'count_hour': instance.countHour,
      'count_minute': instance.countMinute,
      'count_second': instance.countSecond,
    };

IDOActivitySwimmingLapItem _$IDOActivitySwimmingLapItemFromJson(
        Map<String, dynamic> json) =>
    IDOActivitySwimmingLapItem(
      swolf: (json['swolf'] as num?)?.toInt(),
      swimmingPosture: (json['swimming_posture'] as num?)?.toInt(),
      strokesNumber: (json['strokes_number'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      distance: (json['distance'] as num?)?.toInt(),
      frequency: (json['frequency'] as num?)?.toInt(),
      pace: (json['pace'] as num?)?.toInt(),
      stopTime: (json['stop_time'] as num?)?.toInt(),
      differenceTime: (json['difference_time'] as num?)?.toInt(),
    );

Map<String, dynamic> _$IDOActivitySwimmingLapItemToJson(
        IDOActivitySwimmingLapItem instance) =>
    <String, dynamic>{
      'swolf': instance.swolf,
      'swimming_posture': instance.swimmingPosture,
      'strokes_number': instance.strokesNumber,
      'duration': instance.duration,
      'distance': instance.distance,
      'frequency': instance.frequency,
      'pace': instance.pace,
      'stop_time': instance.stopTime,
      'difference_time': instance.differenceTime,
    };

IDOActivityRopeSkipItem _$IDOActivityRopeSkipItemFromJson(
        Map<String, dynamic> json) =>
    IDOActivityRopeSkipItem(
      ropeSkipCount: (json['rope_skip_count'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
    );

Map<String, dynamic> _$IDOActivityRopeSkipItemToJson(
        IDOActivityRopeSkipItem instance) =>
    <String, dynamic>{
      'rope_skip_count': instance.ropeSkipCount,
      'duration': instance.duration,
    };

IDOAppActivityDataV3ExchangeModel _$IDOAppActivityDataV3ExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOAppActivityDataV3ExchangeModel(
      year: (json['year'] as num?)?.toInt(),
      month: (json['month'] as num?)?.toInt(),
      version: (json['version'] as num?)?.toInt(),
      hrInterval: (json['hr_data_interval_minute'] as num?)?.toInt(),
      step: (json['step'] as num?)?.toInt(),
      durations: (json['durations'] as num?)?.toInt(),
      calories: (json['calories'] as num?)?.toInt(),
      distance: (json['distance'] as num?)?.toInt(),
      burnFatMins: (json['burn_fat_mins'] as num?)?.toInt(),
      aerobicMins: (json['aerobic_mins'] as num?)?.toInt(),
      limitMins: (json['limit_mins'] as num?)?.toInt(),
      warmUp: (json['warm_up'] as num?)?.toInt(),
      fatBurning: (json['fat_burning'] as num?)?.toInt(),
      aerobicExercise: (json['aerobic_exercise'] as num?)?.toInt(),
      anaerobicExercise: (json['anaerobic_exercise'] as num?)?.toInt(),
      extremeExercise: (json['extreme_exercise'] as num?)?.toInt(),
      warmUpTime: (json['warm_up_time'] as num?)?.toInt(),
      fatBurningTime: (json['fat_burning_time'] as num?)?.toInt(),
      aerobicExerciseTime: (json['aerobic_exercise_time'] as num?)?.toInt(),
      anaerobicExerciseTime: (json['anaerobic_exercise_time'] as num?)?.toInt(),
      extremeExerciseTime: (json['extreme_exercise_time'] as num?)?.toInt(),
      avgSpeed: (json['avg_speed'] as num?)?.toInt(),
      maxSpeed: (json['max_speed'] as num?)?.toInt(),
      avgStepStride: (json['avg_step_stride'] as num?)?.toInt(),
      maxStepStride: (json['max_step_stride'] as num?)?.toInt(),
      kmSpeed: (json['km_speed'] as num?)?.toInt(),
      fastKmSpeed: (json['fast_km_speed'] as num?)?.toInt(),
      avgStepFrequency: (json['avg_step_frequency'] as num?)?.toInt(),
      maxStepFrequency: (json['max_step_frequency'] as num?)?.toInt(),
      avgHrValue: (json['avg_hr_value'] as num?)?.toInt(),
      maxHrValue: (json['max_hr_value'] as num?)?.toInt(),
      kmSpeedCount: (json['km_speed_count'] as num?)?.toInt(),
      actionDataCount: (json['action_data_count'] as num?)?.toInt(),
      stepsFrequencyCount: (json['steps_frequency_count'] as num?)?.toInt(),
      miSpeedCount: (json['mi_speed_count'] as num?)?.toInt(),
      recoverTime: (json['recover_time'] as num?)?.toInt(),
      vo2max: (json['vo2max'] as num?)?.toInt(),
      trainingEffect: (json['training_effect'] as num?)?.toInt(),
      grade: (json['grade'] as num?)?.toInt(),
      realSpeedCount: (json['real_speed_count'] as num?)?.toInt(),
      paceSpeedCount: (json['pace_speed_count'] as num?)?.toInt(),
      inClassCalories: (json['in_class_calories'] as num?)?.toInt(),
      completionRate: (json['completion_rate'] as num?)?.toInt(),
      hrCompletionRate: (json['hr_completion_rate'] as num?)?.toInt(),
      segmentItemNum: (json['segdata_item_num'] as num?)?.toInt(),
      segmentTotalTime: (json['segdata_total_time'] as num?)?.toInt(),
      segmentTotalDistance: (json['segdata_total_distance'] as num?)?.toInt(),
      segmentTotalPace: (json['segdata_total_pace'] as num?)?.toInt(),
      segmentTotalAvgHr: (json['segdata_total_avg_hr'] as num?)?.toInt(),
      segmentTotalAvgStepFrequency:
          (json['segdata_total_avg_step_frequency'] as num?)?.toInt(),
      paceHiit: (json['pace_hiit'] as num?)?.toInt(),
      paceAnaerobic: (json['pace_anaerobic'] as num?)?.toInt(),
      paceLacticAcidThreshold:
          (json['pace_lactic_acid_threshold'] as num?)?.toInt(),
      paceMarathon: (json['pace_marathon'] as num?)?.toInt(),
      paceEasyRun: (json['pace_easy_run'] as num?)?.toInt(),
      kmSpeeds: (json['km_speed_s'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      stepsFrequency: (json['steps_frequency'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      itemsMiSpeed: (json['items_mi_speed'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      itemRealSpeed: (json['item_real_speed'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      paceSpeedItems: (json['pace_speed_items'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      actionData: (json['items'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      segmentItems: (json['seg_items'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      cumulativeClimb: (json['cumulative_altitude_rise'] as num?)?.toInt(),
      cumulativeDecline: (json['cumulative_altitude_loss'] as num?)?.toInt(),
      minStepStride: (json['min_step_stride'] as num?)?.toInt(),
      minStepFrequency: (json['min_step_frequency'] as num?)?.toInt(),
      slowestKmPace: (json['slowest_km_pace'] as num?)?.toInt(),
      heartRateZonesMode: (json['heart_rate_zones_mode'] as num?)?.toInt(),
      minSpeed: (json['min_speed'] as num?)?.toInt(),
      easyZoneTime: (json['easy_zone_time'] as num?)?.toInt(),
      marathonZoneTime: (json['marathon_zone_time'] as num?)?.toInt(),
      thresholdZoneTime: (json['threshold_zone_time'] as num?)?.toInt(),
      anaerobicZoneTime: (json['anaerobic_zone_time'] as num?)?.toInt(),
      intervalZoneTime: (json['interval_zone_time'] as num?)?.toInt(),
      actType: (json['act_type'] as num?)?.toInt(),
      trainingOffset: (json['training_offset'] as num?)?.toInt(),
      distance3d: (json['distance3d'] as num?)?.toInt(),
      avg3dSpeed: (json['avg_3d_speed'] as num?)?.toInt(),
      avgVerticalSpeed: (json['avg_vertical_speed'] as num?)?.toInt(),
      avgSlope: (json['avg_slope'] as num?)?.toInt(),
      maxAltitude: (json['max_altitude'] as num?)?.toInt(),
      minAltitude: (json['min_altitude'] as num?)?.toInt(),
      avgAltitude: (json['avg_altitude'] as num?)?.toInt(),
      altitudeCount: (json['altitude_count'] as num?)?.toInt(),
      altitudeItem: (json['altitude_item'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      gpsStatus: (json['gps_status'] as num?)?.toInt(),
      anaerobicTrainingEffect:
          (json['anaerobic_training_effect'] as num?)?.toInt(),
      load: (json['load'] as num?)?.toInt(),
      runningEconomy: (json['running_economy'] as num?)?.toInt(),
      maxRunningPower: (json['max_running_power'] as num?)?.toInt(),
      minRunningPower: (json['min_running_power'] as num?)?.toInt(),
      avgRunningPower: (json['avg_running_power'] as num?)?.toInt(),
      runningPowerCount: (json['running_power_count'] as num?)?.toInt(),
      rtpeCount: (json['rtpe_count'] as num?)?.toInt(),
      maxRtoc: (json['max_rtoc'] as num?)?.toInt(),
      minRtoc: (json['min_rtoc'] as num?)?.toInt(),
      avgRtoc: (json['avg_rtoc'] as num?)?.toInt(),
      rtocCount: (json['rtoc_count'] as num?)?.toInt(),
      maxRopeFrequency: (json['max_rope_frequency'] as num?)?.toInt(),
      minRopeFrequency: (json['min_rope_frequency'] as num?)?.toInt(),
      avgRopeFrequency: (json['avg_rope_frequency'] as num?)?.toInt(),
      maxRopeSkipCount: (json['max_rope_skip_count'] as num?)?.toInt(),
      ropeTripCount: (json['rope_trip_count'] as num?)?.toInt(),
      totalRopeCount: (json['total_rope_count'] as num?)?.toInt(),
      ropeItemCount: (json['rope_item_count'] as num?)?.toInt(),
      kmPace: (json['km_pace'] as num?)?.toInt(),
      fastKmPace: (json['fast_km_pace'] as num?)?.toInt(),
      kmPaceCount: (json['km_pace_count'] as num?)?.toInt(),
      miPaceCount: (json['mi_pace_count'] as num?)?.toInt(),
      paceRealTimeCount: (json['pace_real_time_count'] as num?)?.toInt(),
      aerobicPowerInterval: (json['aerobic_power_interval'] as num?)?.toInt(),
      mixedOxygenPowerInterval:
          (json['mixed_oxygen_power_interval'] as num?)?.toInt(),
      thresholdRunningPowerInterval:
          (json['threshold_running_power_interval'] as num?)?.toInt(),
      intermittentRunPowerInterval:
          (json['intermittent_run_power_interval'] as num?)?.toInt(),
      sprintRunPowerInterval:
          (json['sprint_run_power_interval'] as num?)?.toInt(),
      strideCount: (json['stride_count'] as num?)?.toInt(),
      strideItems: (json['stride_items'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      itemRunningPower: (json['item_running_power'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      itemRtpe: (json['item_rtpe'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      itemRtoc: (json['item_rtoc'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      itemRopeInfo: (json['item_rope_info'] as List<dynamic>?)
          ?.map((e) =>
              IDOActivityRopeSkipItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      smartCompetitor: (json['smart_competitor'] as num?)?.toInt(),
      aiImageId: (json['ai_image_id'] as num?)?.toInt(),
      userImageId: (json['user_image_id'] as num?)?.toInt(),
      bgImageId: (json['bg_image_id'] as num?)?.toInt(),
      smartCompetitorPace: (json['smart_competitor_pace'] as num?)?.toInt(),
      tennisServeCount: (json['tennis_serve_count'] as num?)?.toInt(),
      tennisForeheadCount: (json['tennis_forehead_count'] as num?)?.toInt(),
      tennisBackhandCount: (json['tennis_backhand_count'] as num?)?.toInt(),
      trips: (json['trips'] as num?)?.toInt(),
      averageSwolf: (json['average_swolf'] as num?)?.toInt(),
      totalStrokesNumber: (json['total_strokes_number'] as num?)?.toInt(),
      swimmingPosture: (json['swimming_posture'] as num?)?.toInt(),
      swimmingAvgPace: (json['swimming_avg_pace'] as num?)?.toInt(),
      avgFrequency: (json['avg_frequency'] as num?)?.toInt(),
      bodyAge: (json['body_age'] as num?)?.toInt(),
      swimmingPoolDistance:
          (json['swimming_pool_distance'] as num?)?.toDouble(),
      swimmingItemCount: (json['swimming_item_count'] as num?)?.toInt(),
      swimmingItems: (json['swimming_items'] as List<dynamic>?)
          ?.map((e) =>
              IDOActivitySwimmingLapItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOAppActivityDataV3ExchangeModelToJson(
        IDOAppActivityDataV3ExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'year': instance.year,
      'month': instance.month,
      'version': instance.version,
      'hr_data_interval_minute': instance.hrInterval,
      'step': instance.step,
      'durations': instance.durations,
      'calories': instance.calories,
      'distance': instance.distance,
      'burn_fat_mins': instance.burnFatMins,
      'aerobic_mins': instance.aerobicMins,
      'limit_mins': instance.limitMins,
      'warm_up': instance.warmUp,
      'fat_burning': instance.fatBurning,
      'aerobic_exercise': instance.aerobicExercise,
      'anaerobic_exercise': instance.anaerobicExercise,
      'extreme_exercise': instance.extremeExercise,
      'warm_up_time': instance.warmUpTime,
      'fat_burning_time': instance.fatBurningTime,
      'aerobic_exercise_time': instance.aerobicExerciseTime,
      'anaerobic_exercise_time': instance.anaerobicExerciseTime,
      'extreme_exercise_time': instance.extremeExerciseTime,
      'avg_speed': instance.avgSpeed,
      'max_speed': instance.maxSpeed,
      'avg_step_stride': instance.avgStepStride,
      'max_step_stride': instance.maxStepStride,
      'km_speed': instance.kmSpeed,
      'fast_km_speed': instance.fastKmSpeed,
      'avg_step_frequency': instance.avgStepFrequency,
      'max_step_frequency': instance.maxStepFrequency,
      'avg_hr_value': instance.avgHrValue,
      'max_hr_value': instance.maxHrValue,
      'recover_time': instance.recoverTime,
      'vo2max': instance.vo2max,
      'training_effect': instance.trainingEffect,
      'grade': instance.grade,
      'steps_frequency_count': instance.stepsFrequencyCount,
      'mi_speed_count': instance.miSpeedCount,
      'real_speed_count': instance.realSpeedCount,
      'pace_speed_count': instance.paceSpeedCount,
      'km_speed_count': instance.kmSpeedCount,
      'action_data_count': instance.actionDataCount,
      'in_class_calories': instance.inClassCalories,
      'completion_rate': instance.completionRate,
      'hr_completion_rate': instance.hrCompletionRate,
      'segdata_item_num': instance.segmentItemNum,
      'segdata_total_time': instance.segmentTotalTime,
      'segdata_total_distance': instance.segmentTotalDistance,
      'segdata_total_pace': instance.segmentTotalPace,
      'segdata_total_avg_hr': instance.segmentTotalAvgHr,
      'segdata_total_avg_step_frequency': instance.segmentTotalAvgStepFrequency,
      'pace_hiit': instance.paceHiit,
      'pace_anaerobic': instance.paceAnaerobic,
      'pace_lactic_acid_threshold': instance.paceLacticAcidThreshold,
      'pace_marathon': instance.paceMarathon,
      'pace_easy_run': instance.paceEasyRun,
      'km_speed_s': instance.kmSpeeds,
      'steps_frequency': instance.stepsFrequency,
      'items_mi_speed': instance.itemsMiSpeed,
      'item_real_speed': instance.itemRealSpeed,
      'pace_speed_items': instance.paceSpeedItems,
      'seg_items': instance.segmentItems,
      'items': instance.actionData,
      'cumulative_altitude_rise': instance.cumulativeClimb,
      'cumulative_altitude_loss': instance.cumulativeDecline,
      'min_step_stride': instance.minStepStride,
      'min_step_frequency': instance.minStepFrequency,
      'slowest_km_pace': instance.slowestKmPace,
      'heart_rate_zones_mode': instance.heartRateZonesMode,
      'min_speed': instance.minSpeed,
      'easy_zone_time': instance.easyZoneTime,
      'marathon_zone_time': instance.marathonZoneTime,
      'threshold_zone_time': instance.thresholdZoneTime,
      'anaerobic_zone_time': instance.anaerobicZoneTime,
      'interval_zone_time': instance.intervalZoneTime,
      'act_type': instance.actType,
      'training_offset': instance.trainingOffset,
      'distance3d': instance.distance3d,
      'avg_3d_speed': instance.avg3dSpeed,
      'avg_vertical_speed': instance.avgVerticalSpeed,
      'avg_slope': instance.avgSlope,
      'max_altitude': instance.maxAltitude,
      'min_altitude': instance.minAltitude,
      'avg_altitude': instance.avgAltitude,
      'altitude_count': instance.altitudeCount,
      'altitude_item': instance.altitudeItem,
      'gps_status': instance.gpsStatus,
      'anaerobic_training_effect': instance.anaerobicTrainingEffect,
      'load': instance.load,
      'running_economy': instance.runningEconomy,
      'max_running_power': instance.maxRunningPower,
      'min_running_power': instance.minRunningPower,
      'avg_running_power': instance.avgRunningPower,
      'running_power_count': instance.runningPowerCount,
      'rtpe_count': instance.rtpeCount,
      'max_rtoc': instance.maxRtoc,
      'min_rtoc': instance.minRtoc,
      'avg_rtoc': instance.avgRtoc,
      'rtoc_count': instance.rtocCount,
      'max_rope_frequency': instance.maxRopeFrequency,
      'min_rope_frequency': instance.minRopeFrequency,
      'avg_rope_frequency': instance.avgRopeFrequency,
      'max_rope_skip_count': instance.maxRopeSkipCount,
      'rope_trip_count': instance.ropeTripCount,
      'total_rope_count': instance.totalRopeCount,
      'rope_item_count': instance.ropeItemCount,
      'km_pace': instance.kmPace,
      'fast_km_pace': instance.fastKmPace,
      'km_pace_count': instance.kmPaceCount,
      'mi_pace_count': instance.miPaceCount,
      'pace_real_time_count': instance.paceRealTimeCount,
      'aerobic_power_interval': instance.aerobicPowerInterval,
      'mixed_oxygen_power_interval': instance.mixedOxygenPowerInterval,
      'threshold_running_power_interval':
          instance.thresholdRunningPowerInterval,
      'intermittent_run_power_interval': instance.intermittentRunPowerInterval,
      'sprint_run_power_interval': instance.sprintRunPowerInterval,
      'stride_count': instance.strideCount,
      'stride_items': instance.strideItems,
      'item_running_power': instance.itemRunningPower,
      'item_rtpe': instance.itemRtpe,
      'item_rtoc': instance.itemRtoc,
      'item_rope_info': instance.itemRopeInfo,
      'smart_competitor': instance.smartCompetitor,
      'ai_image_id': instance.aiImageId,
      'user_image_id': instance.userImageId,
      'bg_image_id': instance.bgImageId,
      'smart_competitor_pace': instance.smartCompetitorPace,
      'tennis_serve_count': instance.tennisServeCount,
      'tennis_forehead_count': instance.tennisForeheadCount,
      'tennis_backhand_count': instance.tennisBackhandCount,
      'trips': instance.trips,
      'average_swolf': instance.averageSwolf,
      'total_strokes_number': instance.totalStrokesNumber,
      'swimming_posture': instance.swimmingPosture,
      'swimming_avg_pace': instance.swimmingAvgPace,
      'avg_frequency': instance.avgFrequency,
      'body_age': instance.bodyAge,
      'swimming_pool_distance': instance.swimmingPoolDistance,
      'swimming_item_count': instance.swimmingItemCount,
      'swimming_items': instance.swimmingItems,
    };

IDOAppHrDataExchangeModel _$IDOAppHrDataExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOAppHrDataExchangeModel(
      version: (json['version'] as num?)?.toInt(),
      heartRateHistoryLen: (json['heart_rate_history_len'] as num?)?.toInt(),
      interval: (json['interval_second'] as num?)?.toInt(),
      heartRates: (json['heart_rate_history'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOAppHrDataExchangeModelToJson(
        IDOAppHrDataExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'version': instance.version,
      'heart_rate_history_len': instance.heartRateHistoryLen,
      'interval_second': instance.interval,
      'heart_rate_history': instance.heartRates,
    };

IDOAppGpsDataExchangeModel _$IDOAppGpsDataExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOAppGpsDataExchangeModel(
      version: (json['version'] as num?)?.toInt(),
      intervalSecond: (json['interval_second'] as num?)?.toInt(),
      gpsCount: (json['GPS_data_len'] as num?)?.toInt(),
      gpsData: (json['GPS_data'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOAppGpsDataExchangeModelToJson(
        IDOAppGpsDataExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'version': instance.version,
      'interval_second': instance.intervalSecond,
      'GPS_data_len': instance.gpsCount,
      'GPS_data': instance.gpsData,
    };

IDOAppBlePauseExchangeModel _$IDOAppBlePauseExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOAppBlePauseExchangeModel()
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOAppBlePauseExchangeModelToJson(
        IDOAppBlePauseExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
    };

IDOAppBlePauseReplyExchangeModel _$IDOAppBlePauseReplyExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOAppBlePauseReplyExchangeModel(
      errCode: (json['err_code'] as num?)?.toInt(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOAppBlePauseReplyExchangeModelToJson(
        IDOAppBlePauseReplyExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'err_code': instance.errCode,
    };

IDOAppBleRestoreExchangeModel _$IDOAppBleRestoreExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOAppBleRestoreExchangeModel()
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOAppBleRestoreExchangeModelToJson(
        IDOAppBleRestoreExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
    };

IDOAppBleRestoreReplyExchangeModel _$IDOAppBleRestoreReplyExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOAppBleRestoreReplyExchangeModel(
      errCode: (json['err_code'] as num?)?.toInt(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOAppBleRestoreReplyExchangeModelToJson(
        IDOAppBleRestoreReplyExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'err_code': instance.errCode,
    };

IDOAppBleEndExchangeModel _$IDOAppBleEndExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOAppBleEndExchangeModel(
      duration: (json['duration'] as num?)?.toInt(),
      calories: (json['calories'] as num?)?.toInt(),
      distance: (json['distance'] as num?)?.toInt(),
      avgHr: (json['avg_hr_value'] as num?)?.toInt(),
      maxHr: (json['max_hr_value'] as num?)?.toInt(),
      burnFatMins: (json['burn_fat_mins'] as num?)?.toInt(),
      aerobicMins: (json['aerobic_mins'] as num?)?.toInt(),
      limitMins: (json['limit_mins'] as num?)?.toInt(),
      isSave: (json['is_save'] as num?)?.toInt(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOAppBleEndExchangeModelToJson(
        IDOAppBleEndExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'duration': instance.duration,
      'calories': instance.calories,
      'distance': instance.distance,
      'avg_hr_value': instance.avgHr,
      'max_hr_value': instance.maxHr,
      'burn_fat_mins': instance.burnFatMins,
      'aerobic_mins': instance.aerobicMins,
      'limit_mins': instance.limitMins,
      'is_save': instance.isSave,
    };

IDOAppBleEndReplyExchangeModel _$IDOAppBleEndReplyExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOAppBleEndReplyExchangeModel(
      errCode: (json['err_code'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      calories: (json['calories'] as num?)?.toInt(),
      distance: (json['distance'] as num?)?.toInt(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOAppBleEndReplyExchangeModelToJson(
        IDOAppBleEndReplyExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'err_code': instance.errCode,
      'duration': instance.duration,
      'calories': instance.calories,
      'distance': instance.distance,
    };

IDOBleStartExchangeModel _$IDOBleStartExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOBleStartExchangeModel(
      operate: (json['operate'] as num?)?.toInt(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOBleStartExchangeModelToJson(
        IDOBleStartExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'operate': instance.operate,
    };

IDOBleIngExchangeModel _$IDOBleIngExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOBleIngExchangeModel(
      distance: (json['distance'] as num?)?.toInt(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOBleIngExchangeModelToJson(
        IDOBleIngExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'distance': instance.distance,
    };

IDOBleEndExchangeModel _$IDOBleEndExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOBleEndExchangeModel()
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOBleEndExchangeModelToJson(
        IDOBleEndExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
    };

IDOBlePauseExchangeModel _$IDOBlePauseExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOBlePauseExchangeModel()
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOBlePauseExchangeModelToJson(
        IDOBlePauseExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
    };

IDOBleRestoreExchangeModel _$IDOBleRestoreExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOBleRestoreExchangeModel()
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOBleRestoreExchangeModelToJson(
        IDOBleRestoreExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
    };

IDOBleStartReplyExchangeModel _$IDOBleStartReplyExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOBleStartReplyExchangeModel(
      operate: (json['operate'] as num?)?.toInt(),
      retCode: (json['ret_code'] as num?)?.toInt(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOBleStartReplyExchangeModelToJson(
        IDOBleStartReplyExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'operate': instance.operate,
      'ret_code': instance.retCode,
    };

IDOBleIngReplyExchangeModel _$IDOBleIngReplyExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOBleIngReplyExchangeModel(
      distance: (json['distance'] as num?)?.toInt(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOBleIngReplyExchangeModelToJson(
        IDOBleIngReplyExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'distance': instance.distance,
    };

IDOBleEndReplyExchangeModel _$IDOBleEndReplyExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOBleEndReplyExchangeModel(
      retCode: (json['ret_code'] as num?)?.toInt(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOBleEndReplyExchangeModelToJson(
        IDOBleEndReplyExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'ret_code': instance.retCode,
    };

IDOBlePauseReplyExchangeModel _$IDOBlePauseReplyExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOBlePauseReplyExchangeModel(
      retCode: (json['ret_code'] as num?)?.toInt(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOBlePauseReplyExchangeModelToJson(
        IDOBlePauseReplyExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'ret_code': instance.retCode,
    };

IDOBleRestoreReplyExchangeModel _$IDOBleRestoreReplyExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOBleRestoreReplyExchangeModel(
      retCode: (json['ret_code'] as num?)?.toInt(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOBleRestoreReplyExchangeModelToJson(
        IDOBleRestoreReplyExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'ret_code': instance.retCode,
    };

IDOAppOperatePlanExchangeModel _$IDOAppOperatePlanExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOAppOperatePlanExchangeModel(
      operate: (json['operate'] as num?)?.toInt(),
      trainingOffset: (json['training_offset'] as num?)?.toInt(),
      planType: (json['type'] as num?)?.toInt(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOAppOperatePlanExchangeModelToJson(
        IDOAppOperatePlanExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'operate': instance.operate,
      'training_offset': instance.trainingOffset,
      'type': instance.planType,
    };

IDOAppOperatePlanReplyExchangeModel
    _$IDOAppOperatePlanReplyExchangeModelFromJson(Map<String, dynamic> json) =>
        IDOAppOperatePlanReplyExchangeModel(
          planType: (json['type'] as num?)?.toInt(),
          operate: (json['operate'] as num?)?.toInt(),
          actionType: (json['action_type'] as num?)?.toInt(),
          errorCode: (json['err_code'] as num?)?.toInt(),
        )
          ..day = (json['day'] as num?)?.toInt()
          ..hour = (json['hour'] as num?)?.toInt()
          ..minute = (json['minute'] as num?)?.toInt()
          ..second = (json['second'] as num?)?.toInt()
          ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOAppOperatePlanReplyExchangeModelToJson(
        IDOAppOperatePlanReplyExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'type': instance.planType,
      'operate': instance.operate,
      'action_type': instance.actionType,
      'err_code': instance.errorCode,
    };

IDOBleOperatePlanExchangeModel _$IDOBleOperatePlanExchangeModelFromJson(
        Map<String, dynamic> json) =>
    IDOBleOperatePlanExchangeModel(
      operate: (json['operate'] as num?)?.toInt(),
      planType: (json['type'] as num?)?.toInt(),
      actionType: (json['action_type'] as num?)?.toInt(),
      errorCode: (json['err_code'] as num?)?.toInt(),
      trainingYear: (json['year'] as num?)?.toInt(),
      trainingMonth: (json['month'] as num?)?.toInt(),
      trainingDay: (json['training_day'] as num?)?.toInt(),
      time: (json['time'] as num?)?.toInt(),
      lowHeart: (json['low_heart'] as num?)?.toInt(),
      heightHeart: (json['height_heart'] as num?)?.toInt(),
    )
      ..day = (json['day'] as num?)?.toInt()
      ..hour = (json['hour'] as num?)?.toInt()
      ..minute = (json['minute'] as num?)?.toInt()
      ..second = (json['second'] as num?)?.toInt()
      ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOBleOperatePlanExchangeModelToJson(
        IDOBleOperatePlanExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'operate': instance.operate,
      'type': instance.planType,
      'action_type': instance.actionType,
      'err_code': instance.errorCode,
      'year': instance.trainingYear,
      'month': instance.trainingMonth,
      'training_day': instance.trainingDay,
      'time': instance.time,
      'low_heart': instance.lowHeart,
      'height_heart': instance.heightHeart,
    };

IDOBleOperatePlanReplyExchangeModel
    _$IDOBleOperatePlanReplyExchangeModelFromJson(Map<String, dynamic> json) =>
        IDOBleOperatePlanReplyExchangeModel(
          operate: (json['operate'] as num?)?.toInt(),
          planType: (json['type'] as num?)?.toInt(),
          actionType: (json['action_type'] as num?)?.toInt(),
          errorCode: (json['err_code'] as num?)?.toInt(),
        )
          ..day = (json['day'] as num?)?.toInt()
          ..hour = (json['hour'] as num?)?.toInt()
          ..minute = (json['minute'] as num?)?.toInt()
          ..second = (json['second'] as num?)?.toInt()
          ..sportType = (json['sport_type'] as num?)?.toInt();

Map<String, dynamic> _$IDOBleOperatePlanReplyExchangeModelToJson(
        IDOBleOperatePlanReplyExchangeModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hour': instance.hour,
      'minute': instance.minute,
      'second': instance.second,
      'sport_type': instance.sportType,
      'operate': instance.operate,
      'type': instance.planType,
      'action_type': instance.actionType,
      'err_code': instance.errorCode,
    };
