part of '../ido_device_bind.dart';

/// 绑定状态
enum BindStatus {
  /// 绑定失败
  failed,

  /// 绑定成功
  successful,

  /// 已经绑定
  binded,

  /// 需要授权码绑定
  needAuth,

  /// 拒绝绑定
  refusedBind,

  /// 绑定错误设备
  wrongDevice,

  /// 授权码校验失败
  authCodeCheckFailed,

  /// 取消绑定
  canceled,

  /// 绑定失败（获取功能表失败)
  failedOnGetFunctionTable,

  /// 绑定失败（获取设备信息失败)
  failedOnGetDeviceInfo,
}

class _IDODeviceBind implements IDODeviceBind {
  _IDODeviceBind._internal() {
    _loadAuthMode();
    _loadBindState();
  }
  static final _instance = _IDODeviceBind._internal();
  factory _IDODeviceBind() => _instance;

  late final _libMgr = IDOProtocolLibManager();
  late final _coreMgr = IDOProtocolCoreManager();
  Completer<BindStatus>? _completerBind;
  late final _updateSetModeNotification = PublishSubject<int>();

  BindValueCallback<IDODeviceInfo>? funDeviceInfo;
  BindValueCallback<IDOFunctionTable>? funFunctionTable;

  /// 授权模式（0 未知，1 授权码，2 配对码)
  var _authMode = 0;

  /// 绑定状态
  bool? _isBinded;
  bool _isBinding = false;

  @override
  Future<bool> get isBinded async {
    return await _loadBindState();
  }

  @override
  bool get isBinding => _isBinding;

  @override
  Stream<bool> setAuthCode(String code, int osVersion) {
    if (!IDOProtocolLibManager().isConnected) {
      throw UnsupportedError('Unconnected calls are not supported');
    }

    // 根据功能表判定是否支持
    if (!_libMgr.funTable.getBindCodeAuth) {
      // throw UnsupportedError('Unconnected calls are not supported');
      logger?.d("Do not support BindCodeAuth");
      return Stream.value(false);
    }

    //logger?.d('绑定 - 配对码校验');
    final codeList = code.split('').cast<int>();
    final json = {
      'is_clean_data': 1,
      'os_type': Platform.isIOS ? 1 : 2,
      'os_version': osVersion,
      'bind_version': 1,
      'auth_code': codeList,
      'auth_length': codeList.length
    };
    final jsonStr = jsonEncode(json);
    return _libMgr
        .send(evt: CmdEvtType.setAuthCode, json: jsonEncode(json))
        .asyncMap((event) async {
      if (event.code == 0 && event.json != null) {
        final map = jsonDecode(event.json!);
        final authCode = map['auth_code'] as int;
        // 状态（0x00:成功 ，0x01：失败, 0x02:绑定码丢失失败）
        if (authCode == 2) {
          storage?.cleanBindAuthData(); // 清除缓存数据
        } else if (authCode == 0) {
          await storage?.saveBindAuthDataToDisk(jsonStr); // 缓存配对码数据
          _authMode = 2;
          await _saveAuthMode();
        }
        return authCode == 0;
      }
      return false;
    });
  }

  @override
  Stream<BindStatus> startBind(
      {required int osVersion,
      required BindValueCallback<IDODeviceInfo> deviceInfo,
      required BindValueCallback<IDOFunctionTable> functionTable}) {
    if (!IDOProtocolLibManager().isConnected) {
      _isBinding = false;
      //throw UnsupportedError('Unconnected calls are not supported');
      logger?.e('bind - Unconnected calls are not supported');
      return Stream.value(BindStatus.failed);
    }
    _isBinding = true;
    funDeviceInfo = deviceInfo;
    funFunctionTable = functionTable;
    _completerBind = Completer();
    CancelableOperation.fromFuture(_bindExec(osVersion), onCancel: () {
      _isBinding = false;
      if (_completerBind != null && !_completerBind!.isCompleted) {
        logger?.d('bind - BindStatus.canceled');
        _completerBind?.complete(BindStatus.canceled);
      } else {
        logger?.d('bind - BindStatus.canceled _completer is null');
      }
    });
    return _completerBind!.future.asStream();
  }

