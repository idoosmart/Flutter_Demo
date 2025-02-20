part of '../ido_data_exchange.dart';

class _IDOExchangeData implements IDOExchangeData {
  static final _instance = _IDOExchangeData._internal();
  _IDOExchangeData._internal(){
    _init();
  }
  factory _IDOExchangeData() => _instance;
  late final _libMgr = IDOProtocolLibManager();
  late final _funTable = _libMgr.funTable;
  late final _coreMgr = IDOProtocolCoreManager();
  late final _streamResponse = StreamController<ExchangeResponse>.broadcast();
  late final _streamV2Exchange = StreamController<IDOV2ExchangeModel>.broadcast();
  late final _streamV3Exchange = StreamController<IDOV3ExchangeModel>.broadcast();
  late final _streamStatus = StreamController<ExchangeStatus>.broadcast();

  IDOAppStartExchangeModel? _baseModel;
  IDOV2ExchangeModel? _v2Model;
  IDOV3ExchangeModel? _v3Model;
  ExchangeStatus? _status;

  set setStatus(ExchangeStatus value) {
    _status = value;
    _streamStatus.add(value);
  }

  void _init() {
    _streamV3Exchange.stream.listen((event) {
       if (kDebugMode) {
         logger?.d("_v3Model == ${event.toJson()}");
       }
    });
    _streamV2Exchange.stream.listen((event) {
       if (kDebugMode) {
         logger?.d("_v2Model == ${event.toJson()}");
       }
    });
  }

  @override
  void appExec({required IDOBaseExchangeModel model}) {
    _appExec(model);
  }

  @override
  Stream<ExchangeResponse> listenBleResponse() {
    _bleExec();
    return _streamResponse.stream;
  }

  @override
  Stream<IDOV2ExchangeModel> v2_exchangeData() {
    return _streamV2Exchange.stream;
  }

  @override
  Stream<IDOV3ExchangeModel> v3_exchangeData() {
    return _streamV3Exchange.stream;
  }

  @override
  Stream<ExchangeStatus> listenExchangeStatus() {
    return _streamStatus.stream;
  }

  @override
  Future<bool> getActivityHrData() {
    return _getActivityHrData();
  }

  @override
  Future<bool> getLastActivityData() {
    return _getActivityData();
  }

  @override
  Future<bool> getActivityGpsData() {
    return _getActvityGpsData();
  }

  @override
  void appReplyExec({required IDOBaseExchangeModel model}) {
    _appReplyExec(model);
  }

  @override
  ExchangeStatus? get status => _status;

  @override
  bool get supportV3ActivityExchange => _funTable.syncV3ActivityExchangeData;

}

