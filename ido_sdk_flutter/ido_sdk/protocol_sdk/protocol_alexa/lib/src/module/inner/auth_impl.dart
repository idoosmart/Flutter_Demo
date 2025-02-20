part of '../auth.dart';

/// 认证、授权管理
class _Auth implements Auth {
  static final _instance = _Auth._internal();
  _Auth._internal() {
    _registerReachability();
  }
  factory _Auth() => _instance;

  late final _reachability = AlexaReachability();
  late final _service = ServiceManager();
  late final _alexaChannel = AlexaChannelImpl();
  final _subjectLoginState = StreamController<LoginState>.broadcast();

  bool _isLogin = false;
  String? _clientId;
  AuthModel? _authModel;
  String _productId = '';

  Timer? _timer; // 登录待倒计时
  Completer<LoginResponse>? _completerLogin;
  StreamSubscription? _streamSubscriptionLogin;

  // 登录状态
  LoginState __loginState = LoginState.logout;
  set _loginState(LoginState state) {
    final isChanged = true;//__loginState != state;
    __loginState = state;
    logger?.d('alexa - set __loginState = $state isChanged:$isChanged');
    if (isChanged && _subjectLoginState.hasListener) {
      logger?.d('alexa - _subjectLoginState send');
      _subjectLoginState.add(__loginState);
    }
  }

  @override
  bool get isLogin => _isLogin;

  @override
  String get clientId {
    assert(_clientId != null,
        'Alexa clientId can not empty! has call await IDOProtocolAlexa.registerAlexa(clientId: clientId) in main.dart');
    return _clientId!;
  }

  @override
  Future<LoginResponse> login(
      {required String productId, required CallbackPairCode func}) async {
    logger?.v('call login productId：$productId');
    _stopTimer();
    _streamSubscriptionLogin?.cancel();
    _completerLogin = Completer();

    _markLogging();
    // 刷新token
    final hasToken = await _refreshToken();
    if (hasToken) {
      _markLogin();
      _productId = productId;
      _completerLogin?.complete(LoginResponse.successful);
      return _completerLogin!.future;
    }

    LoginResponse res = LoginResponse.failed;

    final macAddr = libManager.deviceInfo.macAddressFull ?? libManager.macAddress;
    logger?.d('获取alexa登录授权码 clientId:$clientId productId:$productId deviceSerialNumber:$macAddr');
    // 获取pair code
    final pair = await _service.createCodePair(
        clientId: clientId,
        productId: productId,
        deviceSerialNumber: macAddr);

    if (pair.status != 0 || pair.result?.userCode == null) {
      _markLogout();
      _completerLogin?.complete(res);
      return _completerLogin!.future;
    }

    // 上报，由上层打开给定的url
    func(pair.result!.userCode!, pair.result!.verificationUri!);

    // 启用轮询 获取accessToke 注：pair code 有效时长为300秒，控制轮询总时长不超过该时间
    _streamSubscriptionLogin =
        _startGetAccess(pair.result!.deviceCode!, pair.result!.userCode!)
            .listen((auth) async {
      if (auth != null && auth.isOK) {
        res = LoginResponse.successful;
        _authModel = auth;
        _productId = productId;
        await storage?.saveAuthDataToDisk(auth); // 保存token
        await storage?.saveProductId(productId);
        if (_completerLogin != null && !_completerLogin!.isCompleted) {
          _completerLogin!.complete(res);
          _completerLogin = null;
        }
        _markLogin();
      } else {
        res = LoginResponse.failed;
        if (_completerLogin != null && !_completerLogin!.isCompleted) {
          _completerLogin!.complete(res);
          _completerLogin = null;
        }
        _markLogout();
      }
    });
    return _completerLogin!.future;
  }

  @override
  void stopLogin() {
    logger?.v('stopLogin');
    _cancelLogin();
    _stopTimer();
    if (__loginState == LoginState.logging) {
      _markLogout();
    }
  }

  @override
  void logout() {
    logger?.d('alexa - call logout');
    _authModel = null;
    _productId = '';

    //清除闹钟数据
    storage?.saveAlarmDataToDisk(libManager.deviceInfo.macAddress,[]);
    AlexaClient().createAlarmArr(false);

    storage?.saveProductId(_productId);
    storage?.cleanAuthData();
    _markLogout();
  }

  @override
  Future<bool> refreshToken() {
    return _refreshToken();
  }

  @override
  StreamSubscription listenLoginStateChanged(
      void Function(LoginState state) func) {
    return _subjectLoginState.stream.listen(func);
  }

