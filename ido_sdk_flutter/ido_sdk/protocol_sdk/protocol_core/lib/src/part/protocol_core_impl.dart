part of '../ido_protocol_core.dart';

typedef CallbackWriteDataToBle = void Function(CmdRequest data);
typedef CallbackCRequestCmd = void Function(int evtType, int error, int val);
typedef CallbackFastSyncComplete = void Function(int errorCode);

class _IDOProtocolCoreManager implements IDOProtocolCoreManager {
  late final _queueCmd = Executor();
  late final _queueSync = Executor();
  late final _queueLog = Executor();
  late final _queueTrans = Executor();
  // //数据响应接口
  late final _cLibManager = IDOProtocolClibManager();
  late final _subjectDeviceState = StreamController<int>.broadcast();
  late final _subjectControlEvent =
      StreamController<Tuple3<int, int, String>>.broadcast();
  late final _subjectFastSyncComplete = StreamController<int>.broadcast();

  CallbackWriteDataToBle? _callbackWriteDataToBle;
  CallbackCRequestCmd? _callbackCRequestCmd;
  // CallbackFastSyncComplete? _callbackFastSyncComplete;
  CallbackCRequestCmd? _callbackCRequestCmdExt;

  /// 相同指令存在最大数量
  final _maxSameCmdTaskCount = 3;

  _IDOProtocolCoreManager._internal();
  static final _instance = _IDOProtocolCoreManager._internal();
  factory _IDOProtocolCoreManager() => _instance;

  @override
  Future<bool> initClib() async {
    print('initClib - _IDOProtocolCoreManager');
    await _cLibManager.initClib();
    _registerStreamListen();
    return true;
  }

  @override
  bool get isPaused => _queueCmd.isPaused;

  @override
  StreamController<Tuple3<int, int, String>> get streamListenReceiveData =>
      _cLibManager.streamListenReceiveData;

  @override
  CancelableOperation<CmdResponse> writeJson(
      {required int evtBase,
      required int evtType,
      String? json,
      int? val1,
      int? val2,
      bool useQueue = true,
      CmdPriority cmdPriority = CmdPriority.normal,
      Map<String, String>? cmdMap}) {
    if (!useQueue) {
      if (cmdMap != null) {
        logger?.v('发送：${cmdMap["cmd"]} - "${cmdMap["desc"]}"');
      }
      logger?.d('request evtType:$evtType json:$json');
      final rs = _cLibManager.cLib.writeJsonData(
          json: json ?? '{}', evtType: evtType, evtBase: evtBase);
      logger?.d('response evtType:$evtType rs:$rs');
      if (cmdMap != null) {
        logger?.v('收到：${cmdMap["cmd"]} - "${cmdMap["desc"]}"');
      }
      return CancelableOperation<CmdResponse>.fromFuture(
          Future(() => CmdResponse(code: ErrorCode.success)),
          onCancel: () {});
    }

    // 过滤重复指令不超过3个
    if (_queueCmd.findTaskCount(evtBase: evtBase, evtType: evtType, json: json) >=
        _maxSameCmdTaskCount) {
      return CancelableOperation<CmdResponse>.fromFuture(
          Future(() => CmdResponse(code: ErrorCode.task_already_exists)),
          onCancel: () {});
    }

    // 部分指令优先级略高，此处打印log
    if (cmdPriority != CmdPriority.normal) {
      logger?.v('evtType:$evtType cmdPriority: ${cmdPriority.name}');
    }

    // 基础命令的优先级要高于数据同步
    // 命令执行间隔 20毫秒
    Cancelable<CmdResponse> cmdTask = _queueCmd.execute(
      arg1: evtBase,
      arg2: evtType,
      arg3: json ?? '{}',
      fun3: _execCmd,
      priority: _mapCmdPriority(cmdPriority),
      interval: const Duration(milliseconds: 20),
      onDispose: _onDispose,
    );
    if (cmdMap != null) {
      logger?.v('cmd - ${cmdMap["cmd"]} "${cmdMap["desc"]}"');
    }
    logger?.v("cmd - add $evtType, "
        "active ${_queueCmd.getCurrentWorkTask() ?? "-"}, "
        "queue: ${_queueCmd.getQueueList()}");
    return CancelableOperation<CmdResponse>.fromFuture(cmdTask, onCancel: () {
      logger?.d('CancelableOperation cancel, evtType:$evtType');
      cmdTask.cancel();
      logger?.v("cmd - cancel $evtType, queue: ${_queueCmd.getQueueList()}");
    });
  }

