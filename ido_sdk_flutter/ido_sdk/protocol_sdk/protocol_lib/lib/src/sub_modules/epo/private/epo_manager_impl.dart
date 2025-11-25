part of '../epo_manager.dart';

class _IDOEPOManager implements IDOEPOManager {
  static final _instance = _IDOEPOManager._internal();
  factory _IDOEPOManager() => _instance;

  final _statusModel = _EpoStatusModel();

  /// 回调
  final _streamCallbackCtrl = StreamController.broadcast();
  StreamSubscription? _streamDownloadCtrl;
  StreamSubscription<bool>? _streamSendCtrl;

  /// 重试次数
  int _retryCountMax = 0;
  final _retryCountMap = <EpoUpgradeStatus, int>{};
  /// 异常时重置状态（容错用）
  Timer? _timerReset;
  final _autoResetDelay = 2 * 60; // 秒
  /// 快速配置完成后，延迟1分钟触发自动升级（内部使用）
  Timer? _timerAutoUpgrade;
  final _autoUpgradeDelay = 1 * 60; // 秒
  final _downDirName = 'down';
  bool _needAutoUpdateOnIdle = false; // 未启用
  bool _enableAutoUpgrade = false;

  // 每30分钟主动更新热启动参数
  Timer? _timerHotGpsStart;
  final _hotGpsStartDelay = 30 * 60; // 30分钟

  @override
  bool get enableAutoUpgrade => _enableAutoUpgrade;

  @override
  set enableAutoUpgrade(bool value) {
    _enableAutoUpgrade = value;
  }

  @override
  EpoUpgradeStatus get status => _statusModel.epoStatus;

  @override
  bool get isSupported => _isSupported();

  @override
  IDOEPOManagerDelegate? delegateGetGps;

  _IDOEPOManager._internal() {
    _registerListener();
  }

  @override
  Future<int> lastUpdateTimestamp() async {
    var otaInfo = await storage?.loadOtaInfoByDisk();
    otaInfo ??= IDODeviceOtaInfo(macAddress: libManager.macAddress);
    logger?.i('EPO: epoUpdateTimestamp: ${otaInfo.epoUpdateTimestamp} macAddress${otaInfo.macAddress}');
    return otaInfo.epoUpdateTimestamp;
  }

  ///是否需要更新
  @override
  Future<bool> shouldUpdateForEPO({bool isForce = false}) async {
    if (isForce) {
      return true;
    }
    if (_statusModel.isTransBusy) {
      return false;
    }
    final timestamp = await lastUpdateTimestamp();
    final now = DateTime.now();
    if (timestamp != 0 &&
        now.isAfter24Hour(timestamp) &&
        now.isSameDay(DateTime.fromMillisecondsSinceEpoch(timestamp))) {
      logger?.i('EPO: 两次检查时间不超过一天');
      return false;
    }
    return true;
  }

  @override
  void willStartInstall({bool isForce = false, int retryCount = 3}) async {
    logger?.i('EPO: 当前是否在升级中 isUpgrading:${_statusModel.isUpgrading} isForce:$isForce');
    _statusModel.isStopped = false;
    if (await _canUpgradeEpo(isForce) == false) {
      return;
    }
    // 开始执行升级流程
    _retryCountMap.clear();
    _retryCountMax = retryCount;
    _statusModel.isForceUpdate = isForce;
    await _execUpgrade();
  }

  @override
  StreamSubscription listenEPOStatusChanged(
      void Function(EpoUpgradeStatus status) funcStatus,
      void Function(double progress)? downProgress,
      void Function(double progress)? sendProgress,
      void Function(int errorCode) funcComplete) {

    final listener = _EpoStatusListener(
      onStatusChanged: funcStatus,
      onDownloadProgress: downProgress,
      onSendProgress: sendProgress,
      onComplete: funcComplete,
    );

    return _streamCallbackCtrl.stream.listen((event) {
      if (event is EpoUpgradeStatus) {
        listener.onStatusChanged(event);
      } else if (event is double) {
        if(_statusModel.epoStatus == EpoUpgradeStatus.downing) {
          listener.onDownloadProgress?.call(event);
        }else if(_statusModel.epoStatus == EpoUpgradeStatus.sending) {
          listener.onSendProgress?.call(event);
        }
      } else if(event is int) {
        listener.onComplete(event);
      }
    });
  }