  @override
  Future<bool> unbind(
      {required String macAddress, bool isForceRemove = false}) async {
    final macAddr = macAddress.replaceAll(':', '').toUpperCase();
    // 离线设备
    if (macAddr != _libMgr.macAddress || !IDOProtocolLibManager().isConnected) {
      logger?.d(
          'unbind offline macAddr:$macAddr libManager.macAddr:${_libMgr.macAddress}');
      // 解绑非当前设备
      await storage?.cleanAuthMode(macAddr);
      await storage?.cleanBindStatus(macAddress: macAddr);
      return true;
    }

    logger?.d(
        'unbind online macAddr:$macAddr libManager.macAddr:${_libMgr.macAddress} forceRemove:$isForceRemove');
    // 清除指令队列 和 快速配置
    _libMgr.dispose();
    _libMgr.stopSyncConfig();

    final res = await _libMgr.send(evt: CmdEvtType.setBindRemove).first;
    final rs = res.isOK || isForceRemove;

    if (rs) {
      try {
        _isBinded = false;
        // await _saveBindState();
        await _cleanAuthData();
        await storage?.cleanAuthMode(macAddr);
        await storage?.cleanBindStatus(macAddress: macAddr);
        //_coreMgr.setBindMode(mode: 0);
      } catch (e) {
        logger?.e('unbind online error：$e');
      }
    }
    logger?.v('unbind online rs:${res.isOK}');
    return rs;
  }

  @override
  StreamSubscription listenUpdateSetModeNotification(
      void Function(int mode) func) {
    return _updateSetModeNotification.listen(func);
  }
}

extension _IDODeviceBindExt on _IDODeviceBind {
  Future<BindStatus> _bindExec(int osVersion) async {
    // 清除指令队列 和 快速配置
    _libMgr.dispose();
    _coreMgr.stopSyncConfig();

    await _loadAuthMode();
    await _loadBindState();

    logger?.d('bind - get device info');
    // 获取设备信息
    final deviceInfo = await _libMgr.deviceInfo.refreshDeviceInfoBeforeBind();
    if (funDeviceInfo != null) {
      if (deviceInfo != null) {
        funDeviceInfo!(deviceInfo);
      } else {
        _isBinding = false;
        if (_completerBind != null && !_completerBind!.isCompleted) {
          logger?.d('bind - failedOnGetDeviceInfo');
          _completerBind?.complete(BindStatus.failedOnGetDeviceInfo);
        } else {
          logger?.d('bind - failedOnGetDeviceInfo completer is null');
        }
        return _completerBind!.future;
      }
    }

    // 获取功能表
    if (funFunctionTable != null) {
      logger?.d('bind - get function table');
      final functionTable = await _libMgr.funTable.refreshFuncTable();
      if (functionTable != null) {
        funFunctionTable!(functionTable);
      } else {
        _isBinding = false;
        if (_completerBind != null && !_completerBind!.isCompleted) {
          logger?.d('bind - failedOnGetFunctionTable');
          _completerBind?.complete(BindStatus.failedOnGetFunctionTable);
        } else {
          logger?.d('bind - failedOnGetFunctionTable completer is null');
        }
        return _completerBind!.future;
      }
    }

    if (_isBinded!) {
      if (await _tryBindWithCache()) {
        _markBindStateToClib(true);
        _isBinding = false;
        if (_completerBind != null && !_completerBind!.isCompleted) {
          logger?.d('bind - BindStatus.successful');
          _completerBind?.complete(BindStatus.successful);
        } else {
          logger?.d('bind - BindStatus.successful completer is null');
        }
        return _completerBind!.future;
      } else {
        logger?.d('bind - _tryBindWithCache false');
      }
    }

    //logger?.d('绑定 - 发送绑定请求');
    final json = <String, dynamic>{
      'is_clean_data': 1,
      'os_type': Platform.isIOS ? 1 : 2,
      'os_version': osVersion,
      'bind_version': 1
    };
    final rs = await _libMgr
        .send(evt: CmdEvtType.setBindStart, json: jsonEncode(json))
        .first;
    if (rs.code == 0 && rs.json != null) {
      final map = jsonDecode(rs.json!);
      final bindCode = map['bind_ret_code'] as int;
      final authLength = map['auth_length'] as int;
      // bindCode 0表示成功,1表示失败,2表示已经绑定
      if (bindCode == 0) {
        _checkAuthIfNeed(authLength, map);
      } else if (bindCode == 2) {
        _markBindStateToClib(true);
        _isBinding = false;
        if (_completerBind != null && !_completerBind!.isCompleted) {
          logger?.d('bind - BindStatus.binded 263');
          _completerBind?.complete(BindStatus.binded);
        } else {
          logger?.d('bind - BindStatus.binded 263 _completer is null');
        }
      } else {
        _isBinding = false;
        if (_completerBind != null && !_completerBind!.isCompleted) {
          logger?.d('bind - BindStatus.failed 268');
          _completerBind?.complete(BindStatus.failed);
        } else {
          logger?.d('bind - BindStatus.failed 268 completer is null');
        }
      }
    } else {
      _isBinding = false;
      if (_completerBind != null && !_completerBind!.isCompleted) {
        logger?.d('bind - BindStatus.failed 274');
        _completerBind?.complete(BindStatus.failed);
      } else {
        logger?.d('bind - BindStatus.failed 274 completer is null');
      }
    }

    return _completerBind!.future;
  }

