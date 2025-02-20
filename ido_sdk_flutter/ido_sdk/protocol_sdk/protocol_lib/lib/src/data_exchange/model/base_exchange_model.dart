import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'base_exchange_model.g.dart';

class IDOBaseExchangeModel {
  /// 日期
  int? day;

  /// 时
  int? hour;

  /// 分钟
  int? minute;

  /// 秒钟
  int? second;

  /// 运动类型
  @JsonKey(name: 'sport_type')
  int? sportType;

  IDOBaseExchangeModel(
      {this.day, this.hour, this.minute, this.second, this.sportType});
}

/// app 开始发起运动
@JsonSerializable()
class IDOAppStartExchangeModel extends IDOBaseExchangeModel {
  /// 目标类型
  @JsonKey(name: 'target_type')
  int? targetType;

  /// 目标值
  @JsonKey(name: 'target_value')
  int? targetValue;

  /// 是否强制开始 0:不强制,1:强制
  @JsonKey(name: 'force_start')
  int? forceStart;

  /// 最大摄氧量 单位 ml/kg/min
  @JsonKey(name: 'vo2max')
  int? vo2max;

  /// 恢复时长：单位小时
  @JsonKey(name: 'recover_time')
  int? recoverTime;

  /// 上个月平均每周的运动时间 单位分钟
  @JsonKey(name: 'avg_week_activity_time')
  int? avgWeekActivityTime;

  IDOAppStartExchangeModel(
      {this.targetValue,
      this.targetType,
      this.forceStart,
      this.vo2max,
      this.recoverTime,
      this.avgWeekActivityTime});

  Map<String, dynamic> toJson() => _$IDOAppStartExchangeModelToJson(this);

  factory IDOAppStartExchangeModel.fromJson(Map<String, dynamic> json) =>
      _$IDOAppStartExchangeModelFromJson(json);
}

/// app 开始发起运动 ble回复
@JsonSerializable()
class IDOAppStartReplyExchangeModel extends IDOBaseExchangeModel {
  /// 0:成功; 1:设备已经进入运动模式失败;
  /// 2:设备电量低失败;3:手环正在充电
  /// 4:正在使用Alexa 5:通话中
  @JsonKey(name: 'ret_code')
  int? retCode;

  IDOAppStartReplyExchangeModel({this.retCode});

  Map<String, dynamic> toJson() => _$IDOAppStartReplyExchangeModelToJson(this);

  factory IDOAppStartReplyExchangeModel.fromJson(Map<String, dynamic> json) =>
      _$IDOAppStartReplyExchangeModelFromJson(json);
}

/// app 发起运动结束
@JsonSerializable()
class IDOAppEndExchangeModel extends IDOBaseExchangeModel {
  /// 持续时长（单位：s）
  int? duration;

  /// 卡路里，单位大卡
  int? calories;

  /// 距离（单位：米）
  int? distance;

  /// 0:不保存，1:保存
  @JsonKey(name: 'is_save')
  int? isSave;

  IDOAppEndExchangeModel(
      {this.duration, this.calories, this.distance, this.isSave});

  Map<String, dynamic> toJson() => _$IDOAppEndExchangeModelToJson(this);

  factory IDOAppEndExchangeModel.fromJson(Map<String, dynamic> json) =>
      _$IDOAppEndExchangeModelFromJson(json);
}

/// app 发起运动结束 ble回复
@JsonSerializable()
class IDOAppEndReplyExchangeModel extends IDOBaseExchangeModel {
  /// 0:成功; 1:设备结束失败
  @JsonKey(name: 'err_code')
  int? errorCode;

  /// 卡路里，单位大卡
  int? calories;

  /// 距离（单位：米）
  int? distance;

  /// 步数 (单位:步)
  int? step;

  /// 平均心率
  @JsonKey(name: 'avg_hr_value')
  int? avgHr;

  /// 最大心率
  @JsonKey(name: 'max_hr_value')
  int? maxHr;

  /// 脂肪燃烧时长 单位分钟
  @JsonKey(name: 'burn_fat_mins')
  int? burnFatMins;

  /// 心肺锻炼时长 单位分钟
  @JsonKey(name: 'aerobic_mins')
  int? aerobicMins;

  /// 极限锻炼时长 单位分钟
  @JsonKey(name: 'limit_mins')
  int? limitMins;

  IDOAppEndReplyExchangeModel(
      {this.errorCode,
      this.calories,
      this.distance,
      this.step,
      this.avgHr,
      this.maxHr,
      this.burnFatMins,
      this.aerobicMins,
      this.limitMins});

  Map<String, dynamic> toJson() => _$IDOAppEndReplyExchangeModelToJson(this);

  factory IDOAppEndReplyExchangeModel.fromJson(Map<String, dynamic> json) =>
      _$IDOAppEndReplyExchangeModelFromJson(json);
}

/// app 交换运动数据
@JsonSerializable()
class IDOAppIngExchangeModel extends IDOBaseExchangeModel {
  /// 持续时长 单位s
  int? duration;

  /// 卡路里 单位大卡
  int? calories;

  /// 距离 单位0.01km
  int? distance;

  /// 0: 全部有效、1: 距离无效、 2: GPS信号弱
  int? status;

  IDOAppIngExchangeModel(
      {this.calories, this.distance, this.duration, this.status});

  Map<String, dynamic> toJson() => _$IDOAppIngExchangeModelToJson(this);

  factory IDOAppIngExchangeModel.fromJson(Map<String, dynamic> json) =>
      _$IDOAppIngExchangeModelFromJson(json);
}

/// app 交换运动数据 ble回复
@JsonSerializable()
class IDOAppIngReplyExchangeModel extends IDOBaseExchangeModel {
  /// 卡路里 单位大卡
  int? calories;

  /// 距离 单位0.01km
  int? distance;

  /// 0: 全部有效、1: 距离无效、 2: GPS信号弱
  int? status;

  /// 步数
  int? step;

  /// 当前心率
  @JsonKey(name: 'cur_hr_value')
  int? currentHr;

  /// 心率间隔 单位s
  @JsonKey(name: 'interval_second')
  int? interval;

