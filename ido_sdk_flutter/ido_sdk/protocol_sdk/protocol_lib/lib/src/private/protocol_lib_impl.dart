part of '../ido_protocol_lib.dart';

class _IDOProtocolLibManager
    implements IDOProtocolLibManager, LocalStorageConfig {
  static const _pathStorageC = 'c_files';
  static const _pathStorageLib = 'protocol_lib';
  static const _pathStorageLog = 'logs';
  // 最后修改时间: 2025-11-20 14:34:18
  static const _sdkVersion = '4.1.10';
  static const _sdkBuildNum = '691EB66A';

  static bool _outputToConsoleClib = false;
  static bool _isReleaseClib = true;

  late final _coreMgr = IDOProtocolCoreManager();
  late final _messageIcon = IDOMessageIcon();
  late final _tools = IDOTool();
  late final _callNotice = IDOCallNotice();
  late final _cache = IDOCache();

  late final _alexaOpt = AlexaOperator();
  AlexaDelegate? _alexaDelegate;

  bool _isInitClib = false;
  late final String _clibVersion = _coreMgr.getClibVersion() ?? 'unknown';
  StreamSubscription<int>? _subscriptFastSyncComplete;
  late IDOOtaType __otaType = IDOOtaType.none;
  set _otaType(IDOOtaType value) {
    __otaType = value;
    sdkStateChanged.add(null);
  }
  late bool __isConnected = false;
  set _isConnected(bool value) {
    __isConnected = value;
    sdkStateChanged.add(null);
  }
  late bool __isConnecting = false;
  set _isConnecting(bool value) {
    __isConnecting = value;
    sdkStateChanged.add(null);
  }
  late bool __isFastSynchronizing = false;
  set _isFastSynchronizing(bool value) {
    __isFastSynchronizing = value;
    sdkStateChanged.add(null);
  }
  // 由于目前快速配置存在下发 setMode后不上报问题，此处添加容错机制
  Timer? _timerFastSync;
  // x秒后重置 _isFastSynchronizing 为 false
  final int _timerFastSyncDuration = 35; //快速配置等待最长时间 单位 秒
  String? __macAddress = 'UNKNOWN'; // SDK内统一为去除冒号后的转大写字符串
  set _macAddress(String? value) {
    __macAddress = value ?? 'UNKNOWN';
    sdkStateChanged.add(null);
  }
  String? _macAddressOriginal; // markConnected传入的原始macAddress
  String? _uuid; // ios专用
  bool _isPersimwearOtaUpgrading = false;
  bool _isSicheDfuMode = false;
  int _lastDevicePlatform = -1;
  bool _isPreviewingCamera = false; // 是否处于摄像头预览中

  _IDOProtocolLibManager._internal() {
    storage = LocalStorage.config(config: this);
    IsolateManager.instance.init();
  }
  static final _instance = _IDOProtocolLibManager._internal();
  factory _IDOProtocolLibManager() => _instance;

  /// 处理不需要响应的指令
  late final _excludeCmd = {
    CmdEvtType.connected,
    CmdEvtType.disconnect,
    CmdEvtType.alexaVoiceBleGetPhoneLoginState,
  };

  // 有效的通知事件
  late final _controlEventTypeSet = {551}
    ..addAll({552, 553, 554, 555, 556, 557, 558, 559})
    ..addAll({560, 561, 562, 563, 565, 567, 568, 569, 570, 571, 581})
    ..addAll({572, 574, 575, 576, 578, 579, 580, 591});

  _initClib() async {
    logger?.d('begin _initClib hasCode:$hashCode');
    await _initClibFilePath();
    await _coreMgr.initClib();
    _cRequestHandle();
    _fastSyncComplete();
    _listenDeviceState();
    _registerDeviceStatusChanged();
    _registerAlexaReceive();
    _registerUpdateSetModeChanged();
    _registerBindStateChanged();
    _registerBleReceiveData();
    // _registerMessageIcon(); 暂时不注册,影响到安卓权限申请
    // 设置c库运行模式
    _setClibRunMode(isDebug: !_isReleaseClib);
    // 设置c库流数据记录到log开关公开 0不写入 1写入 默认不写入流数据
    _coreMgr.setWriteStreamByte(_isReleaseClib ? 0 : 1);
    logger?.d('end _initClib hasCode:$hashCode');
  }

  @override
  String get macAddress => __macAddress ?? 'UNKNOWN';

  @override
  String? get macAddressFull => _macAddressOriginal;

  @override
  Future<bool> markSiceOtaMode({
    required String macAddress,
    required String iosUUID,
    required int platform,
    required int deviceId}) async {
    if (![98, 99].contains(platform)) {
      logger?.e("markSiceOtaMode platform:$platform, 98, 99 only");
      return false;
    }

    logger?.d('markSiceOtaMode - set mode: 2');

    // ota模式下，macAddress获取不到
    // if (macAddress.isEmpty) {
    //   final macAddr = await _requestMacAddress();
    //   if (macAddr != null && macAddr.isNotEmpty) {
    //     macAddress = macAddr;
    //     debugPrint('markOta - macAddress:$macAddress');
    //   }
    // }

    libManager.deviceInfo.innerSetDeviceInfo(platform: platform, macAddress: macAddress,
        otaMode: true, uuid: iosUUID, deviceId: deviceId);
    _isConnecting = false;
    _isFastSynchronizing = false;
    _lastDevicePlatform = platform;
    // mode: 0 没有绑定, 1 已经绑定, 2 升级模式, 3 重连, 4 泰凌微
    //await _setBindMode(2); // 不需要设置
    return Future(() => true);
  }

  @override
  Future<bool> checkSiceOtaDoing() async {
    if (Platform.isAndroid) {
      if (libManager.deviceInfo.platform != 98 && _lastDevicePlatform != 98) {
        logger?.d("checkSiceOtaDoing, not sifli nor(98) platform, _lastDevicePlatform = $_lastDevicePlatform, device platform = ${libManager.deviceInfo.platform}");
        return false;
      }
      final rs = await SifliChannelImpl().sifliHost.checkOtaDoing();
      logger?.d("android checkSiceOtaDoing rs:$rs");
      return rs;
    }else {
      logger?.d("ios checkSiceOtaDoing, Will always return false");
      return Future.value(false);
    }
  }

  @override
  Future<bool> markConnectedDeviceSafe(
      {required String uniqueId,
      required IDOOtaType otaType,
      required bool isBinded,
      String? deviceName = '',
      String? iosUUID}) async {
    assert(uniqueId.isNotEmpty, 'macAddress cannot be empty');
    _registerMessageIcon();
    _lastDevicePlatform = -1;
    // iOS平台且传入的uniqueId为uuid时，添加获取mac地址流程
    if (Platform.isIOS && uniqueId.length > 17) {
      logger?.d('call markConnectedDeviceSafe, uniqueId:$uniqueId');
      // dispose();
      final macAddr = await _requestMacAddress();
      if (macAddr != null) {
        return _markConnectedDevice(
            macAddress: macAddr,
            otaType: otaType,
            isBinded: isBinded,
            deviceName: deviceName,
            uuid: uniqueId);
      }
      logger?.e('_requestMacAddress fail, macStr: $macAddr');
      return false;
    }

    // 其它情况走原逻辑
    return _markConnectedDevice(
        macAddress: uniqueId,
        otaType: otaType,
        isBinded: isBinded,
        deviceName: deviceName,
        uuid: iosUUID);
  }

  @override
  Future<bool> markDisconnectedDevice(
      {String? macAddress, String? uuid}) async {
    // 忽略非必要调用
    if (!__isConnected && __macAddress == null) {
      logger?.d(
          'ignore mark disconnected $macAddress _isConnected:$__isConnected _macAddress:$__macAddress');
      return Future(() => true);
    }

    // 非当前设备不执行断开操作
    if (macAddress != null) {
      final tmpMacAddress = macAddress.replaceAll(':', '').toUpperCase();
      if (tmpMacAddress != __macAddress) {
        logger?.e(
            'not the current device, do not perform disconnection macAddress:$tmpMacAddress');
        return Future(() => false);
      }
    } else if (Platform.isIOS && uuid != null) {
      if (uuid != _uuid) {
        logger?.e(
            'not the current device, do not perform disconnection uuid:$uuid');
        return Future(() => false);
      }
    }

    logger?.d('mark disconnected macAddress:$macAddress uuid:$uuid');
    deviceBind.stopBindIfNeed();
    _isConnected = false;
    _isConnecting = false;
    _isFastSynchronizing = false;
    _macAddress = null;
    _macAddressOriginal = null;
    _uuid = null;
    _otaType = IDOOtaType.none;
    _isPreviewingCamera = false;
    _lastDevicePlatform = deviceInfo.platform;
    _stopTimerFastSync();
    // !!!: 98平台ota比较特殊，会先断开蓝牙，再重连（走思澈sdk)，此处需要保留文件传输任务
    final needKeepTransFileTask = libManager.deviceInfo.platform == 98
        && libManager.transFile.isTransmitting
        && libManager.transFile.transFileType == FileTransType.fw;
    if (needKeepTransFileTask) {
      logger?.d("platform 98 needKeepTransFileTask:$needKeepTransFileTask");
    }
    _coreMgr.dispose(needKeepTransFileTask: needKeepTransFileTask);
    deviceLog.cancel();
    _coreMgr.cleanProtocolQueue();
    _coreMgr.stopSyncConfig(); // 停止快速配置

    deviceInfo.cleanDataOnMemory();
    funTable.cleanDataOnMemory();

    connectStatusChanged.add(__isConnected);

    // 断开连接
    await send(evt: CmdEvtType.disconnect).first;

    return Future(() => true);
  }

  @override
  Stream<CmdResponse> send({required CmdEvtType evt, String? json = '{}',
    IDOCmdPriority priority = IDOCmdPriority.normal}) {
    assert(_isInitClib, 'has call await IDOProtocolLibManager.register(...) in main.dart');
    if (json == null || json.isEmpty || json.trim().isEmpty) {
      json = '{}';
    }
    json = _cmdParamsInterceptor(evt.evtType, json);

    if (!__isConnected &&
        !{CmdEvtType.connected, CmdEvtType.disconnect}.contains(evt)) {
      logger?.v('no connected device，evtType:${evt.evtType} ignore');
      return Future(() => CmdResponse(
          code: ErrorCode.no_connected_device,
          evtType: evt.evtType)).asStream();
    }

    // 屏蔽思澈平台ota中的所有指令发送
    if ((libManager.deviceInfo.isSilfiPlatform()
        && libManager.transFile.isTransmitting
        && libManager.transFile.transFileType == FileTransType.fw) ||
        (libManager.deviceInfo.isPersimwearPlatform() && _isPersimwearOtaUpgrading)) {
      logger?.v('${libManager.deviceInfo.platform} platform ota mode, evtType:${evt.evtType} ignore');
      _coreMgr.dispose(needKeepTransFileTask: true);
      return Future(() => CmdResponse(
          code: ErrorCode.ota_mode,
          evtType: evt.evtType,
          msg: '设备处理ota中，忽略所有指令')).asStream();
    }

    // 屏蔽相机预览过程中的指令发送
    if (_isPreviewingCamera && [
      CmdEvtType.connected.evtType,
      CmdEvtType.disconnect.evtType,
      CmdEvtType.replyDeviceStartCameraPreviewRequest.evtType,
      CmdEvtType.replyDevicePauseCameraPreviewRequest.evtType,
      CmdEvtType.replyDeviceStopCameraPreviewRequest.evtType
    ].contains(evt.evtType) == false) {
      logger?.v('camera preview mode, evtType:${evt.evtType} ignore');
      return Future(() => CmdResponse(
          code: ErrorCode.onCameraPreview,
          evtType: evt.evtType,
          msg: '相机预览中，忽略所有指令')).asStream();
    }

    if (!_canSend(evt.evtType)) {
      final msg = 'on fast synchronizing, evtType:${evt.evtType} ignores';
      logger?.d(msg);
      return Future(() => CmdResponse(
          code: ErrorCode.onFastSynchronizing,
          evtType: evt.evtType,
          msg: msg)).asStream();
    }
    final useQueue = !_excludeCmd.contains(evt);

    return _coreMgr
        .writeJson(
            evtBase: evt.evtBase,
            evtType: evt.evtType,
            json: json,
            useQueue: useQueue,
            cmdPriority: priority.cmdPriority,
            cmdMap: evt._cmdInfo())
        .asStream();
  }

  @override
  StreamSubscription listenStatusNotification(
      void Function(IDOStatusNotification status) func) {
    assert(_isInitClib, 'has call await IDOProtocolLibManager.register(...) in main.dart');
    return statusSdkNotification.listen(func);
  }

  @override
  IDODeviceInfo get deviceInfo => IDODeviceInfo();

  @override
  IDOFunctionTable get funTable => IDOFunctionTable();

  @override
  IDOSyncData get syncData => IDOSyncData();

  @override
  IDOFileTransfer get transFile => IDOFileTransfer();

  @override
  IDODeviceBind get deviceBind => IDODeviceBind();

  @override
  IDOMessageIcon get messageIcon => IDOMessageIcon();

  @override
  IDOExchangeData get exchangeData => IDOExchangeData();

  @override
  bool get isConnected => __isConnected;

  @override
  bool get isConnecting => __isConnecting;

  @override
  IDOOtaType get otaType => __otaType;

  @override
  bool get isBinding => deviceBind.isBinding;

  @override
  bool get isFastSynchronizing {
    logger?.v("_isFastSynchronizing: $__isFastSynchronizing");
    return __isFastSynchronizing;
  }

  @override
  IDODeviceLog get deviceLog => IDODeviceLog();

  @override
  IDOProtocolLibDelegate? delegate;

  @override
  void receiveDataFromBle(Uint8List data, String? macAddress, int type) {
    // 非v3协议的数据补齐20字节
    if (data.isNotEmpty && data.length < 20 && data[0] != 0x33) {
      final dataList = data.toList();
      List.generate(20 - data.length, (index) => dataList.add(0x00));
      data = Uint8List.fromList(dataList);
    }
    _coreMgr.receiveDataFromBle(data, macAddress, type);
  }

  @override
  void registerWriteDataToBle(void Function(CmdRequest data) func) {
    _coreMgr.writeDataToBle(func);
  }

  @override
  void writeDataComplete() {
    _coreMgr.writeDataComplete();
  }

  @override
  void writeSppDataComplete() {
    _coreMgr.writeSppDataComplete();
  }

  @override
  void dispose() {
    _coreMgr.dispose();
    _coreMgr.cleanProtocolQueue();
  }

  @override
  void stopSyncConfig() {
    _coreMgr.stopSyncConfig();
    _stopTimerFastSync();
    _isFastSynchronizing = false;
  }

  @override
  AlexaOperator joinAlexa(AlexaDelegate delegate) {
    _alexaDelegate = delegate;
    return _alexaOpt;
  }

  @override
  StreamSubscription listenDeviceNotification(
      void Function(IDODeviceNotificationModel model) func) {
    return statusDeviceNotification.listen(func);
  }

  @override
  StreamSubscription listenConnectStatusChanged(void Function(bool isConnected) func) {
    return connectStatusChanged.listen(func);
  }

  @override
  StreamSubscription listenAllStateChanged(void Function(void) func) {
    return sdkStateChanged.listen(func);
  }

  @override
  StreamSubscription listenDeviceRawDataReport(void Function(int dataType,String jsonStr) func) {
    return deviceRawDataReportStream.listen((report) {
      func(report.dataType, report.data);
    });
  }

  @override
  void setPersimwearOtaUpgrading(bool upgrading) {
    _isPersimwearOtaUpgrading = upgrading;
  }

  @override
  bool get isPersimwearOtaUpgrading => _isPersimwearOtaUpgrading;

  @override
  IDOCallNotice get callNotice => _callNotice;

  @override
  IDOTool get tools => _tools;

  @override
  IDOCache get cache => _cache;

  @override
  String get getClibVersion => _clibVersion;

  @override
  String get getSdkVersion => _sdkVersion;

  @override
  String get getSdkBuildNum => _sdkBuildNum;

  @override
  int get lastDevicePlatform => _lastDevicePlatform;

  static Future<bool> doInitClib() async {
    return await _IDOProtocolLibManager()._doInitClib();
  }

  static Future<bool> initLog(
      {bool writeToFile = true,
      bool outputToConsole = true,
      bool outputToConsoleClib = false,
      bool isReleaseClib = true,
      LoggerLevel logLevel = LoggerLevel.verbose}) async {

    // 优先初始化Storage
    _IDOProtocolLibManager();
    await storage?.initStorage();

    return register(
        writeToFile: writeToFile,
        outputToConsole: outputToConsole,
        outputToConsoleClib: outputToConsoleClib,
        isReleaseClib: isReleaseClib,
        logLevel: logLevel);
  }

  static Future<bool> register(
      {bool writeToFile = true,
      bool outputToConsole = true,
      bool outputToConsoleClib = false,
      bool isReleaseClib = true,
      LoggerLevel logLevel = LoggerLevel.verbose}) async {
    if (!kDebugMode) {
      // release模式下日志由sdk内部控制
      logLevel = LoggerLevel.verbose;
    }
    _outputToConsoleClib = outputToConsoleClib;
    _isReleaseClib = isReleaseClib;
    String dirPath = '';
    if (writeToFile || outputToConsole) {
      final map = await storage?.loadLogConfigProtocol();
      var maximumFileSize = 10 * 1024 * 1024;
      var maximumNumberOfLogFiles = 5;
      if (map != null) {
        maximumFileSize = map["fileSize"] as int;
        maximumNumberOfLogFiles =  map["fileCount"] as int;
      }
      final pathSDK = await LocalStorage.pathSDKStatic();
      dirPath = '$pathSDK/$_pathStorageLog';
      final config = LoggerConfig(
          dirPath: '$dirPath/$_pathStorageLib',
          writeToFile: writeToFile,
          outputToConsole: outputToConsole,
          maximumFileSize: maximumFileSize,
          maximumNumberOfLogFiles: maximumNumberOfLogFiles,
          level: logLevel);
      LoggerSingle.configLogger(config: config);
      // logger = LoggerManager(config: config);
      // IDOProtocolCoreManager.setLogger(logger);
      IDOProtocolCoreManager()
          .initLogs(outputToConsoleClib: _outputToConsoleClib);
      logger = LoggerSingle();
      logger?.v("protocol log map = $map");
    } else {
      logger = null;
      // IDOProtocolCoreManager.setLogger(logger);
    }

    return true;
  }
}

