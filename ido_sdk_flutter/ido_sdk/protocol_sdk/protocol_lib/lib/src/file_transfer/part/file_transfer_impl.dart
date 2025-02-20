part of '../ido_file_transfer.dart';

class _IDOFileTransfer implements IDOFileTransfer {
  static final _instance = _IDOFileTransfer._internal();
  factory _IDOFileTransfer() => _instance;
  _IDOFileTransfer._internal() {
    IDOProtocolLibManager().listenConnectStatusChanged((isConnected) {
      if (!isConnected) {
        logger?.d("cleanFileTransType on disconnected");
        _cleanFileTransType();
      }
    });
  }

  late final _coreMgr = IDOProtocolCoreManager();
  late final _libMgr = IDOProtocolLibManager();

  late final _subjectTranFileTypeChanged =
      StreamController<FileTransType?>.broadcast();

  CallbackFileTransStatusMultiple? _funcStatus;
  CallbackFileTransProgressMultiple? _funcProgress;
  CallbackFileTransErrorCode? _funError;

  // 用于内部取消传输
  CancelableOperation? _cancelableOperation;

  // 结果集
  final _resultList = <bool>[];
  // 每个文件占比
  final _ratioSize = <double>[];

  // 是否有传输在执行
  bool _isBusy = false;

  // 任务取消
  bool _isCanceled = false;
  // 当前传输任务, 可用于取消
  BaseFile? _currentTask;
  int _currentExecIndex = 0;
  // 传输任务列表
  late final tranFileItems = <BaseFile>[];
  Completer<List<bool>>? _completer;

  Timer? _timerCloseFastMode;

  // 进度日志节流
  var _lastLoggedProgress = 0.0;
  final _progressThreshold = 0.01;

  // 当前传输的文件类型
  FileTransType? __fileTransType;
  set _fileTransType(FileTransType? state) {
    final isChanged = __fileTransType != state;
    __fileTransType = state;
    logger?.v('__fileTransType: $state');
    if (isChanged && _subjectTranFileTypeChanged.hasListener) {
      _subjectTranFileTypeChanged.add(__fileTransType);
    }
  }

  @override
  StreamSubscription listenTransFileTypeChanged(
      void Function(FileTransType? fileType) func) {
    return _subjectTranFileTypeChanged.stream.listen(func);
  }

  @override
  Stream<bool> transferSingle(
      {required BaseFileModel fileItem,
      required CallbackFileTransStatusSingle funcStatus,
      required CallbackFileTransProgressSingle funcProgress,
      CallbackFileTransErrorCode? funError,
      bool cancelPrevTranTask = false}) {
    return transferMultiple(
            fileItems: [fileItem],
            funcStatus: (int index, FileTransStatus status) =>
                funcStatus(status),
            funcProgress: (int currentIndex, int totalCount,
                    double currentProgress, double totalProgress) =>
                funcProgress(currentProgress),
            funError: funError,
            cancelPrevTranTask: cancelPrevTranTask)
        .map((e) => e.first);
  }

  @override
  Stream<List<bool>> transferMultiple(
      {required List<BaseFileModel> fileItems,
      required CallbackFileTransStatusMultiple funcStatus,
      required CallbackFileTransProgressMultiple funcProgress,
      CallbackFileTransErrorCode? funError,
      bool cancelPrevTranTask = false}) {
    logger?.v("trans fileItems: ${fileItems.length} cancelPrevTranTask: $cancelPrevTranTask funError: $funError");
    // 取消前次操作
    if (cancelPrevTranTask) {
      _cancelPrevTranIfExists();
      _currentExecIndex = 0;
    } else if (_isBusy) {
      funcStatus(0, FileTransStatus.busy);
      return Future(() => fileItems.map((e) => false).toList()).asStream();
    }

    // 初始化结果集
    _resultList.clear();
    for (var e in fileItems) {
      _resultList.add(false);
    }

    // // 未标记连接，不执行传输
    // if (!_libMgr.isConnected) {
    //   logger?.e('transfer - Unconnected calls are not supported');
    //   funcStatus(0, FileTransStatus.error);
    //   return Future(() => _resultList).asStream();
    // }

    // 快速配置中，不执行传输
    if (_libMgr.isFastSynchronizing) {
      logger?.e('transfer - on fast synchronizing, calls are not supported');
      funcStatus(0, FileTransStatus.onFastSynchronizing);
      return Future(() => _resultList).asStream();
    }

    // 列表空，不执行传输
    if (fileItems.isEmpty) {
      logger?.e('transfer - list cannot be empty');
      funcStatus(0, FileTransStatus.error);
      return Future(() => _resultList).asStream();
    }

    _funcStatus = funcStatus;
    _funcProgress = funcProgress;
    _funError = funError;

    _isBusy = true;
    _isCanceled = false;
    _completer = Completer();

    // 创建可取消的stream任务
    final cancelableOpt =
        CancelableOperation.fromFuture(_exec(fileItems), onCancel: () {
      logger?.d('file transfer canceled');
      _didCancel();
    });
    _cancelableOperation = cancelableOpt;
    return cancelableOpt.asStream();
  }

