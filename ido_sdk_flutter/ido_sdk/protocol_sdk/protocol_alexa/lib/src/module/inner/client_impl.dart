part of '../client.dart';

class _AlexaClient implements AlexaClient {
  final _keywordContentType = "Content-Type: application/json";
  final _service = ServiceManager();
  late final _auth = Auth();
  late final _voice = Voice();
  late final _uploadDirectivesAnalysis = UploadDirectivesAnalysis();
  late final _downDirectivesAnalysis = DownDirectivesAnalysis();
  late final _capabilitiesReport = CapabilitiesReport();
  late final _alexaChannel = AlexaChannelImpl();
  final _reachability = AlexaReachability();
  List? _timerArr;
  List? _alarmArr;

  static const _pingDurationSeconds = 2 * 60; // 执行ping的间隔时间（单位 秒）
  bool _isSetupAlexaAlready = false; // 是否已设置alexa
  bool _loginStateUpdated = false; // alexa登录状态已更新
  bool _deviceFastSyncCompleted = false; // 设备快速配置完成
  int _offlineMilliseconds = 0; //用于计算离线时长


  Timer? _timerPing;
  CancelToken? _cancelTokenDirectives;
  StreamSubscription? _subscriptDirectives; // 下行流通道
  StreamSubscription? _subscriptCreateNewRetry; // 下行流创建重试

  bool _isOnNewDirectivesCreating = false; //正在创建下行通道流
  bool _hasCreateNewDirectives = false; //需要重新创建下行流 (网络恢复时)
  Completer<bool>? _completerNewDirectives;
  late final _subjectDirectiveData =
      StreamController<DirectiveModel>.broadcast();

  static final _instance = _AlexaClient._internal();
  factory _AlexaClient() => _instance;
  _AlexaClient._internal() {
    //_setupAlexa();
    _registerAllListen();
    _channelLog();
  }

  @override
  String get messageId => _voice.uniqueID;

  @override
  IDOAlexaDelegate? delegate;

  @override
  bool? isSmartHomeSkill;
  @override
  String? lastTimerToken;
  @override
  List alarmArr = [];
  @override
  List reminderArr = [];

  @override
  List createTimerArr() {
    if (_timerArr == null) {
      _timerArr = [];
      for (int i = 0; i <= 2; i++) {
        AlexaTimerModel model = AlexaTimerModel();
        model.index = i;
        model.isOpen = false;
        _timerArr?.add(model);
      }
    }
    return _timerArr!;
  }

  Future<List> createAlarmArr(bool isCreate) async {
    if (isCreate){
      if (_alarmArr == null || _alarmArr?.length == 0) {
        _alarmArr = [];
        final alexaAlarmArr = await storage?.loadAlarmDataByDisk(libManager.deviceInfo.macAddress);
        if (alexaAlarmArr != null && alexaAlarmArr is List){
          if (alexaAlarmArr.length == 10){
            _alarmArr?.addAll(alexaAlarmArr);
          }else{
            for (int i = 1; i <= 10; i++) {
              if (i < alexaAlarmArr.length){
                _alarmArr?.add(alexaAlarmArr[i]);
              }else{
                AlexaAlarmModel model = AlexaAlarmModel();
                model.alarmId = i;
                _alarmArr?.add(model);
              }
            }
          }
        }else{
          for (int i = 1; i <= 10; i++) {
            AlexaAlarmModel model = AlexaAlarmModel();
            model.alarmId = i;
            _alarmArr?.add(model);
          }
        }

      }
      return _alarmArr!;
    }else{
      _alarmArr = [];
      return _alarmArr!;
    }

  }

  @override
  Auth get auth => _auth;

  @override
  Voice get voice => _voice;

  @override
  UploadDirectivesAnalysis get uploadDirectivesAnalysis => _uploadDirectivesAnalysis;