extension _IDOProtocolLibManagerExt on _IDOProtocolLibManager {
  Future<bool> _doInitClib() async {
    logger?.d("initClib _isInitClib = $_isInitClib");
    if (!_isInitClib) {
      _isInitClib = true;
      await _initClib();
      // _clibVersion = _coreMgr.getClibVersion() ?? 'unknown';
      // logger?.v("clib: $_clibVersion sdk: $getSdkVersion os: ${Platform.isIOS ? "iOS" : "Android"}");
      // final aMap = await ToolsImpl().getPlatformDeviceInfo();
      // if (aMap != null) {
      //   logger?.v("$aMap");
      // }
    } else {
      // 设置c库运行模式
      _setClibRunMode(isDebug: !_IDOProtocolLibManager._isReleaseClib);
      // 设置c库流数据记录到log开关公开 0不写入 1写入 默认不写入流数据
      _coreMgr.setWriteStreamByte(_IDOProtocolLibManager._isReleaseClib ? 0 : 1);
    }
    return true;
  }

  void _setClibRunMode({required bool isDebug}) {
    logger?.v('setClibRunMode isDebug:$isDebug');
    _coreMgr.setRunMode(isDebug ? 0 : 1);
  }

  Future<bool> _markConnectedDevice(
      {required String macAddress,
      required IDOOtaType otaType,
      required bool isBinded,
      String? deviceName = '',
      String? uuid = ''}) async {
    assert(_isInitClib, 'has call await IDOProtocolLibManager.register(...) in main.dart');
    assert(macAddress.isNotEmpty, 'macAddress cannot be empty');
    if (macAddress.isEmpty) {
      logger?.e('macAddress cannot be empty');
      return Future(() => false);
    }
    final tmpMacAddress = macAddress.replaceAll(':', '').toUpperCase();
    if (__isConnected && __macAddress == tmpMacAddress) {
      logger?.d(
          'ignore mark connected $__macAddress isBinded:$isBinded otaType:$otaType');
      return Future(() => true);
    }

    // 泰凌微设备OTA 特殊处理
    if (otaType == IDOOtaType.telink) {
      _otaType = otaType;
      _isConnecting = true;
      _isConnected = true;
      _isFastSynchronizing = false;
      _macAddress = tmpMacAddress;
      _macAddressOriginal = macAddress;
      _uuid = uuid;
      logger?.d(
          'mark connected $__macAddress isBinded:$isBinded otaType:$otaType deviceName:$deviceName');
      storage?.resetCachePathOnDeviceChanged();
      _stopTimerFastSync();

      // 设置c库绑定模式
      await _setBindMode(4);
      logger?.d('set mode: 4');
      // 非ota模式时，发送连接指令
      await send(evt: CmdEvtType.connected).first;
      connectStatusChanged.add(__isConnected);
      // 协议库桥接蓝牙库初始化完成
      statusSdkNotification.add(IDOStatusNotification.protocolConnectCompleted);
      return Future(() => true);
    }

    final otaMode = otaType == IDOOtaType.nordic;
    if (__isConnected && __macAddress != tmpMacAddress) {
      // 因目前同时只允许连接一台设备，此处主动标记上个设备断开连接
      logger?.d('inner call mark disconnected $__macAddress isBinded:$isBinded');
      await markDisconnectedDevice();
    }

    _otaType = otaType;
    if (__isConnecting) {
      // 设备连接中，限制切换设备
      logger?.e(
          'device connecting, cannot switch device. old:$__macAddress this:$tmpMacAddress');
      return Future(() => false);
    }

    if (deviceBind.isBinding) {
      // 设备绑定中，限制切换设备
      logger?.e(
          'device binding, cannot switch device. old:$__macAddress this:$tmpMacAddress');
      return Future(() => false);
    }

    _isConnecting = true;
    _isConnected = true;
    _isFastSynchronizing = false;
    _macAddress = tmpMacAddress;
    _macAddressOriginal = macAddress;
    _uuid = uuid;
    logger
        ?.d('mark connected $__macAddress isBinded:$isBinded otaType:$otaType deviceName:$deviceName');
    storage?.resetCachePathOnDeviceChanged();
    _stopTimerFastSync();

    // 记录该设备
    final rs = await storage?.saveDeviceInfoExtToDisk(DeviceInfoExtModel(
        macAddress: __macAddress!,
        macAddressFull: macAddress,
        otaMode: otaMode,
        deviceName: deviceName ?? '',
        uuid: uuid ?? '',
        updateTime: DateTime.now().millisecondsSinceEpoch));
    logger?.d("saveDeviceInfoExtToDisk rs: $rs");

    // 加载缓存的设备扩展信息
    await deviceInfo.refreshDeviceExtInfo();

    // 加载缓存的设备信息
    await deviceInfo.refreshDeviceInfo(forced: false);

    // 加载缓存的三级版本
    await deviceInfo.refreshFirmwareVersion(forced: false);

    // 加载缓存的功能表
    await funTable.refreshFuncTable(forced: false);

    //storage?.setBool(key: deviceBind.keyIsBindState, value: isBinded);
    await storage?.saveBindStatus(isBinded);
    connectStatusChanged.add(__isConnected);
    // mode: 0 没有绑定, 1 已经绑定, 2 升级模式, 3 重连, 4 泰凌微
    if (otaMode) {
      // 设置c库绑定模式
      await _setBindMode(2);
      logger?.d('set mode: 2');
      // 协议库桥接蓝牙库初始化完成
      statusSdkNotification.add(IDOStatusNotification.protocolConnectCompleted);
      _isConnecting = false;
      return Future(() => true);
    } else {
      //final isBinded = await deviceBind.isBinded;
      final mode = isBinded ? 3 : 0;
      await _setBindMode(mode);
      logger?.d('set mode: $mode');
      if (!isBinded) {
        _isConnecting = false;
      }
      // 非ota模式时，发送连接指令
      await send(evt: CmdEvtType.connected).first;
      // 协议库桥接蓝牙库初始化完成
      statusSdkNotification.add(IDOStatusNotification.protocolConnectCompleted);
      return Future(() => true);
    }
  }

