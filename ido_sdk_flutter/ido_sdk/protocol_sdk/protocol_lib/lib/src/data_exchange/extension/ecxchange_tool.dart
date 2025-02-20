
import 'package:protocol_lib/protocol_lib.dart';

extension IDOV3ExchangeDataExtension on IDOV3ExchangeModel {

  /// app 发起ble暂停、ble恢复
  appStartBle2AppData(int day, int hour, int minute, int second, int sportType) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
  }

  /// app 发起ble暂停、ble恢复 app回复
  appStartBle2AppReplyData(int retCode) {
    this.retCode = retCode;
  }

  /// app 发起ble停止
  appStartBleEnd2AppData(int day, int hour, int minute, int second, int sportType, int duration, int calories, int distance,
      int avgHr, int maxHr, int burnFatMins, int aerobicMins, int limitMins, int isSave
      ) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
    this.durations = duration;
    this.calories = calories;
    this.distance = distance;
    this.avgHr = avgHr;
    this.maxHr = maxHr;
    this.burnFatMins = burnFatMins;
    this.aerobicMins = aerobicMins;
    this.limitMins = limitMins;
    this.isSave = isSave == 1;
  }

  /// app 发起ble停止 app回复
  appStartBleEnd2AppReplyData(int duration, int calories, int distance, int errCode) {
    this.durations = duration;
    this.calories = calories;
    this.distance = distance;
    this.retCode = errCode;
  }

  /// ble 开始
  bleStart2AppData(int day, int hour, int minute, int second, int sportType,int operate) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
    this.operate = operate;
  }

  /// ble 结束
  bleEnd2AppData(int day, int hour, int minute, int second, int sportType) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
  }

  /// ble 暂停
  blePause2AppData(int day, int hour, int minute, int second, int sportType) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
  }

  /// ble 恢复
  bleRestore2AppData(int day, int hour, int minute, int second, int sportType) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
  }

  /// ble 交换中
  bleIng2AppData(int day, int hour, int minute, int second, int sportType,int distance) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
    this.distance = distance;
  }

  /// app 开始
  appStart2BleData(int day, int hour, int minute, int second,
      int sportType,int targetType,int targetValue,int forceStart,
      int vo2Max,int recoverTime,int avgWeekActivityTime) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
    this.targetType = targetType;
    this.targetValue = targetValue;
    this.forceStart = forceStart;
    this.vo2Max = vo2Max;
    this.recoverTime = recoverTime;
    this.avgWeekActivityTime = avgWeekActivityTime;
  }

  /// app 操作 ble回复
  appOperate2BleReplyData(int retCode) {
    this.retCode = retCode;
  }

  /// app 结束
  appEnd2BleData(int day, int hour, int minute, int second,
      int sportType,int duration,int calories,int distance,int isSave) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
    this.durations = duration;
    this.calories = calories;
    this.distance = distance;
    this.isSave = isSave == 1;
  }

  /// app 结束 ble回复
  appEnd2BleReplyData(int retCode,int calories,int distance,int step,
      int avgHr,int maxHr,int burnFatMins,int aerobicMins,int limitMins) {
    this.retCode = retCode;
    this.calories = calories;
    this.distance = distance;
    this.step = step;
    this.avgHr = avgHr;
    this.maxHr = maxHr;
    this.burnFatMins = burnFatMins;
    this.aerobicMins = aerobicMins;
    this.limitMins = limitMins;
  }

  /// app 恢复
  appRestore2BleData(int day, int hour, int minute, int second, int sportType) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
  }

  /// app 暂停
  appPause2BleData(int day, int hour, int minute, int second, int sportType) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
  }

  /// app 交换中
  appIng2BleData(int day, int hour, int minute, int second,
      int sportType,int duration,int calories,
      int distance,int speed,int version,int signal) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
    this.durations = duration;
    this.calories = calories;
    this.distance = distance;
    this.version = version;
    this.realTimeSpeed = speed;
    this.signalFlag = signal;
  }

  /// app 交换中 ble回复
  appIng2BleReplyData(int version,int heartRate,int distance,int duration,int realTimeCalories,
      int realTimeSpeed,int kmSpeed,int steps,int swimPosture,int status,int realTimeSpeedPace,
      int trainingEffect,int anaerobicTrainingEffect,int actionType,int countHour,int countMinute,
      int countSecond
      ) {
      this.version = version;
      this.curHr = heartRate;
      this.distance = distance;
      this.durations = duration;
      this.calories = realTimeCalories;
      this.realTimeSpeed = realTimeSpeed;
      this.kmSpeed = kmSpeed;
      this.step = steps;
      this.swimPosture = swimPosture;
      this.status  = status;
      this.realTimePace = realTimeSpeedPace;
      this.trainingEffect = trainingEffect;
      this.anaerobicTrainingEffect = anaerobicTrainingEffect;
      this.actionType = actionType;
      this.countHour = countHour;
      this.countMinute = countMinute;
      this.countSecond = countSecond;
   }

  /// app 运动计划操作
  appPlan2BleData(int day, int hour, int minute, int second,
      int sportType,int operate, int trainingOffset, int planType) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
    this.operate = operate;
    this.trainingOffset = trainingOffset;
    this.planType = planType;
  }

  /// ble 运动计划操作
  blePlan2AppData(int trainingDay, int hour, int minute, int second,
      int sportType,int operate, int planType, int actionType,
      int errorCode, int trainingYear, int trainingMonth, int time,
      int lowHeart, int heightHeart
      ) {
    this.day = trainingDay;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
    this.operate = operate;
    this.actionType = actionType;
    this.planType = planType;
    this.retCode = errorCode;
    this.year = trainingYear;
    this.month = trainingMonth;
    this.time = time;
    this.lowHeart = lowHeart;
    this.heightHeart = heightHeart;
  }

  /// app 操作 ble 回复
  appPlan2BleReplyData(int operate,int retCode,int planType,int actionType) {
    this.retCode = retCode;
    this.operate = operate;
    this.planType = planType;
    this.actionType = actionType;
  }

  /// 获取心率数据
  getHrData(int day, int hour, int minute, int second,
      int sportType, int version, int length, int interval, List<int> heartRates) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
    this.version = version;
    this.hrCount = (this.hrCount ?? 0) + length;
    this.interval = interval;
    this.hrValues?.addAll(heartRates);
  }

  /// 获取最后运动数据
  getActivityData(int day, int hour, int minute, int second,
      int sportType,int year,int month,int version,int hrInterval,
      int step, int durations, int calories, int distance, int burnFatMins,
      int aerobicMins, int limitMins, int warmUp, int fatBurning, int aerobicExercise,
      int anaerobicExercise, int extremeExercise, int warmUpTime, int fatBurningTime,
      int aerobicExerciseTime, int anaerobicExerciseTime, int extremeExerciseTime,
      int avgSpeed, int avgStepStride, int maxStepStride, int kmSpeed, int maxSpeed,
      int fastKmSpeed, int avgStepFrequency, int maxStepFrequency, int avgHrValue,
      int maxHrValue, int kmSpeedCount, int actionDataCount, int stepsFrequencyCount,
      int miSpeedCount, int recoverTime, int vo2max, int trainingEffect, int grade,
      int realSpeedCount, int paceSpeedCount, int inClassCalories,
      int completionRate, int hrCompletionRate, List<int> kmSpeeds, List<int> stepsFrequency,
      List<int> itemsMiSpeed, List<int> itemRealSpeed, List<int> paceSpeedItems, List<Map<String,dynamic>> actionData,
      int segmentItemNum, int segmentTotalTime, int segmentTotalDistance, int segmentTotalPace, int segmentTotalAvgHr,
      int segmentTotalAvgStepFrequency, int paceHiit, int paceAnaerobic, int paceLacticAcidThreshold, int paceMarathon,
      int paceEasyRun, List<Map<String, dynamic>> segmentItems) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
    this.year = year;
    this.month = month;
    this.version = version;
    this.interval = hrInterval;
    this.step = step;
    this.durations = durations;
    this.calories = calories;
    this.distance = distance;
    this.burnFatMins = burnFatMins;
    this.aerobicMins = aerobicMins;
    this.limitMins = limitMins;
    this.warmUpValue = warmUp;
    this.fatBurnValue = fatBurning;
    this.aerobicValue = aerobicExercise;
    this.anaerobicValue = anaerobicExercise;
    this.limitValue = extremeExercise;
    this.warmUpSecond = warmUpTime;
    this.fatBurnSecond = fatBurningTime;
    this.aerobicSecond = aerobicExerciseTime;
    this.anaeroicSecond = anaerobicExerciseTime;
    this.limitSecond = extremeExerciseTime;
    this.avgSpeed = avgSpeed;
    this.avgStepStride = avgStepStride;
    this.maxStepStride = maxStepStride;
    this.kmSpeed = kmSpeed;
    this.maxSpeed = maxSpeed;
    this.fastKmSpeed = fastKmSpeed;
    this.avgStepFrequency = avgStepFrequency;
    this.maxStepFrequency = maxStepFrequency;
    this.avgHr = avgHrValue;
    this.maxHr = maxHrValue;
    this.recoverTime = recoverTime;
    this.vo2Max  = vo2max;
    this.trainingEffect = trainingEffect;
    this.grade = grade;
    this.kmSpeedCount = (this.kmSpeedCount ?? 0) + kmSpeedCount;
    this.actionDataCount = (this.actionDataCount ?? 0) + actionDataCount;
    this.stepsFrequencyCount = (this.stepsFrequencyCount ?? 0) + stepsFrequencyCount;
    this.mileCount = (this.mileCount ?? 0) + miSpeedCount;
    this.realSpeedCount = (this.realSpeedCount ?? 0) + realSpeedCount;
    this.paceSpeedCount = (this.paceSpeedCount ?? 0) + paceSpeedCount;
    this.inClassCalories = inClassCalories;
    this.completionRate = completionRate;
    this.hrCompletionRate = hrCompletionRate;
    this.kmSpeeds?.addAll(kmSpeeds);
    this.stepsFrequencys?.addAll(stepsFrequency);
    this.mileSpeeds?.addAll(itemsMiSpeed);
    this.realSpeeds?.addAll(itemRealSpeed);
    this.paceSpeeds?.addAll(paceSpeedItems);
    this.actionData?.addAll(actionData);
    this.segmentItemNum = (this.segmentItemNum ?? 0) + segmentItemNum;
    this.segmentTotalTime = segmentTotalTime;
    this.segmentTotalDistance = segmentTotalDistance;
    this.segmentTotalPace = segmentTotalPace;
    this.segmentTotalAvgHr = segmentTotalAvgHr;
    this.segmentTotalAvgStepFrequency = segmentTotalAvgStepFrequency;
    this.paceHiit = paceHiit;
    this.paceAnaerobic = paceAnaerobic;
    this.paceLacticAcidThreshold = paceLacticAcidThreshold;
    this.paceMarathon = paceMarathon;
    this.paceEasyRun = paceEasyRun;
    this.segmentItems?.addAll(segmentItems);
  }

  /// 获取云端GPS数据
  getActivityGpsData(int day, int hour, int minute, int second, int sportType,
      int version,int intervalSecond,int gpsCount,List<Map<String,dynamic>> gpsData) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
    this.version = version;
    this.intervalSecond = version;
    this.gpsCount = (this.gpsCount ?? 0) + gpsCount;
    this.gpsData?.addAll(gpsData);
  }

  /// ble 开始 app 回复
  bleStart2AppReplyData(int operate, int retCode) {
    this.retCode = retCode;
    this.operate = operate;
  }

  /// ble 操作 app 回复
  bleOperate2AppReplyData(int retCode) {
    this.retCode = retCode;
  }

  /// ble 交换中 app 回复
  bleIng2AppReplyData(int distance) {
    this.distance = distance;
  }

  /// ble 操作 app 回复
  blePlan2AppReplyData(int operate,int retCode,int planType,int actionType) {
    this.retCode = retCode;
    this.operate = operate;
    this.planType = planType;
    this.actionType = actionType;
  }

}