  @override
  CancelableOperation<CmdResponse> sync(
      {required SyncType type,
      required SyncProgressCallback progressCallback,
      required SyncDataCallback dataCallback}) {
    // 数据同步的优先级要低于基础指令
    Cancelable<CmdResponse>? rs;
    return CancelableOperation<CmdResponse>.fromFuture(
        (rs = _queueSync.execute(
          arg1: type,
          arg2: progressCallback,
          arg3: dataCallback,
          fun3: _execSyncs,
          priority: WorkPriority.regular,
          interval: const Duration(milliseconds: 50),
          onDispose: _onDispose,
        )), onCancel: () {
      //logger?.d('CancelableOperation cancel');
      rs?.cancel();
    });
  }

  @override
  CancelableOperation<CmdResponse> trans({
    required FileTranItem fileTranItem,
    required FileTranStatusCallback statusCallback,
    required FileTranProgressCallback progressCallback,
  }) {
    // 文件传输优先级需要高于基础指令
    Cancelable<CmdResponse>? rs;
    return CancelableOperation<CmdResponse>.fromFuture(
        (rs = _queueTrans.execute(
          arg1: fileTranItem,
          arg2: statusCallback,
          arg3: progressCallback,
          fun3: _execTrans,
          priority: _mapFileTranPriority(fileTranItem),
          interval: const Duration(milliseconds: 50),
          onDispose: _onDispose,
        )), onCancel: () {
      logger?.d('call trans cancel');
      rs?.cancel();
    });
  }

  @override
  CancelableOperation<CmdResponse> deviceLog(
      {required LogType type, required String dirPath}) {
    Cancelable<CmdResponse>? rs;
    return CancelableOperation<CmdResponse>.fromFuture(
        (rs = _queueLog.execute(
          arg1: type,
          arg2: dirPath,
          fun2: _execLogs,
          priority: WorkPriority.regular,
          interval: const Duration(milliseconds: 50),
          onDispose: _onDispose,
        )), onCancel: () {
      //logger?.d('CancelableOperation cancel');
      rs?.cancel();
    });
  }

  @override
  StreamSubscription listenDeviceStateChanged(void Function(int code) func) {
    return _subjectDeviceState.stream.listen(func);
  }

  @override
  StreamSubscription listenControlEvent(void Function(Tuple3 t3) func) {
    return _subjectControlEvent.stream.listen(func);
  }

  @override
  void dispose() {
    _queueCmd.dispose();
    _queueSync.dispose();
    _queueLog.dispose();
    _queueTrans.dispose();
  }

  @override
  void pause() {
    _queueCmd.pause();
    _queueSync.pause();
    _queueLog.pause();
    _queueTrans.pause();
  }

  @override
  void resume() {
    _queueCmd.resume();
    _queueSync.resume();
    _queueLog.resume();
    _queueTrans.resume();
  }

  @override
  void receiveDataFromBle(Uint8List data, String? macAddress, int type) {
    //响应数据 , Mac地址为多设备操作数据准备，目前C库不能多设备通信
    _cLibManager.cLib.receiveDataFromBle(data: data, type: type);
  }

  @override
  void writeDataComplete() {
    //写入数据完成，执行下一个包发送
    _cLibManager.cLib.tranDataSendComplete();
  }

