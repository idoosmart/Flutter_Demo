part of '../ido_device_log.dart';

class _IDODeviceLog implements IDODeviceLog {
  static final _instance = _IDODeviceLog._internal();
  _IDODeviceLog._internal();
  factory _IDODeviceLog() => _instance;
  late final _coreMgr = IDOProtocolCoreManager();
  late final _libMgr = IDOProtocolLibManager();
  StreamSubscription? _logStreamSubscription;
  Completer<bool>? _completer;
  bool _getLogIng = false;

  Future<String> _getLogDirPath() async {
    return storage!.pathDeviceLog();
  }

  @override
  Future<String> get logDirPath  => _getLogDirPath();

  @override
  Stream<bool> startGet({required List<IDOLogType> types, int timeOut = 60}) {
    if (!IDOProtocolLibManager().isConnected) {
      return Future(() => false).asStream();
    }
    _getLogIng = true;
    _coreMgr.setProtocolGetFlashLogSetTime(timeOut);
    _completer = Completer();
    final stream = CancelableOperation.fromFuture(
        _exec(types),
        onCancel: () {
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

}

extension _IDODeviceLogExt on _IDODeviceLog {

  String _supportWithLogType(IDOLogType type) {
    if (   type == IDOLogType.general
        || type == IDOLogType.reset
        || type == IDOLogType.hardware
        || type == IDOLogType.algorithm
        || type == IDOLogType.restart) {
      final support = true;//_libMgr.funTable.getFlashLog; // 该功能由业务层判定
      return support ? '' : 'flash log obtaining is not supported';
    }else if (type == IDOLogType.battery) {
      final support = _libMgr.funTable.getBatteryLog;
      return support ? '' : 'battery log obtaining is not supported';
    }else if (type == IDOLogType.heat) {
      final support = _libMgr.funTable.getHeatLog;
      return support ? '' : 'heat log obtaining is not supported';
    }
    return '';
  }

  Future<bool> _exec(List<IDOLogType> types) async {
    final supportList = <IDOLogType>[];
    var error = false;
    try {
      for (var element in types) {
        final str = _supportWithLogType(element);
        if (str.isNotEmpty) {
          error = true;
        }else {
          supportList.add(element);
        }
      }
    } catch(e) {
      _completer!.completeError(e);
    }
    if (!error) {
      logger?.d("get device log type == $types");
      final streamList = <Stream<CmdResponse>>[];
      final path = await logDirPath;
      for (var element in supportList) {
        final logStream = _coreMgr.deviceLog(type: LogType.values[element.index],dirPath: path).asStream();
        streamList.add(logStream);
      }
      _logStreamSubscription = Rx.combineLatestList(streamList).map((event) => event.last).listen((event) {
        _getLogIng = false;
        _completer?.complete(event.code == 0);
        _completer = null;
      });
    }else {
      Future.delayed(const Duration(seconds: 1),(){
        _getLogIng = false;
        _completer?.complete(false);
        _completer = null;
      });
    }
    return _completer!.future;
  }
}