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

  /// 绑定超时（支持该功能的设备专用）
  timeout,

  /// 新账户绑定，用户确定删除设备数据（支持该功能的设备专用）
  agreeDeleteDeviceData,

  /// 新账户绑定，用户不删除设备数据，绑定失败（支持该功能的设备专用）
  denyDeleteDeviceData,

  /// 新账户绑定，用户不选择，设备超时（支持该功能的设备专用）
  timeoutOnNewAccount,

  /// 设备同意配对(绑定)请求，等待APP下发配对结果
  needConfirmByApp,

  /// 失败，账户不一致（恒玄平台设备专用）
  accountNotMatch,

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
  late final _unbindNotification = PublishSubject<String>();
  late final _bindStateChangedNotification = PublishSubject<void>();

  BindValueCallback<IDODeviceInfo>? funDeviceInfo;
  BindValueCallback<IDOFunctionTable>? funFunctionTable;

  /// 授权模式（0 未知，1 授权码，2 配对码)
  var _authMode = 0;

  /// 绑定状态
  bool? _isBinded;
  bool __isBinding = false;
  set _isBinding(bool value) {
    __isBinding = value;
    _bindStateChangedNotification.add(null);
  }
  /// 待app确认绑定结果
  bool _needAppConfirm = false;
  @override
  Future<bool> get isBinded async {
    return await _loadBindState();
  }

  @override
  bool get isBinding => __isBinding;

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
      required BindValueCallback<IDOFunctionTable> functionTable,
      String? userId}) {
    if (!IDOProtocolLibManager().isConnected) {
      _isBinding = false;
      //throw UnsupportedError('Unconnected calls are not supported');
      logger?.e('bind - Unconnected calls are not supported');
      return Stream.value(BindStatus.failed);
    }

    if (__isBinding && _completerBind != null && _completerBind!.isCompleted) {
      logger?.e('bind - The previous binding task is still running');
      //_completerBind?.complete(BindStatus.canceled);
    }

    logger?.d('bind - startBind, before _isBinding:$__isBinding');
    _isBinding = true;
    funDeviceInfo = deviceInfo;
    funFunctionTable = functionTable;
    _completerBind = Completer();
    return CancelableOperation.fromFuture(_bindExec(osVersion, userId), onCancel: () {
      _isBinding = false;
      if (_completerBind != null && !_completerBind!.isCompleted) {
        logger?.d('bind - BindStatus.canceled');
        _completerBind?.complete(BindStatus.canceled);
      } else {
        logger?.d('bind - BindStatus.canceled _completer is null');
      }
      _completerBind = null;
    }).asStream();
    // return _completerBind!.future.asStream();
  }

  @override
  void stopBindIfNeed() {
    if(__isBinding && _completerBind != null && !_completerBind!.isCompleted) {
      logger?.d('bind - stopBind');
      _completerBind?.complete(BindStatus.failed);
      _completerBind = null;
      _isBinding = false;
    }
  }

  @override
  void appMarkBindResult({required bool success}) {
    logger?.d('绑定 - APP确认绑定结果：$success _needAppConfirm:$_needAppConfirm');
    if (success && _needAppConfirm) {
      // 直接绑定
      _markBindStateToClib(true);
      _isBinding = false;
    }
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
      await storage?.removeCLibFuncTableCache(macAddr);
      // final cacheDir = await storage?.getCLibFuncTableCachePath(macAddr);
      // if (cacheDir != null) {
      //   await _libMgr.send(evt: CmdEvtType.cleanHealthDataOffset, json: jsonEncode({
      //     "device_cache_dir":cacheDir,"online_status":0
      //   })).first;
      // }
      _unbindNotification.add(macAddress);
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
        await storage?.removeCLibFuncTableCache(macAddr);
        // final cacheDir = await storage?.getCLibFuncTableCachePath(macAddr);
        // if (cacheDir != null) {
        //   await _libMgr.send(evt: CmdEvtType.cleanHealthDataOffset, json: jsonEncode({
        //     "device_cache_dir":cacheDir,"online_status":0
        //   })).first;
        // }
        //_coreMgr.setBindMode(mode: 0);
        _unbindNotification.add(macAddress);
      } catch (e) {
        logger?.e('unbind online error：$e');
      }
    }
    logger?.v('unbind online res:${res.isOK} rs:$rs');
    return rs;
  }

  @override
  StreamSubscription listenUpdateSetModeNotification(
      void Function(int mode) func) {
    return _updateSetModeNotification.listen(func);
  }

  @override
  StreamSubscription listenUnbindNotification(
      void Function(String macAddress) func) {
    return _unbindNotification.listen(func);
  }

  @override
  StreamSubscription listenBindStateChangedNotification(
      void Function(void) func) {
    return _bindStateChangedNotification.listen(func);
  }
}

