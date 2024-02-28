part of '../ido_protocol_alexa.dart';

class _IDOProtocolAlexa implements IDOProtocolAlexa, LocalStorageConfig {
  static String? _clientId;
  String? _uniqueID;
  AlexaOperator? _alexaOperator;
  late final _client = AlexaClient();
  late final _identityLogReport = IdentityLogReport();

  // 语言
  static AlexaLanguageType _lanType = AlexaLanguageType.usa;

  static final _instance = _IDOProtocolAlexa._internal();
  factory _IDOProtocolAlexa() => _instance;
  _IDOProtocolAlexa._internal() {
    storage = LocalStorage.config(config: this);
    _alexaOperator =
        libManager.joinAlexa(_client.voice.alexaDelegate); // 关联protocol_lib库
    _client.voice.alexaOperator = _alexaOperator;
    _listenProtocolLibDeviceNotification();
    logger?.d("alexa version: $getSdkVersion");
  }

  static Future<void> registerAlexa({required String clientId}) async {
    assert(clientId.isNotEmpty, 'Alexa clientId can not empty!');
    final same = _clientId == clientId;
    _clientId = clientId;
    logger?.d('registerAlexa same:$same');
    if (!same) {
      _instance._uniqueID = null; // 置空标识码
      await Auth().setClientID(clientId);
    }

    ApiAlexaFlutter.setup(AlexaChannelImpl());

    // TODO GetStorage存在bug，app刚起动 存在获取不到值的问题，待修改
    Future.delayed(const Duration(seconds: 1), () async {
      // 加载语言, 不存在缓存将使用默认值
      final type = await storage?.loadLanguageType();
      if (type != null) {
        _lanType = type;
      } else {
        await storage?.saveLanguageType(_lanType);
      }
    });
  }

  static Future<bool> changeLanguage(AlexaLanguageType type) async {
    // 登录状态, 切换语言，不成功将回滚
    if (Auth().isLogin) {
      AlexaServerManager().setRegion(region: type.region);
      final rs = await _IDOProtocolAlexaExt._localesChanged(type);
      if (rs) {
        _lanType = type;
        await storage?.saveLanguageType(type);
      } else {
        // 回滚
        AlexaServerManager().setRegion(region: _lanType.region);
        logger?.d('修改语言 $_lanType to $type 失败，已回滚');
      }
      return rs;
    }

    // 未登录, 默认成功
    _lanType = type;
    AlexaServerManager().setRegion(region: type.region);
    await storage?.saveLanguageType(type);
    return true;
  }

  static Future<bool> initLog(
      {bool writeToFile = true,
      bool outputToConsole = true,
      LoggerLevel logLevel = LoggerLevel.verbose}) async {
    return AlexaClient.setLog(writeToFile, outputToConsole, logLevel: logLevel);
  }

  @override
  String get uniqueID {
    assert(_clientId != null,
        'Has call IDOProtocolAlexa.registerAlexa(...) set alexa clientId first');
    _uniqueID ??= "${_clientId!}-aJ3V28akEs".md5();
    return _uniqueID!;
  }

  @override
  AlexaLanguageType get currentLanguage => _lanType;

  @override
  debugTest() async {
    if (!kDebugMode) {
      return;
    }

    if (Auth().isLogin) {
      // TODO: 测试

      // HttpClient.getInstance().testRecreateDio(); // 测试创建dio实例
      // _client.voice.test();
      AlexaClient().createNewDirectives();
    }
  }

  @override
  refreshToken() async {
    if (!kDebugMode) {
      return;
    }
    return _client.auth.refreshToken();
  }

  _testListen() {
    // TODO: 测试
  }

  @override
  Future<LoginResponse> authorizeRequest(
      {required String productId, required CallbackPairCode func}) {
    return _client.auth.login(productId: productId, func: func);
  }

  @override
  void stopLogin() {
    _client.auth.stopLogin();
  }

  @override
  bool get isLogin => _client.auth.isLogin;

  @override
  StreamSubscription listenLoginStateChanged(
      void Function(LoginState state) func) {
    return _client.auth.listenLoginStateChanged(func);
  }

  @override
  StreamSubscription listenVoiceStateChanged(
      void Function(VoiceState state) func) {
    return _client.voice.listenVoiceStateChanged(func);
  }

  @override
  void logout() {
    _client.auth.logout();
  }

  @override
  set delegate(IDOAlexaDelegate delegate) {
    _client.delegate = delegate;
  }

  @override
  Future<bool> get isSupportAudioTesting async {
    final dirPath = await libManager.cache.alexaTestPath();
    final file = File('$dirPath/content.json');
    final rs = await file.exists() && file.statSync().size > 100;
    return rs;
  }

  @override
  Future<bool> testUploadPCM(String pcmPath) async {
    if (Auth().isLogin) {
      return _client.voice.testUploadPCM(pcmPath);
    }else {
      logger?.v('testUploadPCM 需要登录alexa后使用');
    }
    return false;
  }

  // 最后修改时间: 2023-12-12 09:39:37
  @override
  String get getSdkVersion => '2.0.9';
}

extension _IDOProtocolAlexaExt on _IDOProtocolAlexa {
  /// 设备通知
  _listenProtocolLibDeviceNotification() {

    libManager.listenDeviceNotification((m) {
      final type = m.dataType ?? 0;
      switch (type) {
        case 0:
          break;
        case 5:
          logger?.d('alexa - stopReceiveVoiceDataFromBle');
          // Alexa识别过程中退出
          _alexaOperator?.stopReceiveVoiceDataFromBle();
          break;
        case 9:
          // alexa设置的闹钟，固件修改，需要发送对应的通知位给app，app收到后发送获取V3的闹钟命令
          break;
        case 31:
          _identityLogReport.userSoftwareInfoReport();
          break;
        case 32:
          _identityLogReport.userInactivityReport(inactiveTimeInSeconds: 3600);
          break;
      }

      final controlEvtType = m.controlEvt ?? 0;
      switch (controlEvtType) {
        case 0:
          break;
        case 591:
          _identityLogReport.volumeChangedInfoReport(volumeJsonStr: m.controlJson!);
          break;
      }
    });

    libManager.listenStatusNotification((status) {
        if (status == IDOStatusNotification.fastSyncCompleted) {

        }
    });

  }

  /// 修改语言
  static Future<bool> _localesChanged(AlexaLanguageType lan) async {
    if (!Auth().isLogin) {
      logger?.d('未登录，无法调用alexa修改语言接口');
      return false;
    }
    final rs = await ServiceManager().sendEventPart(
        accessToken: Auth().accessToken!,
        dataBody: DataBox.localesChanged(lan.lan),
        label: '修改语言');
    return rs.status == 0 || rs.status == 204;
  }
}
