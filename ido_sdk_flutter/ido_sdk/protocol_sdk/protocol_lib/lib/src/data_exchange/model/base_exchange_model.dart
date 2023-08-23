import 'package:protocol_lib/protocol_lib.dart';

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
  int? sportType;
}

/// app 开始发起运动
class IDOAppStartExchangeModel extends IDOBaseExchangeModel {
  /// 目标类型
  int? targetType;

  /// 目标值
  int? targetValue;

  /// 是否强制开始 0:不强制,1:强制
  int? forceStart;

  /// 最大摄氧量 单位 ml/kg/min
  int? vo2max;

  /// 恢复时长：单位小时
  int? recoverTime;

  /// 上个月平均每周的运动时间 单位分钟
  int? avgWeekActivityTime;

  Map<String, dynamic> _StartExchangeModelToJson(
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
        'avg_week_activity_time': instance.avgWeekActivityTime
      };

  Map<String, dynamic> toJson() => _StartExchangeModelToJson(this);
}

/// app 开始发起运动 ble回复
class IDOAppStartReplyExchangeModel extends IDOBaseExchangeModel {
  /// 0:成功; 1:设备已经进入运动模式失败;
  /// 2:设备电量低失败;3:手环正在充电
  /// 4:正在使用Alexa 5:通话中
  int? retCode;

  IDOAppStartReplyExchangeModel({this.retCode});

  factory IDOAppStartReplyExchangeModel.fromJson(Map<String, dynamic> json) =>
      IDOAppStartReplyExchangeModel(retCode: json['ret_code'] as int?);
}

/// app 发起运动结束
class IDOAppEndExchangeModel extends IDOBaseExchangeModel {
  /// 持续时长（单位：s）
  int? duration;

  /// 卡路里，单位大卡
  int? calories;

  /// 距离（单位：米）
  int? distance;

  /// 0:不保存，1:保存
  int? isSave;

  Map<String, dynamic> _EndExchangeModelToJson(IDOAppEndExchangeModel instance) =>
      <String, dynamic>{
        'day': instance.day,
        'hour': instance.hour,
        'minute': instance.minute,
        'second': instance.second,
        'duration': instance.duration,
        'calories': instance.calories,
        'distance': instance.distance,
        'sport_type': instance.sportType,
        'is_save': instance.isSave
      };

  Map<String, dynamic> toJson() => _EndExchangeModelToJson(this);
}

/// app 发起运动结束 ble回复
class IDOAppEndReplyExchangeModel extends IDOBaseExchangeModel {
  /// 0:成功; 1:设备结束失败
  int? errorCode;

  /// 卡路里，单位大卡
  int? calories;

  /// 距离（单位：米）
  int? distance;

  /// 步数 (单位:步)
  int? step;

  /// 平均心率
  int? avgHr;

  /// 最大心率
  int? maxHr;

  /// 脂肪燃烧时长 单位分钟
  int? burnFatMins;

  /// 心肺锻炼时长 单位分钟
  int? aerobicMins;

  /// 极限锻炼时长 单位分钟
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

  factory IDOAppEndReplyExchangeModel.fromJson(Map<String, dynamic> json) =>
      IDOAppEndReplyExchangeModel(
          errorCode: json['err_code'] as int?,
          step: json['step'] as int?,
          calories: json['calories'] as int?,
          distance: json['distance'] as int?,
          avgHr: json['avg_hr_value'] as int?,
          maxHr: json['max_hr_value'] as int?,
          burnFatMins: json['burn_fat_mins'] as int?,
          aerobicMins: json['aerobic_mins'] as int?,
          limitMins: json['limit_mins'] as int?);
}

/// app 交换运动数据
class IDOAppIngExchangeModel extends IDOBaseExchangeModel {
  /// 持续时长 单位s
  int? duration;

  /// 卡路里 单位大卡
  int? calories;

  /// 距离 单位0.01km
  int? distance;

  /// 0: 全部有效、1: 距离无效、 2: GPS信号弱
  int? status;

  Map<String, dynamic> _IngExchangeModelToJson(IDOAppIngExchangeModel instance) =>
      <String, dynamic>{
        'day': instance.day,
        'hour': instance.hour,
        'minute': instance.minute,
        'second': instance.second,
        'duration': instance.duration,
        'calories': instance.calories,
        'distance': instance.distance,
        'status': instance.status,
      };

  Map<String, dynamic> toJson() => _IngExchangeModelToJson(this);
}

