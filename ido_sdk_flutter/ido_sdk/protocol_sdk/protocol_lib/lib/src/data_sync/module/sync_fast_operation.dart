import 'dart:async';

import 'package:protocol_core/protocol_core.dart';
import 'package:protocol_lib/src/private/logger/logger.dart';
import '../../ido_protocol_lib.dart';

abstract class AbstractSyncFast {
  //监听快速配置完成
  Future<bool> listenSyncFastComplete();
}

class SyncFastOperation extends AbstractSyncFast {
  late final _coreMgr = IDOProtocolCoreManager();
  late final _libMgr = IDOProtocolLibManager();
  late final _funTable = _libMgr.funTable;
  StreamSubscription<int>? _subscriptFastSyncComplete;
  @override
  Future<bool> listenSyncFastComplete() async {
    Completer<bool> completer = Completer();
    if (!_coreMgr.isFastSyncComplete) {
      return Future<bool>(() {
        _subscriptFastSyncComplete?.cancel();
        _subscriptFastSyncComplete =  _coreMgr.fastSyncComplete((errorCode) {
          if (!completer.isCompleted) {
            completer.complete(true);
          }
        });
        return completer.future;
      }).timeout(const Duration(seconds: 3), onTimeout: () async {
        logger?.d('the function table is refreshed again after the fast data synchronization configuration times out');
        //超时3秒重新刷新功能表
        await _funTable.refreshFuncTable();
        _subscriptFastSyncComplete?.cancel();
        if (!completer.isCompleted) {
          completer.complete(true);
        }
        return completer.future;
      });
    } else {
      completer.complete(true);
      return completer.future;
    }
  }
}