  /// 序列号
  @JsonKey(name: 'hr_value_serial')
  int? hrSerial;

  /// 心率值数据
  @JsonKey(name: 'hr_value')
  List<int>? hrJson;

  IDOAppIngReplyExchangeModel(
      {this.calories,
      this.distance,
      this.status,
      this.step,
      this.currentHr,
      this.interval,
      this.hrSerial,
      this.hrJson});

  Map<String, dynamic> toJson() => _$IDOAppIngReplyExchangeModelToJson(this);

  factory IDOAppIngReplyExchangeModel.fromJson(Map<String, dynamic> json) =>
      _$IDOAppIngReplyExchangeModelFromJson(json);
}

/// app 交换运动数据暂停
@JsonSerializable()
class IDOAppPauseExchangeModel extends IDOBaseExchangeModel {
  /// 暂停时
  @JsonKey(name: 'sport_hour')
  int? pauseHour;

  /// 暂停分
  @JsonKey(name: 'sport_minute')
  int? pauseMinute;

  /// 暂停秒
  @JsonKey(name: 'sport_second')
  int? pauseSecond;

  IDOAppPauseExchangeModel(
      {this.pauseHour, this.pauseMinute, this.pauseSecond});

  Map<String, dynamic> toJson() => _$IDOAppPauseExchangeModelToJson(this);

  factory IDOAppPauseExchangeModel.fromJson(Map<String, dynamic> json) =>
      _$IDOAppPauseExchangeModelFromJson(json);
}

/// app 交换运动数据暂停 ble回复
@JsonSerializable()
class IDOAppPauseReplyExchangeModel extends IDOBaseExchangeModel {
  /// 暂停错误码 0:成功 非0:失败
  @JsonKey(name: 'err_code')
  int? errCode;

  IDOAppPauseReplyExchangeModel({this.errCode});

  Map<String, dynamic> toJson() => _$IDOAppPauseReplyExchangeModelToJson(this);

  factory IDOAppPauseReplyExchangeModel.fromJson(Map<String, dynamic> json) =>
      _$IDOAppPauseReplyExchangeModelFromJson(json);
}

/// app 交换运动数据恢复
@JsonSerializable()
class IDOAppRestoreExchangeModel extends IDOBaseExchangeModel {
  IDOAppRestoreExchangeModel();

  Map<String, dynamic> toJson() => _$IDOAppRestoreExchangeModelToJson(this);

  factory IDOAppRestoreExchangeModel.fromJson(Map<String, dynamic> json) =>
      _$IDOAppRestoreExchangeModelFromJson(json);
}

/// app 交换运动数据恢复 ble回复
@JsonSerializable()
class IDOAppRestoreReplyExchangeModel extends IDOBaseExchangeModel {
  /// 暂停错误码 0:成功 非0:失败
  @JsonKey(name: 'err_code')
  int? errCode;

  IDOAppRestoreReplyExchangeModel({this.errCode});

  Map<String, dynamic> toJson() =>
      _$IDOAppRestoreReplyExchangeModelToJson(this);

  factory IDOAppRestoreReplyExchangeModel.fromJson(Map<String, dynamic> json) =>
      _$IDOAppRestoreReplyExchangeModelFromJson(json);
}

/// app v3交换运动数据
@JsonSerializable()
class IDOAppIngV3ExchangeModel extends IDOBaseExchangeModel {
  /// 协议版本号
  int? version;

  /// 0: 表示信号弱 2: 表示信号强
  @JsonKey(name: 'signal_flag')
  int? signal;

  /// app 距离
  int? distance;

  /// app计算显示实时配速，单位km/h，100倍
  @JsonKey(name: 'real_time_speed')
  int? speed;

  /// 持续时间
  int? duration;

  /// 卡路里
  int? calories;

  /// gps个数 最多30个
  @JsonKey(name: 'gps_info_count')
  int? gpsInfoCount;

  /// 坐标数据 最多30个
  /// ```dart
  /// example: "gps" : [
  ///     {
  ///       "latitude" :22543100,
  ///       "longitude" :114057800
  ///     },
  ///     {
  ///       "latitude" :23129100,
  ///       "longitude" :113264400
  ///     }
  ///   ]
  ///   ```
  List<Map<String, int>>? gps;

  IDOAppIngV3ExchangeModel(
      {this.version,
      this.signal,
      this.distance,
      this.speed,
      this.duration,
      this.calories,
      this.gpsInfoCount,
      this.gps});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> newMap = {};
    final map = _$IDOAppIngV3ExchangeModelToJson(this);
    map.forEach((key, value) {
      var newKey = key;
      if (key == 'sport_type') {
        /// 替换key
        newKey = key.replaceAll('sport_type', 'type');
      }
      newMap[newKey] = value;
    });
    return newMap;
  }

  factory IDOAppIngV3ExchangeModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> newJson = {};
    json.forEach((key, value) {
      var newKey = key;
      if (key == 'type') {
        /// 替换key
        newKey = key.replaceAll('type', 'sport_type');
      }
      newJson[newKey] = value;
    });
    return _$IDOAppIngV3ExchangeModelFromJson(newJson);
  }
}

/// app v3交换运动数据 ble回复
@JsonSerializable()
class IDOAppIngV3ReplyExchangeModel extends IDOBaseExchangeModel {
  /// 协议版本号
  int? version;

  /// 心率数据
  @JsonKey(name: 'heart_rate')
  int? heartRate;

  /// 距离 单位根据单位设置的单位显示
  int? distance;

  /// 持续时间 秒钟
  int? duration;

  /// 动态卡路里
  @JsonKey(name: 'real_time_calories')
  int? realTimeCalories;

  /// 实时速度，单位km/h，扩大100倍
  @JsonKey(name: 'real_time_speed')
  int? realTimeSpeed;

  /// 实时公里配速 单位s/公里
  @JsonKey(name: 'km_speed')
  int? kmSpeed;

  /// 步数
  int? steps;

  /// 主泳姿
  @JsonKey(name: 'swim_posture')
  int? swimPosture;