  @override
  void writeDataToBle(void Function(CmdRequest data) func) {
    logger?.d('writeDataToBle()');
    _callbackWriteDataToBle = func;
  }

  @override
  void cRequestCmd(void Function(int evtType, int error, int val) func) {
    logger?.d('cRequestCmd()');
    _callbackCRequestCmd = func;
  }

  @override
  void cRequestCmdExt(void Function(int evtType, int error, int val) func) {
    logger?.d('cRequestCmdExt()');
    _callbackCRequestCmdExt = func;
  }

  @override
  StreamSubscription<int> fastSyncComplete(void Function(int errorCode) func) {
    logger?.d('register fastSyncComplete func');
    //logger?.d('core 快速配置完成回调 3');
    return _subjectFastSyncComplete.stream.listen(func);
    // _callbackFastSyncComplete = func;
  }

  @override
  bool get isFastSyncComplete =>
      _cLibManager.cLib.getSyncConfigStatus() == 0 ? true : false;

  @override
  int cleanProtocolQueue() {
    logger?.d('clean clib queue');
    return _cLibManager.cLib.cleanProtocolQueue();
  }

  @override
  int stopSyncConfig() {
    logger?.d('stop sync config');
    return _cLibManager.cLib.stopSyncConfig();
  }

  @override
  initLogs({bool outputToConsoleClib = false}) {
    Executor.showLog = false;
    final log = LoggerSingle();
    assert(
        log.config != null, 'You need to call LoggerSingle.configLogger(...)');
    if (log.config != null) {
      logger = log;
      IDOProtocolAPI().initLogs(outputToConsoleClib: outputToConsoleClib);
    }
  }

  @override
  int setProtocolGetFlashLogSetTime(int time) {
    return _cLibManager.cLib.setProtocolGetFlashLogSetTime(time);
  }
}

extension _IDOProtocolCoreManagerExt on _IDOProtocolCoreManager {
  /// 执行指令task
  Future<CmdResponse> _execCmd(
      int evtBase, int evtType, String json, Stream notification) async {
    final task = CommandTask.create(evtType, evtBase, json);
    notification.listen((event) {
      if (event is String && event == 'kill') {
        logger?.d('kill current task evtType:$evtType');
        task.cancel();
      }
    });
    final rs = await task.call();
    logger?.v("cmd - done $evtType, queue: ${_queueCmd.getQueueList()}");
    return rs;
  }

  /// 执行数据同步task
  Future<CmdResponse> _execSyncs(
      SyncType syncType,
      SyncProgressCallback progressCallback,
      SyncDataCallback dataCallback,
      Stream notification) async {
    final task = SyncTask.create(syncType, progressCallback, dataCallback);
    notification.listen((event) {
      if (event is String && event == 'kill') {
        logger?.d('sync task kill syncType:$syncType');
        task.cancel();
      }
    });
    return await task.call();
  }

  /// 执行日志task
  Future<CmdResponse> _execLogs(
      LogType logType, String dirPath, Stream notification) async {
    final task = LogTask.create(logType, dirPath);
    notification.listen((event) {
      if (event is String && event == 'kill') {
        logger?.d('log task kill logType:$logType');
        task.cancel();
      }
    });
    return await task.call();
  }

  /// 执行文件传输task
  Future<CmdResponse> _execTrans(
      FileTranItem fileTranItem,
      FileTranStatusCallback statusCallback,
      FileTranProgressCallback progressCallback,
      Stream notification) async {
    final task =
        FileTask.create(fileTranItem, statusCallback, progressCallback);
    notification.listen((event) {
      if (event is String && event == 'kill') {
        logger?.d('trans task kill filePath:${fileTranItem.filePath}');
        task.cancel();
      }
    });
    return await task.call();
  }

  CmdResponse _onDispose([bool? stop]) {
    final isStop = stop ?? false;
    return CmdResponse(
        code: isStop ? ErrorCode.task_interrupted : ErrorCode.canceled);
  }