/// app 交换运动数据 ble回复
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
  int? currentHr;

  /// 心率间隔 单位s
  int? interval;

  /// 序列号
  int? hrSerial;

  /// 心率值数据
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

  factory IDOAppIngReplyExchangeModel.fromJson(Map<String, dynamic> json) =>
      IDOAppIngReplyExchangeModel(
          calories: json['calories'] as int?,
          distance: json['distance'] as int?,
          status: json['status'] as int?,
          step: json['step'] as int?,
          currentHr: json['cur_hr_value'] as int?,
          interval: json['interval_second'] as int?,
          hrSerial: json['hr_value_serial'] as int?,
          hrJson: ((json['hr_value'] ?? <dynamic>[]) as List<dynamic>).map((e) => e as int).toList());
}

/// app 交换运动数据暂停
class IDOAppPauseExchangeModel extends IDOBaseExchangeModel {
  /// 暂停时
  int? pauseHour;

  /// 暂停分
  int? pauseMinute;

  /// 暂停秒
  int? pauseSecond;

  Map<String, dynamic> _PauseExchangeModelToJson(
      IDOAppPauseExchangeModel instance) =>
      <String, dynamic>{
        'day': instance.day,
        'hour': instance.hour,
        'minute': instance.minute,
        'second': instance.second,
        'sport_hour': instance.pauseHour,
        'sport_minute': instance.pauseMinute,
        'sport_second': instance.pauseSecond,
      };

  Map<String, dynamic> toJson() => _PauseExchangeModelToJson(this);
}

/// app 交换运动数据暂停 ble回复
class IDOAppPauseReplyExchangeModel extends IDOBaseExchangeModel {
  /// 暂停错误码 0:成功 非0:失败
  int? errCode;

  IDOAppPauseReplyExchangeModel({this.errCode});

  factory IDOAppPauseReplyExchangeModel.fromJson(Map<String, dynamic> json) =>
      IDOAppPauseReplyExchangeModel(errCode: json['err_code'] as int?);
}

/// app 交换运动数据恢复
class IDOAppRestoreExchangeModel extends IDOBaseExchangeModel {
  Map<String, dynamic> _RestoreExchangeModelToJson(
      IDOAppRestoreExchangeModel instance) =>
      <String, dynamic>{
        'day': instance.day,
        'hour': instance.hour,
        'minute': instance.minute,
        'second': instance.second,
      };

  Map<String, dynamic> toJson() => _RestoreExchangeModelToJson(this);
}

/// app 交换运动数据恢复 ble回复
class IDOAppRestoreReplyExchangeModel extends IDOBaseExchangeModel {
  /// 暂停错误码 0:成功 非0:失败
  int? errCode;

  IDOAppRestoreReplyExchangeModel({this.errCode});

  factory IDOAppRestoreReplyExchangeModel.fromJson(Map<String, dynamic> json) =>
      IDOAppRestoreReplyExchangeModel(errCode: json['err_code'] as int?);
}

/// app v3交换运动数据
class IDOAppIngV3ExchangeModel extends IDOBaseExchangeModel {
  /// 协议版本号
  int? version;

  /// 0: 表示信号弱 2: 表示信号强
  int? signal;

  /// app 距离
  int? distance;

  /// app计算显示实时配速，单位km/h，100倍
  int? speed;

  /// 持续时间
  int? duration;

  /// 卡路里
  int? calories;

  Map<String, dynamic> _IngV3ExchangeModelToJson(
      IDOAppIngV3ExchangeModel instance) =>
      <String, dynamic>{
        'version': instance.version,
        'type': instance.sportType,
        'signal_flag': instance.signal,
        'distance': instance.distance,
        'real_time_speed': instance.speed,
        'duration': instance.duration,
        'calories': instance.calories,
      };

  Map<String, dynamic> toJson() => _IngV3ExchangeModelToJson(this);
}

/// app v3交换运动数据 ble回复
class IDOAppIngV3ReplyExchangeModel extends IDOBaseExchangeModel {
  /// 协议版本号
  int? version;

  /// 心率数据
  int? heartRate;

  /// 距离 单位根据单位设置的单位显示
  int? distance;

  /// 持续时间 秒钟
  int? duration;

  /// 动态卡路里
  int? realTimeCalories;

  /// 实时速度，单位km/h，扩大100倍
  int? realTimeSpeed;

  /// 实时公里配速 单位s/公里
  int? kmSpeed;

  /// 步数
  int? steps;

  /// 主泳姿
  int? swimPosture;

  /// 状态 0：无效 1：开始 2：手动暂停 3：结束 4：自动暂停
  int? status;

  /// 实时的配速，单位秒，5秒使用滑动平均，第5秒使用1-5秒数据，第6秒使用2-6秒数据
  int? realTimeSpeedPace;

