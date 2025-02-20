part of '../ido_protocol_core.dart';

typedef CallbackWriteDataToBle = void Function(CmdRequest data);
typedef CallbackCRequestCmd = void Function(int evtType, int error, int val);
typedef CallbackFastSyncComplete = void Function(int errorCode);

class _IDOProtocolCoreManager implements IDOProtocolCoreManager {
  late final _queueCmd = Executor();
  late final _queueSync = Executor();
  late final _queueLog = Executor();
  late final _queueTrans = Executor();
  late final _taskTool = _ListTaskTool();
  // //数据响应接口
  late final _cLibManager = IDOProtocolClibManager();
  late final _subjectDeviceState = StreamController<int>.broadcast();
  late final _subjectControlEvent =
  StreamController<Tuple3<int, int, String>>.broadcast();
  late final _subjectFastSyncComplete = StreamController<int>.broadcast();
  late final _subjectOnBeforeDeviceDisconnect = StreamController<void>.broadcast();

  late final _sppManager = SppTransManager();

  @override
  SifliChannelImpl? sifliChannel;

  /// 不使用队列且不需要响应的指令
  ///
  /// 数据交换相关：620, 624, 626, 628, 622, 5055, 610, 612, 614
  /// 快速短信回复：580
  /// 设置v2/v3热启动参数：158, 5070
  late final _noQueueNoResCmds = [620, 624, 626, 628, 622, 5055, 610, 612, 614, 580, 158, 5070];

  /// 不使用队列但需要响应的指令
  ///
  /// 数据交换相关：600, 604, 608, 606, 602, 5021, 5056, 5023, 5022
  late final _noQueueHasResCmds = [600, 604, 608, 606, 602, 5021, 5056, 5023, 5022];

  CallbackWriteDataToBle? _callbackWriteDataToBle;
  CallbackCRequestCmd? _callbackCRequestCmd;
  // CallbackFastSyncComplete? _callbackFastSyncComplete;
  CallbackCRequestCmd? _callbackCRequestCmdExt;

  FileTranRequestCallback? _callbackDevice2AppRequest;
  FileTranProgressCallback? _callbackDevice2AppProgress;
  FileTranStatusCallback? _callbackDevice2AppStatus;

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
    _initSppTransManager();
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
    if (!useQueue || _noQueueNoResCmds.contains(evtType)) {
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
      if (evtType == 2) {
        _subjectOnBeforeDeviceDisconnect.add(null);
      }
      return CancelableOperation<CmdResponse>.fromFuture(
          Future(() => CmdResponse(code: ErrorCode.success)),
          onCancel: () {});
    }

    // 数据交换相关指令特殊处理(不使用队列）
    if (_noQueueHasResCmds.contains(evtType)) {
      if (cmdMap != null) {
        logger?.v('exchange cmd - ${cmdMap["cmd"]} "${cmdMap["desc"]}"');
      }
      final exchangeTask = ExchangeTask.create(evtType, evtBase, json);
      return CancelableOperation<CmdResponse>.fromFuture(_taskTool.addTask(exchangeTask),
          onCancel: () {
            logger?.d('exchange CancelableOperation cancel, evtType:$evtType');
            exchangeTask.cancel();
            logger?.v("exchange cmd - cancel $evtType");
          });
    }

    // SKG定制功能，app确认绑定结果
    if (evtType == 206) {
      if (cmdMap != null) {
        logger?.v('cmd - ${cmdMap["cmd"]} "${cmdMap["desc"]}"');
      }
      final cmdTask = CommandTask.create(evtType, evtBase, json);
      return CancelableOperation<CmdResponse>.fromFuture(_taskTool.addTask(cmdTask),
          onCancel: () {
            logger?.d('CancelableOperation cancel, evtType:$evtType');
            cmdTask.cancel();
            logger?.v("cmd - cancel $evtType");
          });
    }

    // 基础指令不使用队列（代码保留 不要删）
    // else {
    //   if (cmdMap != null) {
    //     logger?.v('cmd - ${cmdMap["cmd"]} "${cmdMap["desc"]}"');
    //   }
    //   final cmdTask = CommandTask.create(evtType, evtBase, json);
    //   return CancelableOperation<CmdResponse>.fromFuture(_taskTool.addTask(cmdTask),
    //       onCancel: () {
    //         logger?.d('CancelableOperation cancel, evtType:$evtType');
    //         cmdTask.cancel();
    //         logger?.v("cmd - cancel $evtType");
    //       });
    // }