  /// 状态 0：无效 1：开始 2：手动暂停 3：结束 4：自动暂停
  int? status;

  /// 实时的配速，单位秒，5秒使用滑动平均，第5秒使用1-5秒数据，第6秒使用2-6秒数据
  @JsonKey(name: 'real_time_speed_pace')
  int? realTimeSpeedPace;

  /// 有氧训练效果等级  单位无  范围 0-50 扩大10倍传输
  @JsonKey(name: 'te')
  int? trainingEffect;

  /// 无氧运动训练效果等级 单位无  范围 0-50 扩大10倍传输
  @JsonKey(name: 'tean')
  int? anaerobicTrainingEffect;

  /// 动作类型
  /// 1快走
  /// 2慢跑
  /// 3中速跑
  /// 4快跑
  /// 5结束课程运动 （还要等待用户是否有自由运动）
  /// 6课程结束后自由运动（此字段当operate为5起作用）
  /// 运动累积时间=课程内训练时间+课程结束后计时
  @JsonKey(name: 'action_type')
  int? actionType;

  /// 需要固件开启功能表
  /// action_type = 1—5时，该字段是运动倒计时时间（注：时间递减）
  /// action_type = 6时，该字段是课程结束后计时（注：时间递增）
  @JsonKey(name: 'count_hour')
  int? countHour;

  /// 需要固件开启功能表
  /// action_type = 1—5时，该字段是运动倒计时时间（注：时间递减）
  /// action_type = 6时，该字段是课程结束后计时（注：时间递增）
  @JsonKey(name: 'count_minute')
  int? countMinute;

  /// 需要固件开启功能表
  /// action_type = 1—5时，该字段是运动倒计时时间（注：时间递减）
  /// action_type = 6时，该字段是课程结束后计时（注：时间递增）
  @JsonKey(name: 'count_second')
  int? countSecond;

  IDOAppIngV3ReplyExchangeModel({
    this.version,
    this.heartRate,
    this.distance,
    this.duration,
    this.realTimeCalories,
    this.realTimeSpeed,
    this.kmSpeed,
    this.steps,
    this.swimPosture,
    this.status,
    this.realTimeSpeedPace,
    this.trainingEffect,
    this.anaerobicTrainingEffect,
    this.actionType,
    this.countHour,
    this.countMinute,
    this.countSecond,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> newMap = {};
    final map = _$IDOAppIngV3ReplyExchangeModelToJson(this);
    map.forEach((key, value) {
      var newKey = key;
      if (key == 'sport_type') {
        /// 替换key
        newKey = key.replaceAll('sport_type', 'type');
      }
      newMap[newKey] = value;
    });
    return newMap;
  }

  factory IDOAppIngV3ReplyExchangeModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> newJson = {};
    json.forEach((key, value) {
      var newKey = key;
      if (key == 'type') {
        /// 替换key
        newKey = key.replaceAll('type', 'sport_type');
      }
      newJson[newKey] = value;
    });
    return _$IDOAppIngV3ReplyExchangeModelFromJson(newJson);
  }
}

/// app 获取v3多运动数据
@JsonSerializable()
class IDOAppActivityDataV3ExchangeModel extends IDOBaseExchangeModel {
  /// 年份
  int? year;

  /// 月份
  int? month;

  /// 协议库版本号
  int? version;

  /// 心率间隔 单位分钟
  @JsonKey(name: 'hr_data_interval_minute')
  int? hrInterval;

  /// 步数
  int? step;

  /// 持续时间
  int? durations;

  /// 卡路里
  int? calories;

  /// 距离
  int? distance;

  /// 脂肪燃烧的心率持续时间 单位分钟
  @JsonKey(name: 'burn_fat_mins')
  int? burnFatMins;

  /// 有氧运动的持续时间 单位分钟
  @JsonKey(name: 'aerobic_mins')
  int? aerobicMins;

  /// 极限锻炼的持续时间 单位分钟
  @JsonKey(name: 'limit_mins')
  int? limitMins;

  /// 热身运动
  @JsonKey(name: 'warm_up')
  int? warmUp;

  /// 脂肪燃烧
  @JsonKey(name: 'fat_burning')
  int? fatBurning;

  /// 有氧训练
  @JsonKey(name: 'aerobic_exercise')
  int? aerobicExercise;

  /// 无氧训练
  @JsonKey(name: 'anaerobic_exercise')
  int? anaerobicExercise;

  /// 极限训练
  @JsonKey(name: 'extreme_exercise')
  int? extremeExercise;

  /// 热身运动的累计时长 单位秒
  @JsonKey(name: 'warm_up_time')
  int? warmUpTime;

  /// 脂肪燃烧的累计时长 单位秒
  @JsonKey(name: 'fat_burning_time')
  int? fatBurningTime;

  /// 有氧运动的累计时长 单位秒
  @JsonKey(name: 'aerobic_exercise_time')
  int? aerobicExerciseTime;

  /// 无氧运动的累计时长 单位秒
  @JsonKey(name: 'anaerobic_exercise_time')
  int? anaerobicExerciseTime;

  /// 极限锻炼的累计时长 单位秒
  @JsonKey(name: 'extreme_exercise_time')
  int? extremeExerciseTime;

  /// 平均速度 单位km/h
  @JsonKey(name: 'avg_speed')
  int? avgSpeed;

  /// 最快速度 单位km/h
  @JsonKey(name: 'max_speed')
  int? maxSpeed;

  /// 平均步幅
  @JsonKey(name: 'avg_step_stride')
  int? avgStepStride;

  /// 最大步幅
  @JsonKey(name: 'max_step_stride')
  int? maxStepStride;

  /// 平均公里配速
  @JsonKey(name: 'km_speed')
  int? kmSpeed;

  /// 最快公里配速
  @JsonKey(name: 'fast_km_speed')
  int? fastKmSpeed;

  /// 平均步频
  @JsonKey(name: 'avg_step_frequency')
  int? avgStepFrequency;

  /// 最大步频
  @JsonKey(name: 'max_step_frequency')
  int? maxStepFrequency;

  /// 平均心率
  @JsonKey(name: 'avg_hr_value')
  int? avgHrValue;

