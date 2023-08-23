part of '../client.dart';

class _AlexaClient implements AlexaClient {
  late final _service = ServiceManager();
  late final _auth = Auth();
  late final _voice = Voice();
  late final _uploadDirectivesAnalysis = UploadDirectivesAnalysis();
  late final _downDirectivesAnalysis = DownDirectivesAnalysis();
  late final _capabilitiesReport = CapabilitiesReport();
  final _reachability = AlexaReachability();
  static const _pingDurationSeconds = 2 * 60; // 执行ping的间隔时间（单位 秒）
  bool _isSetupAlexaAlready = false; // 是否已设置alexa
  bool _loginStateUpdated = false; // alexa登录状态已更新
  bool _deviceFastSyncCompleted = false; // 设备快速配置完成

  Timer? _timerPing;
  CancelToken? _cancelTokenDirectives;
  StreamSubscription? _streamSubscription;
  List? _timerArr;
  late final _subjectDirectiveData =
      StreamController<DirectiveModel>.broadcast();

  static final _instance = _AlexaClient._internal();
  factory _AlexaClient() => _instance;
  _AlexaClient._internal() {
    _setupAlexa();
    _listenReachabilityChanged();
    _listenLoginStateChanged();
    _listenUploadAndDownDirectiveData();
    _listenStatusNotification();
  }

  @override
  String get messageId => _voice.uniqueID;

  @override
  IDOAlexaDelegate? delegate;

  @override
  bool? isSmartHomeSkill = false;
  String? lastTimerToken;
  List alarmArr = [];
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

  @override
  Auth get auth => _auth;

  @override
  Voice get voice => _voice;

  @override
  Future<bool> createNewDirectives({int retryCount = 5}) async {
    var count = 0;
    return Rx.retryWhen(() {
      if (count > 0 && count < retryCount) {
        logger?.v('创建下行流通道执行第$count次 重试');
      }
      return _createNewDirectives().asStream().map((res) {
        if (count > retryCount) {
          logger?.d('创建下行流通道执行超过$retryCount次 结束重试');
          return res;
        } else if (!res) {
          throw 'has retry'; // 触发重试
        }
        return res;
      });
    }, (e, s) {
      count++;
      logger?.e(e);
      return Rx.timer(null, const Duration(seconds: 1)); // 刷新间隔
    }).map((res) {
      return res;
    }).last;
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
      logger
          ?.d('Not currently logged in, can not call _setupAlexa() return...');
      return;
    }

    logger?.d('call _setupAlexa()');

    await _capabilitiesReport.initUpdateDeviceCapabilities();

    // 创建下行流
    logger?.d('调用 创建下行流通道');
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