  /// 快速配置中不允许其他指令调用
  bool _canSend(int evt) {
    if (__isFastSynchronizing) {
      return {1, 2, 104, 110, 202, 204, 300, 301, 303, 341, 336, 352, 354, 506}
          .contains(evt);
    }
    return true;
  }

  /// 处理C库请求
  _cRequestHandle() {
    // evt_type 获取Mac地址 =>300 , 获取设备信息 => 301 ,
    // 获取功能表 => 303 , 获取BT连接状态 => 352 , 获取固件三级版本号 => 336 ,
    // 开启ancs => 506 , 设置授权码 => 202 , 设置时间 => 104 , 获取sn => 341, 获取Bt名称 => 354
    // 发送计算好的授权数据 => 204, 设置手机系统 => 110
    _coreMgr.cRequestCmd((evtType, error, val) {
      logger?.d('fast config:$evtType');
      switch (evtType) {
        case 104:
          _setDateTime();
          break;
        case 110:
          _setSystemVersion();
          break;
        case 202:
          _tryBindWithAuthData();
          break;
        case 204:
          _tryBindWithEncryptedData();
          break;
        case 300:
          _getMacAddress();
          break;
        case 301:
          _getDeviceInfo();
          break;
        case 303:
          dispose(); // 快速配置功能获取前，清空队列
          funTable.refreshFuncTable();
          break;
        case 341:
          deviceInfo.refreshDeviceSn();
          break;
        case 352:
          send(evt: CmdEvtType.getBtNotice).listen((event) {});
          break;
        case 354:
          deviceInfo.refreshDeviceBtName();
          break;
        case 336:
          deviceInfo.refreshFirmwareVersion();
          break;
        case 506:
          send(evt: CmdEvtType.openAncs).listen((event) {});
          break;
      }
    });
  }

