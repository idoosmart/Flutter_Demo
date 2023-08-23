part of '../ido_sync_data.dart';

class _IDOSyncData implements IDOSyncData {
  static final _instance = _IDOSyncData._internal();
  _IDOSyncData._internal();
  factory _IDOSyncData() => _instance;

  Completer<bool>? _completer;
  SyncDataHandle? _syncHandle;
  /// 使用 _status = xx 赋值
  SyncStatus __statusPrivate = SyncStatus.init;
  set _status(SyncStatus val) {
    __statusPrivate = val;
    if (val == SyncStatus.syncing) {
      statusNotification?.add(IDOStatusNotification.syncHealthDataIng);
    }else if (val != SyncStatus.init) {
      statusNotification?.add(IDOStatusNotification.syncHealthDataCompleted);
    }
  }

  @override
  Stream<bool> startSync(
      {required CallbackSyncProgress funcProgress,
      required CallbackSyncData funcData,
      required CallbackSyncCompleted funcCompleted}) {
    if (!IDOProtocolLibManager().isConnected) {
      return CancelableOperation.fromFuture(Future(() => false)).asStream();
    }
    _completer = Completer();
    final stream = CancelableOperation.fromFuture(
        _startSync(funcProgress, funcData, funcCompleted), onCancel: () {
      _status = SyncStatus.canceled;
      _completer?.complete(false);
      _completer = null;
    }).asStream();
    return stream;
  }

  @override
  void stopSync() {
    _stopSync();
  }

  @override
  SyncStatus get syncStatus => __statusPrivate;

}

extension _IDOSyncDataExt on _IDOSyncData {
  // 开始同步
  Future<bool> _startSync(CallbackSyncProgress funcProgress,
      CallbackSyncData funcData, CallbackSyncCompleted funcCompleted) async {
    try {
      if (!libManager.isConnected) {
        logger?.e('sync data device disconnect');
         if (funcCompleted != null) {
             funcCompleted(-4);
         }  
         return Future(() => false);
      }
      if (libManager.otaType != IDOOtaType.none) {
        logger?.e('sync data device is ota mode == ${libManager.otaType}');
        if (funcCompleted != null) {
            funcCompleted(-5);
        }
        return Future(() => false);
      }
      logger?.d('sync data start');
      _status = SyncStatus.syncing;
      final syncFast = SyncFastOperation();
      await syncFast.listenSyncFastComplete();
      final calculate = SyncCalculate();
      await calculate.refreshProgressProportion();
      _syncHandle =
          SyncDataHandle(calculate.activityCount > 0, calculate.gpsCount > 0,
              (progress, type) {
        if (type == SyncType.v2Health) {
          calculate.v2HealthProgress = progress;
        } else if (type == SyncType.v2Activity) {
          calculate.v2ActivityProgress = progress;
        } else if (type == SyncType.v2Gps) {
          calculate.v2GpsProgress = progress;
        } else if (type == SyncType.v3Data) {
          calculate.v3DataProgress = progress;
        }
        if (syncStatus != SyncStatus.syncing) {
          return;
        }
        if (funcProgress != null) {
          funcProgress(calculate.getSyncProgress());
        }
      }, (type, jsonStr, errorCode) {
        if (syncStatus != SyncStatus.syncing) {
          return;
        }
        if (funcData != null) {
          logger?.d('sync data ==${jsonStr} data type ==${type} error code ==${errorCode}');
          final dataType = SyncDataType.values[type.index];
          funcData(dataType, jsonStr, errorCode);
        }
      }, (errorCode) {
        if (syncStatus != SyncStatus.syncing) {
          return;
        }
        logger?.d('sync data complete error code ==${errorCode}');
        if (funcCompleted != null) {
          funcCompleted(errorCode);
        }
        _status = SyncStatus.finished;
        _completer?.complete(errorCode == 0);
        _completer = null;
      });
      _syncHandle!.start().timeout(Duration(seconds: calculate.syncTimeout),
          onTimeout: () {
        return _timeout();
      });
    } catch (e) {
      logger?.e('sync data error');
      _status = SyncStatus.error;
      _completer!.completeError(e);
      _completer = null;
    }
    return _completer!.future;
  }

  // 同步超时
  _timeout() {
    logger?.d('sync data timeout');
    _status = SyncStatus.timeout;
    _completer?.complete(false);
    // return _completer?.future;
    _completer = null;
    return false;
  }

  //停止同步
  _stopSync() {
    logger?.d('sync data stop');
    _status = SyncStatus.stopped;
    _syncHandle?.stop();
  }
}
