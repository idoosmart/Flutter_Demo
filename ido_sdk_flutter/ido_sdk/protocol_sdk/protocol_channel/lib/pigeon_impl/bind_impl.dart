import 'dart:async';

import 'package:protocol_lib/protocol_lib.dart';

import '../pigeon_generate/bind.g.dart';
import '../pigeon_generate/device.g.dart';
import '../pigeon_generate/func_table.g.dart';
import 'func_table_ext.dart';
import 'device_impl.dart';

class BindImpl extends Bind {
  final delegateDeviceInfo = DeviceDelegate();
  final delegateFuncTable = FuncTableDelegate();

  StreamSubscription<dynamic>? _streamSubscription;
  Completer<int>? _completer;

  BindImpl() {
    libManager.deviceInfo.onDeviceInfoChanged((p0) {
      delegateDeviceInfo.listenDeviceChanged(libManager.deviceInfo.toDeviceInfo());
    });
    libManager.funTable.onFunctionTableChanged((p0) {
      delegateFuncTable.listenFuncTableChanged(libManager.funTable.toJsonString());
    });
  }

  @override
  Future<int> bind(int osVersion) async {
    _completer = Completer();
    _streamSubscription = libManager.deviceBind
        .startBind(
            osVersion: osVersion,
            deviceInfo: (d) {
              delegateDeviceInfo.listenDeviceOnBind(d.toDeviceInfo());
            },
            functionTable: (f) {
              delegateFuncTable.listenFuncTableOnBind(f.toJsonString());
            })
        .listen((event) {
      _completer?.complete(event.index);
      _completer = null;
    });
    return _completer!.future;
  }

  @override
  void cancelBind() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _completer = null;
    // skg设备发送206指令
    if (true) {
      libManager.send(evt: CmdEvtType.sendBindResult, json: '{"bind_result":1}');
    }
  }

  @override
  void appMarkBindResult(bool success) {
    libManager.deviceBind.appMarkBindResult(success: success);
  }

  @override
  Future<bool> isBinded() async {
    return libManager.deviceBind.isBinded;
  }

  @override
  bool isBinding() {
    return libManager.deviceBind.isBinding;
  }

  @override
  Future<bool> setAuthCode(String code, int osVersion) async {
    return libManager.deviceBind.setAuthCode(code, osVersion).first;
  }

  @override
  Future<bool> unbind(String macAddress, bool isForceRemove) async {
    return libManager.deviceBind
        .unbind(macAddress: macAddress, isForceRemove: isForceRemove);
  }
}