  /// 文件优先级 -> task优先级
  WorkPriority _mapFileTranPriority(FileTranItem fileTranItem) {
    var priority = WorkPriority.high;
    switch (fileTranItem.tranPriority) {
      case FileTranPriority.high:
        priority = WorkPriority.veryHigh;
        break;
      case FileTranPriority.veryHigh:
        priority = WorkPriority.immediately;
        break;
      default:
        break;
    }
    return priority;
  }

  void _registerStreamListen() {
    logger?.d('core _registerStreamListen');
    // 写数据到蓝牙设备
    _cLibManager.streamWriteData.stream.listen((tuple) {
      // logger?.d(
      //     'core streamWriteData listen data:${tuple.item1} type:${tuple.item2}');
      if (_callbackWriteDataToBle != null) {
        // type 0:BLE数据 1:SPP数据
        final req =
            CmdRequest(data: tuple.item1, type: tuple.item2, macAddress: '');
        _callbackWriteDataToBle!(req);
      }
    });

    // C库请求命令快速配置
    _cLibManager.streamCNoticeCmd.stream.listen((tuple) {
      logger?.d('core streamCNoticeCmd listen data:$tuple');
      if (_callbackCRequestCmd != null) {
        _callbackCRequestCmd!(tuple.item1, tuple.item2, tuple.item3);
      }
    });

    // C库通知
    _cLibManager.streamCNoticeCmdExt.stream.listen((tuple) {
      logger?.d('core streamCNoticeCmdExt listen data:$tuple');
      _callbackCRequestCmdExt?.call(tuple.item1, tuple.item2, tuple.item3);
    });

    // 快速配置完成回调
    _cLibManager.streamFastSyncComplete.stream.listen((errCode) {
      logger?.d('core streamFastSyncComplete listen data:$errCode');
      if (_subjectFastSyncComplete.hasListener) {
        //logger?.d('core 快速配置完成回调 4');
        _subjectFastSyncComplete.add(errCode);
      } else {
        logger?.e('core 快速配置完成回调 4 失败');
        logger?.e('core _callbackFastSyncComplete is null');
      }
      // if (_callbackFastSyncComplete != null) {
      //   logger?.e('core 快速配置完成回调 4');
      //   _callbackFastSyncComplete!(errCode);
      // }else {
      //   logger?.e('core 快速配置完成回调 4 失败');
      //   logger?.e('core _callbackFastSyncComplete is null');
      // }
    });

    // 监听设备状态
    _cLibManager.streamListenReceiveData.stream.listen((tuple) {
      //logger?.v('streamListenReceiveData.stream.listen');
      if (tuple.item2 >= 551 && tuple.item2 <= 591) {
        // 有效区间事件才需要打印log
        logger?.v('controlEvent ${[tuple.item1, tuple.item2, tuple.item3]}');
      }
      if (tuple.item2 == 577) {
        final json = tuple.item3;
        final map = jsonDecode(json) as Map<String, dynamic>;
        final dataType = map['data_type'] as int;
        if (_subjectDeviceState.hasListener) {
          _subjectDeviceState.add(dataType);
          //logger?.v('_subjectDeviceState.hasListener true');
        } else {
          logger?.v('_subjectDeviceState.hasListener false');
        }
      }
      if (_subjectControlEvent.hasListener) {
        _subjectControlEvent.add(tuple);
        //logger?.v('_subjectControlEvent.hasListener true');
      } else {
        logger?.v('_subjectControlEvent.hasListener false');
      }
    });
  }

  WorkPriority _mapCmdPriority(CmdPriority priority) {
    var rs = WorkPriority.highRegular;
    switch (priority) {
      case CmdPriority.normal:
        break;
      case CmdPriority.high:
        rs = WorkPriority.high;
        break;
      case CmdPriority.veryHigh:
        rs = WorkPriority.veryHigh;
        break;
    }
    return rs;
  }
}