  @override
  Future<int> iwfFileSize({required String filePath, required int type}) async {
    FileTransType transType =
        type == 1 ? FileTransType.iwf_lz : FileTransType.wallpaper_z;
    final item = WatchFile(
      transType,
      NormalFileModel(
          fileType: transType, filePath: filePath, fileName: 'tmp_dual'),
    );

    try {
      // 校验文件类型
      final isValid = await item.verifyFileType();
      if (!isValid) {
        logger?.d('file type mismatch');
        throw ArgumentError('file type mismatch');
      }

      // 压缩、转换文件
      final fileModel = await item.makeFileIfNeed();

      return Future(() => fileModel.originalFileSize ?? 0);
    } catch (e) {
      return Future(() => 0);
    }
  }

  @override
  bool get isTransmitting => _isBusy;

  @override
  FileTransType? get transFileType => __fileTransType;

  @override
  void registerDeviceTranFileToApp(
      void Function(DeviceFileToAppTask task) taskFunc) {
    logger?.d("registerDeviceTranFileToApp");
    _coreMgr.registerDeviceTranFileToApp(
        requestCallback: (String json) {
          final jsonMap = jsonDecode(json);
          final item = DeviceTransItem.fromJson(jsonMap);
          final task = DeviceFileToAppTask(item);
          logger?.d("device file -> app item: ${item.toJson()}");
          taskFunc(task);
        });
  }

  @override
  void unregisterDeviceTranFileToApp() {
    logger?.d("unregisterDeviceTranFileToApp");
    _coreMgr.unregisterDeviceTranFileToApp();
  }

}

extension _IDOFileTransferExt on _IDOFileTransfer {
  /// 任务取消
  void _didCancel() {
    _currentTask?.cancel();
    _isCanceled = true;
    _isBusy = false;
    _cleanFileTransType();
    _completer?.complete(_resultList);
    _completer = null;
    // _closeFastMode();
    _restartCloseFastModeTimer();
  }

