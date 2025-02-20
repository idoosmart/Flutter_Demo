import 'dart:async';
import 'dart:collection';

import 'package:protocol_ffi/protocol_ffi.dart';
import '../manager/response.dart';
import '../logger/logger.dart';
import '../manager/type_define.dart';
import 'base_task.dart';


class SyncTask extends BaseTask {
  TaskStatus _status = TaskStatus.waiting;
  final SyncType syncType;
  final SyncProgressCallback? progressCallback;
  final SyncDataCallback? dataCallback;
  List<int>? selectTypes;
  late final Queue<int> _queueTypes = Queue();
  Completer<bool>? _completerSingleSync;

  Completer<CmdResponse>? _completer;

  SyncTask.create(this.syncType,this.progressCallback,this.dataCallback) : super.create();

  @override
  Future<CmdResponse> call() async {
    return _exec();
  }

  @override
  cancel() {
    logger?.d('cancel sync data');
    _status = TaskStatus.canceled;
    if (_completer != null && !_completer!.isCompleted) {
      final res = SyncResponse(code: ErrorCode.canceled);
      _completer!.complete(res);
      _completer = null;
    }
    if (_completerSingleSync != null && !_completerSingleSync!.isCompleted) {
      _completerSingleSync = null;
    }
    _stopSync();
  }

  @override
  TaskStatus get status => _status;

}

extension _SyncTask on SyncTask {

  Future<CmdResponse> _exec() {
    _status = TaskStatus.running;
    logger?.d('begin sync task data type = $syncType');

    _completer = Completer<CmdResponse>();

     _sync();

    logger?.d('end call sync type: ${syncType}');
    return _completer!.future;
  }

  Future<bool> _sync() async {
    switch(syncType) {
      case SyncType.v2Health:
        {
          _syncV2HealhData();
        }
        break;
      case SyncType.v2Activity:
        {
          _syncV2Activity();
        }
        break;
      case SyncType.v2Gps:
        {
          _syncV2Gps();
        }
        break;
      case SyncType.v3Data:
        {
          _syncV3Data();
        }
        break;
      default:
    }
    return Future(() => true);
  }

  //初始化健康数据偏移量,默认从0开始，不再需要外部赋值，当天全量同步
  _initHealthOffset() {
    coreManager.cLib.setSyncV2HealthOffset(type: 0, value: 0); //步数
    coreManager.cLib.setSyncV2HealthOffset(type: 1, value: 0); //睡眠
    coreManager.cLib.setSyncV2HealthOffset(type: 2, value: 0); //心率
    coreManager.cLib.setSyncV2HealthOffset(type: 3, value: 0); //血压
  }

  //同步健康数据
  _syncV2HealhData() {
     _initHealthOffset();
     coreManager.cLib.registerV2SyncDataJsonDataCbReg(func: (String json,int type,int errorCode){
       if (_status == TaskStatus.canceled) {
           return;
       }
       //数据类型 15: V2步数 16: V2睡眠 17: V2心率 18: V2血压 19: V2 GPS 20: V2多运动
       SyncJsonType dataType = SyncJsonType.values[0];
         if (type == 6000) { //步数
           dataType = SyncJsonType.v2StepCount;
         }else if (type == 6001) { //睡眠
           dataType = SyncJsonType.v2Sleep;
         }else if (type == 6002) { //心率
           dataType = SyncJsonType.v2HeartRate;
         }else if (type == 6003) { //血压
           dataType = SyncJsonType.v2BloodPressure;
         }else if (type == 6004) { //GPS
           dataType = SyncJsonType.v2GPS;
         }else if (type == 652) { //多运动
           dataType = SyncJsonType.v2Activity;
         }
       logger?.d('sync data type: $dataType data: $json error code: $errorCode');
       if (dataCallback != null) {
           dataCallback!(dataType,json,errorCode);
       }
     });
     coreManager.cLib.registerSyncV2HealthCompleteCallbackReg(func:(int errorCode) {
       if (_status == TaskStatus.canceled) {
         return;
       }
         _status = TaskStatus.finished;
          final res = SyncResponse(code: errorCode, syncType: SyncType.v2Health);
         _completer?.complete(res);
         _completer = null;
         logger?.d('sync v2 health data complete error code: $errorCode');
     });
     coreManager.cLib.registerSyncV2HealthProgressCallbackReg(func: (int progress) {
       if (_status == TaskStatus.canceled) {
         return;
       }
       if (progressCallback != null) {
         progressCallback!(progress, SyncType.v2Health);
       }
     });
     coreManager.cLib.startSyncV2HealthData();
  }

  //同步多运动数据
  _syncV2Activity() {
    coreManager.cLib.registerSyncV2ActivityCompleteCallbackReg(func: (int errorCode) {
      if (_status == TaskStatus.canceled) {
        return;
      }
      _status = TaskStatus.finished;
      final res = SyncResponse(code: errorCode, syncType: SyncType.v2Activity);
      _completer?.complete(res);
      _completer = null;
      logger?.d('sync v2 activity data complete error code: ${errorCode}');
    });
    coreManager.cLib.registerSyncV2ActivityProgressCallbackReg(func: (int progress) {
      if (_status == TaskStatus.canceled) {
        return;
      }
          if (progressCallback != null) {
              progressCallback!(progress, SyncType.v2Activity);
          }
    });
     coreManager.cLib.startSyncV2ActivityData();
  }