extension _IDODeviceBindExt on _IDODeviceBind {
  Future<BindStatus> _bindExec(int osVersion, String? userId) async {
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
        // 恒玄平台需要提供user_id
        if (userId != null && deviceInfo.isPersimwearPlatform()) {
          // 0:成功/一致；1:失败；2:失败，账户不一致；3:失败，无账户
          final code = await _setSystemVersion(userId, deviceInfo.deviceId);
          if (code == 2) {
            _isBinding = false;
            if (_completerBind != null && !_completerBind!.isCompleted) {
              logger?.d('bind - accountNotMatch');
              _completerBind?.complete(BindStatus.accountNotMatch);
            } else {
              logger?.d('bind - accountNotMatch completer is null');
            }
            return _completerBind!.future;
          }else if (code == 13) {
            // 指令超时
            _isBinding = false;
            if (_completerBind != null && !_completerBind!.isCompleted) {
              logger?.d('bind - _setSystemVersion timeout');
              _completerBind?.complete(BindStatus.failed);
            } else {
              logger?.d('bind - _setSystemVersion completer is null');
            }
            return _completerBind!.future;
          }
          funDeviceInfo!(deviceInfo);
        }else {
          funDeviceInfo!(deviceInfo);
        }
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
        // 添加 获取三级版本号
        if (_libMgr.funTable.getBleAndBtVersion) {
          final devInfo = await libManager.deviceInfo.refreshFirmwareVersion();
          if (devInfo == null) {
            _isBinding = false;
            if (_completerBind != null && !_completerBind!.isCompleted) {
              logger?.d('bind - failed refreshFirmwareVersion');
              _completerBind?.complete(BindStatus.failedOnGetFunctionTable);
            } else {
              logger?.d('bind - failed refreshFirmwareVersion completer is null');
            }
            return _completerBind!.future;
          }
        }
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

    if (_completerBind == null) {
      // skg支持绑定过程中取消绑定，如果是在调用绑定指令前取消，此处需要拦截绑定指令
      logger?.d('bind - BindStatus.failed 269, cancel bind task');
      return BindStatus.failed;
    }

    // 音乐控制需要依赖手机平台参数，应固件要求，需要在绑定前把手机平台发给设备
    if (_libMgr.funTable.getSupportAppSendPhoneSystemInfo && !_libMgr.deviceInfo.isPersimwearPlatform()) {
      await _setSystemVersion(null, _libMgr.deviceInfo.deviceId);
      logger?.d("bind - call setAppOS");
    }

    //logger?.d('绑定 - 发送绑定请求');
    final json = <String, dynamic>{
      'is_clean_data': 1,
      'os_type': Platform.isIOS ? 1 : 2,
      'os_version': osVersion,
      'bind_version': 1
    };
    _needAppConfirm = false;
    final rs = await _libMgr
        .send(evt: CmdEvtType.setBindStart, json: jsonEncode(json))
        .first;
    if (rs.code == 0 && rs.json != null) {
      final map = jsonDecode(rs.json!);
      final bindCode = map['bind_ret_code'] as int;
      final authLength = map['auth_length'] as int;
      // bindCode 0表示成功,1表示失败,2表示已经绑定
      // 3：超时(GT5)
      // 4：新账户绑定，用户确定删除设备数据(GT5)
      // 5：新账户绑定，用户不删除设备数据，绑定失败(GT5)
      // 6：新账户绑定，用户不选择，设备超时（GT5）
      // 7：设备同意配对(绑定)请求，等待APP下发配对结果（GT5）
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
      } else if (bindCode == 3) {
        // 超时(GT5)
        _isBinding = false;
        if (_completerBind != null && !_completerBind!.isCompleted) {
          logger?.d('bind - BindStatus.timeout');
          _completerBind?.complete(BindStatus.timeout);
        } else {
          logger?.d('bind - BindStatus.timeout completer is null');
        }
      } else if (bindCode == 4) {
        // 4：新账户绑定，用户确定删除设备数据(GT5)
        _isBinding = false;
        if (_completerBind != null && !_completerBind!.isCompleted) {
          logger?.d('bind - BindStatus.agreeDeleteDeviceData');
          _completerBind?.complete(BindStatus.agreeDeleteDeviceData);
        } else {
          logger?.d('bind - BindStatus.agreeDeleteDeviceData completer is null');
        }
      } else if (bindCode == 5) {
        // 5：新账户绑定，用户不删除设备数据，绑定失败(GT5)
        _isBinding = false;
        if (_completerBind != null && !_completerBind!.isCompleted) {
          logger?.d('bind - BindStatus.denyDeleteDeviceData');
          _completerBind?.complete(BindStatus.denyDeleteDeviceData);
        } else {
          logger?.d('bind - BindStatus.denyDeleteDeviceData completer is null');
        }
      } else if (bindCode == 6) {
        // 新账户绑定，用户不选择，设备超时（GT5）
        _isBinding = false;
        if (_completerBind != null && !_completerBind!.isCompleted) {
          logger?.d('bind - BindStatus.timeoutOnNewAccount');
          _completerBind?.complete(BindStatus.timeoutOnNewAccount);
        } else {
          logger?.d('bind - BindStatus.timeoutOnNewAccount completer is null');
        }
      } else if (bindCode == 7) {
        // 设备同意配对(绑定)请求，等待APP下发配对结果（GT5）
        _needAppConfirm = true;
        _isBinding = false;
        if (_completerBind != null && !_completerBind!.isCompleted) {
          logger?.d('bind - BindStatus.needConfirmByApp');
          _completerBind?.complete(BindStatus.needConfirmByApp);
        } else {
          logger?.d('bind - BindStatus.needConfirmByApp completer is null');
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

  /// 设置系统版本（仅限内部调用）
  Future<int> _setSystemVersion(String? userId, int deviceId) async {
    // 游客模式(-1)
    if (userId == null || userId == '-1') {
      final param = <String, dynamic>{
        "system": Platform.isIOS ? 1 : 2
      };
      final rs = await _libMgr.send(evt: CmdEvtType.setAppOS, json: jsonEncode(param)).first;
      return rs.code == 2 ? 1 : rs.code;
    }

    // 恒玄平台特殊处理
    Future<int> doit({required bool useUserId}) async {
      final param = <String, dynamic>{
        "system": Platform.isIOS ? 1 : 2
      };
      final newUid = userId.length > 14 ? userId.substring(userId.length - 14) : userId;
      if (useUserId) {
        param['user_id'] = newUid;
      }
      final rs = await _libMgr.send(evt: CmdEvtType.setAppOS, json: jsonEncode(param)).first;
      if (rs.code == 0 && rs.json != null && jsonDecode(rs.json!)["error_code"] == 2) {
        return 2;
      }
      return rs.code == 2 ? 1 : rs.code;
    }

    final rs = await doit(useUserId: true);
    // 7828设备超时时，尝试不带user_id再发一次
    if (rs == 13 && deviceId == 7828) {
      logger?.i("绑定时setAppOS超时，尝试不带user_id再发一次");
      await Future.delayed(const Duration(seconds: 4));
      return await doit(useUserId: false);
    }
    return rs;
  }
}