  /// 执行传输任务
  Future<List<bool>> _exec(List<BaseFileModel> fileItems) async {
    final tranFileList = <BaseFile>[];
    int totalSize = 0;
    _ratioSize.clear();
    tranFileItems.clear();

    // 校验类型 & 记录文件大小
    for (int i = 0; i < fileItems.length; i++) {
      final fileItem = fileItems[i];
      logger?.v("file $i = ${fileItem.toString()}");
      final tranFile = _createTranFile(fileItem);
      if (tranFile == null) {
        // 创建tranFile失败
        logger?.e('create tranFile failed ${fileItem.filePath}');
        _funcStatus!(i, FileTransStatus.invalid);
        _completer?.complete(_resultList);
        _cleanFileTransType();
        return _completer!.future;
      }

      // 校验类型
      final rs = await tranFile.verifyFileType();
      if (!rs) {
        logger?.e(
            'verify filetype failed ${fileItem.fileType.name} ${fileItem.filePath}');
        _funcStatus!(i, FileTransStatus.invalid);
        _completer?.complete(_resultList);
        _cleanFileTransType();
        return _completer!.future;
      }

      // 判断文件是否存在
      final isExists = await tranFile.checkExists();
      if (!isExists) {
        logger?.e(
            'file not exists ${fileItem.fileType.name} ${fileItem.filePath}');
        _funcStatus!(i, FileTransStatus.notExists);
        _completer?.complete(_resultList);
        _cleanFileTransType();
        return _completer!.future;
      }

      // 获取文件大小，用于计算总进度
      final fileSize = fileItem.fileSize ?? 0;
      totalSize += fileSize;
      _ratioSize.add(fileSize.toDouble());

      // 标记索引
      tranFile.index = i;
      tranFileItems.add(tranFile);
      if (i == 0) {
        _fileTransType = tranFile.type;
      }

      tranFileList.add(tranFile);
    }

    // 计算每个文件占比
    for (int i = 0; i < _ratioSize.length; i++) {
      _ratioSize[i] = _ratioSize[i] / totalSize;
    }

    try {
      if (!_libMgr.deviceInfo.otaMode) {
        // 启用快速模式
        await _openFastMode();
      }
    } catch (e) {
      logger?.e(e.toString());
    }
    // 执行传输
    try {
      for (int i = 0; i < tranFileList.length; i++) {
        // 被取消
        if (_isCanceled) {
          logger?.d('trans task canceled, return');
          _currentTask?.cancel();
          break;
        }
        _currentExecIndex = i;
        final tranFile = tranFileList[i];
        _currentTask = tranFile;
        _fileTransType = tranFile.type;
        _lastLoggedProgress = 0.0;
        final rs = await tranFile.tranFile(); // 调用文件传输
        _resultList[i] = rs;

        // 所有任务执行完毕
        if (i == tranFileList.length - 1) {
          // try {
          //   // 关闭快速模式
          //   _closeFastMode(); // 去除同步任务（业务反馈文件进度走完 但不会及时上报完成状态）
          // } catch (e) {
          //   logger?.e(e.toString());
          // }
          _restartCloseFastModeTimer();

          // 完成回调
          if (_completer != null && !_completer!.isCompleted) {
            _completer?.complete(_resultList);
            logger?.d('trans rs: $_resultList');
            _cleanFileTransType();
            _cancelableOperation = null;
            return _completer!.future;
          }
        }
      }
    } catch (e) {
      logger?.e(e.toString());
      // // 关闭快速模式
      // _closeFastMode();
      _restartCloseFastModeTimer();
      if (_completer != null && !_completer!.isCompleted) {
        _completer?.complete(_resultList);
        _cleanFileTransType();
        return _completer!.future;
      }
    }

    return _completer!.future;
  }

  /// 取消前文件传输任务
  void _cancelPrevTranIfExists() {
    if (_cancelableOperation != null) {
      _cancelableOperation?.cancel();
      _cancelableOperation = null;
      _isBusy = false;
      // 回调被通知上传被取消
      _funError?.call(_currentExecIndex, -1, -1, 0);
      logger?.v('call _cancelPrevTranIfExists -1');
    }

    if (_completer != null && !_completer!.isCompleted) {
      _completer!.complete(_resultList);
      _completer = null;
      _cleanFileTransType();
    }
  }