  /// 有氧训练效果等级  单位无  范围 0-50 扩大10倍传输
  int? trainingEffect;

  /// 无氧运动训练效果等级 单位无  范围 0-50 扩大10倍传输
  int? anaerobicTrainingEffect;

  /// 动作类型
  /// 1快走
  /// 2慢跑
  /// 3中速跑
  /// 4快跑
  /// 5结束课程运动 （还要等待用户是否有自由运动）
  /// 6课程结束后自由运动（此字段当operate为5起作用）
  /// 运动累积时间=课程内训练时间+课程结束后计时
  int? actionType;

  /// 需要固件开启功能表
  /// action_type = 1—5时，该字段是运动倒计时时间（注：时间递减）
  /// action_type = 6时，该字段是课程结束后计时（注：时间递增）
  int? countHour;

  /// 需要固件开启功能表
  /// action_type = 1—5时，该字段是运动倒计时时间（注：时间递减）
  /// action_type = 6时，该字段是课程结束后计时（注：时间递增）
  int? countMinute;

  /// 需要固件开启功能表
  /// action_type = 1—5时，该字段是运动倒计时时间（注：时间递减）
  /// action_type = 6时，该字段是课程结束后计时（注：时间递增）
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

  factory IDOAppIngV3ReplyExchangeModel.fromJson(Map<String, dynamic> json) {
    final model = IDOAppIngV3ReplyExchangeModel(
        version: json['version'] as int?,
        heartRate: json['heart_rate'] as int?,
        distance: json['distance'] as int?,
        duration: json['duration'] as int?,
        realTimeCalories: json['real_time_calories'] as int?,
        realTimeSpeed: json['real_time_speed'] as int?,
        kmSpeed: json['km_speed'] as int?,
        steps: json['steps'] as int?,
        swimPosture: json['swim_posture'] as int?,
        status: json['status'] as int?,
        realTimeSpeedPace: json['real_time_speed_pace'] as int?,
        trainingEffect: json['te'] as int?,
        anaerobicTrainingEffect: json['tean'] as int?,
        actionType: json['action_type'] as int?,
        countHour: json['count_hour'] as int?,
        countMinute: json['count_minute'] as int?,
        countSecond: json['count_second'] as int?);
    model.day = json['day'] as int?;
    model.hour = json['hour'] as int?;
    model.minute = json['minute'] as int?;
    model.second = json['second'] as int?;
    model.sportType = json['type'] as int?;
    return model;
  }
}

/// app 获取v3多运动数据
class IDOAppActivityDataV3ExchangeModel extends IDOBaseExchangeModel {
  /// 年份
  int? year;

  /// 月份
  int? month;

  /// 协议库版本号
  int? version;

  /// 心率间隔 单位分钟
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
  int? burnFatMins;

  /// 有氧运动的持续时间 单位分钟
  int? aerobicMins;

  /// 极限锻炼的持续时间 单位分钟
  int? limitMins;

  /// 热身运动
  int? warmUp;

  /// 脂肪燃烧
  int? fatBurning;

  /// 有氧训练
  int? aerobicExercise;

  /// 无氧训练
  int? anaerobicExercise;

  /// 极限训练
  int? extremeExercise;

  /// 热身运动的累计时长 单位秒
  int? warmUpTime;

  /// 脂肪燃烧的累计时长 单位秒
  int? fatBurningTime;

  /// 有氧运动的累计时长 单位秒
  int? aerobicExerciseTime;

  /// 无氧运动的累计时长 单位秒
  int? anaerobicExerciseTime;

  /// 极限锻炼的累计时长 单位秒
  int? extremeExerciseTime;

  /// 平均速度 单位km/h
  int? avgSpeed;

  /// 最快速度 单位km/h
  int? maxSpeed;

  /// 平均步幅
  int? avgStepStride;

  /// 最大步幅
  int? maxStepStride;

  /// 平均公里配速
  int? kmSpeed;

  /// 最快公里配速
  int? fastKmSpeed;

  /// 平均步频
  int? avgStepFrequency;

  /// 最大步频
  int? maxStepFrequency;

  /// 平均心率
  int? avgHrValue;

  /// 最大心率
  int? maxHrValue;

  /// 恢复时长 单位小时 app收到该数据之后，每过1小时需要自减1
  int? recoverTime;

  /// 最大摄氧量 单位 ml/kg/min
  int? vo2max;

  /// 训练效果 范围： 1.0 - 5.0 （扩大10倍传输）
  int? trainingEffect;

  /// 摄氧量等级 1：低等 2：业余 3：一般 4：平均 5：良好 6：优秀 7：专业
  int? grade;