  /// 快速配置完成回调
  _fastSyncComplete() {
    //logger?.d('快速配置完成回调 2');
    _subscriptFastSyncComplete?.cancel();
    _subscriptFastSyncComplete = _coreMgr.fastSyncComplete((errorCode) {
      logger?.d('快速配置完成回调 5 完成');
      logger?.d('fastSyncComplete errorCode:$errorCode');
      _isConnecting = false;
      _isFastSynchronizing = false;
      _stopTimerFastSync();
      final rs = errorCode == 0;
      if (!rs) {
        funTable.refreshFuncTable(); // 快速配置失败，重新获取一次功能表
        _getDeviceInfo(); // 快速配置失败，重新获取一次设备信息 (用于触发绑定状态判定）
      }
      // 汇顶平台特殊处理，添加获取mtu
      if (deviceInfo.platform == 40) {
        libManager.send(evt: CmdEvtType.getMtuInfo);
      }
      statusSdkNotification.add(rs
          ? IDOStatusNotification.fastSyncCompleted
          : IDOStatusNotification.fastSyncFailed);
    });
  }

  /// 监听设备状态
  _listenDeviceState() {
    _coreMgr.listenDeviceStateChanged((code) {
      logger?.d('listen device state: $code');
    });
  }

  /// 注册消息图标更新
  _registerMessageIcon() {
    _messageIcon.registerListenUpdate();
  }