  /// 根据要传输的文件基础信息，转换为对应的传输文件
  BaseFile? _createTranFile(BaseFileModel item) {
    final type = item.fileType;
    BaseFile? bf;
    switch (type) {
      case FileTransType.fw:
      case FileTransType.fzbin:
      case FileTransType.bin:
      case FileTransType.lang:
      case FileTransType.bt:
      case FileTransType.ton:
      case FileTransType.bpbin:
      case FileTransType.gps:
      case FileTransType.watch:
      case FileTransType.other:
      case FileTransType.app:
        bf = NormalFile(type, item);
        break;
      case FileTransType.iwf_lz:
      case FileTransType.wallpaper_z:
        bf = WatchFile(type, item);
        break;
      case FileTransType.ml:
        bf = ContactFile(type, item);
        break;
      case FileTransType.online_ubx:
      case FileTransType.offline_ubx:
        bf = AGpsFile(type, item);
        break;
      case FileTransType.mp3:
        bf = MusicFile(type, item);
        break;
      case FileTransType.msg:
        bf = MsgFile(type, item);
        break;
      case FileTransType.sport:
      case FileTransType.sports:
        bf = SportFile(type, item);
        break;
      case FileTransType.epo:
        if (item is NormalFileModel) {
          bf = EpoFile(type, item, item.needCheckWriteFileComplete);
        }else {
          bf = EpoFile(type, item, true);
        }
        break;
      case FileTransType.voice:
        bf = VoiceFile(type, item);
        break;
    }
    // 设置回调
    bf.setCallbackFunc(
        (error, errorVal, index) => _statusCallback(error, errorVal, index),
        (progress, index) => _progressCallback(progress, index));
    return bf;
  }

  /// 开启快速模式
  Future<bool> _openFastMode() async {
    if (_libMgr.funTable.getDeviceControlFastModeAlone) {
      logger?.v("开启快速模式 由设备控制，无需app处理");
      return true;
    }

    const mode = 0x01; // 快速模式
    // 0 失败 1 模式切换成功 2 需要执行查模式
    final rs = await _switchMode(mode: mode);
    if (rs == 2) {
      // 刚切换模式没那么快生效，此处延迟1秒查询成功率比较高
      return Future.delayed(const Duration(seconds: 1),
          () => _checkFastMode(mode: mode, retryCount: 1));
    }
    return Future(() => rs == 1);
  }

  /// 关闭快速模式
  Future<bool> _closeFastMode() async {
    if (_libMgr.funTable.getDeviceControlFastModeAlone) {
      logger?.v("关闭快速模式 由设备控制，无需app处理");
      return true;
    }
    const mode = 0x02; // 慢速模式
    // 0 失败 1 模式切换成功 2 需要执行查模式
    final rs = await _switchMode(mode: mode, retryCount: 1);
    if (rs == 2) {
      // 刚切换模式没那么快生效，此处延迟1秒查询成功率比较高
      return Future.delayed(const Duration(seconds: 1),
          () => _checkFastMode(mode: mode, retryCount: 1));
    }
    return Future(() => rs == 1);
  }

  /// mode: 0x00 查模式, 0x01 快速模式 , 0x02 慢速模式
  String _jsonChangeMode(int mode) {
    final map = {
      'mode': mode,
      'modify_conn_param': 0,
      'max_interval': 5,
      'min_interval': 0,
      'slave_latency': 2,
      'conn_timeout': 5,
    };
    return jsonEncode(map);
  }

  /// 校验模式
  ///
  /// mode: 0x00 查模式, 0x01 快速模式 , 0x02 慢速模式
  bool _isSuccessful(CmdResponse res, int mode) {
    if (res.code == 0 && res.json != null) {
      final map = jsonDecode(res.json!);
      return (map['err_code'] as int) == 0 && (map['cur_mode'] as int) == mode;
    }
    return false;
  }

  /// 切换模式
  ///
  /// ```dart
  /// mode: 0x01 快速模式 , 0x02 慢速模式
  /// 返回：0 失败 1 模式切换成功 2 需要执行查模式
  /// ```
  Future<int> _switchMode({required int mode, int retryCount = 5}) {
    // 重试x次 间隔2秒
    var count = 0;
    return Rx.retryWhen(() {
      if (count > 0 && count < retryCount) {
        logger?.v('切换 ${mode == 1 ? '快速' : '慢速'} 模式执行第$count次 重试');
      }
      return _libMgr
          .send(evt: CmdEvtType.setConnParam, json: _jsonChangeMode(mode))
          .map((res) {
        if (count > retryCount) {
          logger?.d('切换模式执行超过$retryCount次 结束重试');
          return res;
        } else if (!res.isOK) {
          throw '切换模式接口调用失败'; // 触发重试
        }
        return res;
      });
    }, (e, s) {
      count++;
      logger?.e(e);
      return Rx.timer(null, const Duration(seconds: 2)); // 重试间隔
    }).map((res) {
      if (res.isOK) {
        return _isSuccessful(res, mode) ? 1 : 2;
      }
      return 0;
    }).last;
  }