  /// 步频详情个数
  int? stepsFrequencyCount;

  /// 英里配速个数 最大100
  int? miSpeedCount;

  /// 实时速度个数
  int? realSpeedCount;

  /// 实时配速个数
  int? paceSpeedCount;

  /// 公里配速详情个数 最大100
  int? kmSpeedCount;

  /// 本次动作训练个数
  int? actionDataCount;

  /// 每公里耗时秒数 配速集合
  List<int>? kmSpeeds;

  /// 步频集合 单位步/分钟
  List<int>? stepsFrequency;

  /// 英里配速数组
  List<int>? itemsMiSpeed;

  /// 实时速度数组 单位km/h
  List<int>? itemRealSpeed;

  /// 实时配速数组
  List<int>? paceSpeedItems;

  ///  动作完成内容
  ///  type : 动作类型  1快走；2慢跑; 3中速跑；4快跑
  ///  heart_con_value : 每个动作心率控制
  ///  time : 动作完成时间 单位秒
  ///  goal_time ：动作目标时间
  List<Map<String,dynamic>>? actionData;

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
      this.kmSpeeds,
      this.stepsFrequency,
      this.itemsMiSpeed,
      this.itemRealSpeed,
      this.paceSpeedItems,
      this.actionData
      });

  factory IDOAppActivityDataV3ExchangeModel.fromJson(Map<String, dynamic> json) {
    final model = IDOAppActivityDataV3ExchangeModel(
        year: json['year'] as int?,
        month: json['month'] as int?,
        version: json['version'] as int?,
        hrInterval: json['hr_data_interval_minute'] as int?,
        step: json['step'] as int?,
        durations: json['durations'] as int?,
        calories: json['calories'] as int?,
        distance: json['distance'] as int?,
        burnFatMins: json['burn_fat_mins'] as int?,
        aerobicMins: json['aerobic_mins'] as int?,
        limitMins: json['limit_mins'] as int?,
        warmUp: json['warm_up'] as int?,
        fatBurning: json['fat_burning'] as int?,
        aerobicExercise: json['aerobic_exercise'] as int?,
        anaerobicExercise: json['anaerobic_exercise'] as int?,
        extremeExercise: json['extreme_exercise'] as int?,
        warmUpTime: json['warm_up_time'] as int?,
        fatBurningTime: json['fat_burning_time'] as int?,
        aerobicExerciseTime: json['aerobic_exercise_time'] as int?,
        anaerobicExerciseTime: json['anaerobic_exercise_time'] as int?,
        extremeExerciseTime: json['extreme_exercise_time'] as int?,
        avgSpeed: json['avg_speed'] as int?,
        avgStepStride: json['avg_step_stride'] as int?,
        maxStepStride: json['max_step_stride'] as int?,
        kmSpeed: json['km_speed'] as int?,
        fastKmSpeed: json['fast_km_speed'] as int?,
        avgStepFrequency: json['avg_step_frequency'] as int?,
        maxStepFrequency: json['max_step_frequency'] as int?,
        avgHrValue: json['avg_hr_value'] as int?,
        maxHrValue: json['max_hr_value'] as int?,
        kmSpeedCount: json['km_speed_count'] as int?,
        actionDataCount: json['action_data_count'] as int?,
        stepsFrequencyCount: json['steps_frequency_count'] as int?,
        miSpeedCount: json['mi_speed_count'] as int?,
        recoverTime: json['recover_time'] as int?,
        vo2max: json['vo2max'] as int?,
        trainingEffect: json['training_effect'] as int?,
        grade: json['grade'] as int?,
        realSpeedCount: json['real_speed_count'] as int?,
        paceSpeedCount: json['pace_speed_count'] as int?,
        kmSpeeds: ((json['km_speed_s'] ?? <dynamic>[]) as List<dynamic>).map((e) => e as int).toList(),
        stepsFrequency: ((json['steps_frequency'] ?? <dynamic>[]) as List<dynamic>).map((e) => e as int).toList(),
        itemsMiSpeed: ((json['items_mi_speed'] ?? <dynamic>[]) as List<dynamic>).map((e) => e as int).toList(),
        itemRealSpeed: ((json['item_real_speed']?? <dynamic>[]) as List<dynamic>).map((e) => e as int).toList(),
        paceSpeedItems: ((json['pace_speed_items'] ?? <dynamic>[]) as List<dynamic>).map((e) => e as int).toList(),
        actionData: ((json['items'] ?? <dynamic>[]) as List<dynamic>).map((e) => e as Map<String, dynamic>).toList()
    );
    model.day = json['day'] as int?;
    model.hour = json['hour'] as int?;
    model.minute = json['minute'] as int?;
    model.second = json['second'] as int?;
    model.sportType = json['type'] as int?;
    return model;
  }
}