    // 过滤重复指令不超过3个
    if (_queueCmd.findTaskCount(evtBase: evtBase, evtType: evtType, json: json) >=
        _maxSameCmdTaskCount) {
      logger?.w("同一指令$evtType超过队列$_maxSameCmdTaskCount个限制, json:$json");
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
  CancelableOperation<CmdResponse> sync({
    List<int> selectTypes = const [],
        required SyncType type,
        required SyncProgressCallback progressCallback,
        required SyncDataCallback dataCallback}) {
    // 数据同步的优先级要低于基础指令
    Cancelable<CmdResponse>? rs;
    return CancelableOperation<CmdResponse>.fromFuture(
        (rs = _queueSync.execute(
          arg1: selectTypes,
          arg2: type,
          arg3: progressCallback,
          arg4: dataCallback,
          fun4: _execSyncs,
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
      {required LogType type,
        required String dirPath,
        LogProgressCallback? progressCallback}) {
    Cancelable<CmdResponse>? rs;
    return CancelableOperation<CmdResponse>.fromFuture(
        (rs = _queueLog.execute(
          arg1: type,
          arg2: dirPath,
          arg3: progressCallback,
          fun3: _execLogs,
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
  StreamSubscription listenOnBeforeDeviceDisconnect(void Function(void) func) {
    return _subjectOnBeforeDeviceDisconnect.stream.listen(func);
  }

  @override
  void dispose({bool needKeepTransFileTask = false}) {
    _queueCmd.dispose();
    _queueSync.dispose();
    _queueLog.dispose();
    if (!needKeepTransFileTask) {
      _queueTrans.dispose();
    }else{
      logger?.d("platform is 97|98|99, needKeepTransFileTask is true, ignore queueTrans.dispose()");
    }
    _taskTool.cancelAll();
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
    //拦截spp或根据条件放行
    if (type == 1 && _sppManager.interceptCmd(data)) {
      _sppManager.receivedData(data);
    } else {
      _cLibManager.cLib.receiveDataFromBle(data: data, type: type);
    }
  }

  @override
  void writeDataComplete() {
    //写入数据完成，执行下一个包发送
    _cLibManager.cLib.tranDataSendComplete();
  }

  @override
  void writeSppDataComplete() {
    _sppManager.sppDataTransComplete();
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

  @override
  int writeRawData({required Uint8List data}) {
    return _cLibManager.cLib.writeRawData(data: data);
  }

  @override
  void registerDeviceTranFileToApp({
    required FileTranRequestCallback requestCallback}) {
    _callbackDevice2AppRequest = requestCallback;
  }

  @override
  void unregisterDeviceTranFileToApp() {
    _callbackDevice2AppRequest = null;
    _callbackDevice2AppProgress = null;
    _callbackDevice2AppStatus = null;
  }

  @override
  void listenDeviceTranFileToApp({
    required FileTranProgressCallback progressCallback,
    required FileTranStatusCallback statusCallback,
  }) {
    _callbackDevice2AppProgress = progressCallback;
    _callbackDevice2AppStatus = statusCallback;
  }

  @override
  void initSifliChannel() {
    if (sifliChannel == null) {
      logger?.d("init sifli channel");
      sifliChannel = SifliChannelImpl();
      ApiSifliFlutter.setup(sifliChannel!);
    }
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
      List<int> types,
      SyncType syncType,
      SyncProgressCallback progressCallback,
      SyncDataCallback dataCallback,
      Stream notification) async {
    final task = SyncTask.create(syncType, progressCallback, dataCallback);
    task.selectTypes = types;
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
      LogType logType,
      String dirPath,
      LogProgressCallback? progressCallback,
      Stream notification) async {
    final task = LogTask.create(logType, dirPath,progressCallback);
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
      // 有效区间事件才需要打印log
      if (tuple.item2 >= 551 && tuple.item2 <= 591) {
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

    _cLibManager.streamDataTranToAppComplete.stream.listen((event) {
      if (_callbackDevice2AppRequest != null) {
        _callbackDevice2AppStatus?.call(event, 0);
      }
    });

    _cLibManager.streamDataTranToAppProgress.stream.listen((event) {
      if (_callbackDevice2AppRequest != null) {
        _callbackDevice2AppProgress?.call(event/100.0);
      }
    });

    _cLibManager.streamDataTranToAppRequest.stream.listen((event) {
      _callbackDevice2AppRequest?.call(event);
    });
  }

  WorkPriority _mapCmdPriority(CmdPriority priority) {
    var rs = WorkPriority.highRegular;
    switch (priority) {
      case CmdPriority.low:
        rs = WorkPriority.regular;
        break;
      case CmdPriority.normal:
        rs = WorkPriority.highRegular;
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

  void _initSppTransManager() {
    _sppManager.initSpp();
    _sppManager.registerCoreBridge(
        inOtaMode: () => _cLibManager.cLib.getBindMode() == 2,
        supportContinueTrans: () => _cLibManager.cLib.getIsSupportTranContinue(),
        writer: (data) {
          if (_callbackWriteDataToBle != null) {
            _callbackWriteDataToBle!(
                CmdRequest(data: data, type: 1, macAddress: ''));
          }
        });
    listenOnBeforeDeviceDisconnect((p0) {
      _sppManager.onDisconnect();
    });
  }
}

class _ListTaskTool<T extends BaseTask> {
  late List<T> _taskList;

  _ListTaskTool() {
    _taskList = [];
  }

  Future<CmdResponse> addTask(T task) async {
    _taskList.add(task);
    return _executeTask(task);
  }

  Future<CmdResponse> _executeTask(T task) async {
    final result = await task.call();
    _taskList.remove(task);
    return result;
  }

  void cancelAll() {
    for (var e in _taskList) {
      e.cancel();
    }
    _taskList.clear();
  }

}