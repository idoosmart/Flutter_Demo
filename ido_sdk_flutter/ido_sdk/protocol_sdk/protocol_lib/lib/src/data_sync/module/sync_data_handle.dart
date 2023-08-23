import 'dart:async';
import 'package:protocol_core/protocol_core.dart';
import 'package:rxdart/rxdart.dart';

import '../../ido_protocol_lib.dart';

/// 所有数据同步完成
typedef SyncCompletedCallback = void Function(int errorCode);

abstract class AbstractSyncData {
  final bool needSyncActivity;
  final bool needSyncGps;

  final SyncProgressCallback funcProgress;
  final SyncDataCallback funcData;
  final SyncCompletedCallback funcCompleted;

  AbstractSyncData(this.needSyncActivity, this.needSyncGps, this.funcProgress,
      this.funcData, this.funcCompleted);

  /// 开始同步所有数据
  Future<bool> start();

  /// 停止同步所有数据
  void stop();
}

class SyncDataHandle extends AbstractSyncData {
  late final _coreMgr = IDOProtocolCoreManager();
  late final _libMgr = IDOProtocolLibManager();
  late final _funTable = _libMgr.funTable;
  StreamSubscription? _syncStreamSubscription;

  SyncDataHandle(super.needSyncActivity, super.needSyncGps, super.funcProgress,
      super.funcData, super.funcCompleted);

  @override
  Future<bool> start() {
    return _exec();
  }

  @override
  void stop() {
    _syncStreamSubscription?.cancel();
  }
}

extension _IDOSyncDataExt on SyncDataHandle {
  // 判断功能表是否需要同步v2数据
  _isNeedSyncV2Data() {
    return _funTable.syncNeedV2 && _funTable.syncTimeLine;
  }

  // 判断功能表是否需要同步v3数据
  _isNeedSyncV3Data() {
    return _funTable.syncV3Hr ||
        _funTable.syncV3Sleep ||
        _funTable.syncV3Swim ||
        _funTable.syncV3Pressure ||
        _funTable.syncV3Activity ||
        _funTable.syncV3Gps ||
        _funTable.syncV3Sports ||
        _funTable.syncV3Spo2 ||
        _funTable.syncV3Noise ||
        _funTable.syncV3Temperature;
  }

  Future<bool> _exec() {
    final completer = Completer<bool>();
    final streamList = <Stream<CmdResponse>>[];
    if (_isNeedSyncV2Data()) {
      final healthStream = _coreMgr
          .sync(
              type: SyncType.v2Health,
              progressCallback: (progress, type) {
                if (funcProgress != null) {
                  funcProgress(progress, type);
                }
              },
              dataCallback: (type, jsonStr, errorCode) {
                if (funcData != null) {
                  funcData(type, jsonStr, errorCode);
                }
              })
          .asStream();
      streamList.add(healthStream);
      if (needSyncActivity) {
        final activityStream = _coreMgr
            .sync(
                type: SyncType.v2Activity,
                progressCallback: (progress, type) {
                  if (funcProgress != null) {
                    funcProgress(progress, type);
                  }
                },
                dataCallback: (type, jsonStr, errorCode) {
                  if (funcData != null) {
                    funcData(type, jsonStr, errorCode);
                  }
                })
            .asStream();
        streamList.add(activityStream);
      }
      if (needSyncGps) {
        final gpsStream = _coreMgr
            .sync(
                type: SyncType.v2Gps,
                progressCallback: (progress, type) {
                  if (funcProgress != null) {
                    funcProgress(progress, type);
                  }
                },
                dataCallback: (type, jsonStr, errorCode) {
                  if (funcData != null) {
                    funcData(type, jsonStr, errorCode);
                  }
                })
            .asStream();
        streamList.add(gpsStream);
      }
    } else if (_isNeedSyncV3Data()) {
      final v3DataStream = _coreMgr
          .sync(
              type: SyncType.v3Data,
              progressCallback: (progress, type) {
                if (funcProgress != null) {
                  funcProgress(progress, type);
                }
              },
              dataCallback: (type, jsonStr, errorCode) {
                if (funcData != null) {
                  funcData(type, jsonStr, errorCode);
                }
              })
          .asStream();
      streamList.add(v3DataStream);
    }
    _syncStreamSubscription = Rx.combineLatestList(streamList)
        .map((event) => event.last)
        .listen((event) {
      funcCompleted(event.code);
      completer.complete(event.code == 0);
    });
    return completer.future;
  }
}