/// app v3 多运动数交换中获取1分钟心率数据
class IDOAppHrDataExchangeModel extends IDOBaseExchangeModel {
  /// 协议版本号
  int? version;

  /// 心率数据数组长度 最大60
  int? heartRateHistoryLen;

  /// 心率间隔 单位秒
  int? interval;

  /// 心率数据数组 存一分钟的心率数据, 1s存一个
  List<int>? heartRates;

  IDOAppHrDataExchangeModel(
      {this.version, this.heartRateHistoryLen, this.interval, this.heartRates});

  factory IDOAppHrDataExchangeModel.fromJson(Map<String, dynamic> json) {
    final model = IDOAppHrDataExchangeModel(
        version: json['version'] as int?,
        heartRateHistoryLen: json['heart_rate_history_len'] as int?,
        interval: json['interval_second'] as int?,
        heartRates: ((json['heart_rate_history'] ?? <dynamic>[]) as List<dynamic>).map((e) => e as int).toList());
    model.day = json['day'] as int?;
    model.hour = json['hour'] as int?;
    model.minute = json['minute'] as int?;
    model.second = json['second'] as int?;
    model.sportType = json['type'] as int?;
    return model;
  }
}

/// app v3 多运动数据交换中获取GPS经纬度数据
class IDOAppGpsDataExchangeModel extends IDOBaseExchangeModel {

  /// 协议版本号
  int? version;
  /// 坐标点时间间隔 单位秒
  int? intervalSecond;
  /// 坐标点个数
  int? gpsCount;
  /// gps数据详情集合 [{'latitude':0,'longitude':0}]
  List<Map<String,dynamic>>? gpsData;

  IDOAppGpsDataExchangeModel(
      {this.version, this.intervalSecond, this.gpsCount, this.gpsData});

  factory IDOAppGpsDataExchangeModel.fromJson(Map<String, dynamic> json) {
    final model = IDOAppGpsDataExchangeModel(
        version: json['version'] as int?,
        intervalSecond: json['interval_second'] as int?,
        gpsCount: json['GPS_data_len'] as int?,
        gpsData: ((json['GPS_data'] ?? <dynamic>[]) as List<dynamic>).map((e) => e as Map<String, dynamic>).toList());
    model.day = json['day'] as int?;
    model.hour = json['hour'] as int?;
    model.minute = json['minute'] as int?;
    model.second = json['second'] as int?;
    model.sportType = json['type'] as int?;
    return model;
  }
}

/// app发起运动 ble设备发送交换运动数据暂停
class IDOAppBlePauseExchangeModel extends IDOBaseExchangeModel {

    IDOAppBlePauseExchangeModel();

    factory IDOAppBlePauseExchangeModel.fromJson(Map<String, dynamic> json) {
      final model = IDOAppBlePauseExchangeModel();
      model.day = json['day'] as int?;
      model.hour = json['hour'] as int?;
      model.minute = json['minute'] as int?;
      model.second = json['second'] as int?;
      model.sportType = json['type'] as int?;
      return model;
    }
}

/// app发起运动 ble设备发送交换运动数据暂停 app回复
class IDOAppBlePauseReplyExchangeModel extends IDOBaseExchangeModel {
  /// 0: 成功; 1: 没有进入运动模式失败
  int? errCode;

  Map<String, dynamic> _AppBlePauseReplyExchangeModelToJson(
      IDOAppBlePauseReplyExchangeModel instance) =>
      <String, dynamic>{'err_code': instance.errCode};

  Map<String, dynamic> toJson() => _AppBlePauseReplyExchangeModelToJson(this);
}

/// app发起运动 ble设备发送交换运动数据恢复
class IDOAppBleRestoreExchangeModel extends IDOBaseExchangeModel {

  IDOAppBleRestoreExchangeModel();

  factory IDOAppBleRestoreExchangeModel.fromJson(Map<String, dynamic> json) {
    final model = IDOAppBleRestoreExchangeModel();
    model.day = json['day'] as int?;
    model.hour = json['hour'] as int?;
    model.minute = json['minute'] as int?;
    model.second = json['second'] as int?;
    model.sportType = json['type'] as int?;
    return model;
  }
}

/// app发起运动 ble设备发送交换运动数据恢复 app回复
class IDOAppBleRestoreReplyExchangeModel extends IDOBaseExchangeModel {
  /// 0: 成功; 1: 没有进入运动模式失败
  int? errCode;