      // 定时ping
      _startPing();
    }
  }

  void _startPing() async {
    logger?.d('call _startPing');
    _timerPing?.cancel();
    _timerPing = Timer.periodic(
        const Duration(seconds: _AlexaClient._pingDurationSeconds),
        (timer) async {
      if (_auth.isLogin) {
        final rs = await _service.ping(accessToken: Auth().accessToken!);

        if (!rs.isOK) {
          logger?.d(
              'ping failed, _reachability.hasNetwork:${_reachability.hasNetwork} status:${rs.status}');
          // token 失效，重新获取token
          if (_reachability.hasNetwork && await _auth.refreshToken()) {
            // 重连
            logger?.d('ping failed, recreate new directives');
            logger?.d('调用 创建下行流通道');
            if (!await _createNewDirectives()) {
              // TODO 重连失败
              logger?.d('ping failed, recreate new directives failed');
            }
          } else {
            final hasNetwork = _reachability.hasNetwork;
            final msg = hasNetwork ? '' : '- ping失败导致退出登录！';
            logger?.d('ping failed, hasNetwork:$hasNetwork $msg');
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
      if (_cancelTokenDirectives != null &&
          !_cancelTokenDirectives!.isCancelled) {
        logger?.d('关闭当前下行通道流');
        _cancelTokenDirectives!.cancel();
      }
    } catch (e) {
      logger?.e(e);
    }
  }

  /// 创建下行流
  Future<bool> _createNewDirectives() async {
    _closeNewDirectivesIfNeed();
    logger?.v('开始创建下行流通道...');
    _cancelTokenDirectives = CancelToken();
    final rs = await _service.createDirectives(
        accessToken: _auth.accessToken!, cancelToken: _cancelTokenDirectives);
    if (rs.isOK && rs.result != null) {
      _streamSubscription?.cancel();
      _streamSubscription = rs.result!.stream.listen((data) {
        final model = _parseDirectives(data);
        //logger?.v('22========Directives Response: $model');
        if (model != null) {
          if (_subjectDirectiveData.hasListener) {
            _subjectDirectiveData.add(model);
          }
          if (model.isStopCapture) {
            // 停止流上传
            //_voice.stopUpload();
          }
        }
      });
      logger?.d('下行流通道创建: 成功');
      return true;
    }
    logger?.e('下行流通道创建: 失败 rs:$rs');
    return false;
  }

  DirectiveModel? _parseDirectives(Uint8List data) {
    try {
      var str = utf8.decode(data);
      logger?.v('下行流通道收到数据：data len:${data.length} \nContent: $str');
      if (str.startsWith('Content-Type: application/json')) {
        str = str.substring(str.indexOf('{'), str.lastIndexOf('}') + 1);
        logger?.v('下行流通道数据解析成功：\n json:$str');
        final json = jsonDecode(str);
        final directive = json['directive'];
        if (directive != null && directive is Map<String, dynamic>) {
          final directiveModel = DirectiveModel.fromJson(directive);
          if (directiveModel.isSpeak) {}
          return directiveModel;
        }
      }
    } catch (e) {
      logger?.e('下行流通道数据解析异常');
      logger?.e(e.toString());
    }
    return null;
  }

  /// 网络变更
  _listenReachabilityChanged() {
    _reachability.listenNetworkStatusChanged((status) {});
  }

  /// 登录状态变更
  _listenLoginStateChanged() {
    _auth.listenLoginStateChanged((state) {
      if (_auth.isLogin) {
        // 已登录
        if (!_isSetupAlexaAlready) {
          logger?.d("需要执行alexa设置");
          _setupAlexa();
        }
        _loginStateUpdated = true;
        _updateAlexaLoginStateToDevice();
      } else {
        // 未登录
        _isSetupAlexaAlready = false; // 重置状态
        _stopPing(); // 未登录停止ping
        _closeNewDirectivesIfNeed(); // 取消下行流
      }

      // 退出
      if (state == LoginState.logout) {
        logger?.v('alexa退出登录，清除设备连接状态');
        _loginStateUpdated = false;
        _updateAlexaLoginStateToDevice(forceUpdate: true);
      }
    });
  }

  /// 设备连接状态
  _listenStatusNotification() {
    libManager.listenStatusNotification((status) {
      if (status == IDOStatusNotification.fastSyncCompleted) {
        _deviceFastSyncCompleted = true;
        _updateAlexaLoginStateToDevice();
      }
    });
  }

  /// 上下流数据解析处理
  _listenUploadAndDownDirectiveData() {
    listenDirectiveData((model) {
      logger?.v('↓下行流通道数据分发：${jsonEncode(model.toJson())}');
      _downDirectivesAnalysis.receiveDirectives(model: model);
    });

    listenUploadVoiceData((model) {
      logger?.v('↑上行流通道数据分发：${jsonEncode(model.toMapBlurry())}');
      _uploadDirectivesAnalysis.parsingTextDirectivesAnalysis(
          directives: model);
    });
  }

  /// 从app更新alexa登录状态到设备
  Future<void> _updateAlexaLoginStateToDevice(
      {bool forceUpdate = false}) async {
    if (forceUpdate || (_deviceFastSyncCompleted && _loginStateUpdated)) {
      final logState = IDOProtocolAlexa().isLogin ? 0 : 1;
      logger?.d(
          'update login state:$logState to device ${libManager.macAddress} forceUpdate:$forceUpdate');
      // log_state 0：正常状态（登录） 1：未登录 2：网络断连 3：未获取状态
      final param = {"log_state": logState};
      final rs = await libManager
          .send(
              evt: CmdEvtType.alexaVoiceBleGetPhoneLoginState,
              json: jsonEncode(param))
          .first;
      if (rs.isOK) {
        //_deviceConnectUpdated = false;
      }
    } else {
      //logger?.v('_deviceConnected: $_deviceConnectUpdated _loginStateUpdated: $_loginStateUpdated');
    }
  }
}
