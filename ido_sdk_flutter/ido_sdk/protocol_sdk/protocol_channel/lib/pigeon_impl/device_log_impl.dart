import 'package:protocol_lib/protocol_lib.dart';

import '../pigeon_generate/device_log.g.dart';

class DeviceLogImpl extends DeviceLog {

  final _delegate = DeviceLogDelegate();

  DeviceLogImpl() {
    libManager.deviceLog.listenLogDirPath().listen((event) {
      _delegate.listenLogDirPath(event);
    });
    libManager.deviceLog.listenLogIng().listen((event) {
      _delegate.listenLogStatus(event);
    });
  }

  @override
  void cancel() {
    libManager.deviceLog.cancel();
  }

  @override
  bool getLogIng() {
    return libManager.deviceLog.getLogIng;
  }

  @override
  Future<String> logDirPath() async {
    return libManager.deviceLog.logDirPath;
  }

  @override
  Future<bool> startGet(List<int?> types, int timeOut) async {
    final list = <IDOLogType>[];
    for (final obj in types) {
      if (obj != null) {
        list.add(IDOLogType.values[obj]);
      }
    }
    return libManager.deviceLog.startGet(types: list,
        timeOut: timeOut,
        progressCallback:(int progress) {
       _delegate.callbackLogProgress(progress.toDouble());
    }).first;
  }
}