  Map<String, dynamic> _AppBleRestoreReplyExchangeModelToJson(
      IDOAppBleRestoreReplyExchangeModel instance) =>
      <String, dynamic>{'err_code': instance.errCode};

  Map<String, dynamic> toJson() => _AppBleRestoreReplyExchangeModelToJson(this);
}

/// app发起运动 ble设备发送交换运动数据结束
class IDOAppBleEndExchangeModel extends IDOBaseExchangeModel {

  /// 持续时长 单位s
  int? duration;

  /// 卡路里 单位大卡
  int? calories;

  /// 距离 单位0.01km
  int? distance;

  /// 平均心率
  int? avgHr;

  /// 最大心率
  int? maxHr;

  /// 脂肪燃烧时长 单位分钟
  int? burnFatMins;

  /// 心肺锻炼时长 单位分钟
  int? aerobicMins;

  /// 极限锻炼时长 单位分钟
  int? limitMins;

  /// 0:不保存，1:保存
  int? isSave;

  IDOAppBleEndExchangeModel({this.duration,
    this.calories,
    this.distance,
    this.avgHr,
    this.maxHr,
    this.burnFatMins,
    this.aerobicMins,
    this.limitMins,
    this.isSave});

  factory IDOAppBleEndExchangeModel.fromJson(Map<String, dynamic> json) {
    final model = IDOAppBleEndExchangeModel(duration: json['duration'] as int?,
    calories: json['calories'] as int?, distance: json['distance'] as int?,
      avgHr: json['avg_hr_value'] as int?,maxHr: json['max_hr_value'] as int?,
      burnFatMins: json['burn_fat_mins'] as int?,aerobicMins: json['aerobic_mins'] as int?,
      limitMins: json['limit_mins'] as int?,isSave: json['is_save'] as int?,
    );
    model.day = json['day'] as int?;
    model.hour = json['hour'] as int?;
    model.minute = json['minute'] as int?;
    model.second = json['second'] as int?;
    model.sportType = json['sport_type'] as int?;
    return model;
  }

}

/// app发起运动 ble设备发送交换运动数据结束 app回复
class IDOAppBleEndReplyExchangeModel extends IDOBaseExchangeModel {
  /// 0: 成功; 1: 没有进入运动模式失败
  int? errCode;

  ///持续时长 单位s
  int? duration;

  ///卡路里 单位大卡
  int? calories;

  ///距离 单位0.01km
  int? distance;

  Map<String, dynamic> _AppBleEndReplyExchangeModelToJson(
      IDOAppBleEndReplyExchangeModel instance) =>
      <String, dynamic>{'err_code': instance.errCode,'duration': instance.duration,
      'calories': instance.calories,'distance': instance.distance
      };

  Map<String, dynamic> toJson() => _AppBleEndReplyExchangeModelToJson(this);
}


/// ble发起运动 ble设备发送交换运动数据开始
class IDOBleStartExchangeModel extends IDOBaseExchangeModel {
  /// 1：请求app打开gps 2：发起运动请求
  int? operate;

  IDOBleStartExchangeModel({this.operate});

  factory IDOBleStartExchangeModel.fromJson(Map<String, dynamic> json) {
    final model = IDOBleStartExchangeModel(operate: json['operate'] as int?);
    model.day = json['day'] as int?;
    model.hour = json['hour'] as int?;
    model.minute = json['minute'] as int?;
    model.second = json['second'] as int?;
    model.sportType = json['type'] as int?;
    return model;
  }
}

/// ble发起的运动 ble设备交换运动数据过程中
class IDOBleIngExchangeModel extends IDOBaseExchangeModel {
  /// 距离 单位：0.01km
  int? distance;

  IDOBleIngExchangeModel({this.distance});

  factory IDOBleIngExchangeModel.fromJson(Map<String, dynamic> json) {
    final model = IDOBleIngExchangeModel(distance: json['distance'] as int?);
    model.day = json['day'] as int?;
    model.hour = json['hour'] as int?;
    model.minute = json['minute'] as int?;
    model.second = json['second'] as int?;
    model.sportType = json['type'] as int?;
    return model;
  }
}

/// ble发起的运动 ble设备发送交换运动数据结束
class IDOBleEndExchangeModel extends IDOBaseExchangeModel {
  IDOBleEndExchangeModel();

  factory IDOBleEndExchangeModel.fromJson(Map<String, dynamic> json) {
    final model = IDOBleEndExchangeModel();
    model.day = json['day'] as int?;
    model.hour = json['hour'] as int?;
    model.minute = json['minute'] as int?;
    model.second = json['second'] as int?;
    model.sportType = json['type'] as int?;
    return model;
  }
}