  /// 最大心率
  @JsonKey(name: 'max_hr_value')
  int? maxHrValue;

  /// 恢复时长 单位小时 app收到该数据之后，每过1小时需要自减1
  @JsonKey(name: 'recover_time')
  int? recoverTime;

  /// 最大摄氧量 单位 ml/kg/min
  @JsonKey(name: 'vo2max')
  int? vo2max;

  /// 训练效果 范围： 1.0 - 5.0 （扩大10倍传输）
  @JsonKey(name: 'training_effect')
  int? trainingEffect;

  /// 摄氧量等级 1：低等 2：业余 3：一般 4：平均 5：良好 6：优秀 7：专业
  @JsonKey(name: 'grade')
  int? grade;

  /// 步频详情个数
  @JsonKey(name: 'steps_frequency_count')
  int? stepsFrequencyCount;

  /// 英里配速个数 最大100
  @JsonKey(name: 'mi_speed_count')
  int? miSpeedCount;

  /// 实时速度个数
  @JsonKey(name: 'real_speed_count')
  int? realSpeedCount;

  /// 实时配速个数
  @JsonKey(name: 'pace_speed_count')
  int? paceSpeedCount;

  /// 公里配速详情个数 最大100
  @JsonKey(name: 'km_speed_count')
  int? kmSpeedCount;

  /// 本次动作训练个数
  @JsonKey(name: 'action_data_count')
  int? actionDataCount;

  /// 课程内运动热量 单位千卡
  @JsonKey(name: 'in_class_calories')
  int? inClassCalories;

  /// 动作完成率 0—100
  @JsonKey(name: 'completion_rate')
  int? completionRate;

  /// 心率控制率 0—100
  @JsonKey(name: 'hr_completion_rate')
  int? hrCompletionRate;

  /// 分段数据个数
  @JsonKey(name: 'segdata_item_num')
  int? segmentItemNum;

  /// 分段数据总时间 单位秒
  @JsonKey(name: 'segdata_total_time')
  int? segmentTotalTime;

  /// 分段数据总距离 单位米
  @JsonKey(name: 'segdata_total_distance')
  int? segmentTotalDistance;

  /// 分段数据总配速 单位秒/百米
  @JsonKey(name: 'segdata_total_pace')
  int? segmentTotalPace;

  ///分段数据总平均心率
  @JsonKey(name: 'segdata_total_avg_hr')
  int? segmentTotalAvgHr;

  /// 分段数据总步频 单位次/分
  @JsonKey(name: 'segdata_total_avg_step_frequency')
  int? segmentTotalAvgStepFrequency;

  /// 区间配速
  /// 高强度间歇配速 单位秒/百米
  @JsonKey(name: 'pace_hiit')
  int? paceHiit;

  /// 区间配速
  /// 无氧配速
  /// 单位秒/百米
  @JsonKey(name: 'pace_anaerobic')
  int? paceAnaerobic;

  /// 区间配速
  /// 乳酸阈配速
  /// 单位秒/百米
  @JsonKey(name: 'pace_lactic_acid_threshold')
  int? paceLacticAcidThreshold;

  /// 区间配速
  /// 马拉松配速
  /// 单位秒/百米
  @JsonKey(name: 'pace_marathon')
  int? paceMarathon;

  /// 区间配速
  /// 轻松跑配速
  /// 单位秒/百米
  @JsonKey(name: 'pace_easy_run')
  int? paceEasyRun;

  /// 每公里耗时秒数 配速集合
  @JsonKey(name: 'km_speed_s')
  List<int>? kmSpeeds;

  /// 步频集合 单位步/分钟
  @JsonKey(name: 'steps_frequency')
  List<int>? stepsFrequency;

  /// 英里配速数组
  @JsonKey(name: 'items_mi_speed')
  List<int>? itemsMiSpeed;

  /// 实时速度数组 单位km/h
  @JsonKey(name: 'item_real_speed')
  List<int>? itemRealSpeed;

  /// 实时配速数组
  @JsonKey(name: 'pace_speed_items')
  List<int>? paceSpeedItems;

  /// 分段数据详情
  /// index ：分段序号
  /// time: 用时 单位秒
  /// distance: 距离 单位米
  /// pace: 配速 单位秒/百米
  /// avg_hr: 平均心率 单位次/分
  /// avg_step_frequency: 平均步频 单位次/分
  @JsonKey(name: 'seg_items')
  List<Map<String, dynamic>>? segmentItems;

  ///  动作完成内容
  ///  type : 动作类型  1快走；2慢跑; 3中速跑；4快跑
  ///  heart_con_value : 每个动作心率控制
  ///  time : 动作完成时间 单位秒
  ///  goal_timegoal_time ：动作目标时间
  @JsonKey(name: 'items')
  List<Map<String, dynamic>>? actionData;

  IDOAppActivityDataV3ExchangeModel(
      {this.year,
      this.month,
      this.version,
      this.hrInterval,
      this.step,
      this.durations,
      this.calories,
      this.distance,
      this.burnFatMins,
      this.aerobicMins,
      this.limitMins,
      this.warmUp,
      this.fatBurning,
      this.aerobicExercise,
      this.anaerobicExercise,
      this.extremeExercise,
      this.warmUpTime,
      this.fatBurningTime,
      this.aerobicExerciseTime,
      this.anaerobicExerciseTime,
      this.extremeExerciseTime,
      this.avgSpeed,
      this.avgStepStride,
      this.maxStepStride,
      this.kmSpeed,
      this.fastKmSpeed,
      this.avgStepFrequency,
      this.maxStepFrequency,
      this.avgHrValue,
      this.maxHrValue,
      this.kmSpeedCount,
      this.actionDataCount,
      this.stepsFrequencyCount,
      this.miSpeedCount,
      this.recoverTime,
      this.vo2max,
      this.trainingEffect,
      this.grade,
      this.realSpeedCount,
      this.paceSpeedCount,
      this.inClassCalories,
      this.completionRate,
      this.hrCompletionRate,
      this.segmentItemNum,
      this.segmentTotalTime,
      this.segmentTotalDistance,
      this.segmentTotalPace,
      this.segmentTotalAvgHr,
      this.segmentTotalAvgStepFrequency,
      this.paceHiit,
      this.paceAnaerobic,
      this.paceLacticAcidThreshold,
      this.paceMarathon,
      this.paceEasyRun,
      this.kmSpeeds,
      this.stepsFrequency,
      this.itemsMiSpeed,
      this.itemRealSpeed,
      this.paceSpeedItems,
      this.actionData,
      this.segmentItems});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> newMap = {};
    final map = _$IDOAppActivityDataV3ExchangeModelToJson(this);
    map.forEach((key, value) {
      var newKey = key;
      if (key == 'sport_type') {
        /// 替换key
        newKey = key.replaceAll('sport_type', 'type');
      }
      newMap[newKey] = value;
    });
    return newMap;
  }

  factory IDOAppActivityDataV3ExchangeModel.fromJson(
      Map<String, dynamic> json) {
    Map<String, dynamic> newJson = {};
    json.forEach((key, value) {
      var newKey = key;
      if (key == 'type') {
        /// 替换key
        newKey = key.replaceAll('type', 'sport_type');
      }
      newJson[newKey] = value;
    });
    return _$IDOAppActivityDataV3ExchangeModelFromJson(newJson);
  }
}