  @override
  void stop() {
    _streamDownloadCtrl?.cancel();
    debugPrint("_streamDownloadCtrl cancel");
    _streamSendCtrl?.cancel();
    _stopResetTimer();
    _statusModel.resetAll();
    _needAutoUpdateOnIdle = true;
    // 最后标记为已停止
    _statusModel.isStopped = true;
  }

}

extension _IDOEPOManagerPrivate on _IDOEPOManager {

  Future<bool> _canUpgradeEpo(bool isForce) async {
    if (_statusModel.isUpgrading) {
      _startResetTimer(); // 2分钟后恢复默认值
      return false;
    }

    // 恒玄平台的epo处理逻辑
    if (libManager.deviceInfo.isPersimwearPlatform()) {
      logger?.i('EPO: sdk暂不支持恒玄平台的epo升级，需业务端自行处理');
      return false;
    }

    if (await _checkUpdatePreconditions() == false) {
      return false;
    }

    // 检查是否需要更新
    final shouldUpdate = await shouldUpdateForEPO(isForce: isForce);
    if (!shouldUpdate) {
      return false;
    }
    return true;
  }

  bool _isSupported() {
    return (libManager.funTable.setAirohaGpsChip
        && (libManager.funTable.syncGps || libManager.funTable.syncV3Gps))
        || libManager.deviceInfo.gpsPlatform > 0;
  }

  ///检查前置条件
  Future<bool> _checkUpdatePreconditions() async {
    if (!_statusModel.isConnected) {
      logger?.i('EPO: 设备未连接');
      return false;
    }

    if (_isSupported() == false) {
      debugPrint("libManager.deviceInfo: ${libManager.deviceInfo.toJson()}");
      logger?.i(
          'OTA: 功能表不支持EPO ${libManager.funTable.setAirohaGpsChip} ${libManager.funTable.syncGps}  ${libManager.funTable.syncV3Gps} ${libManager.deviceInfo.gpsPlatform}');
      return false;
    }

    return true;
  }

  _tryUpgradeIfNeed(EpoUpgradeStatus status) async {
    int retryCount = _retryCountMap[status] ?? 0;
    if (retryCount < _retryCountMax) {
      retryCount += 1;
      _retryCountMap[status] = retryCount;
      logger?.i('EPO: retry $retryCount/$_retryCountMax - ${status.toString()}');
      await _execUpgrade();
    } else {
      logger?.i('EPO: 升级失败 - ${status.toString()}');
      retryCount = 0;
      _updateResult(false);
    }
  }