/// ble发起的运动 ble设备发送交换运动数据暂停
class IDOBlePauseExchangeModel extends IDOBaseExchangeModel {
  IDOBlePauseExchangeModel();

  factory IDOBlePauseExchangeModel.fromJson(Map<String, dynamic> json) {
    final model = IDOBlePauseExchangeModel();
    model.day = json['day'] as int?;
    model.hour = json['hour'] as int?;
    model.minute = json['minute'] as int?;
    model.second = json['second'] as int?;
    model.sportType = json['type'] as int?;
    return model;
  }
}

/// ble发起的运动 ble设备发送交换运动数据恢复
class IDOBleRestoreExchangeModel extends IDOBaseExchangeModel {
  IDOBleRestoreExchangeModel();

  factory IDOBleRestoreExchangeModel.fromJson(Map<String, dynamic> json) {
    final model = IDOBleRestoreExchangeModel();
    model.day = json['day'] as int?;
    model.hour = json['hour'] as int?;
    model.minute = json['minute'] as int?;
    model.second = json['second'] as int?;
    model.sportType = json['type'] as int?;
    return model;
  }
}

/// ble发起的运动 ble设备发送交换运动数据开始 app回复
class IDOBleStartReplyExchangeModel extends IDOBaseExchangeModel {
  /// 1：请求app打开gps 2：发起运动请求
  int? operate;

  /// 0: 成功 非0: 失败
  int? retCode;

  Map<String, dynamic> _StartReplyExchangeModelToJson(
      IDOBleStartReplyExchangeModel instance) =>
      <String, dynamic>{
        'operate': instance.operate,
        'ret_code': instance.retCode
      };

  Map<String, dynamic> toJson() => _StartReplyExchangeModelToJson(this);
}

/// ble发起的运动 ble设备交换运动数据过程中 app回复
class IDOBleIngReplyExchangeModel extends IDOBaseExchangeModel {
  /// 距离 单位：0.01km
  int? distance;

  Map<String, dynamic> _IngReplyExchangeModelToJson(
      IDOBleIngReplyExchangeModel instance) =>
      <String, dynamic>{'distance': instance.distance};

  Map<String, dynamic> toJson() => _IngReplyExchangeModelToJson(this);
}

/// ble发起的运动 ble设备发送交换运动数据结束 app回复
class IDOBleEndReplyExchangeModel extends IDOBaseExchangeModel {
  /// 0: 成功 非0: 失败
  int? retCode;

  Map<String, dynamic> _EndReplyExchangeModelToJson(
      IDOBleEndReplyExchangeModel instance) =>
      <String, dynamic>{'ret_code': instance.retCode};

  Map<String, dynamic> toJson() => _EndReplyExchangeModelToJson(this);
}

/// ble发起的运动 ble设备发送交换运动数据暂停 app回复
class IDOBlePauseReplyExchangeModel extends IDOBaseExchangeModel {
  /// 0: 成功 非0: 失败
  int? retCode;

  Map<String, dynamic> _PauseReplyExchangeModelToJson(
      IDOBlePauseReplyExchangeModel instance) =>
      <String, dynamic>{'ret_code': instance.retCode};

  Map<String, dynamic> toJson() => _PauseReplyExchangeModelToJson(this);
}

/// ble发起的运动 ble设备发送交换运动数据恢复 app回复
class IDOBleRestoreReplyExchangeModel extends IDOBaseExchangeModel {
  /// 0: 成功 非0: 失败
  int? retCode;

  Map<String, dynamic> _RestoreReplyExchangeModelToJson(
      IDOBleRestoreReplyExchangeModel instance) =>
      <String, dynamic>{'ret_code': instance.retCode};

  Map<String, dynamic> toJson() => _RestoreReplyExchangeModelToJson(this);
}

/// app 操作计划运动
class IDOAppOperatePlanExchangeModel extends IDOBaseExchangeModel {
  /// 1:开始运动，2：暂停运动, 3:恢复运动 ，4：结束运动, 5: 切换动作
  int? operate;
  /// 训练的课程日期偏移 从0开始
  int? trainingOffset;
  /// 计划类型：1：跑步计划3km，2：跑步计划5km，
  /// 3：跑步计划10km，4：半程马拉松训练（二期，5：马拉松训练（二期）
  int? planType;

  Map<String, dynamic> _AppOperatePlanExchangeModelToJson(
      IDOAppOperatePlanExchangeModel instance) =>
      <String, dynamic>{'operate': instance.operate,'type':instance.planType,
      'training_offset': instance.trainingOffset,'hour':instance.hour,
      'minute':instance.minute, 'second': instance.second
      };
  Map<String, dynamic> toJson() => _AppOperatePlanExchangeModelToJson(this);
}

