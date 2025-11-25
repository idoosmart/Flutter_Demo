import 'dart:async';
import 'dart:convert';

import 'package:protocol_ffi/protocol_ffi.dart';
import 'package:protocol_core/protocol_core.dart';

import '../logger/logger.dart';

import 'base_task.dart';

class CommandTask extends BaseTask {
  TaskStatus _status = TaskStatus.waiting;
  final int evtType;
  final int baseType;
  late final String? jsonStr;
  Completer<CmdResponse>? _completer;
  StreamSubscription? _streamSubscription;

  CommandTask.create(this.evtType, this.baseType, this.jsonStr)
      : super.create();

  @override
  Future<CmdResponse> call() async {
    // 绑定接口特殊处理，超时设置为35秒
    final timeoutSecond = evtType == 200 ? 35 : 20;
    return _exec().timeout(Duration(seconds: timeoutSecond), onTimeout: () {
      return _onTimeout();
    });
  }

  @override
  cancel() {
    _status = TaskStatus.canceled;
    _streamSubscription?.cancel();
    if (_completer != null && !_completer!.isCompleted) {
      final res = CmdResponse(code: ErrorCode.canceled);
      _completer!.complete(res);
      _completer = null;
    }
  }

  @override
  TaskStatus get status => _status;
}

extension _CommandTask on CommandTask {
  Future<CmdResponse> _exec() {
    _status = TaskStatus.running;
    logger?.d('request evtType:$evtType json:${jsonStr}');

    _completer = Completer<CmdResponse>();

    // 注册回调监听
    _streamSubscription = coreManager.streamReceiveData.stream.listen((tuple) {
      logger?.d(
          'call coreManager.streamReceiveData.stream.listen  eventType == ${tuple.item2} currentType == ${evtType}');
      if (tuple.item2 != evtType && tuple.item2 != 2) {
        //logger?.d('not match evtType number, send:${evtType} back:${tuple.item2}');
        return;
      }
      var errorCode = tuple.item1;
      if (tuple.item2 == 2) {
        // 设备断线C库返回断线回调
        errorCode = -1;
      }
      _status = TaskStatus.finished;
      //logger?.d('response evtType:${tuple.item2} code:$errorCode json:${evtType != 303 ? (tuple.item3 == 'null\n' ? '' : tuple.item3) : 'too more...'}');
      logger?.d(
          'response evtType:${tuple.item2} code:$errorCode json:${tuple.item3}');
      // logger?.d('cmd response evtType:${event[1]} data: ${event[2]} } errorCode:${event[0]}');
      String? json;
      if (tuple.item3.trimLeft().startsWith("{")) {
        json = tuple.item3;
      }

      // 添加返回结果修改
      json = _updateJsonContentIfNeed(errorCode, tuple.item2, json);

      final res =
          CmdResponse(code: errorCode, evtType: tuple.item2, json: json);
      _completer?.complete(res);
      _completer = null;
      _streamSubscription?.cancel();
    });

    // 发送指令
    int rs = coreManager.cLib.writeJsonData(
        json: jsonStr ?? '{}', evtType: evtType, evtBase: baseType);

    if (rs != 0) {
      //timer.cancel();
      _streamSubscription?.cancel();
      final res = CmdResponse(
          code: rs, msg: 'call coreManager.cLib.writeJsonData() failed');
      _completer?.complete(res);
      return _completer!.future;
    }

    // logger?.d('end call evtType:$evtType baseType:$baseType 0x${baseType.toRadixString(16)}');

    return _completer!.future;
  }

  _onTimeout() {
    logger?.d('timeout evtType:$evtType');
    _status = TaskStatus.timeout;
    _streamSubscription?.cancel();
    final res = CmdResponse(code: ErrorCode.timeout);
    _completer?.complete(res);
    return _completer?.future;
  }

  String? _updateJsonContentIfNeed(int errorCode, int evtType, String? json) {
    if (errorCode != 0) return json;

    // 312（getGpsInfo） 获取gps信息, 根据fw_version值提取并转换为XX.XX.XX格式
    if (evtType == 312 && json != null && json.isNotEmpty) {
      try {
        final map = jsonDecode(json);
        final fwVersion = map["fw_version"];
        if (fwVersion != null) {
          final strVer = _getGpsThirdVersion(fwVersion as int);
          map["fw_version_str"] = strVer;
          json = jsonEncode(map);
          logger?.d("add 'fw_version_str' ");
          logger?.d(
              'new response evtType:$evtType code:$errorCode json:$json');
        }
      }catch(e) {
        logger?.e('312（getGpsInfo）change fw_version failed');
      }
    }
    return json;
  }