  /// setMode变更监听
  _registerUpdateSetModeChanged() {
    // 监听绑定时触发的setMode调用
    deviceBind.listenUpdateSetModeNotification((mode) {
      _setBindMode(mode);
      if (mode == 1) {
        // 清除v3健康缓存数据
        final rs = _coreMgr.unBindClearV3HealthData();
        logger?.d("clear v3 health data rs: $rs");
      }
    });
  }

  /// 只监听设备响应数据
  _registerBleReceiveData() {
    _coreMgr.streamListenReceiveData.stream.listen((tuple) {
      int code = tuple.item1;
      int evt = tuple.item2;
      // 5106 - 算法原始数据采集 操作0x02为数据采集中
      if (evt == 5106 && code == 0) {
        final jsonStr = tuple.item3;
        try {
          final Map<String, dynamic> json = jsonDecode(jsonStr);
          // 0x01为开始采集,0x02为数据采集中,0x03为结束采集, 0x04为设置开关,0x05为查询开关
          if (json.containsKey("operate") && (json["operate"] as int) == 2 && json.containsKey("info_items")) {
            final errCode = json["error_code"] != null ? json["error_code"] as int : 0;
            if (errCode != 0) {
              logger?.e("算法原始数据采集 errCode: $errCode");
              return;
            }
            deviceRawDataReportStream.add(DeviceRawDataReportModel(1,  jsonEncode(json["info_items"])));
          }
        } catch (e, stacktrace) {
          logger?.e("算法原始数据采集 json 解析失败: $e\n$stacktrace");
        }
      }
    });
  }