  @override
  Future<bool> createNewDirectives({int retryCount = 15}) async {
    return _createNewDirectivesNative();

    // 使用原生，以下代码废弃
    // if (_isOnNewDirectivesCreating &&
    //     _completerNewDirectives != null &&
    //     !_completerNewDirectives!.isCompleted) {
    //   logger?.v('正在创建下行流通道 $_isOnNewDirectivesCreating');
    //   return _completerNewDirectives!.future;
    // }
    // _isOnNewDirectivesCreating = true;
    // _completerNewDirectives = Completer();
    // var count = 0;
    // _subscriptCreateNewRetry?.cancel();
    // _subscriptCreateNewRetry = Rx.retryWhen(() {
    //   if (count > 0 && count < retryCount) {
    //     logger?.v('创建下行流通道执行第$count次 重试');
    //   }
    //   return _createNewDirectives().asStream().map((res) {
    //     if (!_reachability.hasNetwork) {
    //       _hasCreateNewDirectives = true;
    //       logger?.d('创建下行流通道 无网络 结束创建 待有网时恢复创建');
    //       return res;
    //     } else if (count > retryCount) {
    //       logger?.d('创建下行流通道执行超过$retryCount次 结束重试');
    //       return res;
    //     } else if (!res) {
    //       throw 'has retry'; // 触发重试
    //     }
    //     return res;
    //   });
    // }, (e, s) {
    //   count++;
    //   logger?.e(e);
    //   return Rx.timer(null, const Duration(seconds: 1)); // 刷新间隔
    // }).listen((res) {
    //   _isOnNewDirectivesCreating = false;
    //   _hasCreateNewDirectives = !res;
    //   _completerNewDirectives?.complete(res);
    //   _completerNewDirectives = null;
    //   logger?.d('call createNewDirectives res == $res');
    // });
    // return _completerNewDirectives!.future;
  }

  /// 设置log
  static Future<bool> _setLog(writeToFile, bool outputToConsole,
      {LoggerLevel logLevel = LoggerLevel.verbose}) async {
    // String dirPath = '';
    if (!kDebugMode) {
      // release模式下日志由sdk内部控制
      logLevel = LoggerLevel.debug;
    }
    if (writeToFile || outputToConsole) {
      final log = LoggerSingle();
      assert(log.config != null,
          'You need to call LoggerSingle.configLogger(...)');
      if (log.config != null) {
        logger = log;
      }
    } else {
      logger = null;
    }
    return Future(() => true);
  }

  @override
  StreamSubscription listenDirectiveData(
      void Function(DirectiveModel model) func) {
    return _subjectDirectiveData.stream.listen(func);
  }

  @override
  StreamSubscription listenUploadVoiceData(
      void Function(VoiceReceivedData receivedData) func) {
    return _voice.listenUploadVoiceData(func);
  }
}

extension _AlexaClientExt on _AlexaClient {
  /// 设置alexa
  _setupAlexa() async {
    if (!_auth.isLogin) {
      logger?.d('Not login, _setupAlexa() return...');
      return;
    }

    if (!(_deviceFastSyncCompleted && libManager.isConnected)) {
      logger?.d('alexa - Not FastSyncCompleted, _setupAlexa() return...');
      return;
    }

    logger?.d('alexa - call _setupAlexa()');

    logger?.d('alexa - initUpdateDeviceCapabilities begin');
    _capabilitiesReport.initUpdateDeviceCapabilities().then((value) {
      logger?.d('alexa - initUpdateDeviceCapabilities end');
    });

    // 创建下行流
    logger?.d('调用 创建下行流通道1');
    final success = await createNewDirectives();
    if (success) {
      _isSetupAlexaAlready = true;
      BaseEntity<dynamic>? rs;
      rs = await _service.ping(accessToken: _auth.accessToken!);
      logger?.v('ping rs = $rs');

      if (rs.isOK) {
        // 同步
        rs = await _service.sendEventPart(
            accessToken: _auth.accessToken!,
            dataBody: DataBox.synchronizeWithContext(1),
            label: '同步');
        logger?.v('synchronizeWithContext rs = $rs');
      }
    }

    // 定时ping
    _startPing();
  }

  void _startPing() async {
    logger?.d('call _startPing');
    _timerPing?.cancel();
    _timerPing = Timer.periodic(
        const Duration(seconds: _AlexaClient._pingDurationSeconds),
        (timer) async {
      if (_auth.isLogin) {
        if (!_reachability.hasNetwork) {
          logger?.v("no network, not ping");
          return;
        }
        final rs = await _service.ping(accessToken: Auth().accessToken!);
        logger?.v("ping rs = $rs");
        if (!(rs.status == 0 || rs.status == 202 || rs.status == 204)) {
          logger?.d(
              'ping failed, hasNetwork1:${_reachability.hasNetwork} status:${rs.status}');
          if(!_reachability.hasNetwork) {
            logger?.v("no network, not ping 02");
          }else if (rs.status == 403) {
            logger?.d('ping failed, 403, recreate new directives');
            // 认证失效，刷新token
            if (await _auth.refreshToken()) {
              // 重新创建下行流
              logger?.d('调用 创建下行流通道2 (token已更新)');
              await createNewDirectives();
            }
          }else {
            logger?.d('ping failed, hasNetwork2:${_reachability.hasNetwork}');
          }
        }
      }
    });
  }

  void _stopPing() {
    logger?.d('call _stopPing');
    _timerPing?.cancel();
    _timerPing = null;
  }