  /// 检查是否需要授权
  void _checkAuthIfNeed(int authLength, Map map) {
    // 成功
    if (authLength == 12) {
      logger?.d('绑定 - 需要进行加密授权');
      // 需要进行加密授权
      final mapEncryptedData = _saveEncryptedData(map);
      _setEncryptedAuth(jsonEncode(mapEncryptedData));
      _authMode = 1;
      _saveAuthMode();
    } else if (authLength == 8) {
      logger?.d('绑定 - 需配对码绑定');
      // 绑定码授权
      _isBinding = false;
      if (_completerBind != null && !_completerBind!.isCompleted) {
        logger?.d('bind - BindStatus.needAuth');
        _completerBind?.complete(BindStatus.needAuth);
      } else {
        logger?.d('bind - BindStatus.needAuth completer is null');
      }
    } else if (authLength == 0) {
      logger?.d('绑定 - 直接绑定');
      // 直接绑定
      _markBindStateToClib(true);
      _isBinding = false;
      if (_completerBind != null && !_completerBind!.isCompleted) {
        logger?.d('bind - BindStatus.successful 316');
        _completerBind?.complete(BindStatus.successful);
      } else {
        logger?.d('bind - BindStatus.successful 274 completer is null');
      }
    }
  }

  /// 保存加密授权数据
  Map _saveEncryptedData(Map map) {
    final encryptedVersion = map['encrypted_version'] as int;
    final encryptedData = map['encrypted_data'];
    final jsonData = {
      'autu_data': encryptedData,
      'encrypted_version': encryptedVersion,
      'auth_length': encryptedData.length
    };
    //logger?.d('绑定 - 保存加密数据');
    final jsonStr = jsonEncode(jsonData);
    // 保存加密数据
    storage?.saveBindEncryptedDataToDisk(jsonStr);
    return jsonData;
  }

  /// 加密授权校验
  void _setEncryptedAuth(String json) async {
    //logger?.d('绑定 - 授权码校验');
    _libMgr
        .send(evt: CmdEvtType.setEncryptedAuth, json: json)
        .listen((event) async {
      if (event.code == 0 && event.json != null) {
        final map = jsonDecode(event.json!);
        //授权结果 0 成功 , 非0失败； 1:是手表点击拒绝； 2:密码校验失败，3：已经绑定
        final authCode = map['auth_code'] as int;
        if (authCode == 0) {
          _markBindStateToClib(true);
          _isBinding = false;
          if (_completerBind != null && !_completerBind!.isCompleted) {
            logger?.d('bind - BindStatus.successful 352');
            _completerBind?.complete(BindStatus.successful);
          } else {
            logger?.d('bind - BindStatus.successful 352 _completer is null');
          }
        } else if (authCode == 1) {
          _isBinding = false;
          if (_completerBind != null && !_completerBind!.isCompleted) {
            logger?.d('bind - BindStatus.refusedBind');
            _completerBind?.complete(BindStatus.refusedBind);
          } else {
            logger?.d('bind - BindStatus.refusedBind _completer is null');
          }
        } else if (authCode == 2) {
          //logger?.d('绑定 - 授权码校验失败 - 清除缓存的授权码数据');
          // 清除本地数据
          await storage?.cleanBindEncryptedData();
          _isBinding = false;
          if (_completerBind != null && !_completerBind!.isCompleted) {
            logger?.d('bind - BindStatus.authCodeCheckFailed 371');
            _completerBind?.complete(BindStatus.authCodeCheckFailed);
          } else {
            logger?.d(
                'bind - BindStatus.authCodeCheckFailed 371 _completer is null');
          }
        } else if (authCode == 3) {
          _markBindStateToClib(true);
          _isBinding = false;
          if (_completerBind != null && !_completerBind!.isCompleted) {
            logger?.d('bind - BindStatus.binded 380');
            _completerBind?.complete(BindStatus.binded);
          } else {
            logger?.d('bind - BindStatus.binded 380 _completer is null');
          }
        } else {
          _isBinding = false;
          if (_completerBind != null && !_completerBind!.isCompleted) {
            logger?.d('bind - BindStatus.failed 388');
            _completerBind?.complete(BindStatus.failed);
          } else {
            logger?.d('bind - BindStatus.failed 388 _completer is null');
          }
        }
      } else {
        // 清除本地数据
        await storage?.cleanBindEncryptedData();
        _isBinding = false;
        if (_completerBind != null && !_completerBind!.isCompleted) {
          logger?.d('bind - BindStatus.failed 402');
          _completerBind?.complete(BindStatus.failed);
        } else {
          logger?.d('bind - BindStatus.failed 402 _completer is null');
        }
      }
    });
  }

