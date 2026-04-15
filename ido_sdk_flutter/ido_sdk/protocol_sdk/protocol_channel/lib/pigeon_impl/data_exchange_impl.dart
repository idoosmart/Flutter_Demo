import 'package:protocol_lib/protocol_lib.dart';

import '../pigeon_generate/data_exchange.g.dart';

class DataExchangeImpl extends ApiExchangeData {
  final _exchangeDelegate = ApiExchangeDataDelegate();

  DataExchangeImpl() {
    libManager.exchangeData.listenExchangeStatus().listen((event) {
      final status = ApiExchangeStatus.values[event.index];
      _exchangeDelegate.listenExchangeState(status);
    });
    libManager.exchangeData.listenBleResponse().listen((event) {
      if (event.model is IDOBleStartExchangeModel) {
        final model = BleStartExchangeModel(
            baseModel: event.model?._toInnerModel(),
            operate: (event.model as IDOBleStartExchangeModel).operate);
        _exchangeDelegate.listenBleResponse(model);
      } else if (event.model is IDOBleIngExchangeModel) {
        final model = BleIngExchangeModel(
            baseModel: event.model?._toInnerModel(),
            distance: (event.model as IDOBleIngExchangeModel).distance);
        _exchangeDelegate.listenBleResponse(model);
      } else if (event.model is IDOBleEndExchangeModel) {
        final model =
            BleEndExchangeModel(baseModel: event.model?._toInnerModel());
        _exchangeDelegate.listenBleResponse(model);
      } else if (event.model is IDOBlePauseExchangeModel) {
        final model =
            BlePauseExchangeModel(baseModel: event.model?._toInnerModel());
        _exchangeDelegate.listenBleResponse(model);
      } else if (event.model is IDOBleRestoreExchangeModel) {
        final model =
            BleRestoreExchangeModel(baseModel: event.model?._toInnerModel());
        _exchangeDelegate.listenBleResponse(model);
      } else if (event.model is IDOBleOperatePlanExchangeModel) {
        final plan = event.model as IDOBleOperatePlanExchangeModel;
        final model = BleOperatePlanExchangeModel(
            baseModel: event.model?._toInnerModel(),
            operate: plan.operate,
            planType: plan.planType,
            actionType: plan.actionType,
            errorCode: plan.errorCode,
            trainingYear: plan.trainingYear,
            trainingMonth: plan.trainingMonth,
            trainingDay: plan.trainingDay,
            time: plan.time,
            lowHeart: plan.lowHeart,
            heightHeart: plan.heightHeart);
        _exchangeDelegate.listenBleResponse(model);
      } else if (event.model is IDOAppBlePauseExchangeModel) {
        final model =
            AppBlePauseExchangeModel(baseModel: event.model?._toInnerModel());
        _exchangeDelegate.listenBleResponse(model);
      } else if (event.model is IDOAppBleRestoreExchangeModel) {
        final model =
            AppBleRestoreExchangeModel(baseModel: event.model?._toInnerModel());
        _exchangeDelegate.listenBleResponse(model);
      } else if (event.model is IDOAppBleEndExchangeModel) {
        final end = event.model as IDOAppBleEndExchangeModel;
        final model = AppBleEndExchangeModel(
            baseModel: event.model?._toInnerModel(),
            duration: end.duration,
            calories: end.calories,
            distance: end.distance,
            avgHr: end.avgHr,
            maxHr: end.maxHr,
            burnFatMins: end.burnFatMins,
            aerobicMins: end.aerobicMins,
            limitMins: end.limitMins,
            isSave: end.isSave);
        _exchangeDelegate.listenBleResponse(model);
      } else if (event.model is IDOAppStartReplyExchangeModel) {
        final model = AppStartReplyExchangeModel(
            baseModel: event.model?._toInnerModel(),
            retCode: (event.model as IDOAppStartReplyExchangeModel).retCode);
        _exchangeDelegate.listenBleResponse(model);
      } else if (event.model is IDOAppEndReplyExchangeModel) {
        final end = event.model as IDOAppEndReplyExchangeModel;
        final model = AppEndReplyExchangeModel(
            baseModel: event.model?._toInnerModel(),
            errorCode: end.errorCode,
            calories: end.calories,
            distance: end.distance,
            step: end.step,
            avgHr: end.avgHr,
            maxHr: end.maxHr,
            burnFatMins: end.burnFatMins,
            aerobicMins: end.aerobicMins,
            limitMins: end.limitMins);
        _exchangeDelegate.listenBleResponse(model);
      } else if (event.model is IDOAppIngReplyExchangeModel) {
        final ing = event.model as IDOAppIngReplyExchangeModel;
        final model = AppIngReplyExchangeModel(
            baseModel: event.model?._toInnerModel(),
            calories: ing.calories,
            distance: ing.distance,
            status: ing.status,
            step: ing.step,
            currentHr: ing.currentHr,
            interval: ing.interval,
            hrSerial: ing.hrSerial,
            hrJson: ing.hrJson);
        _exchangeDelegate.listenBleResponse(model);
      } else if (event.model is IDOAppPauseReplyExchangeModel) {
        final model = AppPauseReplyExchangeModel(
            baseModel: event.model?._toInnerModel(),
            errCode: (event.model as IDOAppPauseReplyExchangeModel).errCode);
        _exchangeDelegate.listenBleResponse(model);
      } else if (event.model is IDOAppRestoreReplyExchangeModel) {
        final model = AppRestoreReplyExchangeModel(
            baseModel: event.model?._toInnerModel(),
            errCode: (event.model as IDOAppRestoreReplyExchangeModel).errCode);
        _exchangeDelegate.listenBleResponse(model);
      } else if (event.model is IDOAppIngV3ReplyExchangeModel) {
        final ing = event.model as IDOAppIngV3ReplyExchangeModel;
        final model = AppIngV3ReplyExchangeModel(
            baseModel: event.model?._toInnerModel(),
            version: ing.version,
            heartRate: ing.heartRate,
            distance: ing.distance,
            duration: ing.duration,
            realTimeCalories: ing.realTimeCalories,
            realTimeSpeed: ing.realTimeSpeed,
            kmSpeed: ing.kmSpeed,
            steps: ing.steps,
            swimPosture: ing.swimPosture,
            status: ing.status,
            realTimeSpeedPace: ing.realTimeSpeedPace,
            trainingEffect: ing.trainingEffect,
            anaerobicTrainingEffect: ing.anaerobicTrainingEffect,
            actionType: ing.actionType,
            countHour: ing.countHour,
            countMinute: ing.countMinute,
            countSecond: ing.countSecond);
        _exchangeDelegate.listenBleResponse(model);
      } else if (event.model is IDOAppOperatePlanReplyExchangeModel) {
        final plan = event.model as IDOAppOperatePlanReplyExchangeModel;
        final model = AppOperatePlanReplyExchangeModel(
            baseModel: event.model?._toInnerModel(),
            planType: plan.planType,
            operate: plan.operate,
            actionType: plan.actionType,
            errorCode: plan.errorCode);
        _exchangeDelegate.listenBleResponse(model);
      } else if (event.model is IDOAppActivityDataV3ExchangeModel) {
        final activity = event.model as IDOAppActivityDataV3ExchangeModel;
        final model = AppActivityDataV3ExchangeModel(
            baseModel: event.model?._toInnerModel(),
            year: activity.year,
            month: activity.month,
            version: activity.version,
            hrInterval: activity.hrInterval,
            step: activity.step,
            durations: activity.durations,
            calories: activity.calories,
            distance: activity.distance,
            burnFatMins: activity.burnFatMins,
            aerobicMins: activity.aerobicMins,
            limitMins: activity.limitMins,
            warmUp: activity.warmUp,
            fatBurning: activity.fatBurning,
            aerobicExercise: activity.aerobicExercise,
            warmUpTime: activity.warmUpTime,
            fatBurningTime: activity.fatBurningTime,
            aerobicExerciseTime: activity.aerobicExerciseTime,
            anaerobicExerciseTime: activity.anaerobicExerciseTime,
            extremeExerciseTime: activity.extremeExerciseTime,
            avgSpeed: activity.avgSpeed,
            maxSpeed: activity.maxSpeed,
            avgStepStride: activity.avgStepStride,
            maxStepStride: activity.maxStepStride,
            kmSpeed: activity.kmSpeed,
            fastKmSpeed: activity.fastKmSpeed,
            avgStepFrequency: activity.avgStepFrequency,
            maxStepFrequency: activity.maxStepFrequency,
            avgHrValue: activity.avgHrValue,
            maxHrValue: activity.maxHrValue,
            recoverTime: activity.recoverTime,
            vo2max: activity.vo2max,
            trainingEffect: activity.trainingEffect,
            grade: activity.grade,
            stepsFrequencyCount: activity.stepsFrequencyCount,
            miSpeedCount: activity.miSpeedCount,
            realSpeedCount: activity.realSpeedCount,
            paceSpeedCount: activity.paceSpeedCount,
            kmSpeedCount: activity.kmSpeedCount,
            actionDataCount: activity.actionDataCount,
            inClassCalories: activity.inClassCalories,
            completionRate: activity.completionRate,
            hrCompletionRate: activity.hrCompletionRate,
            kmSpeeds: activity.kmSpeeds,
            stepsFrequency: activity.stepsFrequency,
            itemsMiSpeed: activity.itemsMiSpeed,
            itemRealSpeed: activity.itemRealSpeed,
            paceSpeedItems: activity.paceSpeedItems,
            actionData: activity.actionData);
        _exchangeDelegate.listenBleResponse(model);
      } else if (event.model is IDOAppHrDataExchangeModel) {
        final hr = event.model as IDOAppHrDataExchangeModel;
        final model = ApiAppHrDataExchangeModel(
            baseModel: event.model?._toInnerModel(),
            version: hr.version,
            heartRateHistoryLen: hr.heartRateHistoryLen,
            interval: hr.interval,
            heartRates: hr.heartRates);
        _exchangeDelegate.listenBleResponse(model);
      } else if (event.model is IDOAppGpsDataExchangeModel) {
        final gps = event.model as IDOAppGpsDataExchangeModel;
        final model = ApiAppGpsDataExchangeModel(
            baseModel: event.model?._toInnerModel(),
            version: gps.version,
            intervalSecond: gps.intervalSecond,
            gpsCount: gps.gpsCount,
            gpsData: gps.gpsData);
        _exchangeDelegate.listenBleResponse(model);
      }
    });
    libManager.exchangeData.v2_exchangeData().listen((event) {
      final model = ApiExchangeV2Model(
        baseModel: ApiExchangeBaseModel(
            day: event.day,
            hour: event.hour,
            minute: event.minute,
            second: event.minute,
            sportType: event.sportType),
        operate: event.operate,
        targetValue: event.targetValue,
        targetType: event.targetType,
        forceStart: event.forceStart,
        retCode: event.retCode,
        calories: event.calories,
        distance: event.distance,
        durations: event.durations,
        step: event.step,
        avgHr: event.avgHr,
        maxHr: event.maxHr,
        curHr: event.curHr,
        hrSerial: event.hrSerial,
        burnFatMins: event.burnFatMins,
        aerobicMins: event.aerobicMins,
        limitMins: event.limitMins,
        isSave: event.isSave,
        status: event.status,
        interval: event.interval,
        hrValues: event.hrValues,
      );
      _exchangeDelegate.exchangeV2Data(model);
    });
    libManager.exchangeData.v3_exchangeData().listen((event) {
      final model = ApiExchangeV3Model(
        baseModel: ApiExchangeBaseModel(
            day: event.day,
            hour: event.hour,
            minute: event.minute,
            second: event.minute,
            sportType: event.sportType),
        year: event.year,
        month: event.month,
        planType: event.planType,
        actionType: event.actionType,
        version: event.version,
        operate: event.operate,
        targetValue: event.targetValue,
        targetType: event.targetType,
        forceStart: event.forceStart,
        retCode: event.retCode,
        calories: event.calories,
        distance: event.distance,
        durations: event.durations,
        step: event.step,
        swimPosture: event.swimPosture,
        status: event.status,
        signalFlag: event.signalFlag,
        isSave: event.isSave,
        realTimeSpeed: event.realTimeSpeed,
        realTimePace: event.realTimePace,
        interval: event.interval,
        hrCount: event.hrCount,
        burnFatMins: event.burnFatMins,
        aerobicMins: event.aerobicMins,
        limitMins: event.limitMins,
        hrValues: event.hrValues,
        warmUpSecond: event.warmUpSecond,
        anaeroicSecond: event.anaeroicSecond,
        fatBurnSecond: event.fatBurnSecond,
        aerobicSecond: event.aerobicSecond,
        limitSecond: event.limitSecond,
        avgHr: event.avgHr,
        maxHr: event.maxHr,
        curHr: event.curHr,
        warmUpValue: event.warmUpValue,
        fatBurnValue: event.fatBurnValue,
        aerobicValue: event.aerobicValue,
        limitValue: event.limitValue,
        anaerobicValue: event.anaerobicValue,
        avgSpeed: event.avgSpeed,
        maxSpeed: event.maxSpeed,
        avgStepFrequency: event.avgStepFrequency,
        maxStepFrequency: event.maxStepFrequency,
        avgStepStride: event.avgStepStride,
        maxStepStride: event.maxStepStride,
        kmSpeed: event.kmSpeed,
        fastKmSpeed: event.fastKmSpeed,
        kmSpeedCount: event.kmSpeedCount,
        kmSpeeds: event.kmSpeeds,
        mileCount: event.mileCount,
        mileSpeeds: event.mileSpeeds,
        stepsFrequencyCount: event.stepsFrequencyCount,
        stepsFrequencys: event.stepsFrequencys,
        trainingEffect: event.trainingEffect,
        anaerobicTrainingEffect: event.anaerobicTrainingEffect,
        vo2Max: event.vo2Max,
        actionDataCount: event.actionDataCount,
        inClassCalories: event.inClassCalories,
        completionRate: event.completionRate,
        hrCompletionRate: event.hrCompletionRate,
        recoverTime: event.recoverTime,
        avgWeekActivityTime: event.avgWeekActivityTime,
        grade: event.grade,
        actionData: event.actionData,
        trainingOffset: event.trainingOffset,
        countHour: event.countHour,
        countMinute: event.countMinute,
        countSecond: event.countSecond,
        time: event.time,
        lowHeart: event.lowHeart,
        heightHeart: event.heightHeart,
        paceSpeedCount: event.paceSpeedCount,
        paceSpeeds: event.paceSpeeds,
        realSpeedCount: event.realSpeedCount,
        realSpeeds: event.realSpeeds,
      );
      _exchangeDelegate.exchangeV3Data(model);
    });
  }