/// app v3 多运动数交换中获取1分钟心率数据
@JsonSerializable()
class IDOAppHrDataExchangeModel extends IDOBaseExchangeModel {
  /// 协议版本号
  int? version;

  /// 心率数据数组长度 最大60
  @JsonKey(name: 'heart_rate_history_len')
  int? heartRateHistoryLen;

  /// 心率间隔 单位秒
  @JsonKey(name: 'interval_second')
  int? interval;

  /// 心率数据数组 存一分钟的心率数据, 1s存一个
  @JsonKey(name: 'heart_rate_history')
  List<int>? heartRates;

  IDOAppHrDataExchangeModel(
      {this.version, this.heartRateHistoryLen, this.interval, this.heartRates});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> newMap = {};
    final map = _$IDOAppHrDataExchangeModelToJson(this);
    map.forEach((key, value) {
      var newKey = key;
      if (key == 'sport_type') {
        /// 替换key
        newKey = key.replaceAll('sport_type', 'type');
      }
      newMap[newKey] = value;
    });
    return newMap;
  }

  factory IDOAppHrDataExchangeModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> newJson = {};
    json.forEach((key, value) {
      var newKey = key;
      if (key == 'type') {
        /// 替换key
        newKey = key.replaceAll('type', 'sport_type');
      }
      newJson[newKey] = value;
    });
    return _$IDOAppHrDataExchangeModelFromJson(newJson);
  }
}

/// app v3 多运动数据交换中获取GPS经纬度数据
@JsonSerializable()
class IDOAppGpsDataExchangeModel extends IDOBaseExchangeModel {
  /// 协议版本号
  int? version;

  /// 坐标点时间间隔 单位秒
  @JsonKey(name: 'interval_second')
  int? intervalSecond;

  /// 坐标点个数
  @JsonKey(name: 'GPS_data_len')
  int? gpsCount;

  /// gps数据详情集合 [{'latitude':0,'longitude':0}]
  @JsonKey(name: 'GPS_data')
  List<Map<String, dynamic>>? gpsData;

  IDOAppGpsDataExchangeModel(
      {this.version, this.intervalSecond, this.gpsCount, this.gpsData});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> newMap = {};
    final map = _$IDOAppGpsDataExchangeModelToJson(this);
    map.forEach((key, value) {
      var newKey = key;
      if (key == 'sport_type') {
        /// 替换key
        newKey = key.replaceAll('sport_type', 'type');
      }
      newMap[newKey] = value;
    });
    return newMap;
  }

  factory IDOAppGpsDataExchangeModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> newJson = {};
    json.forEach((key, value) {
      var newKey = key;
      if (key == 'type') {
        /// 替换key
        newKey = key.replaceAll('type', 'sport_type');
      }
      newJson[newKey] = value;
    });
    return _$IDOAppGpsDataExchangeModelFromJson(newJson);
  }
}

/// app发起运动 ble设备发送交换运动数据暂停
@JsonSerializable()
class IDOAppBlePauseExchangeModel extends IDOBaseExchangeModel {
  IDOAppBlePauseExchangeModel();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> newMap = {};
    final map = _$IDOAppBlePauseExchangeModelToJson(this);
    map.forEach((key, value) {
      var newKey = key;
      if (key == 'sport_type') {
        /// 替换key
        newKey = key.replaceAll('sport_type', 'type');
      }
      newMap[newKey] = value;
    });
    return newMap;
  }

  factory IDOAppBlePauseExchangeModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> newJson = {};
    json.forEach((key, value) {
      var newKey = key;
      if (key == 'type') {
        /// 替换key
        newKey = key.replaceAll('type', 'sport_type');
      }
      newJson[newKey] = value;
    });
    return _$IDOAppBlePauseExchangeModelFromJson(newJson);
  }
}

/// app发起运动 ble设备发送交换运动数据暂停 app回复
@JsonSerializable()
class IDOAppBlePauseReplyExchangeModel extends IDOBaseExchangeModel {
  /// 0: 成功; 1: 没有进入运动模式失败
  @JsonKey(name: 'err_code')
  int? errCode;

  IDOAppBlePauseReplyExchangeModel({this.errCode});

  Map<String, dynamic> toJson() =>
      _$IDOAppBlePauseReplyExchangeModelToJson(this);

  factory IDOAppBlePauseReplyExchangeModel.fromJson(
          Map<String, dynamic> json) =>
      _$IDOAppBlePauseReplyExchangeModelFromJson(json);
}