  /// 关闭下行流通道
  void _closeNewDirectivesIfNeed() {
    try {
      logger?.d('Channel通道 - 关闭当前下行通道流');
      _alexaChannel.alexaHost.closeDownStream();
      if (_cancelTokenDirectives != null &&
          !_cancelTokenDirectives!.isCancelled) {
        logger?.d('关闭当前下行通道流');
        _cancelTokenDirectives!.cancel();
      }
      _subscriptDirectives?.cancel();
      _subscriptCreateNewRetry?.cancel();
      _subscriptCreateNewRetry = null;
    } catch (e) {
      logger?.e(e);
    }
  }

  Future<bool> _createNewDirectivesNative() async {
    var completer = Completer<bool>();
    final baseUrl = AlexaServerManager().getServer().getBaseUrl(AlexaAppUrlType.alexaGateway);
    final url = "$baseUrl/v20160207/directives";
    logger?.v('Channel通道 - 准备调用创建下行流');
    _alexaChannel.alexaHost.createDownStream(url).then((success) {
        if (success) {
          logger?.v('Channel通道 - 下行流创建成功');
        }
        if (!completer.isCompleted) {
          completer.complete(success);
        }
    });

    _alexaChannel.blockDownStreamError = (e) async {
        logger?.v("Channel通道 - 下行流 异常：errorCode:${e.errorCode} msg:${e.errorMessage}");
        if (e.errorCode == 403){
          // 刷新token
          logger?.d('Channel通道 - 下行流 403, 刷新token');
          _alexaChannel.alexaHost.closeDownStream();
          // 认证失效，刷新token
          if (await _auth.refreshToken()) {
            // token更新到原生
            _alexaChannel.alexaHost.onTokenChanged(_auth.accessToken);
            // 重新创建下行流
            logger?.d('调用 创建下行流通道3 (token已更新)');
            createNewDirectives(); // 再次创建下行流
          }
        }
    };

    // 收到下行流数据
    _alexaChannel.blockDownStreamData = (data) {
      final models = _parseDirectives(data);
      //logger?.v('22========Directives Response: $model');
      if (models != null) {
        for (final model in models) {
          if (_subjectDirectiveData.hasListener && !_subjectDirectiveData.isClosed) {
            _subjectDirectiveData.add(model);
          }
        }
      }
    };
    return completer.future;
  }

  /// 创建下行流 （废弃）
  // Future<bool> _createNewDirectives() async {
  //   _closeNewDirectivesIfNeed();
  //   logger?.v('开始创建下行流通道...');
  //    isSmartHomeSkill = false;
  //   logger?.v('isSmartHomeSkill = false');
  //   _cancelTokenDirectives = CancelToken();
  //   final rs = await _service.createDirectives(
  //       accessToken: _auth.accessToken!, cancelToken: _cancelTokenDirectives);
  //   if (rs.isOK && rs.result != null) {
  //     await _subscriptDirectives?.cancel();
  //     _subscriptDirectives = rs.result!.stream.listen((data) {
  //       final models = _parseDirectives(data);
  //       //logger?.v('22========Directives Response: $model');
  //       if (models != null) {
  //         for (final model in models) {
  //           if (_subjectDirectiveData.hasListener && !_subjectDirectiveData.isClosed) {
  //             _subjectDirectiveData.add(model);
  //           }
  //           if (model.isStopCapture) {
  //             // 停止流上传
  //             //_voice.stopUpload();
  //           }
  //         }
  //       }
  //     },onDone: () {
  //       logger?.e('下行流通道结束');
  //     }, onError: (e){
  //       logger?.e('下行流通道异常：$e');
  //       _hasCreateNewDirectives = true;
  //       if (e is DioException) {
  //         if (e.type != DioExceptionType.cancel) {
  //           if (_reachability.hasNetwork) {
  //             createNewDirectives();
  //           }else {
  //             logger?.e("下行流通道中断，无网络，待有网后重新创建1");
  //           }
  //         }
  //       } else if(e is SocketException) {
  //         logger?.e("下行流通道中断，io异常，重新创建dio实例");
  //         _closeNewDirectivesIfNeed();
  //         _isOnNewDirectivesCreating = false;
  //         HttpClient.getInstance().doRecreateDioV2();
  //       } else {
  //         if (_reachability.hasNetwork) {
  //           createNewDirectives();
  //         }else {
  //           logger?.e("下行流通道中断，无网络，待有网后重新创建2");
  //         }
  //       }
  //     });
  //     _hasCreateNewDirectives = false;
  //     _isOnNewDirectivesCreating = false;
  //     logger?.d('下行流通道创建: 成功');
  //     return true;
  //   }
  //   _hasCreateNewDirectives = true;
  //   _isOnNewDirectivesCreating = false;
  //   logger?.e('下行流通道创建: 失败 rs:$rs');
  //   return false;
  // }