  @override
  void appExec(Object? model) {
    libManager.exchangeData.appExec(model: _mapModel(model));
  }

  @override
  void appReplyExec(Object? model) {
    libManager.exchangeData.appReplyExec(model: _mapModel(model));
  }

  @override
  ApiExchangeStatus? status() {
    if (libManager.exchangeData.status == null) {
      return null;
    }
    final status =
        ApiExchangeStatus.values[libManager.exchangeData.status!.index];
    return status;
  }

  @override
  bool supportV3ActivityExchange() {
    return libManager.exchangeData.supportV3ActivityExchange;
  }

  @override
  void tmpGenEntryModel(
      BleOperatePlanReplyExchangeModel? t0,
      BleOperatePlanExchangeModel? t1,
      ApiExchangeV2Model? t2,
      ApiExchangeV3Model? t3,
      AppStartExchangeModel? t4,
      AppStartReplyExchangeModel? t5,
      AppEndExchangeModel? t6,
      AppIngExchangeModel? t8,
      AppPauseReplyExchangeModel? t9,
      AppRestoreExchangeModel? t10,
      AppRestoreReplyExchangeModel? t11,
      AppIngV3ExchangeModel? t12,
      AppIngV3ReplyExchangeModel? t13,
      AppActivityDataV3ExchangeModel? t14,
      AppBlePauseExchangeModel? t16,
      AppBleRestoreExchangeModel? t18,
      AppBleRestoreReplyExchangeModel? t19,
      AppBleEndExchangeModel? t20,
      AppBleEndReplyExchangeModel? t21,
      BleStartExchangeModel? t22,
      BleIngExchangeModel? t23,
      BleEndExchangeModel? t24,
      BlePauseExchangeModel? t25,
      AppBlePauseReplyExchangeModel? t26,
      AppOperatePlanReplyExchangeModel? t29,
      AppOperatePlanExchangeModel? t30,
      BleRestoreReplyExchangeModel? t31,
      BlePauseReplyExchangeModel? t32,
      BleEndReplyExchangeModel? t33,
      BleIngReplyExchangeModel? t34,
      BleStartReplyExchangeModel? t35,
      BleRestoreExchangeModel? t36,
      AppPauseExchangeModel? t37,
      ApiAppHrDataExchangeModel? t38,
      AppEndReplyExchangeModel? t39,
      AppIngReplyExchangeModel? t40,
      ApiAppGpsDataExchangeModel? t41) {
    throw UnimplementedError('此方法不需要调用');
  }

