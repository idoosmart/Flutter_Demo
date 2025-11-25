part of '../ido_sync_data.dart';

class _IDOSyncData implements IDOSyncData {
  static final _instance = _IDOSyncData._internal();
  _IDOSyncData._internal();
  factory _IDOSyncData() => _instance;

  late final _streamStatus = StreamController<SyncStatus>.broadcast();

  Completer<bool>? _completer;
  SyncDataHandle? _syncHandle;
  /// 使用 _status = xx 赋值
  SyncStatus __statusPrivate = SyncStatus.init;

  set _status(SyncStatus val) {
    __statusPrivate = val;
    _streamStatus.add(val);
    if (val == SyncStatus.syncing) {
      statusSdkNotification?.add(IDOStatusNotification.syncHealthDataIng);
    }else if (val != SyncStatus.init) {
      statusSdkNotification?.add(IDOStatusNotification.syncHealthDataCompleted);
    }
  }

  @override
  Stream<bool> startSync({
    List<SyncDataType>? types = const [],
      required CallbackSyncProgress funcProgress,
      required CallbackSyncData funcData,
      required CallbackSyncCompleted funcCompleted}) {
    if (!IDOProtocolLibManager().isConnected) {
      return CancelableOperation.fromFuture(Future(() => false)).asStream();
    }
    _completer = Completer();
    final stream = CancelableOperation.fromFuture(
        _startSync((types ?? []).mappingValues, funcProgress, funcData, funcCompleted), onCancel: () {
      _status = SyncStatus.canceled;
      _completer?.complete(false);
      _completer = null;
    }).asStream();
    return stream;
  }

  @override
  void stopSync() {
    _stopSync();
    _closeFastModeIfNeed();
  }

  @override
  SyncStatus get syncStatus => __statusPrivate;

  @override
  Stream<SyncStatus> listenSyncStatus() {
    return _streamStatus.stream;
  }

  @override
  List<SyncDataType> getSupportSyncDataTypeList() {
    // 目前支持单项同步的类型
    final syncTypes = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 14, 15, 16, 20];
    final supportSyncDataTypes = <int>[];
    for (var type in syncTypes) {
      final rs = IDOProtocolCoreManager().isSupportSyncHealthDataType(type);
      if(rs) {
        supportSyncDataTypes.add(type);
      }
    }
    return supportSyncDataTypes.mappingValues;
  }

}

extension _IDOSyncDataExt on _IDOSyncData {
  // 开始同步
  Future<bool> _startSync(
      List<int> types,
      CallbackSyncProgress funcProgress,
      CallbackSyncData funcData, CallbackSyncCompleted funcCompleted) async {
    try {
      if (!libManager.isConnected) {
        logger?.e('sync data device disconnect');
         if (funcCompleted != null) {
             funcCompleted(ErrorCode.no_connected_device);
         }  
         return Future(() => false);
      }

      // fix: 当使用第三方ota库时，在执行ota时需屏蔽数据同步
      // 屏蔽思澈平台ota中的所有指令发送
      if ((libManager.deviceInfo.isSilfiPlatform()
          && libManager.transFile.isTransmitting
          && libManager.transFile.transFileType == FileTransType.fw) ||
          (libManager.deviceInfo.isPersimwearPlatform() && libManager.isPersimwearOtaUpgrading)) {
        logger?.e('In OTA, sync data is not allowed');
        funcCompleted(ErrorCode.ota_mode);
        return Future(() => false);
      }else if (libManager.otaType != IDOOtaType.none) {
        logger?.e('sync data device is ota mode == ${libManager.otaType}');
        if (funcCompleted != null) {
            funcCompleted(ErrorCode.ota_mode);
        }
        return Future(() => false);
      }
      logger?.d('sync data start');
      _openFastModeIfNeed();
      _status = SyncStatus.syncing;
      final syncFast = SyncFastOperation();
      await syncFast.listenSyncFastComplete();
      final calculate = SyncCalculate();
      await calculate.refreshProgressProportion();
      _syncHandle =
          SyncDataHandle(types, calculate.activityCount > 0, calculate.gpsCount > 0,
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
        // if (syncStatus != SyncStatus.syncing) {
        //   return;
        // }
        if (funcProgress != null) {
          funcProgress(calculate.getSyncProgress());
        }
      }, (type, jsonStr, errorCode) {
        // if (syncStatus != SyncStatus.syncing) {
        //   return;
        // }
        if (funcData != null) {
          //logger?.d('sync data ==${jsonStr} data type ==${type} error code ==${errorCode}');
          final dataType = SyncDataType.values[type.index];
          funcData(dataType, jsonStr, errorCode);
        }
      }, (errorCode) {
        if (syncStatus == SyncStatus.finished) {
          return;
        }
        _status = SyncStatus.finished;
        logger?.d('sync data complete status: $syncStatus errCode: $errorCode');
        _completer?.complete(errorCode == 0);
        _completer = null;
        _closeFastModeIfNeed();
        if (funcCompleted != null) {
          funcCompleted(errorCode);
        }
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
      _closeFastModeIfNeed();
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
    _closeFastModeIfNeed();
    return false;
  }

  //停止同步
  _stopSync() {
    logger?.d('sync data stop');
    _status = SyncStatus.stopped;
    _syncHandle?.stop();
  }

  /// 开启快速模式
  _openFastModeIfNeed() async {
    // 支持数据同步时启用快速模式，在结束时需恢复慢速模式
    if (libManager.funTable.syncSupportSetFastModeWhenSyncConfig) {
      // 数据同步和文件传输都存在模式切换，存在问题，暂时废弃
      //await libManager.send(evt: CmdEvtType.setConnParam, json: _jsonChangeMode(0x01)).first;
    }
  }

  /// 关闭快速模式
  _closeFastModeIfNeed() async {
    // 支持数据同步时启用快速模式，在结束时需恢复慢速模式
    if (libManager.funTable.syncSupportSetFastModeWhenSyncConfig &&
        !libManager.transFile.isTransmitting) {
      // 数据同步和文件传输都存在模式切换，存在问题，暂时废弃
      //await libManager.send(evt: CmdEvtType.setConnParam, json: _jsonChangeMode(0x02)).first;
    }
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