  /// 执行升级
  _execUpgrade() async {
    _stopAutoUpgradeTimer();
    _statusModel.epoStatus = EpoUpgradeStatus.ready;
    if (_statusModel.isTransBusy || libManager.isFastSynchronizing) {
      logger?.i('EPO: 升级EPO isTransBusy:${_statusModel.isTransBusy}  '
          'fastSync:${libManager.isFastSynchronizing} '
          'isForce:${_statusModel.isForceUpdate}');
      _needAutoUpdateOnIdle = true;
      return;
    }

    // 1、下载EPO文件
    final saveFolder = await _epoDirectory(subFolders: _downDirName);
    if (saveFolder != null) {
      // 清理超过一天的文件
      await _clearFiles(rootDirPath: saveFolder, keepSameDay: true);
    }
    _statusModel.epoStatus = EpoUpgradeStatus.downing;
    final epoTypes = _isIcoeGpsPlatform()
        ? [_EPOType.c3, _EPOType.g3, _EPOType.e3, _EPOType.j3]
        : [_EPOType.gr, _EPOType.gal, _EPOType.bds];
    final epoPathList = await _downLoadAllEpoFilePath(epoTypes);
    if (epoPathList.isEmpty || epoPathList.length != epoTypes.length) {
      //_statusModel.epoStatus = EpoUpgradeStatus.failure;
      _tryUpgradeIfNeed(EpoUpgradeStatus.downing);
      return;
    }

    // 2、制作EPO文件(epo文件多合一)
    _statusModel.epoStatus = EpoUpgradeStatus.making;
    final downFolder = await _epoDirectory(subFolders: _downDirName);
    final eopFolder = await _epoDirectory();
    if (downFolder == null || eopFolder == null) {
      //_statusModel.epoStatus = EpoUpgradeStatus.failure;
      _tryUpgradeIfNeed(EpoUpgradeStatus.making);
      return;
    }
    final epoFilePath = '$eopFolder/EPO.DAT';
    logger?.i('EPO: 准备开始EPO多合一');
    final makeRes = await libManager.tools.makeEpoFile(dirPath: downFolder, epoFilePath: epoFilePath, fileCount: epoTypes.length);
    logger?.i('EPO: 多合一结果：$makeRes');
    if (!makeRes) {
      //_statusModel.epoStatus = EpoUpgradeStatus.failure;
      _tryUpgradeIfNeed(EpoUpgradeStatus.making);
      return;
    }

    // 3、发送EPO文件到固件
    _statusModel.epoStatus = EpoUpgradeStatus.sending;
    final result = await _sendOtaFileToFirmware(epoFilePath, 'EPO.DAT', FileTransType.epo, (progress) {
      if (progress * 100.toInt() % 10 == 0) {
        logger?.i('EPO: 发送EPO文件到固件,进度：$progress');
      }
      _streamCallbackCtrl.add(progress);
    }, needCheckWriteFileComplete: false);

    if (result && _isIcoeGpsPlatform()) {
      logger?.i('EPO: 平台${libManager.deviceInfo.gpsPlatform}无需0740通知');
      _updateResult(true);
      _updateGpsHotStartParam();
    }else if(!result){
      await _tryUpgradeIfNeed(EpoUpgradeStatus.sending);
    }else {
      _statusModel.epoStatus = EpoUpgradeStatus.installing;
    }
  }

  Future<void> _updateResult(bool isSuccess) async {
    if (!_statusModel.isConnected) {
      logger?.i('EPO: 设备未连接');
      return;
    }
    IDODeviceOtaInfo? otaInfo = await storage?.loadOtaInfoByDisk();
    otaInfo ??= IDODeviceOtaInfo(macAddress: libManager.macAddress);
    if (isSuccess) {
      otaInfo.epoUpdateTimestamp = DateTime.now().millisecondsSinceEpoch;
      await storage?.saveOtaInfoToDisk(otaInfo);
    }

    _statusModel.epoStatus = isSuccess ? EpoUpgradeStatus.success : EpoUpgradeStatus.failure;
    _streamCallbackCtrl.add(isSuccess ? 0 : -2);
  }

  void _updateGpsHotStartParam() async {
    if (!(libManager.funTable.getSupportSendGpsLongitudeAndLatitude || libManager.deviceInfo.gpsPlatform > 0)) {
      logger?.d("EPO: funTable.getSupportSendGpsLongitudeAndLatitude = false");
      return;
    }
    if (delegateGetGps == null) {
      logger?.e("EPO: _updateGpsHotStartParam delegateGetGps = null");
    }
    delegateGetGps?.getAppGpsInfo().then((value) {
      if (value != null) {
        libManager.send(evt: CmdEvtType.setHotStartParam, json: value.toJson()).first.then((value) {
          logger?.d("EPO: update hot gps start param rs: ${value.code}");
        });
      }
    });

    // 每30分钟执行一次
    _startHotGpsTimer();
  }

