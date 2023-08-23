part of '../ido_protocol_lib.dart';

class _IDOProtocolLibManager
    implements IDOProtocolLibManager, LocalStorageConfig {
  static const _pathStorageC = 'c_files';
  static const _pathStorageLib = 'protocol_lib';
  static const _pathStorageLog = 'logs';
  static const _sdkVersion = '4.0.0';

  late final _coreMgr = IDOProtocolCoreManager();
  late final _messageIcon = IDOMessageIcon();
  late final _tools = IDOTool();
  late final _callNotice = IDOCallNotice();
  late final _cache = IDOCache();

  late final _alexaOpt = AlexaOperator();
  AlexaDelegate? _alexaDelegate;

  bool _isInitClib = false;
  String _clibVersion = 'unknown';
  StreamSubscription<int>? _subscriptFastSyncComplete;
  late IDOOtaType _otaType = IDOOtaType.none;
  late bool _isConnected = false;
  late bool _isConnecting = false;
  late bool _isFastSynchronizing = false;
  // 由于目前快速配置存在下发 setMode后不上报问题，此处添加容错机制
  Timer? _timerFastSync;
  // x秒后重置 _isFastSynchronizing 为 false
  final int _timerFastSyncDuration = 16; //快速配置等待最长时间 单位 秒
  String? _macAddress; // SDK内统一为去除冒号后的转大写字符串
  String? _uuid; // ios专用

  _initClib() async {
    logger?.d('begin _initClib hasCode:$hashCode');
    statusNotification = PublishSubject<IDOStatusNotification>();
    await _initClibFilePath();
    await _coreMgr.initClib();
    _cRequestHandle();
    _fastSyncComplete();
    _listenDeviceState();
    _registerMessageIcon();
    _registerAlexaReceive();
    _registerUpdateSetModeChanged();
    storage = LocalStorage.config(config: this);
    // 非debug模式，强制开启log写文件
    if (!kDebugMode) {
      await IDOProtocolLibManager.initLog();
    }
    // // 设置c库运行模式
    // setClibRunMode(isDebug: kDebugMode);
    _isInitClib = true;
    _clibVersion = _coreMgr.getClibVersion() ?? 'unknown';
    logger?.d('end _initClib hasCode:$hashCode');
    logger?.v('clib version: $_clibVersion  sdk ver:$_sdkVersion os:${Platform.isIOS ? "iOS" : "Android"}');
  }

  _IDOProtocolLibManager._internal();
  static final _instance = _IDOProtocolLibManager._internal();
  factory _IDOProtocolLibManager() => _instance;

  /// 数据交换相关指令(不需要响应)
  late final _exchangeExcludeCmd = {
    CmdEvtType.exchangeAppBleStartReply,
    CmdEvtType.exchangeAppBleEndReply,
    CmdEvtType.exchangeAppBlePauseReply,
    CmdEvtType.exchangeAppBleRestoreReply,
    CmdEvtType.exchangeAppBleIngReply,
    CmdEvtType.exchangeAppBlePlan,
    CmdEvtType.exchangeAppStartBlePauseReply,
    CmdEvtType.exchangeAppStartBleRestoreReply,
    CmdEvtType.exchangeAppStartBleEndReply,
  };

  /// 数据交换相关指令(需要响应，拥有较高优先级)
  late final _exchangeCmd = {
    CmdEvtType.exchangeAppStart,
    CmdEvtType.exchangeAppEnd,
    CmdEvtType.exchangeAppRestore,
    CmdEvtType.exchangeAppPause,
    CmdEvtType.exchangeAppV2Ing,
    CmdEvtType.exchangeAppV3Ing,
    CmdEvtType.exchangeAppPlan,
    CmdEvtType.exchangeAppGetV3HrData,
    CmdEvtType.exchangeAppGetActivityData,
  };

  /// 处理不需要响应的指令
  late final _excludeCmd = {
    CmdEvtType.connected,
    CmdEvtType.disconnect,
    CmdEvtType.alexaVoiceBleGetPhoneLoginState,
  }..addAll(_exchangeExcludeCmd);

  // 有效的通知事件
  late final _controlEventTypeSet = {551}
    ..addAll({552, 553, 554, 555, 556, 557, 558, 559})
    ..addAll({560, 561, 562, 563, 565, 570, 571, 581})
    ..addAll({572, 574, 575, 576, 578, 579, 580, 591});

  @override
  String get macAddress => _macAddress ?? 'UNKNOWN';

  @override
  Future<bool> initClib() async {
    print('!!!!!!!!!!!!!!!!initClib _isInitClib: $_isInitClib');
    if (!_isInitClib) {
      await _initClib();
    }
    return true;
  }

  @override
  void setClibRunMode({required bool isDebug}) {
    logger?.v('setClibRunMode isDebug:$isDebug');
    _coreMgr.setRunMode(isDebug ? 0 : 1);
  }

  @override
  Future<bool> markConnectedDevice(
      {required String macAddress,
      required IDOOtaType otaType,
      required bool isBinded,
      String? deviceName = '',
      String? uuid = ''}) async {
    assert(_isInitClib, 'has call await libManager.initClib() in main.dart');
    assert(macAddress.isNotEmpty, 'macAddress cannot be empty');
    if (macAddress.isEmpty) {
      logger?.e('macAddress cannot be empty');
      return Future(() => false);
    }
    final tmpMacAddress = macAddress.replaceAll(':', '').toUpperCase();
    if (_isConnected && _macAddress == tmpMacAddress) {
      logger?.d(
          'ignore mark connected $_macAddress isBinded:$isBinded otaType:$otaType');
      return Future(() => true);
    }

    // 泰凌微设备OTA 特殊处理
    if (otaType == IDOOtaType.telink) {
      _otaType = otaType;
      _isConnecting = true;
      _isConnected = true;
      _isFastSynchronizing = false;
      _macAddress = tmpMacAddress;
      _uuid = uuid;
      logger?.d(
          'mark connected $_macAddress isBinded:$isBinded otaType:$otaType');
      _stopTimerFastSync();

      // 设置c库绑定模式
      await _setBindMode(4);
      logger?.d('set mode: 4');
      // 非ota模式时，发送连接指令
      await send(evt: CmdEvtType.connected).first;
      // 协议库桥接蓝牙库初始化完成
      statusNotification?.add(IDOStatusNotification.protocolConnectCompleted);
      return Future(() => true);
    }

    final otaMode = otaType == IDOOtaType.nordic;
    if (_isConnected && _macAddress != tmpMacAddress) {
      // 因目前同时只允许连接一台设备，此处主动标记上个设备断开连接
      logger?.d('inner call mark disconnected $_macAddress isBinded:$isBinded');
      await markDisconnectedDevice();
    }

    _otaType = otaType;
    if (_isConnecting) {
      // 设备连接中，限制切换设备
      logger?.e(
          'device connecting, cannot switch device. old:$_macAddress this:$tmpMacAddress');
      return Future(() => false);
    }

    if (deviceBind.isBinding) {
      // 设备绑定中，限制切换设备
      logger?.e(
          'device binding, cannot switch device. old:$_macAddress this:$tmpMacAddress');
      return Future(() => false);
    }

    _isConnecting = true;
    _isConnected = true;
    _isFastSynchronizing = false;
    _macAddress = tmpMacAddress;
    _uuid = uuid;
    logger
        ?.d('mark connected $_macAddress isBinded:$isBinded otaType:$otaType');
    _stopTimerFastSync();

    // 记录该设备
    await storage?.saveDeviceInfoExtToDisk(DeviceInfoExtModel(
        macAddress: _macAddress!,
        macAddressFull: macAddress,
        otaMode: otaMode,
        deviceName: deviceName ?? '',
        uuid: uuid ?? '',
        updateTime: DateTime.now().millisecondsSinceEpoch));

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
    // mode: 0 没有绑定, 1 已经绑定, 2 升级模式, 3 重连, 4 泰凌微
    if (otaMode) {
      // 设置c库绑定模式
      await _setBindMode(2);
      logger?.d('set mode: 2');
      // 协议库桥接蓝牙库初始化完成
      statusNotification?.add(IDOStatusNotification.protocolConnectCompleted);
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
      statusNotification?.add(IDOStatusNotification.protocolConnectCompleted);
      return Future(() => true);
    }
  }

  @override
  Future<bool> markConnectedDeviceSafe(
      {required String uniqueId,
      required IDOOtaType otaType,
      required bool isBinded,
      String? deviceName = ''}) async {
    assert(uniqueId.isNotEmpty, 'macAddress cannot be empty');
    // iOS平台且传入的uniqueId为uuid时，添加获取mac地址流程
    if (Platform.isIOS && uniqueId.length > 17) {
      logger?.d('call markConnectedDeviceSafe, uniqueId:$uniqueId');
      // dispose();
      final macAddr = await _requestMacAddress();
      if (macAddr != null) {
        return markConnectedDevice(
            macAddress: macAddr,
            otaType: otaType,
            isBinded: isBinded,
            deviceName: deviceName);
      }
      logger?.e('_requestMacAddress fail, macStr: $macAddr');
      return false;
    }

    // 其它情况走原逻辑
    return markConnectedDevice(
        macAddress: uniqueId,
        otaType: otaType,
        isBinded: isBinded,
        deviceName: deviceName);
  }

  @override
  Future<bool> markDisconnectedDevice(
      {String? macAddress, String? uuid}) async {
    // 忽略非必要调用
    if (!_isConnected && _macAddress == null) {
      logger?.d(
          'ignore mark disconnected $macAddress _isConnected:$_isConnected _macAddress:$_macAddress');
      return Future(() => true);
    }

    // 非当前设备不执行断开操作
    if (macAddress != null) {
      final tmpMacAddress = macAddress.replaceAll(':', '').toUpperCase();
      if (tmpMacAddress != _macAddress) {
        logger?.d(
            'not the current device, do not perform disconnection macAddress:$tmpMacAddress');
        return Future(() => false);
      }
    } else if (Platform.isIOS && uuid != null) {
      if (uuid != _uuid) {
        logger?.d(
            'not the current device, do not perform disconnection uuid:$uuid');
        return Future(() => false);
      }
    }

    logger?.d('mark disconnected macAddress:$macAddress uuid:$uuid');
    _isConnected = false;
    _isConnecting = false;
    _isFastSynchronizing = false;
    _macAddress = null;
    _uuid = null;
    _otaType = IDOOtaType.none;

    _stopTimerFastSync();
    _coreMgr.dispose();
    _coreMgr.cleanProtocolQueue();
    _coreMgr.stopSyncConfig(); // 停止快速配置

    deviceInfo.cleanDataOnMemory();
    funTable.cleanDataOnMemory();

    // 断开连接
    await send(evt: CmdEvtType.disconnect).first;

    return Future(() => true);
  }

  @override
  Stream<CmdResponse> send({required CmdEvtType evt, String? json = '{}'}) {
    assert(_isInitClib, 'has call await libManager.initClib() in main.dart');
    if (json == null || json.isEmpty || json.trim().isEmpty) {
      json = '{}';
    }

    if (!_isConnected &&
        !{CmdEvtType.connected, CmdEvtType.disconnect}.contains(evt)) {
      logger?.v('no connected device，evtType:${evt.evtType} ignore');
      return Future(() => CmdResponse(
          code: ErrorCode.no_connected_device,
          evtType: evt.evtType)).asStream();
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

    final priority =
        _exchangeCmd.contains(evt) ? CmdPriority.high : CmdPriority.normal;

    return _coreMgr
        .writeJson(
            evtBase: evt.evtBase,
            evtType: evt.evtType,
            json: json,
            useQueue: useQueue,
            cmdPriority: priority)
        .asStream();
  }

  @override
  StreamSubscription listenStatusNotification(
      void Function(IDOStatusNotification status) func) {
    assert(_isInitClib, 'has call await libManager.initClib() in main.dart');
    return statusNotification!.listen(func);
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
  bool get isConnected => _isConnected;

  @override
  bool get isConnecting => _isConnecting;

  @override
  IDOOtaType get otaType => _otaType;

  @override
  bool get isBinding => deviceBind.isBinding;

  @override
  bool get isFastSynchronizing => _isFastSynchronizing;

  @override
  IDODeviceLog get deviceLog => IDODeviceLog();

  @override
  void receiveDataFromBle(Uint8List data, String? macAddress, int type) {
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
    return _coreMgr.listenControlEvent((tuple) {
      //logger?.v('listenControlEvent ${[tuple.item1, tuple.item2]}'); // 多个监听 会打印多次
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
        func(model);
      } else if (_controlEventTypeSet.contains(tuple.item2)) {
        logger?.v(
            'listenControlEvent ${[tuple.item1, tuple.item2, tuple.item3]}');
        final model = IDODeviceNotificationModel(
            controlEvt: tuple.item2, controlJson: tuple.item3);
        func(model);
      } else {
        //logger?.v('listenControlEvent controlEvent ${tuple.item2} invalid');
      }
    });
  }

  static Future<bool> initLog(
      {bool writeToFile = true,
      bool outputToConsole = true,
      LoggerLevel logLevel = LoggerLevel.verbose}) async {
    if (!kDebugMode) {
      // release模式下日志由sdk内部控制
      logLevel = LoggerLevel.verbose;
    }
    String dirPath = '';
    if (writeToFile || outputToConsole) {
      final pathSDK = await LocalStorage.pathSDKStatic();
      dirPath = '$pathSDK/$_pathStorageLog';
      final config = LoggerConfig(
          dirPath: '$dirPath/$_pathStorageLib',
          writeToFile: writeToFile,
          outputToConsole: outputToConsole,
          maximumFileSize: 5 * 1024 * 1024,
          maximumNumberOfLogFiles: 5,
          level: logLevel);
      LoggerSingle.configLogger(config: config);
      // logger = LoggerManager(config: config);
      // IDOProtocolCoreManager.setLogger(logger);
      IDOProtocolCoreManager().initLogs();
      logger = LoggerSingle();
    } else {
      logger = null;
      // IDOProtocolCoreManager.setLogger(logger);
    }

    return Future(() => true);
  }

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
}

extension _IDOProtocolLibManagerExt on _IDOProtocolLibManager {
  /// 快速配置中不允许其他指令调用
  bool _canSend(int evt) {
    if (_isFastSynchronizing) {
      return {1, 2, 104, 202, 204, 300, 301, 303, 336, 352, 506}.contains(evt);
    }
    return true;
  }

  /// 处理C库请求
  _cRequestHandle() {
    // evt_type 获取Mac地址 =>300 , 获取设备信息 => 301 ,
    // 获取功能表 => 303 , 获取BT连接状态 => 352 , 获取固件三级版本号 => 336 ,
    // 开启ancs => 506 , 设置授权码 => 202 , 设置时间 => 104
    // 发送计算好的授权数据 => 204
    _coreMgr.cRequestCmd((evtType, error, val) {
      logger?.d('fast config:$evtType');
      switch (evtType) {
        case 104:
          _setDateTime();
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
        case 352:
          send(evt: CmdEvtType.getBtNotice).listen((event) {});
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
    logger?.d('快速配置完成回调 2');
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
      }
      statusNotification?.add(rs
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
    _messageIcon.ios_registerListenUpdate();
  }

  /// setMode变更监听
  _registerUpdateSetModeChanged() {
    // 监听绑定时触发的setMode调用
    deviceBind.listenUpdateSetModeNotification((mode) {
      _setBindMode(mode);
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

  /// 初如化log
  _initClibFilePath() async {
    final pathSDK = await LocalStorage.pathSDKStatic();
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

    if (mode == 1 || mode == 2 || mode == 3) {
      _isFastSynchronizing = true;
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
          statusNotification?.add(IDOStatusNotification.unbindOnAuthCodeError);
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
          statusNotification?.add(IDOStatusNotification.unbindOnAuthCodeError);
        }
        return authCode == 0 || authCode == 3;
      }
      return false;
    }).first;
  }

  /// 设置时间
  void _setDateTime() {
    final date = DateTime.now();
    var timeZone = date.timeZoneOffset.inHours;
    if (IDOFunctionTable().setTimeZoneFloat) {
      /// 时区扩大100倍
      timeZone = timeZone * 100;
    }
    final jsonObj = {
      'year': date.year,
      'monuth': date.month,
      'day': date.day,
      'hour': date.hour,
      'minute': date.minute,
      'second': date.second,
      'week': date.weekday,
      'time_zone': timeZone,
    };
    send(evt: CmdEvtType.setTime, json: jsonEncode(jsonObj)).listen((event) {
      //logger?.d('设置时间： ');
    });
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
          statusNotification
              ?.add(IDOStatusNotification.deviceInfoBtAddressUpdateCompleted);
        }

        if (macAddr != null && macAddr is List) {
          String strAddr =
              macAddr.map((e) => e.toRadixString(16).padLeft(2, '0')).join('');
          strAddr = strAddr.toUpperCase();
          logger?.d('get macAddress：$strAddr');
          if (strAddr.isNotEmpty && strAddr != _macAddress) {
            logger?.e('macAddress error $strAddr $_macAddress');
            // 和当前连接设备mac地址不相同，上报此通知
            statusNotification?.add(IDOStatusNotification.macAddressError);
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
            cmdPriority: CmdPriority.normal)
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
      statusNotification?.add(IDOStatusNotification.unbindOnBindStateError);
    } else {
      logger?.d(
          'bind state - ${devInfo == null ? 'devInfo = null' : devInfo.bindState}');
    }
  }

  /// 启用快速配置执行倒计时 ，指定时间内无响应将重置同步状态
  void _startTimerFastSync() {
    //logger?.v('call _startTimerFastSync');
    _timerFastSync?.cancel();
    _timerFastSync = Timer(Duration(seconds: _timerFastSyncDuration), () {
      if (_isFastSynchronizing) {
        _isFastSynchronizing = false;
        // statusNotification?.add(IDOStatusNotification.fastSyncTimeout); // 快速配置执行超时 （容易对业务层造成困惑，去掉）
        statusNotification?.add(IDOStatusNotification.fastSyncFailed); // 上报失败
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