  /// 绑定结果发给c库
  void _markBindStateToClib(bool successful) async {
    if (_libMgr.deviceInfo.otaMode) {
      _updateSetModeNotification.add(2);
      logger?.d('call _updateSetModeNotification.add(2)');
      // 设置c库绑定模式
      _coreMgr.setBindMode(mode: 2);
    } else {
      if (successful) {
        // 清除指令队列 和 快速配置
        _libMgr.dispose();
        _coreMgr.cleanProtocolQueue();
      }

      // 保存绑定状态
      _isBinded = successful;
      await _saveBindState();
      final mode = successful ? 1 : 0;
      _updateSetModeNotification.add(mode);
      logger?.d('call _updateSetModeNotification.add($mode)');
      _coreMgr.setBindMode(mode: mode);
      await _libMgr.send(evt: CmdEvtType.connected).first;
    }
  }

  /// 清除授权数据
  Future<bool> _cleanAuthData() async {
    if (storage != null) {
      if (_authMode == 1) {
        return await storage!.cleanBindEncryptedData();
      } else if (_authMode == 2) {
        return await storage!.cleanBindAuthData();
      }
    }
    return false;
  }

  /// 使用缓存数据绑定
  Future<bool> _tryBindWithCache() async {
    if (_authMode == 0) {
      return Future(() => false);
    }
    final isAuthCode = _authMode == 2;
    final cmd =
        isAuthCode ? CmdEvtType.setAuthCode : CmdEvtType.setEncryptedAuth;
    final jsonStr = await (isAuthCode
        ? storage?.loadBindAuthDataByDisk()
        : storage?.loadBindEncryptedDataByDisk());
    if (jsonStr == null || jsonStr.isEmpty) {
      return Future(() => false);
    }
    //logger?.d('绑定 - 使用缓存 ${isAuthCode ? '配对码' : '授权码'} 校验');
    return _libMgr.send(evt: cmd, json: jsonStr).asyncMap((event) async {
      if (event.code == 0 && event.json != null) {
        final map = jsonDecode(event.json!);
        final authCode = map['auth_code'] as int;
        final rs = authCode == 0 || authCode == 3;
        //授权结果 0 成功 , 非0失败； 1:是手表点击拒绝； 2:密码校验失败，3：已经绑定
        if (!rs) {
          // 清除缓存数据
          await _cleanAuthData();
        }
        return rs;
      }
      return false;
    }).first;
  }

  /// 加载授权模式
  Future<int> _loadAuthMode() async {
    _authMode = await storage?.loadAuthMode() ?? 0;
    return _authMode;
  }

  Future<bool?> _saveAuthMode() async {
    return await storage?.saveAuthMode(_authMode);
  }

  /// 加载绑定状态
  Future<bool> _loadBindState() async {
    _isBinded =
        await storage?.loadBindStatus(macAddress: libManager.macAddress) ?? false;
    return _isBinded!;
  }

  Future<bool?> _saveBindState() async {
    _isBinded ??= false;
    return await storage?.saveBindStatus(_isBinded!);
  }
}