  List<DirectiveModel>? _parseDirectives(Uint8List data) {
    try {
      var strData = utf8.decode(data);
      logger?.v('下行流通道收到数据：data len:${data.length} \n$strData');
      final items = strData.split(_keywordContentType);
      if (items.isEmpty) {
        logger?.v('下行流通道数据解析：未找到有效数据');
        return null;
      }
      final list = <DirectiveModel>[];
      for (var str in items) {
        try {
          final start = str.indexOf('{');
          final end = str.lastIndexOf('}');
          if (start == -1 || end == -1) {
            logger?.v('非json数据，忽略');
            continue;
          }
          str = str.substring(start, end + 1);
          logger?.v('下行流通道数据解析成功：\n json:|$str|');
          final json = jsonDecode(str);
          final directive = json['directive'];
          if (directive != null && directive is Map<String, dynamic>) {
            final directiveModel = DirectiveModel.fromJson(directive);
            list.add(directiveModel);
          }
        } catch(e) {
          logger?.e('下行流通道json解析异常:${e.toString()}');
          continue;
        }
      }
      return list;
    } catch (e) {
      logger?.e('下行流通道数据解析异常');
      logger?.e(e.toString());
    }
    return null;
  }

  /// 注册监听
  void _registerAllListen() {
    // 网络变更
    _reachability.listenNetworkStatusChanged((status) {
        if (_reachability.hasNetwork) {
          if (_isOfflineLongTime()) {
            // 无网状态时间过长
            logger?.d("无网时长超过3分钟");
          }
          _offlineMilliseconds = 0;
          // 有网，是否需要创建下行流
          if (_isSetupAlexaAlready && _hasCreateNewDirectives && !_isOnNewDirectivesCreating) {
            logger?.d("alexa - 网络恢复 执行创建下行流");
            createNewDirectives();
          }
        }else {
          _offlineMilliseconds = DateTime.now().millisecondsSinceEpoch;
        }
    });

    // 登录状态变更
    _auth.listenLoginStateChanged((state) {
      if (_auth.isLogin) {
        // 已登录
        if (!_isSetupAlexaAlready) {
          logger?.d("alexa - alexa logined, call _setupAlexa");
          _setupAlexa();
        }
        _loginStateUpdated = true;
        //_updateAlexaLoginStateToDevice();
      } else {
        // 未登录
        _isSetupAlexaAlready = false; // 重置状态
        _hasCreateNewDirectives = false;
        _isOnNewDirectivesCreating = false;
        _stopPing(); // 未登录停止ping
        _closeNewDirectivesIfNeed(); // 取消下行流
      }

      // 退出
      if (state == LoginState.logout) {
        logger?.v('alexa logout, clean state');
        _loginStateUpdated = false;
        //_updateAlexaLoginStateToDevice(forceUpdate: true);
      }
    });

    // 设备连接状态
    libManager.listenStatusNotification((status) {
      if (status == IDOStatusNotification.fastSyncCompleted) {
        _deviceFastSyncCompleted = true;
        if (!_isSetupAlexaAlready) {
          logger?.d("alexa - FastSyncCompleted, call _setupAlexa");
          _setupAlexa();
        }
        //_updateAlexaLoginStateToDevice();
      }
    });

    // 下行流通道数据
    listenDirectiveData((model) {
      logger?.v('↓下行流通道数据分发：${jsonEncode(model.toJson())}');
      _downDirectivesAnalysis.receiveDirectives(model: model);
    });

    // 上行流通道
    listenUploadVoiceData((model) {
      logger?.v('↑上行流通道数据分发：${jsonEncode(model.toMapBlurry())}');
      _uploadDirectivesAnalysis.parsingTextDirectivesAnalysis(
          directives: model);
    });

    // 监听dio重新实例化
    HttpClient.getInstance().listenDioV2InstanceChanged((p0) {
      logger?.d('reset _http2');
      //createNewDirectives();
    });
  }

  void _channelLog() {
    AlexaChannelImpl().blockAlexaChannelLog = (s) {
      logger?.v(s);
    };
  }

  // 离线时间过长，存在dio请求发不出去的问题，需要重新创建dio实例和下行流
  bool _isOfflineLongTime() {
    if (_offlineMilliseconds > 0) {
      // 暂定3分钟
      return (DateTime.now().millisecondsSinceEpoch - _offlineMilliseconds) >= 3 * 1000 * 60;
    }
    return false;
  }
}