  _registerBindStateChanged() {
      deviceBind.listenBindStateChangedNotification((p0) {
        sdkStateChanged.add(null);
      });
  }

  _registerAlexaReceive() {
    _coreMgr.listenAlexaReportVoiceLostData((sizeLostPkg, sizeAllPkg) {
      _alexaDelegate?.onAlexaReportVoiceLostData(sizeLostPkg, sizeAllPkg);
    });
    _coreMgr.listenAlexaReportVoiceOpusState((state) {
      _alexaDelegate?.onAlexaReportVoiceOpusState(state);
    });
    _coreMgr.listenAlexaReportVoicePcmData((data, len) {
      _alexaDelegate?.onAlexaReportVoicePcmData(data, len);
    });
  }

  _registerDeviceStatusChanged() {
    _coreMgr.listenControlEvent((tuple) {
      //logger?.v('设备通知: ${[tuple.item1, tuple.item2, tuple.item3]}');
      if (tuple.item2 == 577) {
        final json = tuple.item3;
        final map = jsonDecode(json) as Map<String, dynamic>;
        final dataType = map['data_type'] as int?;
        final notifyType = map['notify_type'] as int?;
        final msgID = map['msg_ID'] as int?;
        final msgNotice = map['msg_notice'] as int?;
        final errorIndex = map['error_index'] as int?;
        final model = IDODeviceNotificationModel(
            dataType: dataType,
            notifyType: notifyType,
            msgId: msgID,
            msgNotice: msgNotice,
            errorIndex: errorIndex);
        if (model.dataType == 55) {
          // 固件快速模式切换慢速模式
          logger?.d("固件快速模式切换慢速模式 type == $dataType");
        }else if (model.dataType == 56) {
          // 固件慢速模式切换快速模式
          logger?.d("固件慢速模式切换快速模式 type == $dataType");
        }else if (model.dataType == 59) {
          // 当前处于DFU模式(思澈平台)
          logger?.d("当前处于DFU模式(思澈平台) type == $dataType");
          _isSicheDfuMode = true;
        }
        statusDeviceNotification.add(model);
      } else if (_controlEventTypeSet.contains(tuple.item2)) {
        final model = IDODeviceNotificationModel(
            controlEvt: tuple.item2, controlJson: tuple.item3);
        statusDeviceNotification.add(model);
      } else {
        //logger?.v('listenControlEvent controlEvent ${tuple.item2} invalid');
      }
    });
  }

  /// 初如化log
  _initClibFilePath() async {
    final pathSDK = await LocalStorage.pathSDKStatic();

    // 添加c库日志保留天数据设置
    var saveDay = await storage?.loadLogConfigClib() ?? 2;
    saveDay = min(saveDay, 2); // 最小两天
    _coreMgr.setSaveLogDay(saveDay);
    logger?.v("clib log saveDay = $saveDay");

    // 初始化SDK存储文件路径
    final dirClib =
        Directory('$pathSDK/${_IDOProtocolLibManager._pathStorageC}');
    final pathClib = (await dirClib.create(recursive: true)).path;
    _coreMgr.setFilePath(filePath: pathClib);
  }

  /// 设置c库绑定模式 mode: 0 没有绑定, 1 已经绑定, 2 升级模式, 3 重连, 4 泰凌微
  _setBindMode(int mode) async {
    // 设置c库功能表位置（带mac地址）
    final aPath = await storage?.pathCLibFuncTable();
    if (aPath != null) {
      _coreMgr.setFunctionTableFilePath(filePath: aPath);
    } else {
      logger?.e('setFunctionTableFilePath failed');
    }

    if (mode == 1 || mode == 3) {
      _isFastSynchronizing = true;
      statusSdkNotification.add(IDOStatusNotification.fastSyncStarting);
      _startTimerFastSync();
    }
    _coreMgr.setBindMode(mode: mode);
  }