//
/// app发起运动 ble设备发送交换运动数据恢复
@JsonSerializable()
class IDOAppBleRestoreExchangeModel extends IDOBaseExchangeModel {
  IDOAppBleRestoreExchangeModel();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> newMap = {};
    final map = _$IDOAppBleRestoreExchangeModelToJson(this);
    map.forEach((key, value) {
      var newKey = key;
      if (key == 'sport_type') {
        /// 替换key
        newKey = key.replaceAll('sport_type', 'type');
      }
      newMap[newKey] = value;
    });
    return newMap;
  }

  factory IDOAppBleRestoreExchangeModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> newJson = {};
    json.forEach((key, value) {
      var newKey = key;
      if (key == 'type') {
        /// 替换key
        newKey = key.replaceAll('type', 'sport_type');
      }
      newJson[newKey] = value;
    });
    return _$IDOAppBleRestoreExchangeModelFromJson(newJson);
  }
}

//
/// app发起运动 ble设备发送交换运动数据恢复 app回复
@JsonSerializable()
class IDOAppBleRestoreReplyExchangeModel extends IDOBaseExchangeModel {
  /// 0: 成功; 1: 没有进入运动模式失败
  @JsonKey(name: 'err_code')
  int? errCode;

  IDOAppBleRestoreReplyExchangeModel({this.errCode});

  Map<String, dynamic> toJson() =>
      _$IDOAppBleRestoreReplyExchangeModelToJson(this);

  factory IDOAppBleRestoreReplyExchangeModel.fromJson(
          Map<String, dynamic> json) =>
      _$IDOAppBleRestoreReplyExchangeModelFromJson(json);
}

//
/// app发起运动 ble设备发送交换运动数据结束
@JsonSerializable()
class IDOAppBleEndExchangeModel extends IDOBaseExchangeModel {
  /// 持续时长 单位s
  int? duration;

  /// 卡路里 单位大卡
  int? calories;

  /// 距离 单位0.01km
  int? distance;

  /// 平均心率
  @JsonKey(name: 'avg_hr_value')
  int? avgHr;

  /// 最大心率
  @JsonKey(name: 'max_hr_value')
  int? maxHr;

  /// 脂肪燃烧时长 单位分钟
  @JsonKey(name: 'burn_fat_mins')
  int? burnFatMins;

  /// 心肺锻炼时长 单位分钟
  @JsonKey(name: 'aerobic_mins')
  int? aerobicMins;

  /// 极限锻炼时长 单位分钟
  @JsonKey(name: 'limit_mins')
  int? limitMins;

  /// 0:不保存，1:保存
  @JsonKey(name: 'is_save')
  int? isSave;

  IDOAppBleEndExchangeModel(
      {this.duration,
      this.calories,
      this.distance,
      this.avgHr,
      this.maxHr,
      this.burnFatMins,
      this.aerobicMins,
      this.limitMins,
      this.isSave});

  Map<String, dynamic> toJson() => _$IDOAppBleEndExchangeModelToJson(this);

  factory IDOAppBleEndExchangeModel.fromJson(Map<String, dynamic> json) =>
      _$IDOAppBleEndExchangeModelFromJson(json);
}

//
/// app发起运动 ble设备发送交换运动数据结束 app回复
@JsonSerializable()
class IDOAppBleEndReplyExchangeModel extends IDOBaseExchangeModel {
  /// 0: 成功; 1: 没有进入运动模式失败
  @JsonKey(name: 'err_code')
  int? errCode;

  ///持续时长 单位s
  int? duration;

  ///卡路里 单位大卡
  int? calories;

  ///距离 单位0.01km
  int? distance;

  IDOAppBleEndReplyExchangeModel(
      {this.errCode, this.duration, this.calories, this.distance});

  Map<String, dynamic> toJson() => _$IDOAppBleEndReplyExchangeModelToJson(this);

  factory IDOAppBleEndReplyExchangeModel.fromJson(Map<String, dynamic> json) =>
      _$IDOAppBleEndReplyExchangeModelFromJson(json);
}

/// ble发起运动 ble设备发送交换运动数据开始
@JsonSerializable()
class IDOBleStartExchangeModel extends IDOBaseExchangeModel {
  /// 1：请求app打开gps 2：发起运动请求
  int? operate;

  IDOBleStartExchangeModel({this.operate});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> newMap = {};
    final map = _$IDOBleStartExchangeModelToJson(this);
    map.forEach((key, value) {
      var newKey = key;
      if (key == 'sport_type') {
        /// 替换key
        newKey = key.replaceAll('sport_type', 'type');
      }
      newMap[newKey] = value;
    });
    return newMap;
  }

  factory IDOBleStartExchangeModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> newJson = {};
    json.forEach((key, value) {
      var newKey = key;
      if (key == 'type') {
        /// 替换key
        newKey = key.replaceAll('type', 'sport_type');
      }
      newJson[newKey] = value;
    });
    return _$IDOBleStartExchangeModelFromJson(newJson);
  }
}

//
/// ble发起的运动 ble设备交换运动数据过程中
@JsonSerializable()
class IDOBleIngExchangeModel extends IDOBaseExchangeModel {
  /// 距离 单位：0.01km
  int? distance;

  IDOBleIngExchangeModel({this.distance});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> newMap = {};
    final map = _$IDOBleIngExchangeModelToJson(this);
    map.forEach((key, value) {
      var newKey = key;
      if (key == 'sport_type') {
        /// 替换key
        newKey = key.replaceAll('sport_type', 'type');
      }
      newMap[newKey] = value;
    });
    return newMap;
  }

  factory IDOBleIngExchangeModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> newJson = {};
    json.forEach((key, value) {
      var newKey = key;
      if (key == 'type') {
        /// 替换key
        newKey = key.replaceAll('type', 'sport_type');
      }
      newJson[newKey] = value;
    });
    return _$IDOBleIngExchangeModelFromJson(newJson);
  }
}

/// ble发起的运动 ble设备发送交换运动数据结束
@JsonSerializable()
class IDOBleEndExchangeModel extends IDOBaseExchangeModel {
  IDOBleEndExchangeModel();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> newMap = {};
    final map = _$IDOBleEndExchangeModelToJson(this);
    map.forEach((key, value) {
      var newKey = key;
      if (key == 'sport_type') {
        /// 替换key
        newKey = key.replaceAll('sport_type', 'type');
      }
      newMap[newKey] = value;
    });
    return newMap;
  }

  factory IDOBleEndExchangeModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> newJson = {};
    json.forEach((key, value) {
      var newKey = key;
      if (key == 'type') {
        /// 替换key
        newKey = key.replaceAll('type', 'sport_type');
      }
      newJson[newKey] = value;
    });
    return _$IDOBleEndExchangeModelFromJson(newJson);
  }
}