extension _IDOExchangeExt on _IDOExchangeData {
  //判断返回数据是否成功
  bool _isSuccessCallback(CmdResponse response) {
    if (response.code == 0) {
      if (response.json != null) {
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  //监听设备操作
   _bleExec() {
      _coreMgr.streamListenReceiveData.stream.listen((tuple) {
        int code = tuple.item1;
        int evt = tuple.item2;
        if (   evt != CmdEvtType.exchangeAppBleStart.evtType
            && evt != CmdEvtType.exchangeAppBleEnd.evtType
            && evt != CmdEvtType.exchangeAppBlePause.evtType
            && evt != CmdEvtType.exchangeAppBleRestore.evtType
            && evt != CmdEvtType.exchangeAppBleIng.evtType
            && evt != CmdEvtType.exchangeAppBlePlan.evtType
            && evt != CmdEvtType.exchangeAppStartBlePause.evtType
            && evt != CmdEvtType.exchangeAppStartBleRestore.evtType
            && evt != CmdEvtType.exchangeAppStartBleEnd.evtType
           ){
          return;
        }
        final data = ExchangeResponse();
        if (code == 0) {
          String? json = tuple.item3;
          data.code = code;
          if (evt == CmdEvtType.exchangeAppStartBlePause.evtType) {
            if (_status == ExchangeStatus.appBlePause) {
              ///防止相同指令多次回调
              return;
            }
            setStatus = ExchangeStatus.appBlePause;
            logger?.d('exchange app start ble to app pause == ${json}');
            final map = jsonDecode(json);
            final model = IDOAppBlePauseExchangeModel.fromJson(map);
            model.sportType = _baseModel?.sportType;
            data.model = model;
            if (this.supportV3ActivityExchange) {
              _v3Model?.appStartBle2AppData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
                  model.second ?? 0, model.sportType ?? 0);
            }else {
              _v2Model?.appStartBle2AppData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
                  model.second ?? 0, model.sportType ?? 0);
            }
          } else if (evt == CmdEvtType.exchangeAppStartBleRestore.evtType) {
            if (_status == ExchangeStatus.appBleRestore) {
              ///防止相同指令多次回调
              return;
            }
            setStatus = ExchangeStatus.appBleRestore;
            logger?.d('exchange app start ble to app restore == ${json}');
            final map = jsonDecode(json);
            final model = IDOAppBleRestoreExchangeModel.fromJson(map);
            model.sportType = _baseModel?.sportType;
            data.model = model;
            if (this.supportV3ActivityExchange) {
              _v3Model?.appStartBle2AppData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
                  model.second ?? 0, model.sportType ?? 0);
            }else {
              _v2Model?.appStartBle2AppData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
                  model.second ?? 0, model.sportType ?? 0);
            }
          } else if (evt == CmdEvtType.exchangeAppStartBleEnd.evtType) {
            if (_status == ExchangeStatus.appBleEnd) {
              ///防止相同指令多次回调
              return;
            }
            setStatus = ExchangeStatus.appBleEnd;
            logger?.d('exchange app start ble to app end == ${json}');
            final map = jsonDecode(json);
            final model = IDOAppBleEndExchangeModel.fromJson(map);
            model.sportType = _baseModel?.sportType;
            data.model = model;
            if (this.supportV3ActivityExchange) {
              _v3Model?.appStartBleEnd2AppData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
                  model.second ?? 0, model.sportType ?? 0, model.duration ?? 0, model.calories ?? 0, model.distance ?? 0,
                  model.avgHr ?? 0, model.maxHr ?? 0, model.burnFatMins ?? 0, model.aerobicMins ?? 0, model.limitMins ?? 0,
                  model.isSave ?? 0
              );
            }else {
              _v2Model?.appStartBleEnd2AppData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
                  model.second ?? 0, model.sportType ?? 0, model.duration ?? 0, model.calories ?? 0, model.distance ?? 0,
                  model.avgHr ?? 0, model.maxHr ?? 0, model.burnFatMins ?? 0, model.aerobicMins ?? 0, model.limitMins ?? 0,
                  model.isSave ?? 0);
            }
          } else if (evt == CmdEvtType.exchangeAppBleStart.evtType) { // 蓝牙开始运动
            if (_status == ExchangeStatus.bleStart) {
              ///防止相同指令多次回调
              return;
            }
            logger?.d('exchange ble to app start == ${json}');
            setStatus = ExchangeStatus.bleStart;
            final map = jsonDecode(json);
            final model = IDOBleStartExchangeModel.fromJson(map);
            _baseModel = IDOAppStartExchangeModel();
            _baseModel?.day = model.day;
            _baseModel?.hour = model.hour;
            _baseModel?.minute = model.minute;
            _baseModel?.second = model.second;
            _baseModel?.sportType = model.sportType;
            data.model = model;
            if (this.supportV3ActivityExchange) {
              final date = DateTime.now();
              final year = date.year;
              final month = date.month;
              _v3Model = IDOV3ExchangeModel(year: year, month: month);
              _v3Model?.hrValues = [];
              _v3Model?.kmSpeeds = [];
              _v3Model?.mileSpeeds = [];
              _v3Model?.stepsFrequencys = [];
              _v3Model?.actionData = [];
              _v3Model?.paceSpeeds = [];
              _v3Model?.realSpeeds = [];
              _v3Model?.gpsData = [];
              _v3Model?.segmentItems = [];
              _v3Model?.bleStart2AppData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
                  model.second ?? 0, model.sportType ?? 0, model.operate ?? 0);
            }else {
              _v2Model = IDOV2ExchangeModel();
              _v2Model?.hrValues = [];
              _v2Model?.bleStart2AppData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
                  model.second ?? 0, model.sportType ?? 0, model.operate ?? 0);
            }
          }else if (evt == CmdEvtType.exchangeAppBleEnd.evtType) {
            if (_status == ExchangeStatus.bleEnd) {
              ///防止相同指令多次回调
              return;
            }
            logger?.d('exchange ble to app end == ${json}');
            setStatus = ExchangeStatus.bleEnd;
            final map = jsonDecode(json);
            final model = IDOBleEndExchangeModel.fromJson(map);
            model.sportType = _baseModel?.sportType;
            data.model = model;
            if (this.supportV3ActivityExchange) {
              _v3Model?.bleEnd2AppData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
                  model.second ?? 0, model.sportType ?? 0);
            }else {
              _v2Model?.bleEnd2AppData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
                  model.second ?? 0, model.sportType ?? 0);
            }
          }else if (evt == CmdEvtType.exchangeAppBlePause.evtType) {
            if (_status == ExchangeStatus.blePause) {
              ///防止相同指令多次回调
              return;
            }
            logger?.d('exchange ble to app pause == ${json}');
            setStatus = ExchangeStatus.blePause;
            final map = jsonDecode(json);
            final model = IDOBlePauseExchangeModel.fromJson(map);
            model.sportType = _baseModel?.sportType;
            data.model = model;
            if (this.supportV3ActivityExchange) {
              _v3Model?.blePause2AppData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
                  model.second ?? 0, model.sportType ?? 0);
            }else {
              _v2Model?.blePause2AppData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
                  model.second ?? 0, model.sportType ?? 0);
            }
          }else if (evt == CmdEvtType.exchangeAppBleRestore.evtType) {
            if (_status == ExchangeStatus.bleRestore) {
              ///防止相同指令多次回调
              return;
            }
            logger?.d('exchange ble to app restore == ${json}');
            setStatus = ExchangeStatus.bleRestore;
            final map = jsonDecode(json);
            final model = IDOBleRestoreExchangeModel.fromJson(map);
            model.sportType = _baseModel?.sportType;
            data.model = model;
            if (this.supportV3ActivityExchange) {
              _v3Model?.bleRestore2AppData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
                  model.second ?? 0, model.sportType ?? 0);
            }else {
              _v2Model?.bleRestore2AppData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
                  model.second ?? 0, model.sportType ?? 0);
            }
          }else if (evt == CmdEvtType.exchangeAppBleIng.evtType) {
            if (_status == ExchangeStatus.bleIng) {
              ///防止相同指令多次回调
              return;
            }
            logger?.d('exchange ble to app ing == ${json}');
            setStatus = ExchangeStatus.bleIng;
            final map = jsonDecode(json);
            final model = IDOBleIngExchangeModel.fromJson(map);
            model.sportType = _baseModel?.sportType;
            data.model = model;
            if (this.supportV3ActivityExchange) {
              _v3Model?.bleIng2AppData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
                  model.second ?? 0, model.sportType ?? 0,model.distance ?? 0);
            }else {
              _v2Model?.bleIng2AppData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
                  model.second ?? 0, model.sportType ?? 0,model.distance ?? 0);
            }
          }else if (evt == CmdEvtType.exchangeAppBlePlan.evtType) {
            final map = jsonDecode(json);
            final model = IDOBleOperatePlanExchangeModel.fromJson(map);
            ///1:开始运动，2：暂停运动, 3:恢复运动 ，4：结束运动, 5: 切换动作
            if (model.operate == 1) {
              if (_status == ExchangeStatus.bleStartPlan) {
                return;
              }
              logger?.d('exchange ble to app plan start == ${json}');
              setStatus = ExchangeStatus.bleStartPlan;
              _baseModel = IDOAppStartExchangeModel();
              _baseModel?.day = model.day;
              _baseModel?.hour = model.hour;
              _baseModel?.minute = model.minute;
              _baseModel?.second = model.second;
              _baseModel?.sportType = model.sportType;
              final date = DateTime.now();
              final year = date.year;
              final month = date.month;
              _v3Model = IDOV3ExchangeModel(year: year, month: month);
              _v3Model?.hrValues = [];
              _v3Model?.kmSpeeds = [];
              _v3Model?.mileSpeeds = [];
              _v3Model?.stepsFrequencys = [];
              _v3Model?.actionData = [];
              _v3Model?.paceSpeeds = [];
              _v3Model?.realSpeeds = [];
              _v3Model?.gpsData = [];
              _v3Model?.segmentItems = [];
            }else if (model.operate == 2) {
              if (_status == ExchangeStatus.blePausePlan) {
                return;
              }
              logger?.d('exchange ble to app plan pause == ${json}');
              setStatus = ExchangeStatus.blePausePlan;
            }else if (model.operate == 3) {
              if (_status == ExchangeStatus.bleRestorePlan) {
                return;
              }
              logger?.d('exchange ble to app plan restore == ${json}');
              setStatus = ExchangeStatus.bleRestorePlan;
            }else if (model.operate == 4) {
              if (_status == ExchangeStatus.bleEndPlan) {
                return;
              }
              logger?.d('exchange ble to app plan end == ${json}');
              setStatus = ExchangeStatus.bleEndPlan;
            }else if (model.operate == 5) {
              if (_status == ExchangeStatus.bleSwitchAction) {
                return;
              }
              logger?.d('exchange ble to app plan action == ${json}');
              setStatus = ExchangeStatus.bleSwitchAction;
            }
            data.model = model;
            _v3Model?.blePlan2AppData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
                model.second ?? 0, model.sportType ?? 0, model.operate ?? 0, model.planType ?? 0,
                model.actionType ?? 0, model.errorCode ?? 0, model.trainingYear?? 0, model.trainingMonth ?? 0,
                model.time ?? 0, model.lowHeart ?? 0, model.heightHeart ?? 0);
          }

          if (this.supportV3ActivityExchange) {
            _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
          }else {
            _streamV2Exchange.sink.add(_v2Model ?? IDOV2ExchangeModel());
          }
        }
        _streamResponse.sink.add(data);
    });
  }

  //获取多运动心率数据
  Future<bool> _getActivityHrData() {
    if (!IDOProtocolLibManager().isConnected) {
      final response = ExchangeResponse();
      response.code = -4;
      _streamResponse.sink.add(response);
      return Future(() => false);
    }
    logger?.d('exchange get activity heart rate cmd');
    final completer = Completer<bool>();
    setStatus = ExchangeStatus.getHr;
    _libMgr.send(evt: CmdEvtType.exchangeAppGetV3HrData).listen((response) {
      if(_status == ExchangeStatus.getHrReply) {
        ///防止相同指令多次回调
        return;
      }
      logger?.d('exchange get activity heart rate data error code == ${response.code}');
      setStatus = ExchangeStatus.getHrReply;
      final data = ExchangeResponse();
      data.code = response.code;
      if (_isSuccessCallback(response)) {
        final map = jsonDecode(response.json!);
        final reply = IDOAppHrDataExchangeModel.fromJson(map);
        reply.day = _baseModel?.day;
        reply.hour = _baseModel?.hour;
        reply.minute = _baseModel?.minute;
        reply.second = _baseModel?.second;
        reply.sportType = _baseModel?.sportType;
        data.model = reply;
        _v3Model?.getHrData(reply.day ?? 0, reply.hour ?? 0, reply.minute ?? 0, reply.second ?? 0, reply.sportType ?? 0,
            reply.version ?? 0, reply.heartRateHistoryLen ?? 0, reply.interval ?? 0, reply.heartRates ?? []);
        _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
      }
      _streamResponse.sink.add(data);
      completer.complete(true);
    });
    return completer.future;
  }


  //获取多运动数据
  Future<bool> _getActivityData() {
    if (!IDOProtocolLibManager().isConnected) {
      final response = ExchangeResponse();
      response.code = -4;
      _streamResponse.sink.add(response);
      return Future(() => false);
    }
    logger?.d('exchange get activity data cmd');
    final completer = Completer<bool>();
    setStatus = ExchangeStatus.getActivity;
    _libMgr.send(evt: CmdEvtType.exchangeAppGetActivityData).listen((response) {
      if(_status == ExchangeStatus.getActivityReply) {
         ///防止相同指令多次回调
         return;
      }
      logger?.d('exchange get activity data error code == ${response.code}');
      setStatus = ExchangeStatus.getActivityReply;
      final data = ExchangeResponse();
      data.code = response.code;
      if (_isSuccessCallback(response)) {
        final map = jsonDecode(response.json!);
        final reply = IDOAppActivityDataV3ExchangeModel.fromJson(map);
        reply.day = _baseModel?.day;
        reply.hour = _baseModel?.hour;
        reply.minute = _baseModel?.minute;
        reply.second = _baseModel?.second;
        reply.sportType = _baseModel?.sportType;
        data.model = reply;

        _v3Model?.getActivityData(reply.day ?? 0, reply.hour ?? 0, reply.minute ?? 0, reply.second ?? 0, reply.sportType ?? 0, reply.year ?? 0,
            reply.month ?? 0, reply.version ?? 0, reply.hrInterval ?? 0, reply.step ?? 0, reply.durations ?? 0, reply.calories ?? 0,
            reply.distance ?? 0, reply.burnFatMins ?? 0, reply.aerobicMins ?? 0, reply.limitMins ?? 0, reply.warmUp ?? 0, reply.fatBurning ?? 0,
            reply.aerobicExercise ?? 0, reply.anaerobicExercise ?? 0, reply.extremeExercise ?? 0, reply.warmUpTime ?? 0, reply.fatBurningTime ?? 0,
            reply.aerobicExerciseTime ?? 0, reply.anaerobicExerciseTime ?? 0, reply.extremeExerciseTime ?? 0, reply.avgSpeed ?? 0, reply.avgStepStride ?? 0,
            reply.maxStepStride ?? 0, reply.kmSpeed ?? 0,reply.maxSpeed ?? 0, reply.fastKmSpeed ?? 0, reply.avgStepFrequency ?? 0, reply.maxStepFrequency ?? 0,
            reply.avgHrValue ?? 0, reply.maxHrValue ?? 0, reply.kmSpeedCount ?? 0, reply.actionDataCount ?? 0, reply.stepsFrequencyCount ?? 0,
            reply.miSpeedCount ?? 0, reply.recoverTime ?? 0, reply.vo2max ?? 0, reply.trainingEffect ?? 0, reply.grade ?? 0, reply.realSpeedCount ?? 0,
            reply.paceSpeedCount ?? 0,reply.inClassCalories ?? 0, reply.completionRate ?? 0, reply.hrCompletionRate ?? 0 ,
            reply.kmSpeeds ?? [], reply.stepsFrequency ?? [], reply.itemsMiSpeed ?? [], reply.itemRealSpeed ?? [], reply.paceSpeedItems ?? [], reply.actionData ?? [],
            reply.segmentItemNum ?? 0, reply.segmentTotalTime ?? 0, reply.segmentTotalDistance ?? 0, reply.segmentTotalPace ?? 0, reply.segmentTotalAvgHr ?? 0,
            reply.segmentTotalAvgStepFrequency ?? 0, reply.paceHiit ?? 0, reply.paceAnaerobic ?? 0, reply.paceLacticAcidThreshold ?? 0, reply.paceMarathon ?? 0,
            reply.paceEasyRun ??0, reply.segmentItems ?? []);
        _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
        /// 此处v3运动数据结束
      }
      _streamResponse.sink.add(data);
      completer.complete(true);
    });
    return completer.future;
  }

  Future<bool> _getActvityGpsData() {
    if (!IDOProtocolLibManager().isConnected) {
      final response = ExchangeResponse();
      response.code = -4;
      _streamResponse.sink.add(response);
      return Future(() => false);
    }
    logger?.d('exchange get activity gps data cmd');
    final completer = Completer<bool>();
    setStatus = ExchangeStatus.getActivityGps;
    _libMgr.send(evt: CmdEvtType.getActivityExchangeGpsData).listen((response) {
      if(_status == ExchangeStatus.getActivityGpsReply) {
        ///防止相同指令多次回调
        return;
      }
       logger?.d('exchange get activity gps data error code == ${response.code}');
      setStatus = ExchangeStatus.getActivityGpsReply;
      final data = ExchangeResponse();
      data.code = response.code;
      if (_isSuccessCallback(response)) {
        final map = jsonDecode(response.json!);
        final reply = IDOAppGpsDataExchangeModel.fromJson(map);
        reply.day = _baseModel?.day;
        reply.hour = _baseModel?.hour;
        reply.minute = _baseModel?.minute;
        reply.second = _baseModel?.second;
        reply.sportType = _baseModel?.sportType;
        data.model = reply;
        _v3Model?.getActivityGpsData(reply.day ?? 0, reply.hour ?? 0, reply.minute ?? 0,
          reply.second ?? 0, reply.sportType ?? 0, reply.version ?? 0,reply.intervalSecond ?? 0,reply.gpsCount ?? 0,reply.gpsData ?? []);
        _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
      }
      _streamResponse.sink.add(data);
      completer.complete(true);
    });
    return completer.future;
  }

  // app执行下发数据交换
  void _appExec(IDOBaseExchangeModel model) {
    if (!IDOProtocolLibManager().isConnected) {
      final response = ExchangeResponse();
      response.code = -4;
      _streamResponse.sink.add(response);
      return;
    }
    if (model is IDOAppStartExchangeModel) {
      /// 恢复流
      // _onResume();
      _baseModel = IDOAppStartExchangeModel();
      _baseModel?.day = model.day;
      _baseModel?.hour = model.hour;
      _baseModel?.minute = model.minute;
      _baseModel?.second = model.second;
      _baseModel?.sportType = model.sportType;
      if (this.supportV3ActivityExchange) {
        final date = DateTime.now();
        final year = date.year;
        final month = date.month;
        _v3Model = IDOV3ExchangeModel(year: year, month: month);
        _v3Model?.hrValues = [];
        _v3Model?.kmSpeeds = [];
        _v3Model?.mileSpeeds = [];
        _v3Model?.stepsFrequencys = [];
        _v3Model?.actionData = [];
        _v3Model?.paceSpeeds = [];
        _v3Model?.realSpeeds = [];
        _v3Model?.gpsData = [];
        _v3Model?.segmentItems = [];
        _v3Model?.appStart2BleData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
            model.second ?? 0, model.sportType ?? 0,model.targetType??0,
            model.targetValue??0,model.forceStart?? 0,model.vo2max??0,model.recoverTime??0,
            model.avgWeekActivityTime??0);
        _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
      }else {
        _v2Model = IDOV2ExchangeModel();
        _v2Model?.hrValues = [];
        _v2Model?.appStart2BleData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
            model.second ?? 0, model.sportType ?? 0,model.targetType??0,
            model.targetValue??0,model.forceStart?? 0);
        _streamV2Exchange.sink.add(_v2Model ?? IDOV2ExchangeModel());
      }
      //app发起运动
      final jsonStr = jsonEncode((model).toJson());
      logger?.d('exchange app to ble start == ${jsonStr}');
      _status = ExchangeStatus.appStart;
      _libMgr
          .send(evt: CmdEvtType.exchangeAppStart, json: jsonStr).listen((response) {
        if(_status == ExchangeStatus.appStartReply) {
          ///防止相同指令多次回调
          return;
        }
        logger?.d('exchange app to ble start reply == ${response.json} error code == ${response.code}');
        setStatus = ExchangeStatus.appStartReply;
        final data = ExchangeResponse();
        data.code = response.code;
        if (_isSuccessCallback(response)) {
          final map = jsonDecode(response.json!);
          final reply = IDOAppStartReplyExchangeModel.fromJson(map);
          reply.day = _baseModel?.day;
          reply.hour = _baseModel?.hour;
          reply.minute = _baseModel?.minute;
          reply.second = _baseModel?.second;
          reply.sportType = _baseModel?.sportType;
          data.model = reply;
          if (this.supportV3ActivityExchange) {
             _v3Model?.appOperate2BleReplyData(reply.retCode ?? 0);
             _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
          }else {
             _v2Model?.appOperate2BleReplyData(reply.retCode ?? 0);
             _streamV2Exchange.sink.add(_v2Model ?? IDOV2ExchangeModel());
          }
        }
        _streamResponse.sink.add(data);
      });
    }
    else if (model is IDOAppEndExchangeModel) {
      if (this.supportV3ActivityExchange) {
        _v3Model?.appEnd2BleData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
            model.second ?? 0, model.sportType ?? 0,model.duration ?? 0,model.calories ?? 0,
            model.distance ?? 0,model.isSave ?? 0);
        _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
      }else {
        _v2Model?.appEnd2BleData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
            model.second ?? 0, model.sportType ?? 0,model.duration ?? 0,model.calories ?? 0,
            model.distance ?? 0,model.isSave ?? 0);
        _streamV2Exchange.sink.add(_v2Model ?? IDOV2ExchangeModel());
      }
      //app发起运动结束
      final jsonStr = jsonEncode((model).toJson());
      logger?.d('exchange app to ble end == ${jsonStr}');
      setStatus = ExchangeStatus.appEnd;
      _libMgr
          .send(evt: CmdEvtType.exchangeAppEnd, json: jsonStr)
          .listen((response) {
        if(_status == ExchangeStatus.appEndReply) {
          ///防止相同指令多次回调
          return;
        }
        logger?.d('exchange app to ble end reply == ${response.json} error code == ${response.code}');
        setStatus = ExchangeStatus.appEndReply;
        final data = ExchangeResponse();
        data.code = response.code;
        if (_isSuccessCallback(response)) {
          final map = jsonDecode(response.json!);
          final reply = IDOAppEndReplyExchangeModel.fromJson(map);
          reply.day = _baseModel?.day;
          reply.hour = _baseModel?.hour;
          reply.minute = _baseModel?.minute;
          reply.second = _baseModel?.second;
          reply.sportType = _baseModel?.sportType;
          data.model = reply;
          if (this.supportV3ActivityExchange) {
            _v3Model?.appEnd2BleReplyData(reply.errorCode ?? 0,reply.calories ?? 0,reply.distance ?? 0, reply.step ?? 0,
                reply.avgHr ?? 0, reply.maxHr ?? 0, reply.burnFatMins ?? 0, reply.aerobicMins ?? 0, reply.limitMins ?? 0);
            _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
          }else {
            _v2Model?.appEnd2BleReplyData(reply.errorCode ?? 0,reply.calories ?? 0,reply.distance ?? 0, reply.step ?? 0,
                reply.avgHr ?? 0, reply.maxHr ?? 0, reply.burnFatMins ?? 0, reply.aerobicMins ?? 0, reply.limitMins ?? 0);
            _streamV2Exchange.sink.add(_v2Model ?? IDOV2ExchangeModel());
            /// 此处v2运动数据结束
          }
        }
        _streamResponse.sink.add(data);
      });
    }
    else if (model is IDOAppRestoreExchangeModel) {
      if (this.supportV3ActivityExchange) {
        _v3Model?.appRestore2BleData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
            model.second ?? 0, model.sportType ?? 0);
        _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
      }else {
        _v2Model?.appRestore2BleData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
            model.second ?? 0, model.sportType ?? 0);
        _streamV2Exchange.sink.add(_v2Model ?? IDOV2ExchangeModel());
      }
      //app发起运动恢复
      final jsonStr = jsonEncode((model).toJson());
      logger?.d('exchange app to ble restore == ${jsonStr}');
      setStatus = ExchangeStatus.appRestore;
      _libMgr
          .send(evt: CmdEvtType.exchangeAppRestore, json: jsonStr)
          .listen((response) {
        if(_status == ExchangeStatus.appRestoreReply) {
          ///防止相同指令多次回调
          return;
        }
        logger?.d('exchange app to ble restore reply == ${response.json} error code == ${response.code}');
        setStatus = ExchangeStatus.appRestoreReply;
        final data = ExchangeResponse();
        data.code = response.code;
        if (_isSuccessCallback(response)) {
          final map = jsonDecode(response.json!);
          final reply = IDOAppRestoreReplyExchangeModel.fromJson(map);
          reply.day = _baseModel?.day;
          reply.hour = _baseModel?.hour;
          reply.minute = _baseModel?.minute;
          reply.second = _baseModel?.second;
          reply.sportType = _baseModel?.sportType;
          data.model = reply;
          if (this.supportV3ActivityExchange) {
            _v3Model?.appOperate2BleReplyData(reply.errCode ?? 0);
            _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
          }else {
            _v2Model?.appOperate2BleReplyData(reply.errCode ?? 0);
            _streamV2Exchange.sink.add(_v2Model ?? IDOV2ExchangeModel());
          }
        }
        _streamResponse.sink.add(data);
      });
    }
    else if (model is IDOAppPauseExchangeModel) {
      if (this.supportV3ActivityExchange) {
        _v3Model?.appPause2BleData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
            model.second ?? 0, model.sportType ?? 0);
        _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
      }else {
        _v2Model?.appPause2BleData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
            model.second ?? 0, model.sportType ?? 0);
        _streamV2Exchange.sink.add(_v2Model ?? IDOV2ExchangeModel());
      }
      //app发起运动暂停
      final jsonStr = jsonEncode((model).toJson());
      logger?.d('exchange app to ble pause == ${jsonStr}');
      setStatus = ExchangeStatus.appPause;
      _libMgr
          .send(evt: CmdEvtType.exchangeAppPause, json: jsonStr)
          .listen((response) {
        if(_status == ExchangeStatus.appPauseReply) {
          ///防止相同指令多次回调
          return;
        }
        logger?.d('exchange app to ble pause reply == ${response.json} error code == ${response.code}');
        setStatus = ExchangeStatus.appPauseReply;
        final data = ExchangeResponse();
        data.code = response.code;
        if (_isSuccessCallback(response)) {
          final map = jsonDecode(response.json!);
          final reply = IDOAppPauseReplyExchangeModel.fromJson(map);
          reply.day = _baseModel?.day;
          reply.hour = _baseModel?.hour;
          reply.minute = _baseModel?.minute;
          reply.second = _baseModel?.second;
          reply.sportType = _baseModel?.sportType;
          data.model = reply;
          if (this.supportV3ActivityExchange) {
            _v3Model?.appOperate2BleReplyData(reply.errCode ?? 0);
            _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
          }else {
            _v2Model?.appOperate2BleReplyData(reply.errCode ?? 0);
            _streamV2Exchange.sink.add(_v2Model ?? IDOV2ExchangeModel());
          }
        }
        _streamResponse.sink.add(data);
      });
    }
    else if (model is IDOAppIngExchangeModel) {

      _v2Model?.appIng2BleData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
          model.second ?? 0, model.sportType ?? 0,model.duration ?? 0,
          model.calories ?? 0, model.distance?? 0, model.status?? 0);
      _streamV2Exchange.sink.add(_v2Model ?? IDOV2ExchangeModel());
      //app发起运动交换过程
      final jsonStr = jsonEncode((model).toJson());
      logger?.d('exchange app to ble v2 ing == ${jsonStr}');
      setStatus = ExchangeStatus.appIng;
      _libMgr
          .send(evt: CmdEvtType.exchangeAppV2Ing, json: jsonStr)
          .listen((response) {
        if(_status == ExchangeStatus.appIngReply) {
          ///防止相同指令多次回调
          return;
        }
        logger?.d('exchange app to ble v2 ing reply == ${response.json} error code == ${response.code}');
        setStatus = ExchangeStatus.appIngReply;
        final data = ExchangeResponse();
        data.code = response.code;
        if (_isSuccessCallback(response)) {
          final map = jsonDecode(response.json!);
          final reply = IDOAppIngReplyExchangeModel.fromJson(map);
          reply.day = _baseModel?.day;
          reply.hour = _baseModel?.hour;
          reply.minute = _baseModel?.minute;
          reply.second = _baseModel?.second;
          reply.sportType = _baseModel?.sportType;
          data.model = reply;
          _v2Model?.appIng2BleReplyData(reply.currentHr ?? 0, reply.distance ?? 0, reply.calories ?? 0,
              reply.hrSerial ?? 0, reply.interval ?? 0, reply.step ?? 0, reply.status ?? 0, reply.hrJson ?? []);
          _streamV2Exchange.sink.add(_v2Model ?? IDOV2ExchangeModel());
        }
        _streamResponse.sink.add(data);
      });
    }
    else if (model is IDOAppIngV3ExchangeModel) {

      _v3Model?.appIng2BleData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
          model.second ?? 0, model.sportType ?? 0,model.duration ?? 0,
          model.calories ?? 0, model.distance?? 0, model.version?? 0, model.speed?? 0, model.signal?? 0);
      _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
      //app发起 v3运动交换过程
      final jsonStr = jsonEncode((model).toJson());
      logger?.d('exchange app to ble v3 ing == ${jsonStr}');
      setStatus = ExchangeStatus.appIng;
      _libMgr
          .send(evt: CmdEvtType.exchangeAppV3Ing, json: jsonStr)
          .listen((response) {
        if(_status == ExchangeStatus.appIngReply) {
          ///防止相同指令多次回调
          return;
        }
        logger?.d('exchange app to ble v3 ing reply == ${response.json} error code == ${response.code}');
        setStatus = ExchangeStatus.appIngReply;
        final data = ExchangeResponse();
        data.code = response.code;
        if (_isSuccessCallback(response)) {
          final map = jsonDecode(response.json!);
          final reply = IDOAppIngV3ReplyExchangeModel.fromJson(map);
          reply.day = _baseModel?.day;
          reply.hour = _baseModel?.hour;
          reply.minute = _baseModel?.minute;
          reply.second = _baseModel?.second;
          reply.sportType = _baseModel?.sportType;
          data.model = reply;
          _v3Model?.appIng2BleReplyData(reply.version ?? 0, reply.heartRate ?? 0, reply.distance ?? 0, reply.duration ?? 0,
              reply.realTimeCalories ?? 0, reply.realTimeSpeed ?? 0, reply.kmSpeed ?? 0, reply.steps ?? 0, reply.swimPosture ?? 0,
              reply.status ?? 0, reply.realTimeSpeedPace ?? 0, reply.trainingEffect ?? 0, reply.anaerobicTrainingEffect ?? 0,
              reply.actionType ?? 0, reply.countHour ?? 0, reply.countMinute ?? 0, reply.countSecond ?? 0);
          _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
        }
        _streamResponse.sink.add(data);
      });
    }
    else if (model is IDOAppOperatePlanExchangeModel) {

      _v3Model?.appPlan2BleData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
          model.second ?? 0, model.sportType ?? 0,model.operate ?? 0,
          model.trainingOffset ?? 0, model.planType?? 0);
      _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());

      //app操作运动计划
      final jsonStr = jsonEncode((model).toJson());
       if (model.operate == 1) { // 开始运动
         final date = DateTime.now();
         final year = date.year;
         final month = date.month;
         _v3Model = IDOV3ExchangeModel(year: year, month: month);
         _v3Model?.hrValues = [];
         _v3Model?.kmSpeeds = [];
         _v3Model?.mileSpeeds = [];
         _v3Model?.stepsFrequencys = [];
         _v3Model?.actionData = [];
         _v3Model?.paceSpeeds = [];
         _v3Model?.realSpeeds = [];
         _v3Model?.gpsData = [];
         _v3Model?.segmentItems = [];
         _v3Model?.appPlan2BleData(model.day ?? 0, model.hour ?? 0, model.minute ?? 0,
             model.second ?? 0, model.sportType ?? 0,model.operate ?? 0,
             model.trainingOffset ?? 0, model.planType?? 0);
         _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());

         _baseModel = IDOAppStartExchangeModel();
         _baseModel?.day = model.day;
         _baseModel?.hour = model.hour;
         _baseModel?.minute = model.minute;
         _baseModel?.second = model.second;
         _baseModel?.sportType = model.sportType;
         setStatus = ExchangeStatus.appStartPlan;
         logger?.d('exchange app to ble plan start == ${jsonStr}');
       }else if (model.operate == 2) {
         setStatus = ExchangeStatus.appPausePlan;
         logger?.d('exchange app to ble plan pause == ${jsonStr}');
       }else if (model.operate == 3) {
         setStatus = ExchangeStatus.appRestorePlan;
         logger?.d('exchange app to ble plan restore == ${jsonStr}');
       }else if (model.operate == 4) {
         setStatus = ExchangeStatus.appEndPlan;
         logger?.d('exchange app to ble plan end == ${jsonStr}');
       }else if (model.operate == 5) {
         setStatus = ExchangeStatus.appSwitchAction;
         logger?.d('exchange app to ble plan action == ${jsonStr}');
       }
       _libMgr.send(evt: CmdEvtType.exchangeAppPlan,json: jsonStr).listen((response) {
         final data = ExchangeResponse();
         data.code = response.code;
         if (_isSuccessCallback(response)) {
           final map = jsonDecode(response.json!);
           final reply = IDOAppOperatePlanReplyExchangeModel.fromJson(map);
           if (reply.operate == 1) { // 开始运动
             if (_status == ExchangeStatus.appStartPlanReply) {
               ///防止相同指令多次回调
                return;
             }
             logger?.d('exchange app to ble plan start reply == ${map}');
             setStatus = ExchangeStatus.appStartPlanReply;
           }else if (reply.operate == 2) {
             if (_status == ExchangeStatus.appPausePlanReply) {
               ///防止相同指令多次回调
               return;
             }
             logger?.d('exchange app to ble plan pause reply == ${map}');
             setStatus = ExchangeStatus.appPausePlanReply;
           }else if (reply.operate == 3) {
             if (_status == ExchangeStatus.appRestorePlanReply) {
               ///防止相同指令多次回调
               return;
             }
             logger?.d('exchange app to ble plan restore reply == ${map}');
             setStatus = ExchangeStatus.appRestorePlanReply;
           }else if (reply.operate == 4) {
             if (_status == ExchangeStatus.appEndPlanReply) {
               ///防止相同指令多次回调
               return;
             }
             logger?.d('exchange app to ble plan end reply == ${map}');
             setStatus = ExchangeStatus.appEndPlanReply;
           }else if (reply.operate == 5) {
             if (_status == ExchangeStatus.appSwitchActionReply) {
               ///防止相同指令多次回调
               return;
             }
             logger?.d('exchange app to ble plan action reply == ${map}');
             setStatus = ExchangeStatus.appSwitchActionReply;
           }
           reply.day = _baseModel?.day;
           reply.hour = _baseModel?.hour;
           reply.minute = _baseModel?.minute;
           reply.second = _baseModel?.second;
           reply.sportType = _baseModel?.sportType;
           data.model = reply;
           _v3Model?.appPlan2BleReplyData(reply.operate ?? 0, reply.errorCode ?? 0, reply.planType ?? 0, reply.actionType ?? 0);
           _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
           if (_status == ExchangeStatus.appEndPlanReply) {
              /// 此处运动计划数据结束
           }
         }
         _streamResponse.sink.add(data);
       });
    }
  }

  // app回复下发数据交换
  void _appReplyExec(IDOBaseExchangeModel model) {
    if (!IDOProtocolLibManager().isConnected) {
      return;
    }
     if (model is IDOBleStartReplyExchangeModel) {
       setStatus = ExchangeStatus.bleStartReply;
       final jsonStr = jsonEncode((model).toJson());
       logger?.d('exchange ble to app start reply == ${jsonStr}');
        _libMgr.send(evt:CmdEvtType.exchangeAppBleStartReply,json: jsonStr);
       if (this.supportV3ActivityExchange) {
         _v3Model?.bleStart2AppReplyData(model.operate ?? 0, model.retCode ?? 0);
         _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
       }else {
         _v2Model?.bleStart2AppReplyData(model.operate ?? 0, model.retCode ?? 0);
         _streamV2Exchange.sink.add(_v2Model ?? IDOV2ExchangeModel());
       }
     }else if (model is IDOBleEndReplyExchangeModel) {
       setStatus = ExchangeStatus.bleEndReply;
       final jsonStr = jsonEncode((model).toJson());
       logger?.d('exchange ble to app end reply == ${jsonStr}');
       _libMgr.send(evt:CmdEvtType.exchangeAppBleEndReply,json: jsonStr);
       if (this.supportV3ActivityExchange) {
         _v3Model?.bleOperate2AppReplyData(model.retCode ?? 0);
         _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
       }else {
         _v2Model?.bleOperate2AppReplyData(model.retCode ?? 0);
         _streamV2Exchange.sink.add(_v2Model ?? IDOV2ExchangeModel());
         ///此处v2运动数据结束
       }
     }else if (model is IDOBlePauseReplyExchangeModel) {
       setStatus = ExchangeStatus.blePauseReply;
       final jsonStr = jsonEncode((model).toJson());
       logger?.d('exchange ble to app pause reply == ${jsonStr}');
       _libMgr.send(evt:CmdEvtType.exchangeAppBlePauseReply,json: jsonStr);
       if (this.supportV3ActivityExchange) {
         _v3Model?.bleOperate2AppReplyData(model.retCode ?? 0);
         _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
       }else {
         _v2Model?.bleOperate2AppReplyData(model.retCode ?? 0);
         _streamV2Exchange.sink.add(_v2Model ?? IDOV2ExchangeModel());
       }
     }else if (model is IDOBleRestoreReplyExchangeModel) {
       setStatus = ExchangeStatus.bleRestoreReply;
       final jsonStr = jsonEncode((model).toJson());
       logger?.d('exchange ble to app restore reply == ${jsonStr}');
       _libMgr.send(evt:CmdEvtType.exchangeAppBleRestoreReply,json: jsonStr);
       if (this.supportV3ActivityExchange) {
         _v3Model?.bleOperate2AppReplyData(model.retCode ?? 0);
         _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
       }else {
         _v2Model?.bleOperate2AppReplyData(model.retCode ?? 0);
         _streamV2Exchange.sink.add(_v2Model ?? IDOV2ExchangeModel());
       }
     }else if (model is IDOBleIngReplyExchangeModel) {
       setStatus = ExchangeStatus.bleIngReply;
       final jsonStr = jsonEncode((model).toJson());
       logger?.d('exchange ble to app ing reply == ${jsonStr}');
       _libMgr.send(evt:CmdEvtType.exchangeAppBleIngReply,json: jsonStr);
       if (this.supportV3ActivityExchange) {
         _v3Model?.bleIng2AppReplyData(model.distance ?? 0);
         _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
       }else {
         _v2Model?.bleIng2AppReplyData(model.distance ?? 0);
         _streamV2Exchange.sink.add(_v2Model ?? IDOV2ExchangeModel());
       }
     }else if (model is IDOBleOperatePlanReplyExchangeModel) {
       setStatus = ExchangeStatus.bleOperatePlanReply;
       final jsonStr = jsonEncode((model).toJson());
       logger?.d('exchange ble to app plan reply == ${jsonStr}');
       _libMgr.send(evt:CmdEvtType.exchangeAppBlePlan,json: jsonStr);
       _v3Model?.blePlan2AppReplyData(model.errorCode?? 0,model.operate?? 0,model.planType?? 0,model.actionType?? 0);
       _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
       if (model.operate == 4) {
           ///此处运动计划结束
       }
     }else if (model is IDOAppBlePauseReplyExchangeModel) {
       setStatus = ExchangeStatus.appBlePauseReply;
       final jsonStr = jsonEncode((model).toJson());
       logger?.d('exchange app start ble to app pause reply == ${jsonStr}');
       _libMgr.send(evt:CmdEvtType.exchangeAppStartBlePauseReply,json: jsonStr);
       if (this.supportV3ActivityExchange) {
         _v3Model?.appStartBle2AppReplyData(model.errCode ?? 0);
         _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
       }else {
         _v2Model?.appStartBle2AppReplyData(model.errCode ?? 0);
         _streamV2Exchange.sink.add(_v2Model ?? IDOV2ExchangeModel());
       }
     }else if (model is IDOAppBleRestoreReplyExchangeModel) {
       setStatus = ExchangeStatus.appBleRestoreReply;
       final jsonStr = jsonEncode((model).toJson());
       logger?.d('exchange app start ble to app restore reply == ${jsonStr}');
       _libMgr.send(evt:CmdEvtType.exchangeAppStartBleRestoreReply,json: jsonStr);
       if (this.supportV3ActivityExchange) {
         _v3Model?.appStartBle2AppReplyData(model.errCode ?? 0);
         _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
       }else {
         _v2Model?.appStartBle2AppReplyData(model.errCode ?? 0);
         _streamV2Exchange.sink.add(_v2Model ?? IDOV2ExchangeModel());
       }
     }else if (model is IDOAppBleEndReplyExchangeModel) {
       setStatus = ExchangeStatus.appBleEndReply;
       final jsonStr = jsonEncode((model).toJson());
       logger?.d('exchange app start ble to app end reply == ${jsonStr}');
       _libMgr.send(evt:CmdEvtType.exchangeAppStartBleEndReply,json: jsonStr);
       if (this.supportV3ActivityExchange) {
         _v3Model?.appStartBleEnd2AppReplyData(model.duration ?? 0, model.calories ?? 0, model.distance ?? 0, model.errCode ?? 0);
         _streamV3Exchange.sink.add(_v3Model ?? IDOV3ExchangeModel());
       }else {
         _v2Model?.appStartBleEnd2AppReplyData(model.duration ?? 0, model.calories ?? 0, model.distance ?? 0, model.errCode ?? 0);
         _streamV2Exchange.sink.add(_v2Model ?? IDOV2ExchangeModel());
       }
     }
  }

}