  /// 绑定处理 配对码
  Future<bool> _tryBindWithAuthData() async {
    final jsonStr = await storage?.loadBindAuthDataByDisk();
    logger?.d('load authCode: $jsonStr');
    if (jsonStr == null || jsonStr.isEmpty) {
      return Future(() => false);
    }

    return send(evt: CmdEvtType.setAuthCode, json: jsonStr).map((event) {
      if (event.code == 0 && event.json != null) {
        final map = jsonDecode(event.json!);
        final authCode = map['auth_code'] as int;
        // 状态（0x00:成功 ，0x01：失败, 0x02:绑定码丢失失败）
        if (authCode == 2) {
          storage?.cleanBindAuthData(); // 清除缓存数据
          statusSdkNotification.add(IDOStatusNotification.unbindOnAuthCodeError);
        }
        return authCode == 0;
      }
      return false;
    }).first;
  }

  /// 绑定处理 授权码
  Future<bool> _tryBindWithEncryptedData() async {
    final jsonStr = await storage?.loadBindEncryptedDataByDisk();
    logger?.d('load EncryptedData: $jsonStr');
    if (jsonStr == null || jsonStr.isEmpty) {
      return Future(() => false);
    }
    return send(evt: CmdEvtType.setEncryptedAuth, json: jsonStr).map((event) {
      if (event.code == 0 && event.json != null) {
        final map = jsonDecode(event.json!);
        final authCode = map['auth_code'] as int;
        //授权结果 0 成功 , 非0失败； 1:是手表点击拒绝； 2:密码校验失败，3：已经绑定
        if (authCode == 2) {
          storage?.cleanBindEncryptedData(); // 清除缓存数据
          statusSdkNotification.add(IDOStatusNotification.unbindOnAuthCodeError);
        }
        return authCode == 0 || authCode == 3;
      }
      return false;
    }).first;
  }

  /// 设置时间
  void _setDateTime() {
    send(evt: CmdEvtType.setTime).listen((event) { });
  }

  void _getMacAddress() {
    send(evt: CmdEvtType.getMac).listen((event) {
      if (event.isOK && event.json != null) {
        final map = jsonDecode(event.json!);
        final btAddr = map['bt_addr'];
        final macAddr = map['mac_addr'];
        if (btAddr != null && btAddr is List) {
          String strAddr =
              btAddr.map((e) => e.toRadixString(16).padLeft(2, '0')).join(':');
          logger?.d('get bt macAddress：${strAddr.toUpperCase()}');
          deviceInfo.setDeviceBtMacAddress(strAddr.toUpperCase());
          statusSdkNotification.add(IDOStatusNotification.deviceInfoBtAddressUpdateCompleted);
        }

        if (macAddr != null && macAddr is List) {
          String strAddr =
              macAddr.map((e) => e.toRadixString(16).padLeft(2, '0')).join('');
          strAddr = strAddr.toUpperCase();
          logger?.d('get macAddress：$strAddr');
          if (strAddr.isNotEmpty && strAddr != __macAddress) {
            logger?.e('macAddress error $strAddr $__macAddress');
            // 和当前连接设备mac地址不相同，上报此通知
            statusSdkNotification.add(IDOStatusNotification.macAddressError);
          }
        }
      }
    });
  }

  /// 获取mac地址（无约束的）
  Future<String?> _requestMacAddress() async {
    // final rs = await send(evt: CmdEvtType.getMac).first;
    const evtType = CmdEvtType.getMac;
    final rs = await _coreMgr
        .writeJson(
            evtBase: evtType.evtBase,
            evtType: evtType.evtType,
            json: '{}',
            useQueue: true,
            cmdPriority: CmdPriority.normal,
            cmdMap: evtType._cmdInfo())
        .value;
    if (rs.isOK && rs.json != null) {
      final map = jsonDecode(rs.json!);
      final macAddr = map['mac_addr'];
      if (macAddr != null && macAddr is List) {
        String strAddr =
            macAddr.map((e) => e.toRadixString(16).padLeft(2, '0')).join(':');
        strAddr = strAddr.toUpperCase();
        logger?.d('get macAddress：$strAddr');
        return strAddr.isNotEmpty ? strAddr : null;
      }
    }
    return null;
  }

  void _getDeviceInfo() async {
    final devInfo = await deviceInfo.refreshDeviceInfo();
    //final isBindByCache = await deviceBind.isBinded;
    // 设备未绑定时，通知业务层解绑设备
    if (devInfo != null && devInfo.bindState == 0) {
      stopSyncConfig(); // 停止同步
      dispose(); // 清除队列
      logger?.d('bind state - not match, notify to unbind~');
      statusSdkNotification.add(IDOStatusNotification.unbindOnBindStateError);
    } else {
      logger?.d(
          'bind state - ${devInfo == null ? 'devInfo = null' : devInfo.bindState}');
    }
  }