/// ble发起的运动 ble设备发送交换运动数据暂停
@JsonSerializable()
class IDOBlePauseExchangeModel extends IDOBaseExchangeModel {
  IDOBlePauseExchangeModel();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> newMap = {};
    final map = _$IDOBlePauseExchangeModelToJson(this);
    map.forEach((key, value) {
      var newKey = key;
      if (key == 'sport_type') {
        /// 替换key
        newKey = key.replaceAll('sport_type', 'type');
      }
      newMap[newKey] = value;
    });
    return newMap;
  }

  factory IDOBlePauseExchangeModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> newJson = {};
    json.forEach((key, value) {
      var newKey = key;
      if (key == 'type') {
        /// 替换key
        newKey = key.replaceAll('type', 'sport_type');
      }
      newJson[newKey] = value;
    });
    return _$IDOBlePauseExchangeModelFromJson(newJson);
  }
}

/// ble发起的运动 ble设备发送交换运动数据恢复
@JsonSerializable()
class IDOBleRestoreExchangeModel extends IDOBaseExchangeModel {
  IDOBleRestoreExchangeModel();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> newMap = {};
    final map = _$IDOBleRestoreExchangeModelToJson(this);
    map.forEach((key, value) {
      var newKey = key;
      if (key == 'sport_type') {
        /// 替换key
        newKey = key.replaceAll('sport_type', 'type');
      }
      newMap[newKey] = value;
    });
    return newMap;
  }

  factory IDOBleRestoreExchangeModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> newJson = {};
    json.forEach((key, value) {
      var newKey = key;
      if (key == 'type') {
        /// 替换key
        newKey = key.replaceAll('type', 'sport_type');
      }
      newJson[newKey] = value;
    });
    return _$IDOBleRestoreExchangeModelFromJson(newJson);
  }
}

/// ble发起的运动 ble设备发送交换运动数据开始 app回复
@JsonSerializable()
class IDOBleStartReplyExchangeModel extends IDOBaseExchangeModel {
  /// 1：请求app打开gps 2：发起运动请求
  int? operate;

  /// 0: 成功 非0: 失败
  @JsonKey(name: 'ret_code')
  int? retCode;

  IDOBleStartReplyExchangeModel({this.operate, this.retCode});

  Map<String, dynamic> toJson() => _$IDOBleStartReplyExchangeModelToJson(this);

  factory IDOBleStartReplyExchangeModel.fromJson(Map<String, dynamic> json) =>
      _$IDOBleStartReplyExchangeModelFromJson(json);
}

//
/// ble发起的运动 ble设备交换运动数据过程中 app回复
@JsonSerializable()
class IDOBleIngReplyExchangeModel extends IDOBaseExchangeModel {
  /// 距离 单位：0.01km
  int? distance;

  IDOBleIngReplyExchangeModel({this.distance});

  Map<String, dynamic> toJson() => _$IDOBleIngReplyExchangeModelToJson(this);

  factory IDOBleIngReplyExchangeModel.fromJson(Map<String, dynamic> json) =>
      _$IDOBleIngReplyExchangeModelFromJson(json);
}

/// ble发起的运动 ble设备发送交换运动数据结束 app回复
@JsonSerializable()
class IDOBleEndReplyExchangeModel extends IDOBaseExchangeModel {
  /// 0: 成功 非0: 失败
  @JsonKey(name: 'ret_code')
  int? retCode;

  IDOBleEndReplyExchangeModel({this.retCode});

  Map<String, dynamic> toJson() => _$IDOBleEndReplyExchangeModelToJson(this);

  factory IDOBleEndReplyExchangeModel.fromJson(Map<String, dynamic> json) =>
      _$IDOBleEndReplyExchangeModelFromJson(json);
}

/// ble发起的运动 ble设备发送交换运动数据暂停 app回复
@JsonSerializable()
class IDOBlePauseReplyExchangeModel extends IDOBaseExchangeModel {
  /// 0: 成功 非0: 失败
  @JsonKey(name: 'ret_code')
  int? retCode;

  IDOBlePauseReplyExchangeModel({this.retCode});

  Map<String, dynamic> toJson() => _$IDOBlePauseReplyExchangeModelToJson(this);

  factory IDOBlePauseReplyExchangeModel.fromJson(Map<String, dynamic> json) =>
      _$IDOBlePauseReplyExchangeModelFromJson(json);
}

/// ble发起的运动 ble设备发送交换运动数据恢复 app回复
@JsonSerializable()
class IDOBleRestoreReplyExchangeModel extends IDOBaseExchangeModel {
  /// 0: 成功 非0: 失败
  @JsonKey(name: 'ret_code')
  int? retCode;

  IDOBleRestoreReplyExchangeModel({this.retCode});

  Map<String, dynamic> toJson() =>
      _$IDOBleRestoreReplyExchangeModelToJson(this);

  factory IDOBleRestoreReplyExchangeModel.fromJson(Map<String, dynamic> json) =>
      _$IDOBleRestoreReplyExchangeModelFromJson(json);
}

/// app 操作计划运动
@JsonSerializable()
class IDOAppOperatePlanExchangeModel extends IDOBaseExchangeModel {
  /// 1:开始运动，2：暂停运动, 3:恢复运动 ，4：结束运动, 5: 切换动作
  int? operate;

  /// 训练的课程日期偏移 从0开始
  @JsonKey(name: 'training_offset')
  int? trainingOffset;

  /// 计划类型：1：跑步计划3km，2：跑步计划5km，
  /// 3：跑步计划10km，4：半程马拉松训练（二期，5：马拉松训练（二期）
  @JsonKey(name: 'type')
  int? planType;