  //同步GPS数据
  _syncV2Gps() {
    coreManager.cLib.registerSyncV2GpsCompleteCallbackReg(func: (int errorCode) {
      if (_status == TaskStatus.canceled) {
        return;
      }
      _status = TaskStatus.finished;
      final res = SyncResponse(code: errorCode, syncType: SyncType.v2Gps);
      _completer?.complete(res);
      _completer = null;
      logger?.d('sync v2 gps data complete error code: $errorCode');
    });
    coreManager.cLib.registerSyncV2GpsProgressCallbackReg(func: (int progress){
      if (_status == TaskStatus.canceled) {
        return;
      }
      if (progressCallback != null) {
          progressCallback!(progress,SyncType.v2Gps);
      }
    });
     coreManager.cLib.startSyncV2GpsData();
  }

  //同步v3数据
  _syncV3Data() async {
    //v3进度
    coreManager.cLib.registerSyncV3HealthDataProgressCallbackReg(func:(int progress){
      if (_status == TaskStatus.canceled) {
        return;
      }
      if (progressCallback != null) {
         progressCallback!(progress,SyncType.v3Data);
      }
    });

    //v3同步完成
    coreManager.cLib.registerSyncV3HealthDataCompleteCallbackReg(func:(int errorCode){
      if (_status == TaskStatus.canceled) {
        return;
      }
      if (_isSingleSync()) {
        logger?.v("单项同步 - 剩余 ${_queueTypes.length} 项 errorCode: $errorCode");
        if (_completerSingleSync != null && !_completerSingleSync!.isCompleted) {
          _completerSingleSync?.complete(errorCode == 0);
          _completerSingleSync = null;
        }
        // 队列未空，不触发完成回调 return
        if (_queueTypes.isNotEmpty) {
          return;
        }
      }
      _status = TaskStatus.finished;
      final res = SyncResponse(code: errorCode, syncType: SyncType.v3Data);
      _completer?.complete(res);
      _completer = null;
      logger?.d('sync v3 all data complete error code: $errorCode');
    });

    //v3数据回调
    coreManager.cLib.registerV3SyncHealthJsonDataCbHandle(func:(String json,int type,int errorCode){
      if (_status == TaskStatus.canceled) {
        logger?.d('canceled ignore. sync data type: $type data: $json error code: $errorCode');
        return;
      }
      SyncJsonType dataType = SyncJsonType.values[0];
      //数据类型 1:步数 2:心率 3:睡眠 4:血压 5:血氧 6:压力 7:噪音 8:皮温 9:呼吸率 10:身体电量 11:HRV 12:多运动 13:GPS 14:游泳
      if (type == 7008) {
        dataType = SyncJsonType.stepCount;
      }else if (type == 7003) {
        dataType = SyncJsonType.heartRate;
      }else if (type == 7007) {
        dataType = SyncJsonType.sleep;
      }else if (type == 7011) {
        dataType = SyncJsonType.bloodPressure;
      }else if (type == 7001) {
        dataType = SyncJsonType.bloodOxygen;
      }else if (type == 7002) {
        dataType = SyncJsonType.pressure;
      }else if (type == 7009) {
        dataType = SyncJsonType.noise;
      }else if (type == 7010) {
        dataType = SyncJsonType.piven;
      }else if (type == 7012) {
        dataType = SyncJsonType.respirationRate;
      }else if (type == 7013) {
        dataType = SyncJsonType.bodyPower;
      }else if (type == 7014) {
        dataType = SyncJsonType.HRV;
      }else if (type == 7004) {
        dataType = SyncJsonType.activity;
      }else if (type == 7005) {
        dataType = SyncJsonType.GPS;
      }else if (type == 7006) {
        dataType = SyncJsonType.swim;
      }
      logger?.d('sync data type: $dataType data: $json error code: $errorCode');
      if (dataCallback != null) {
          dataCallback!(dataType,json,errorCode);
      }
    });

    if (_isSingleSync()) {
      _queueTypes.clear();
      _queueTypes.addAll(selectTypes!);
      do {
        if (_status == TaskStatus.canceled) {
          logger?.d("单项同步 - 同步取消");
          break;
        }
        final type = _queueTypes.removeFirst();
        logger?.v("单项同步 - 开始 type: $type");
        await _doSingleSync(type);
        logger?.v("单项同步 - 结束 type: $type");
      } while(_queueTypes.isNotEmpty);
    }else {
      coreManager.cLib.startSyncV3HealthData();
    }
  }

  //停止同步数据
  _stopSync() {
    switch(syncType) {
      case SyncType.v2Health:
        coreManager.cLib.stopSyncV2HealthData();
        break;
      case SyncType.v2Activity:
        coreManager.cLib.stopSyncV2ActivityData();
        break;
      case SyncType.v2Gps:
        coreManager.cLib.stopSyncV2GpsData();
        break;
      case SyncType.v3Data:
        coreManager.cLib.stopSyncV3HealthData();
        break;
      default:
    }
  }

  /// 同步指定项
  Future<bool> _doSingleSync(int type) async {
    _completerSingleSync = Completer();
    Future(() {
      coreManager.cLib.syncV3HealthDataCustomResource(type);
    });
    return _completerSingleSync!.future;
  }

  /// 单项同步
  bool _isSingleSync() {
      return syncType == SyncType.v3Data && selectTypes != null && selectTypes!.isNotEmpty;
  }
}