/// app 操作计划运动 ble回复
class IDOAppOperatePlanReplyExchangeModel extends IDOBaseExchangeModel {
  /// 计划类型：1：跑步计划3km，2：跑步计划5km，
  /// 3：跑步计划10km，4：半程马拉松训练（二期，5：马拉松训练（二期）
  int? planType;
  /// 1:开始运动，2：暂停运动, 3:恢复运动 ，4：结束运动, 5: 切换动作
  int? operate;
  /// 动作类型  1:快走；2:慢跑；3:中速跑；4:快跑  ；
  /// 5:结束课程运动 （还要等待用户是否有自由运动）；
  /// 6:课程结束后自由运动 （此字段当operate为5起作用）
  int? actionType;
  /// 0为成功，非0为失败
  int? errorCode;

  IDOAppOperatePlanReplyExchangeModel({this.planType,this.operate,this.actionType,this.errorCode});

  factory IDOAppOperatePlanReplyExchangeModel.fromJson(Map<String, dynamic> json) {
    final model = IDOAppOperatePlanReplyExchangeModel(
      planType: json['type'] as int?,
      operate: json['operate'] as int?,
      actionType: json['action_type'] as int?,
      errorCode: json['err_code'] as int?
    );
    return model;
  }
}

/// ble 操作计划运动
class IDOBleOperatePlanExchangeModel extends IDOBaseExchangeModel {
  /// 1:开始运动，2：暂停运动, 3:恢复运动 ，4：结束运动, 5: 切换动作
  int? operate;
  /// 计划类型：1：跑步计划3km，2：跑步计划5km，
  /// 3：跑步计划10km，4：半程马拉松训练（二期，5：马拉松训练（二期）
  int? planType;
  /// 动作类型  1:快走；2:慢跑；3:中速跑；4:快跑  ；
  /// 5:结束课程运动 （还要等待用户是否有自由运动）；
  /// 6:课程结束后自由运动 （此字段当operate为5起作用）
  int? actionType;
  /// 0为成功，非0为失败
  int? errorCode;
  /// 训练课程年份
  int? trainingYear;
  /// 训练课程月份
  int? trainingMonth;
  /// 训练课程日期
  int? trainingDay;
  /// 动作目标时间  单位秒
  int? time;
  /// 心率范围低值
  int? lowHeart;
  /// 心率范围高值
  int? heightHeart;

  IDOBleOperatePlanExchangeModel({this.operate,this.planType,this.actionType,
    this.errorCode,this.trainingYear,this.trainingMonth,this.trainingDay,this.time,this.lowHeart,this.heightHeart});

  factory IDOBleOperatePlanExchangeModel.fromJson(Map<String, dynamic> json) {
    final model = IDOBleOperatePlanExchangeModel(
        operate: json['operate'] as int?,
        planType: json['type'] as int?,
        actionType: json['action_type'] as int?,
        errorCode: json['err_code'] as int?,
        trainingYear: json['year'] as int?,
        trainingMonth: json['month'] as int?,
        trainingDay: json['day'] as int?,
        time: json['time'] as int?,
        lowHeart: json['low_heart'] as int?,
        heightHeart: json['height_heart'] as int?
    );
    model.day = json['cur_day'] as int?;
    model.hour = json['hour'] as int?;
    model.minute = json['minute'] as int?;
    model.second = json['second'] as int?;
    return model;
  }
}

/// ble 操作计划运动 app回复
class IDOBleOperatePlanReplyExchangeModel extends IDOBaseExchangeModel {
  /// 1:开始运动，2：暂停运动, 3:恢复运动 ，4：结束运动, 5: 切换动作
  int? operate;
  /// 计划类型：1：跑步计划3km，2：跑步计划5km，
  /// 3：跑步计划10km，4：半程马拉松训练（二期，5：马拉松训练（二期）
  int? planType;
  /// 动作类型  1:快走；2:慢跑；3:中速跑；4:快跑  ；
  /// 5:结束课程运动 （还要等待用户是否有自由运动）；
  /// 6:课程结束后自由运动 （此字段当operate为5起作用）
  int? actionType;
  /// 0为成功，非0为失败
  int? errorCode;

  Map<String, dynamic> _BleOperatePlanReplyExchangeModelToJson(
      IDOBleOperatePlanReplyExchangeModel instance) =>
      <String, dynamic>{'operate': instance.operate,'type':instance.planType,
        'action_type': instance.actionType,'err_code':instance.errorCode
      };
  Map<String, dynamic> toJson() => _BleOperatePlanReplyExchangeModelToJson(this);
}