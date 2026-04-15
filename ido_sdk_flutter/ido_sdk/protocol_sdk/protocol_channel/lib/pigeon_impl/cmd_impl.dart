import 'dart:async';

import 'package:protocol_lib/protocol_lib.dart';

import '../pigeon_generate/cmd.g.dart';

class CmdImpl extends Cmd {
  final _cmdTask = <String, StreamSubscription<dynamic>>{};

  @override
  void cancelSend(CancelToken cancelToken) {
    _cancelToken(cancelToken);
  }

  @override
  Future<Response> send(
      int evtType, String? json, CancelToken? cancelToken, int? priority) {
    final cmd = CmdEvtType.fromRawValue(evtType);
    if (cmd == null) {
      assert(false, '**Unrecognized instructions evtType:$evtType');
      return Future.value(Response(code: -6, json: null));
    }
    final completer = Completer<Response>();
    var cmdPriority = IDOCmdPriority.normal;
    if (priority != null) {
      // 0: low， 1: normal， 2: high，3： veryHigh
      switch (priority) {
        case 0:
          cmdPriority = IDOCmdPriority.low;
          break;
        case 1:
          cmdPriority = IDOCmdPriority.normal;
          break;
        case 2:
          cmdPriority = IDOCmdPriority.high;
          break;
        case 3:
          cmdPriority = IDOCmdPriority.veryHigh;
          break;
      }
    }
    final subscript = libManager
        .send(evt: cmd, json: json, priority: cmdPriority)
        .listen((event) {
          var json = event.json ?? "{}";
          if (event.code == 0 && event.json == 'null\n') {
            json = "{}";
          }
      completer.complete(Response(code: event.code, json: json));
      _cleanToken(cancelToken);
    });
    if (cancelToken != null) {
      _cmdTask[cancelToken.token!] = subscript;
    }
    return completer.future;
  }

  void _cancelToken(CancelToken? cancelToken) {
    if (cancelToken != null && cancelToken.token != null) {
      _cmdTask[cancelToken.token]?.cancel();
      _cmdTask.remove(cancelToken.token!);
    }
  }

  void _cleanToken(CancelToken? cancelToken) {
    if (cancelToken != null && cancelToken.token != null) {
      _cmdTask.remove(cancelToken.token!);
    }
  }
}