extension IDOV2ExchangeDataExtension on IDOV2ExchangeModel {

  /// app 发起ble暂停、ble
  appStartBle2AppData(int day, int hour, int minute, int second, int sportType) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
  }

  /// app 发起ble暂停、ble恢复 app回复
  appStartBle2AppReplyData(int retCode) {
    this.retCode = retCode;
  }

  /// app 发起ble停止
  appStartBleEnd2AppData(int day, int hour, int minute, int second, int sportType, int duration, int calories, int distance,
      int avgHr, int maxHr, int burnFatMins, int aerobicMins, int limitMins, int isSave
      ) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
    this.durations = duration;
    this.calories = calories;
    this.distance = distance;
    this.avgHr = avgHr;
    this.maxHr = maxHr;
    this.burnFatMins = burnFatMins;
    this.aerobicMins = aerobicMins;
    this.limitMins = limitMins;
    this.isSave = isSave == 1;
  }

  /// app 发起ble停止 app回复
  appStartBleEnd2AppReplyData(int duration, int calories, int distance, int errCode) {
    this.durations = duration;
    this.calories = calories;
    this.distance = distance;
    this.retCode = errCode;
  }

  /// ble 开始
  bleStart2AppData(int day, int hour, int minute, int second, int sportType,int operate) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
    this.operate = operate;
  }

  /// ble 结束
  bleEnd2AppData(int day, int hour, int minute, int second, int sportType) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
  }

  /// ble 暂停
  blePause2AppData(int day, int hour, int minute, int second, int sportType) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
  }

  /// ble 恢复
  bleRestore2AppData(int day, int hour, int minute, int second, int sportType) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
  }

  /// ble 交换中
  bleIng2AppData(int day, int hour, int minute, int second, int sportType,int distance) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
    this.distance = distance;
  }

  /// app 开始
  appStart2BleData(int day, int hour, int minute, int second,
      int sportType,int targetType,int targetValue,int forceStart) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
    this.targetType = targetType;
    this.targetValue = targetValue;
    this.forceStart = forceStart;
  }

  /// app 操作 ble回复
  appOperate2BleReplyData(int retCode) {
    this.retCode = retCode;
  }


  /// app 结束
  appEnd2BleData(int day, int hour, int minute, int second,
      int sportType,int duration,int calories,int distance,int isSave) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
    this.durations = duration;
    this.calories = calories;
    this.distance = distance;
    this.isSave = isSave == 1;
  }

  /// app 结束 ble回复
  appEnd2BleReplyData(int retCode,int calories,int distance,int step,
      int avgHr,int maxHr,int burnFatMins,int aerobicMins,int limitMins) {
    this.retCode = retCode;
    this.calories = calories;
    this.distance = distance;
    this.step = step;
    this.avgHr = avgHr;
    this.maxHr = maxHr;
    this.burnFatMins = burnFatMins;
    this.aerobicMins = aerobicMins;
    this.limitMins = limitMins;
  }

  /// app 恢复
  appRestore2BleData(int day, int hour, int minute, int second, int sportType) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
  }

  /// app 暂停
  appPause2BleData(int day, int hour, int minute, int second, int sportType) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
  }

  /// app 交换中
  appIng2BleData(int day, int hour, int minute, int second,
      int sportType,int duration,int calories,int distance,int status) {
    this.day = day;
    this.hour = hour;
    this.minute = minute;
    this.second = second;
    this.sportType = sportType;
    this.durations = duration;
    this.calories = calories;
    this.distance = distance;
    this.status = status;
  }

  /// app 交换中 ble回复
  appIng2BleReplyData(int heartRate,int distance,int calories,
      int hrSerial,int interval,int steps,int status,List<int> hrValues
      ) {
    this.curHr = heartRate;
    this.distance = distance;
    this.calories = calories;
    this.step = steps;
    this.status  = status;
    this.hrSerial = hrSerial;
    this.interval = interval;
    this.hrValues?.addAll(hrValues);
  }

  /// ble 开始 app 回复
  bleStart2AppReplyData(int operate, int retCode) {
    this.retCode = retCode;
    this.operate = operate;
  }

  /// ble 操作 app 回复
  bleOperate2AppReplyData(int retCode) {
    this.retCode = retCode;
  }

  /// ble 交换中 app 回复
  bleIng2AppReplyData(int distance) {
    this.distance = distance;
  }

}