  /// 清除缓存文件
  ///keepSameDay == true,保留同一天的文件
  Future<void> _clearFiles({required String rootDirPath, bool keepSameDay = false}) async {
    var dir = Directory(rootDirPath);
    List all = await dir.list().toList();
    for (FileSystemEntity file in all) {
      final stat = await file.stat();
      if (!(keepSameDay && stat.changed.isSameDay(DateTime.now()))) {
        logger?.i('EPO: 删除过期文件：${file.path}');
        await file.delete(recursive: true);
      }
    }
  }

}

extension _IDOEpoManagerTimer on _IDOEPOManager {

  void _startResetTimer() {
    _timerReset?.cancel();
    _timerReset = Timer(Duration(seconds: _autoResetDelay), () {
      if (_statusModel.isUpgrading) {
        _statusModel.resetAll();
        logger?.v('EPO: 升级超时，重置状态');
      }
    });
  }

  void _stopResetTimer() {
    //logger?.v('call _stopTimerFastSync');
    _timerReset?.cancel();
    _timerReset = null;
  }

  void _startAutoUpgradeTimer() {
    _statusModel.isStopped = false;
    _timerAutoUpgrade?.cancel();
    if (!_enableAutoUpgrade) {
      logger?.v('EPO: 自动触发epo升级检测未启用，不执行');
      return;
    }
    _timerAutoUpgrade = Timer(Duration(seconds: _autoUpgradeDelay), () {
      logger?.v('EPO: 自动触发epo升级检测');
      willStartInstall();
    });
  }

  void _stopAutoUpgradeTimer() {
    _timerAutoUpgrade?.cancel();
    _timerAutoUpgrade = null;
  }

  void _startHotGpsTimer() {
    _timerHotGpsStart?.cancel();
    _timerHotGpsStart = Timer(Duration(seconds: _hotGpsStartDelay), () {
      logger?.v('EPO: Update hot GPS start parameters every 30 minutes (if needed)');
      _updateGpsHotStartParam();
    });
  }

  void _stopHotGpsTimer() {
    _timerHotGpsStart?.cancel();
    _timerHotGpsStart = null;
  }
}

extension _IDOEpoManagerSend on _IDOEPOManager {
  // 传输包到固件
  Future<bool> _sendOtaFileToFirmware(
      String filePath, String fileName, FileTransType fileType, Function(double) progress,
      {bool cancelPrevTranTask = false, bool needCheckWriteFileComplete = true}) async {
    logger?.i("EPO: 传输包到固件 filePath:$filePath; fileName:$fileName fileType:$fileType");
    final fileItem = NormalFileModel(
        fileType: fileType,
        filePath: filePath,
        fileName: fileName,
        needCheckWriteFileComplete: needCheckWriteFileComplete);
    final result = await _transferFile(fileItem, progress,
        cancelPrevTranTask: cancelPrevTranTask);
    return result;
  }


  Future<bool> _transferFile(BaseFileModel item, Function(double) progress, {bool cancelPrevTranTask = false}) {
    final completer = Completer<bool>();
    _streamSendCtrl = libManager.transFile
        .transferSingle(
        fileItem: item,
        funcStatus: (FileTransStatus status) {
          logger?.i('EPO: 文件传输 状态：${status.name}');
        },
        funcProgress: progress,
        funError: (index, errorCode, errorCodeFromDevice, finishingTime) {
          final newErrorCode = libManager.funTable.getSupportDataTranGetNewErrorCodeV3;
          final tmpCode = newErrorCode ? errorCodeFromDevice : errorCode;
          logger?.i(
              'EPO: funError: index:$index, errorCode:$errorCode, errorCodeFromDevice:$errorCodeFromDevice, tmpCode:$tmpCode finishingTime:$finishingTime');
          if (tmpCode == 22) {
            // low power
            //SmartDialog.showToast(TranslateManager().idoKey9537().zh('电量过低,安装失败'));
          }
          if (tmpCode != 0) {
            _streamCallbackCtrl.add(tmpCode);
          }
        },
        cancelPrevTranTask: cancelPrevTranTask).listen((value) {
      completer.complete(value);
    });
    return completer.future;
  }
}