  /// 查模式
  ///
  /// mode: 0x01 快速模式 , 0x02 慢速模式
  Future<bool> _checkFastMode({required int mode, int retryCount = 1}) {
    // 重试x次 间隔1秒
    var count = 0;
    return Rx.retryWhen(() {
      if (count > 0 && count < retryCount) {
        logger?.v('查模式执行第$count次 重试');
      }
      return _libMgr
          .send(evt: CmdEvtType.setConnParam, json: _jsonChangeMode(0x00))
          .map((res) {
        if (count > retryCount) {
          logger?.d('查模式执行超过$retryCount次 结束重试');
          return res;
        } else if (!_isSuccessful(res, mode)) {
          throw '未成功开启 ${mode == 1 ? '快速' : '慢速'} 模式'; // 触发重试
        }
        return res;
      });
    }, (e, s) {
      count++;
      logger?.e(e);
      return Rx.timer(null, const Duration(seconds: 2)); // 重试间隔
    }).map((res) => _isSuccessful(res, mode)).last;
  }

  /// 状态回调
  void _statusCallback(int error, int errorVal, int index) {
    logger?.d('file transfer error: $error errorVal: $errorVal idx:$index fileTransType: $__fileTransType');
    if (!_isCanceled) {
      final flag = [24, 25].contains(error);
      final newErrorVal = flag ? error : errorVal;
      final finishingTime = flag ? errorVal : 0;
      // 状态回调
      if (error == 0) {
        const p = 1.0; // 进度补满
        _funcProgress!(
            index, tranFileItems.length, p, _progressTotal(p, index));
        _funcStatus!(index, FileTransStatus.finished);
        _funError?.call(index, error, newErrorVal, finishingTime);
      } else {
        _resultList[index] = false;
        _funcStatus!(index, FileTransStatus.error);
        _funError?.call(index, error, newErrorVal, finishingTime);
      }
    } else {
      logger?.e('isCanceled ignore callback');
    }
  }

  /// 进度回调
  void _progressCallback(double progress, index) {
    if (progress == 1.0 || progress - _lastLoggedProgress >= _progressThreshold) {
      logger?.d('progress: ${progress.toStringAsFixed(3)} index:$index');
      _lastLoggedProgress = progress;
    }
    _stopCloseFastModeTimer();
    if (!_isCanceled) {
      final p = max(0.0, min(1.0, progress));
      _funcProgress!(index, tranFileItems.length, p, _progressTotal(p, index));
    } else {
      logger?.e('isCanceled ignore callback');
    }
  }

  /// 多文件总进度计算
  double _progressTotal(double progress, int index) {
    double n = 0, m = 0;
    for (int i = 0; i < _ratioSize.length; i++) {
      if (i == index) {
        m = _ratioSize[i];
        break;
      }
      n += _ratioSize[i];
    }
    final rs = m * progress + n;
    if (rs == double.nan || rs == double.infinity) {
      logger?.e('progress error $rs');
    }
    return rs;
  }

  void _cleanFileTransType() {
    _fileTransType = null;
    _isBusy = false;
  }

  // /// 忽略等待关闭快速模式（用于文件上传后设备会重启的情况）
  // bool _hasWaitCloseFastMode(BaseFile tranFile) {
  //   return !{FileTransType.fw}.contains(tranFile.type);
  // }

  /// 重启关闭快速模式倒计时
  void _restartCloseFastModeTimer() {
    _stopCloseFastModeTimer();
    _timerCloseFastMode =
        Timer.periodic(const Duration(seconds: 2 * 60), (timer) {
      _closeFastMode();
      _timerCloseFastMode?.cancel();
      _timerCloseFastMode = null;
    });
  }

  void _stopCloseFastModeTimer() {
    if (_timerCloseFastMode != null && _timerCloseFastMode!.isActive) {
      _timerCloseFastMode?.cancel();
    }
    _timerCloseFastMode = null;
  }
}