  @override
  Future<bool> getActivityGpsData() {
    return libManager.exchangeData.getActivityGpsData();
  }

  @override
  Future<bool> getActivityHrData() {
    return libManager.exchangeData.getActivityHrData();
  }

  @override
  Future<bool> getLastActivityData() {
    return libManager.exchangeData.getLastActivityData();
  }
}

extension DataExchangeImplExt on DataExchangeImpl {
  dynamic _mapModel(dynamic obj) {
    if (obj is BleOperatePlanReplyExchangeModel) {
      return IDOBleOperatePlanReplyExchangeModel()
        .._fillBaseModel(obj.baseModel)
        ..operate = obj.operate
        ..planType = obj.planType
        ..actionType = obj.actionType
        ..errorCode = obj.errorCode;
    } else if (obj is BleOperatePlanExchangeModel) {
      return IDOBleOperatePlanExchangeModel(
          operate: obj.operate,
          planType: obj.planType,
          actionType: obj.actionType,
          errorCode: obj.errorCode,
          trainingYear: obj.trainingYear,
          trainingMonth: obj.trainingMonth,
          trainingDay: obj.trainingDay,
          time: obj.time,
          lowHeart: obj.lowHeart,
          heightHeart: obj.heightHeart)
        .._fillBaseModel(obj.baseModel);
    } else if (obj is ApiExchangeV2Model) {
      final model = IDOV2ExchangeModel(
        day: obj.baseModel?.day,
        hour: obj.baseModel?.hour,
        minute: obj.baseModel?.minute,
        second: obj.baseModel?.second,
        sportType: obj.baseModel?.sportType,
        operate: obj.operate,
        targetValue: obj.targetValue,
        targetType: obj.targetType,
        forceStart: obj.forceStart,
        retCode: obj.retCode,
        calories: obj.calories,
        distance: obj.distance,
        durations: obj.durations,
        step: obj.step,
        avgHr: obj.avgHr,
        maxHr: obj.maxHr,
        curHr: obj.curHr,
        hrSerial: obj.hrSerial,
        burnFatMins: obj.burnFatMins,
        aerobicMins: obj.aerobicMins,
        limitMins: obj.limitMins,
        isSave: obj.isSave,
        status: obj.status,
        interval: obj.interval,
        hrValues: obj.hrValues?.where((e) => e != null).toList() as List<int>,
      );
      return model;
    } else if (obj is ApiExchangeV3Model) {
      return IDOV3ExchangeModel(
        year: obj.year,
        month: obj.month,
        day: obj.baseModel?.day,
        hour: obj.baseModel?.hour,
        minute: obj.baseModel?.minute,
        second: obj.baseModel?.second,
        sportType: obj.baseModel?.sportType,
        planType: obj.planType,
        actionType: obj.actionType,
        version: obj.version,
        operate: obj.operate,
        targetValue: obj.targetValue,
        targetType: obj.targetType,
        forceStart: obj.forceStart,
        retCode: obj.retCode,
        calories: obj.calories,
        distance: obj.distance,
        durations: obj.durations,
        step: obj.step,
        swimPosture: obj.swimPosture,
        status: obj.status,
        signalFlag: obj.signalFlag,
        isSave: obj.isSave,
        realTimeSpeed: obj.realTimeSpeed,
        realTimePace: obj.realTimePace,
        interval: obj.interval,
        hrCount: obj.hrCount,
        burnFatMins: obj.burnFatMins,
        aerobicMins: obj.aerobicMins,
        limitMins: obj.limitMins,
        hrValues: obj.hrValues?.where((e) => e != null) as List<int>,
        warmUpSecond: obj.warmUpSecond,
        anaeroicSecond: obj.anaeroicSecond,
        fatBurnSecond: obj.fatBurnSecond,
        aerobicSecond: obj.aerobicSecond,
        limitSecond: obj.limitSecond,
        avgHr: obj.avgHr,
        maxHr: obj.maxHr,
        curHr: obj.curHr,
        warmUpValue: obj.warmUpValue,
        fatBurnValue: obj.fatBurnValue,
        aerobicValue: obj.aerobicValue,
        limitValue: obj.limitValue,
        anaerobicValue: obj.anaerobicValue,
        avgSpeed: obj.avgSpeed,
        maxSpeed: obj.maxSpeed,
        avgStepFrequency: obj.avgStepFrequency,
        maxStepFrequency: obj.maxStepFrequency,
        avgStepStride: obj.avgStepStride,
        maxStepStride: obj.maxStepStride,
        kmSpeed: obj.kmSpeed,
        fastKmSpeed: obj.fastKmSpeed,
        kmSpeedCount: obj.kmSpeedCount,
        kmSpeeds: obj.kmSpeeds?.where((e) => e != null) as List<int>,
        mileCount: obj.mileCount,
        mileSpeeds: obj.mileSpeeds?.where((e) => e != null) as List<int>,
        stepsFrequencyCount: obj.stepsFrequencyCount,
        stepsFrequencys:
            obj.stepsFrequencys?.where((e) => e != null) as List<int>,
        trainingEffect: obj.trainingEffect,
        anaerobicTrainingEffect: obj.anaerobicTrainingEffect,
        vo2Max: obj.vo2Max,
        actionDataCount: obj.actionDataCount,
        inClassCalories: obj.inClassCalories,
        completionRate: obj.completionRate,
        hrCompletionRate: obj.hrCompletionRate,
        recoverTime: obj.recoverTime,
        avgWeekActivityTime: obj.avgWeekActivityTime,
        grade: obj.grade,
        actionData: obj.actionData?.where((e) => e != null)
            as List<Map<String, dynamic>>,
        trainingOffset: obj.trainingOffset,
        countHour: obj.countHour,
        countMinute: obj.countMinute,
        countSecond: obj.countSecond,
        time: obj.time,
        lowHeart: obj.lowHeart,
        heightHeart: obj.heightHeart,
        paceSpeedCount: obj.paceSpeedCount,
        paceSpeeds: obj.paceSpeeds?.where((e) => e != null) as List<int>,
        realSpeedCount: obj.realSpeedCount,
        realSpeeds: obj.realSpeeds?.where((e) => e != null) as List<int>,
      );
    } else if (obj is AppStartExchangeModel) {
      return IDOAppStartExchangeModel()
        .._fillBaseModel(obj.baseModel)
        ..targetType = obj.targetType
        ..targetValue = obj.targetValue
        ..forceStart = obj.forceStart
        ..vo2max = obj.vo2max
        ..recoverTime = obj.recoverTime
        ..avgWeekActivityTime = obj.avgWeekActivityTime;
    } else if (obj is AppStartReplyExchangeModel) {
      return IDOAppStartReplyExchangeModel()
        .._fillBaseModel(obj.baseModel)
        ..retCode = obj.retCode;
    } else if (obj is AppEndExchangeModel) {
      return IDOAppEndExchangeModel()
        .._fillBaseModel(obj.baseModel)
        ..duration = obj.duration
        ..calories = obj.calories
        ..distance = obj.distance
        ..isSave = obj.isSave;
    } else if (obj is AppIngExchangeModel) {
      return IDOAppIngExchangeModel()
        .._fillBaseModel(obj.baseModel)
        ..duration = obj.duration
        ..calories = obj.calories
        ..distance = obj.distance
        ..status = obj.status;
    } else if (obj is AppPauseExchangeModel) {
      return IDOAppPauseExchangeModel()
        ..pauseHour = obj.pauseHour
        ..pauseMinute = obj.pauseMinute
        ..pauseSecond = obj.pauseSecond
        .._fillBaseModel(obj.baseModel);
    } else if (obj is AppPauseReplyExchangeModel) {
      return IDOAppPauseReplyExchangeModel()
        .._fillBaseModel(obj.baseModel)
        ..errCode = obj.errCode;
    } else if (obj is AppRestoreExchangeModel) {
      return IDOAppRestoreExchangeModel().._fillBaseModel(obj.baseModel);
    } else if (obj is AppRestoreReplyExchangeModel) {
      return IDOAppRestoreReplyExchangeModel()
        .._fillBaseModel(obj.baseModel)
        ..errCode = obj.errCode;
    } else if (obj is AppIngV3ExchangeModel) {
      return IDOAppIngV3ExchangeModel()
        .._fillBaseModel(obj.baseModel)
        ..version = obj.version
        ..signal = obj.signal
        ..distance = obj.distance
        ..speed = obj.speed
        ..duration = obj.duration
        ..calories = obj.calories;
    } else if (obj is AppIngV3ReplyExchangeModel) {
      return IDOAppIngV3ReplyExchangeModel(
        version: obj.version,
        heartRate: obj.heartRate,
        distance: obj.distance,
        duration: obj.duration,
        realTimeCalories: obj.realTimeCalories,
        realTimeSpeed: obj.realTimeSpeed,
        kmSpeed: obj.kmSpeed,
        steps: obj.steps,
        swimPosture: obj.swimPosture,
        status: obj.status,
        realTimeSpeedPace: obj.realTimeSpeedPace,
        trainingEffect: obj.trainingEffect,
        anaerobicTrainingEffect: obj.anaerobicTrainingEffect,
        actionType: obj.actionType,
        countHour: obj.countHour,
        countMinute: obj.countMinute,
        countSecond: obj.countSecond,
      ).._fillBaseModel(obj.baseModel);
    } else if (obj is AppActivityDataV3ExchangeModel) {
      return IDOAppActivityDataV3ExchangeModel(
        year: obj.year,
        month: obj.month,
        version: obj.version,
        hrInterval: obj.hrInterval,
        step: obj.step,
        durations: obj.durations,
        calories: obj.calories,
        distance: obj.distance,
        burnFatMins: obj.burnFatMins,
        aerobicMins: obj.aerobicMins,
        limitMins: obj.limitMins,
        warmUp: obj.warmUp,
        fatBurning: obj.fatBurning,
        aerobicExercise: obj.aerobicExercise,
        anaerobicExercise: obj.anaerobicExercise,
        extremeExercise: obj.extremeExercise,
        warmUpTime: obj.warmUpTime,
        fatBurningTime: obj.fatBurningTime,
        aerobicExerciseTime: obj.aerobicExerciseTime,
        anaerobicExerciseTime: obj.anaerobicExerciseTime,
        extremeExerciseTime: obj.extremeExerciseTime,
        avgSpeed: obj.avgSpeed,
        avgStepStride: obj.avgStepStride,
        maxStepStride: obj.maxStepStride,
        kmSpeed: obj.kmSpeed,
        fastKmSpeed: obj.fastKmSpeed,
        avgStepFrequency: obj.avgStepFrequency,
        maxStepFrequency: obj.maxStepFrequency,
        avgHrValue: obj.avgHrValue,
        maxHrValue: obj.maxHrValue,
        kmSpeedCount: obj.kmSpeedCount,
        actionDataCount: obj.actionDataCount,
        stepsFrequencyCount: obj.stepsFrequencyCount,
        miSpeedCount: obj.miSpeedCount,
        recoverTime: obj.recoverTime,
        vo2max: obj.vo2max,
        trainingEffect: obj.trainingEffect,
        grade: obj.grade,
        realSpeedCount: obj.realSpeedCount,
        paceSpeedCount: obj.paceSpeedCount,
        kmSpeeds: obj.kmSpeeds?.where((e) => e != null) as List<int>,
        stepsFrequency:
            obj.stepsFrequency?.where((e) => e != null) as List<int>,
        itemsMiSpeed: obj.itemsMiSpeed?.where((e) => e != null) as List<int>,
        itemRealSpeed: obj.itemRealSpeed?.where((e) => e != null) as List<int>,
        paceSpeedItems:
            obj.paceSpeedItems?.where((e) => e != null) as List<int>,
        actionData: obj.actionData?.where((e) => e != null)
            as List<Map<String, dynamic>>,
      ).._fillBaseModel(obj.baseModel);
    } else if (obj is AppBlePauseExchangeModel) {
      return IDOAppBlePauseExchangeModel().._fillBaseModel(obj.baseModel);
    } else if (obj is AppBleRestoreExchangeModel) {
      return IDOAppBleRestoreExchangeModel().._fillBaseModel(obj.baseModel);
    } else if (obj is AppBleRestoreReplyExchangeModel) {
      return IDOAppBleRestoreReplyExchangeModel()
        .._fillBaseModel(obj.baseModel)
        ..errCode = obj.errCode;
    } else if (obj is AppBleEndExchangeModel) {
      return IDOAppBleEndExchangeModel(
        calories: obj.calories,
        distance: obj.distance,
        avgHr: obj.avgHr,
        maxHr: obj.maxHr,
        burnFatMins: obj.burnFatMins,
        aerobicMins: obj.aerobicMins,
        limitMins: obj.limitMins,
        isSave: obj.isSave,
      );
    } else if (obj is AppBleEndReplyExchangeModel) {
      return IDOAppBleEndReplyExchangeModel()
        .._fillBaseModel(obj.baseModel)
        ..errCode = obj.errCode
        ..duration = obj.duration
        ..calories = obj.calories
        ..distance = obj.distance;
    } else if (obj is BleStartExchangeModel) {
      return IDOBleStartExchangeModel()
        .._fillBaseModel(obj.baseModel)
        ..operate = obj.operate;
    } else if (obj is BleIngExchangeModel) {
      return IDOBleIngExchangeModel()
        .._fillBaseModel(obj.baseModel)
        ..distance = obj.distance;
    } else if (obj is BleEndExchangeModel) {
      return IDOBleEndExchangeModel().._fillBaseModel(obj.baseModel);
    } else if (obj is BlePauseExchangeModel) {
      return IDOBlePauseExchangeModel().._fillBaseModel(obj.baseModel);
    } else if (obj is AppBlePauseReplyExchangeModel) {
      return IDOAppBlePauseReplyExchangeModel()
        .._fillBaseModel(obj.baseModel)
        ..errCode = obj.errCode;
    } else if (obj is AppOperatePlanReplyExchangeModel) {
      return IDOAppOperatePlanReplyExchangeModel(
        planType: obj.planType,
        operate: obj.operate,
        actionType: obj.actionType,
        errorCode: obj.errorCode,
      ).._fillBaseModel(obj.baseModel);
    } else if (obj is AppOperatePlanExchangeModel) {
      return IDOAppOperatePlanExchangeModel()
        ..operate = obj.operate
        ..planType = obj.planType
        ..trainingOffset = obj.trainingOffset
        .._fillBaseModel(obj.baseModel);
    } else if (obj is BleRestoreReplyExchangeModel) {
      return IDOBleRestoreReplyExchangeModel()
        .._fillBaseModel(obj.baseModel)
        ..retCode = obj.retCode;
    } else if (obj is BlePauseReplyExchangeModel) {
      return IDOBlePauseReplyExchangeModel()
        .._fillBaseModel(obj.baseModel)
        ..retCode = obj.retCode;
    } else if (obj is BleEndReplyExchangeModel) {
      return IDOBleEndReplyExchangeModel()
        .._fillBaseModel(obj.baseModel)
        ..retCode = obj.retCode;
    } else if (obj is BleIngReplyExchangeModel) {
      return IDOBleIngReplyExchangeModel()
        .._fillBaseModel(obj.baseModel)
        ..distance = obj.distance;
    } else if (obj is BleStartReplyExchangeModel) {
      return IDOBleStartReplyExchangeModel()
        .._fillBaseModel(obj.baseModel)
        ..retCode = obj.retCode
        ..operate = obj.operate;
    } else if (obj is BleRestoreExchangeModel) {
      return IDOBleRestoreExchangeModel().._fillBaseModel(obj.baseModel);
    } else {
      throw '类型不匹配，需要修改';
    }
  }
}

extension IDOBaseExchangeModelExt on IDOBaseExchangeModel {
  void _fillBaseModel(ApiExchangeBaseModel? baseModel) {
    if (baseModel != null) {
      day = baseModel.day;
      hour = baseModel.hour;
      minute = baseModel.minute;
      second = baseModel.second;
      sportType = baseModel.sportType;
    }
  }

  ApiExchangeBaseModel _toInnerModel() {
    return ApiExchangeBaseModel(
        day: day,
        hour: hour,
        minute: minute,
        second: second,
        sportType: sportType);
  }
}