  /// gps版本转为字符串
  String _getGpsThirdVersion(int gpsVersion) {
    String version = "";
    if (gpsVersion > 0) {
      // 低8位
      final int firstCode = gpsVersion & 0xFF;
      final int secondCode = (gpsVersion >> 8) & 0xFF;
      final int thirdCode = (gpsVersion >> 16) & 0xFF;
      if (thirdCode > 0 || secondCode > 0) {
        String secondCodeStr = secondCode.toString().padLeft(2, '0');
        String firstCodeStr = firstCode.toString().padLeft(2, '0');
        version = "$thirdCode.$secondCodeStr.$firstCodeStr";
      } else if (firstCode > 0) {
        version = "$firstCode.00.00";
      }
    }
    return version;
  }

}

// ExchangeTask
class ExchangeTask extends BaseTask {
  TaskStatus _status = TaskStatus.waiting;
  final int evtType;
  final int baseType;
  late final String? jsonStr;
  Completer<CmdResponse>? _completer;
  StreamSubscription? _streamSubscription;

  ExchangeTask.create(this.evtType, this.baseType, this.jsonStr)
      : super.create();

  @override
  Future<CmdResponse> call() async {
    // fix: 12 -> 60s, 12秒太短，现调整为60
    return _exec().timeout(const Duration(seconds: 60), onTimeout: () {
      return _onTimeout();
    });
  }

  @override
  cancel() {
    _status = TaskStatus.canceled;
    _streamSubscription?.cancel();
    if (_completer != null && !_completer!.isCompleted) {
      final res = CmdResponse(code: ErrorCode.canceled);
      _completer!.complete(res);
      _completer = null;
    }
  }

  @override
  TaskStatus get status => _status;
}

extension _ExchangeTask on ExchangeTask {
  Future<CmdResponse> _exec() {
    _status = TaskStatus.running;
    logger?.d('exchange - request evtType:$evtType json:$jsonStr');

    _completer = Completer<CmdResponse>();

    // 注册回调监听
    _streamSubscription = coreManager.streamReceiveData.stream.listen((tuple) {
      logger?.d(
          'exchange - call coreManager.streamReceiveData.stream.listen  eventType == ${tuple.item2} currentType == ${evtType}');
      if (tuple.item2 != evtType && tuple.item2 != 2) {
        //logger?.d('not match evtType number, send:${evtType} back:${tuple.item2}');
        return;
      }
      var errorCode = tuple.item1;
      if (tuple.item2 == 2) {
        // 设备断线C库返回断线回调
        errorCode = -1;
      }
      _status = TaskStatus.finished;
      //logger?.d('response evtType:${tuple.item2} code:$errorCode json:${evtType != 303 ? (tuple.item3 == 'null\n' ? '' : tuple.item3) : 'too more...'}');
      logger?.d(
          'exchange - response evtType:${tuple.item2} code:$errorCode json:${tuple.item3 == 'null\n' ? '' : tuple.item3}');
      // logger?.d('cmd response evtType:${event[1]} data: ${event[2]} } errorCode:${event[0]}');
      final res =
          CmdResponse(code: errorCode, evtType: tuple.item2, json: tuple.item3);
      _completer?.complete(res);
      _completer = null;
      _streamSubscription?.cancel();
    });

    // 发送指令
    int rs = coreManager.cLib.writeJsonData(
        json: jsonStr ?? '{}', evtType: evtType, evtBase: baseType);

    if (rs != 0) {
      //timer.cancel();
      _streamSubscription?.cancel();
      final res = CmdResponse(
          code: rs,
          msg: 'exchange - call coreManager.cLib.writeJsonData() failed');
      _completer?.complete(res);
      return _completer!.future;
    }

    // logger?.d('end call evtType:$evtType baseType:$baseType 0x${baseType.toRadixString(16)}');

    return _completer!.future;
  }

  _onTimeout() {
    logger?.d('exchange - timeout evtType:$evtType');
    _status = TaskStatus.timeout;
    _streamSubscription?.cancel();
    final res = CmdResponse(code: ErrorCode.timeout);
    _completer?.complete(res);
    return _completer?.future;
  }
}