  IDOAppOperatePlanExchangeModel(
      {this.operate, this.trainingOffset, this.planType});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> newMap = {};
    final map = _$IDOAppOperatePlanExchangeModelToJson(this);
    map.forEach((key, value) {
      var newKey = key;
      if (key == 'sport_type') {
        /// 替换key
        newKey = key.replaceAll('sport_type', 'type');
      }
      newMap[newKey] = value;
    });
    return newMap;
  }

  factory IDOAppOperatePlanExchangeModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> newJson = {};
    json.forEach((key, value) {
      var newKey = key;
      if (key == 'type') {
        /// 替换key
        newKey = key.replaceAll('type', 'sport_type');
      }
      newJson[newKey] = value;
    });
    return _$IDOAppOperatePlanExchangeModelFromJson(newJson);
  }
}

/// app 操作计划运动 ble回复
@JsonSerializable()
class IDOAppOperatePlanReplyExchangeModel extends IDOBaseExchangeModel {
  /// 计划类型：1：跑步计划3km，2：跑步计划5km，
  /// 3：跑步计划10km，4：半程马拉松训练（二期，5：马拉松训练（二期）
  @JsonKey(name: 'type')
  int? planType;

  /// 1:开始运动，2：暂停运动, 3:恢复运动 ，4：结束运动, 5: 切换动作
  int? operate;

  /// 动作类型  1:快走；2:慢跑；3:中速跑；4:快跑  ；
  /// 5:结束课程运动 （还要等待用户是否有自由运动）；
  /// 6:课程结束后自由运动 （此字段当operate为5起作用）
  @JsonKey(name: 'action_type')
  int? actionType;

  /// 0为成功，非0为失败
  @JsonKey(name: 'err_code')
  int? errorCode;

  IDOAppOperatePlanReplyExchangeModel(
      {this.planType, this.operate, this.actionType, this.errorCode});

  Map<String, dynamic> toJson() =>
      _$IDOAppOperatePlanReplyExchangeModelToJson(this);

  factory IDOAppOperatePlanReplyExchangeModel.fromJson(
          Map<String, dynamic> json) =>
      _$IDOAppOperatePlanReplyExchangeModelFromJson(json);
}

/// ble 操作计划运动
@JsonSerializable()
class IDOBleOperatePlanExchangeModel extends IDOBaseExchangeModel {
  /// 1:开始运动，2：暂停运动, 3:恢复运动 ，4：结束运动, 5: 切换动作
  int? operate;

  /// 计划类型：1：跑步计划3km，2：跑步计划5km，
  /// 3：跑步计划10km，4：半程马拉松训练（二期，5：马拉松训练（二期）
  @JsonKey(name: 'type')
  int? planType;

  /// 动作类型  1:快走；2:慢跑；3:中速跑；4:快跑  ；
  /// 5:结束课程运动 （还要等待用户是否有自由运动）；
  /// 6:课程结束后自由运动 （此字段当operate为5起作用）
  @JsonKey(name: 'action_type')
  int? actionType;

  /// 0为成功，非0为失败
  @JsonKey(name: 'err_code')
  int? errorCode;

  /// 训练课程年份
  @JsonKey(name: 'year')
  int? trainingYear;

  /// 训练课程月份
  @JsonKey(name: 'month')
  int? trainingMonth;

  /// 训练课程日期
  @JsonKey(name: 'training_day')
  int? trainingDay;

  /// 动作目标时间  单位秒
  @JsonKey(name: 'time')
  int? time;

  /// 心率范围低值
  @JsonKey(name: 'low_heart')
  int? lowHeart;

  /// 心率范围高值
  @JsonKey(name: 'height_heart')
  int? heightHeart;

  IDOBleOperatePlanExchangeModel(
      {this.operate,
      this.planType,
      this.actionType,
      this.errorCode,
      this.trainingYear,
      this.trainingMonth,
      this.trainingDay,
      this.time,
      this.lowHeart,
      this.heightHeart});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> newMap = {};
    final map = _$IDOBleOperatePlanExchangeModelToJson(this);
    map.forEach((key, value) {
      var newKey = key;
      if (key == 'training_day') {
        /// 替换key
        newKey = key.replaceAll('training_day', 'day');
      } else if (key == 'day') {
        /// 替换key
        newKey = key.replaceAll('day', 'cur_day');
      }
      newMap[newKey] = value;
    });
    return newMap;
  }

  factory IDOBleOperatePlanExchangeModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> newJson = {};
    json.forEach((key, value) {
      var newKey = key;
      if (key == 'day') {
        /// 替换key
        newKey = key.replaceAll('day', 'training_day');
      } else if (key == 'cur_day') {
        /// 替换key
        newKey = key.replaceAll('cur_day', 'day');
      }
      newJson[newKey] = value;
    });
    return _$IDOBleOperatePlanExchangeModelFromJson(newJson);
  }
}

/// ble 操作计划运动 app回复
@JsonSerializable()
class IDOBleOperatePlanReplyExchangeModel extends IDOBaseExchangeModel {
  /// 1:开始运动，2：暂停运动, 3:恢复运动 ，4：结束运动, 5: 切换动作
  int? operate;

  /// 计划类型：1：跑步计划3km，2：跑步计划5km，
  /// 3：跑步计划10km，4：半程马拉松训练（二期，5：马拉松训练（二期）
  @JsonKey(name: 'type')
  int? planType;

  /// 动作类型  1:快走；2:慢跑；3:中速跑；4:快跑  ；
  /// 5:结束课程运动 （还要等待用户是否有自由运动）；
  /// 6:课程结束后自由运动 （此字段当operate为5起作用）
  @JsonKey(name: 'action_type')
  int? actionType;

  /// 0为成功，非0为失败
  @JsonKey(name: 'err_code')
  int? errorCode;

  IDOBleOperatePlanReplyExchangeModel(
      {this.operate, this.planType, this.actionType, this.errorCode});

  Map<String, dynamic> toJson() =>
      _$IDOBleOperatePlanReplyExchangeModelToJson(this);

  factory IDOBleOperatePlanReplyExchangeModel.fromJson(
          Map<String, dynamic> json) =>
      _$IDOBleOperatePlanReplyExchangeModelFromJson(json);
}