  void _setSystemVersion() async {
    final param = <String, dynamic>{
      "system": Platform.isIOS ? 1 : 2
    };
    // 恒玄平台处理user_id
    if (libManager.deviceInfo.isPersimwearPlatform()) {
      final userId = delegate?.getUserId();
      if (userId != null && userId != '-1') {
        final newUid = userId.length > 14 ? userId.substring(userId.length - 14) : userId;
        param['user_id'] = newUid;
        final rs = await send(evt: CmdEvtType.setAppOS, json: jsonEncode(param)).first;
        // 0:成功/一致；1:失败；2:失败，账户不一致；3:失败，无账户
        if (rs.code == 0 && rs.json != null) {
          final errCode = jsonDecode(rs.json!)["error_code"] as int;
          if (errCode == 2) {
            stopSyncConfig(); // 停止同步
            dispose(); // 清除队列
            logger?.d('fast config - account not match, stop.');
            markDisconnectedDevice(); // 断开连接
            _isConnecting = false;
            _isFastSynchronizing = false;
            _stopTimerFastSync();
            statusSdkNotification.add(IDOStatusNotification.accountNotMatch);
          }else if(errCode == 0){
            statusSdkNotification.add(IDOStatusNotification.accountMatched);
          }else if(errCode == 1){
            statusSdkNotification.add(IDOStatusNotification.accountFailed);
          }else if(errCode == 3){
            statusSdkNotification.add(IDOStatusNotification.accountNil);
          }
        }
        return;
      }else {
        logger?.d('fast config - user_id is $userId');
      }
    }
    await send(evt: CmdEvtType.setAppOS, json: jsonEncode(param)).first;
  }

  /// 启用快速配置执行倒计时 ，指定时间内无响应将重置同步状态
  void _startTimerFastSync() {
    //logger?.v('call _startTimerFastSync');
    _timerFastSync?.cancel();
    _timerFastSync = Timer(Duration(seconds: _timerFastSyncDuration), () {
      if (__isFastSynchronizing) {
        _isFastSynchronizing = false;
        // statusNotification?.add(IDOStatusNotification.fastSyncTimeout); // 快速配置执行超时 （容易对业务层造成困惑，去掉）
        statusSdkNotification.add(IDOStatusNotification.fastSyncFailed); // 上报失败
        logger?.v('fastSyncTimeout');
      }
      logger?.v('call _startTimerFastSync reset _isFastSynchronizing');
    });
  }

  void _stopTimerFastSync() {
    //logger?.v('call _stopTimerFastSync');
    _timerFastSync?.cancel();
    _timerFastSync = null;
  }
}

extension _IDOProtocolLibManagerInterceptor on _IDOProtocolLibManager {

  /// 拦截器处理
  String? _cmdParamsInterceptor(int evtType, String? jsonString) {
    if (evtType == 104 && (jsonString == null || jsonString.isEmpty || jsonString.trim().length <= 2)) {
      // 设置时间不传参数时，使用默认时间
      return _defaultDatetime();
    } else if (evtType == 5044) {
      // 常用联系人参数特殊符号处理
      return _emojiToUtf8(jsonString);
    } else if (evtType == CmdEvtType.replyDeviceStartCameraPreviewRequest.evtType) {
      _isPreviewingCamera = true;
    } else if (evtType == CmdEvtType.replyDeviceStopCameraPreviewRequest.evtType) {
      _isPreviewingCamera = false;
    }
    return jsonString;
  }

  /// 时间设置统一处理，当不传参数时，使用默认值
  String _defaultDatetime() {
    final date = DateTime.now();
    var timeZone = date.timeZoneOffset.inMinutes / 60;
    if (timeZone < 0) {
      timeZone = timeZone.abs() + 12;
    }
    if (IDOFunctionTable().setTimeZoneFloat) {
      /// 时区扩大100倍
      timeZone = timeZone * 100;
    }else {
      timeZone = date.timeZoneOffset.inHours * 1.0;
    }
    final jsonObj = {
      'year': date.year,
      'monuth': date.month,
      'day': date.day,
      'hour': date.hour,
      'minute': date.minute,
      'second': date.second,
      'week': date.weekday - 1,
      'time_zone': timeZone.toInt(),
    };
    return jsonEncode(jsonObj);
  }

  /// 表情符号相关转utf8
  String? _emojiToUtf8(String? jsonString) {
    if (jsonString == null || jsonString.length == 2) {
      return jsonString;
    }
    logger?.v('before常用联系人:$jsonString');
    // 常用联系人
    Map<String, dynamic> data = jsonDecode(jsonString);
    for (var item in data['items']) {
      var name = item['name'] as String?;
      if (name != null) {
        //item['name'] = _escapeString(name);
        item['name'] = name.replaceAll(r"\\u", "").replaceAll(r"\u", "");
      }
    }
    String resultJson = jsonEncode(data);
    logger?.v('end常用联系人:$jsonString');
    return resultJson;
  }


  // 字符串转unicode编码
  String _escapeString(String input) {
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      int codeUnit = input.codeUnitAt(i);
      if (codeUnit >= 32 && codeUnit <= 126) {
        // 可打印的 ASCII 字符，直接添加到结果中
        buffer.writeCharCode(codeUnit);
      } else {
        // 其他字符，转义为 \u{XXXX} 形式
        buffer.write("\\u${codeUnit.toRadixString(16).padLeft(4, '0').toUpperCase()}");
      }
    }
    return buffer.toString();
  }

}

extension _IDOCmdPriorityExt on IDOCmdPriority {
  CmdPriority get cmdPriority {
    switch (this) {
      case IDOCmdPriority.veryHigh:
        return CmdPriority.veryHigh;
      case IDOCmdPriority.high:
        return CmdPriority.high;
      case IDOCmdPriority.normal:
        return CmdPriority.normal;
      case IDOCmdPriority.low:
        return CmdPriority.low;
    }
  }
}