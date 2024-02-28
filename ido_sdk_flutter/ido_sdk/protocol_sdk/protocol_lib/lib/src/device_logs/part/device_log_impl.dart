part of '../ido_device_log.dart';

class _IDODeviceLog implements IDODeviceLog {
  static final _instance = _IDODeviceLog._internal();

  _IDODeviceLog._internal() {
    _init();
  }

  factory _IDODeviceLog() => _instance;
  late final _coreMgr = IDOProtocolCoreManager();
  late final _libMgr = IDOProtocolLibManager();
  late final _streamStatus = StreamController<bool>.broadcast();
  late final _streamPath = StreamController<String>.broadcast();

  StreamSubscription? _logStreamSubscription;

  Completer<bool>? _completer;
  bool _getLogIng = false;

  set __getLogIng(bool val) {
    _getLogIng = val;
    _streamStatus.add(val);
  }

  final _flashTypes = [
    LogType.general,
    LogType.restart,
    LogType.reset,
    LogType.hardware,
    LogType.algorithm
  ];
  late DeviceLogProgressCallback? _progressCallback;

  void _init() async {
    _libMgr.listenStatusNotification((status) async{
     if (status == IDOStatusNotification.protocolConnectCompleted) {
       final path = await _getLogDirPath();
       _streamPath.add(path);
     }
    });
  }

  Future<String> _getLogDirPath() async {
    return storage!.pathDeviceLog();
  }

  @override
  Future<String> get logDirPath => _getLogDirPath();

  @override
  Stream<bool> startGet(
      {required List<IDOLogType> types,
      int timeOut = 60,
      LogProgressCallback? progressCallback}) {
    if (!IDOProtocolLibManager().isConnected) {
      return Future(() => false).asStream();
    }
    __getLogIng = true;
    _coreMgr.setProtocolGetFlashLogSetTime(timeOut);
    _progressCallback = progressCallback;
    _progressCallback ??= (int progress){};
    _completer = Completer();
    final stream = CancelableOperation.fromFuture(_exec(types), onCancel: () {
      _completer?.complete(false);
      _completer = null;
    }).asStream();
    return stream;
  }

  @override
  void cancel() {
    _logStreamSubscription?.cancel();
  }

  @override
  bool get getLogIng => _getLogIng;

  @override
  Stream<String> listenLogDirPath() {
    return _streamPath.stream;
  }

  @override
  Stream<bool> listenLogIng() {
    return _streamStatus.stream;
  }
}

extension _IDODeviceLogExt on _IDODeviceLog {
  String _supportWithLogType(IDOLogType type) {
    if (type == IDOLogType.general ||
        type == IDOLogType.reset ||
        type == IDOLogType.hardware ||
        type == IDOLogType.algorithm ||
        type == IDOLogType.restart) {
      final support = true; //_libMgr.funTable.getFlashLog; // 该功能由业务层判定
      return support ? '' : 'flash log obtaining is not supported';
    } else if (type == IDOLogType.battery) {
      final support = _libMgr.funTable.getBatteryLog;
      return support ? '' : 'battery log obtaining is not supported';
    } else if (type == IDOLogType.heat) {
      final support = _libMgr.funTable.getHeatLog;
      return support ? '' : 'heat log obtaining is not supported';
    }
    return '';
  }

  Future<bool> _exec(List<IDOLogType> types) async {
    Set<IDOLogType> supportSet = {};
    var error = false;
    try {
      for (var element in types) {
        final str = _supportWithLogType(element);
        if (str.isNotEmpty) {
          error = true;
        } else {
          if (_flashTypes.contains(element)) {
            supportSet.add(IDOLogType.general);
          } else {
            supportSet.add(element);
          }
        }
      }
    } catch (e) {
      logger?.e("get device log error == $e");
      Future.delayed(const Duration(seconds: 1), () {
        __getLogIng = false;
        _completer?.complete(false);
        _completer = null;
      });
    }
    if (!error) {
      logger?.d("get device log type == $types");

      /// 进入快速模式
      // _switchMode(1);
      final streamList = <Stream<CmdResponse>>[];
      final path = await logDirPath;
      for (var element in supportSet) {
        final logStream = _coreMgr
            .deviceLog(
                type: LogType.values[element.index],
                dirPath: path,
                progressCallback: _progressCallback)
            .asStream();
        streamList.add(logStream);
      }
      _logStreamSubscription = Rx.combineLatestList(streamList)
          .map((event) => event.last)
          .listen((event) {
        __getLogIng = false;
        _completer?.complete(event.code == 0);
        _completer = null;

        /// 结束快速模式
        // _switchMode(2);
      });
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        __getLogIng = false;
        _completer?.complete(false);
        _completer = null;
      });
    }
    return _completer!.future;
  }

  /// 切换模式
  Future<bool> _switchMode(int mode) async {
    if (_libMgr.funTable.getDeviceControlFastModeAlone) {
      logger?.v("设备日志获取，开启快速模式 由设备控制，无需app处理");
      return true;
    }
    final res = await _libMgr
        .send(evt: CmdEvtType.setConnParam, json: _jsonChangeMode(mode))
        .first;
    return res.code == 0;
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
}