  @override
  Future<void> setClientID(String clientId) async {
    if (clientId.length > 6) {
      logger?.d('setClientID *${clientId.substring(clientId.length - 6)}');
    }else {
      logger?.d('setClientID $clientId 无效的clientId');
    }
    _clientId = clientId;
    Future.delayed(const Duration(seconds: 1), () => _loadDataByCache());
  }

  @override
  String? get accessToken {
    //assert(_authModel != null && _authModel!.isOK, 'has login first');
    //logger?.v('accessToken: ${_authModel?.accessToken}');
    if (_authModel == null || !_authModel!.isOK) {
      logger?.e("has login first");
    }
    return _authModel?.accessToken;
  }

  @override
  String get productId => _productId;
}

extension _AuthExt on _Auth {
  void _registerReachability() {
    _reachability.listenNetworkStatusChanged((status) {
      if (_reachability.hasNetwork) {
        final isInit = _clientId != null && !_isLogin;
        final canRefreshToken = _authModel != null && _authModel!.isOK;
        if (isInit && canRefreshToken) {
          _refreshToken(); // 有网时
        }
      }
    });
  }

  // 启动token获取（轮询）
  Stream<AuthModel?> _startGetAccess(String deviceCode, String userCode) {
    _startTimer();
    return Rx.retryWhen(() {
      return _service
          .getAccessToken(deviceCode: deviceCode, userCode: userCode)
          .asStream()
          .map((res) {
        if (res.status != 0) {
          // 由于用户可能会有一段时间来完成注册或可以放弃注册，因此在轮询期间，
          // 您可能会收到以下回复：authorization_pending、slow_down、invalid_code_pair、invalid_client、unauthorized_client。
          // invalid_code_pair 时，重新启动注册流程
          if (res.result?.error == 'invalid_code_pair') {
            return res.result!;
          }
          logger?.v('_startGetAccess rs:${res.result.toString()}');
          throw 'has retry'; // 触发重试
        }
        return res.result!;
      });
    }, (e, s) {
      return Rx.timer(null, const Duration(milliseconds: 3000)); // 刷新间隔
    }).map((res) {
      _stopTimer();
      return res;
    });
  }

  // 刷新token
  Future<bool> _refreshToken() async {
    if (_authModel != null && _authModel!.isOK) {
      final res = await _service.refreshAccessToken(
          clientId: clientId, refreshToken: _authModel!.refreshToken!);
      logger?.d('_refreshToken res:$res');
      if (res.status == 0 && res.result != null && res.result!.isOK) {
        await storage?.saveAuthDataToDisk(res.result!);
        _authModel = res.result!;
        _markLogin();
        return Future(() => true);
      } else {
        if (_reachability.hasNetwork) {
          if (res.status != -1) {
            logger?.e('_refreshToken failed, mark logout~~ ');
            // 失败， 需要重新登录
            _authModel = null;
            _markLogout();
          }else {
            logger?.e('_refreshToken failed, res:$res');
          }
        }else {
          logger?.e('_refreshToken failed, res:$res');
        }
      }
    } else {
      logger?.v('_authModel is null');
      _alexaChannel.alexaHost.onTokenChanged(null);
    }
    return Future(() => false);
  }

  // 登录倒计时
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 300), () {
      _cancelLogin();
      if (_completerLogin != null && !_completerLogin!.isCompleted) {
        _completerLogin!.complete(LoginResponse.timeout);
        _completerLogin = null;
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _cancelLogin() {
    _streamSubscriptionLogin?.cancel();
    _streamSubscriptionLogin = null;
  }

  // 加载授权数据，缓存依赖clientId， 该方无需显式调用
  Future<void> _loadDataByCache() async {
    _authModel = await storage?.loadAuthDataByDisk();
    _productId = await storage?.loadProductId() ?? '';
    logger?.d('_loadDataByCache _authModel:$_authModel storage:$storage');
    if (_authModel != null && _authModel!.isOK) {
      _refreshToken();
    }
  }

  // 标记登录
  void _markLogin() {
    _isLogin = true;
    _loginState = LoginState.logined;
    logger?.d("Channel通道 - 1发送token");
    _alexaChannel.alexaHost.onTokenChanged(_authModel?.accessToken);
  }

  // 标记退出
  void _markLogout() {
    _isLogin = false;
    _loginState = LoginState.logout;
    logger?.d("Channel通道 - 2发送token");
    _alexaChannel.alexaHost.onTokenChanged(null);
  }

  void _markLogging() {
    _isLogin = false;
    _loginState = LoginState.logging;
  }
}
