import 'dart:io';

import 'package:protocol_core/protocol_core.dart';

import 'device_trans_item.dart';
import '../../private/logger/logger.dart';

class DeviceFileToAppTask {

  /// 文件项实体
  final DeviceTransItem item;

  late final _coreMgr = IDOProtocolCoreManager();

  DeviceFileToAppTask(this.item);

  /// 允许接收文件
  ///
  /// ```dart
  /// onProgress 传输进度 0 ~ 1.0
  /// onComplete 传输结果， isCompleted，receiveFilePath 接收后的文件（isCompleted为true时有效）
  /// ```
  bool acceptReceiveFile(
      {required void Function(double progress) onProgress,
      required void Function(bool isCompleted, String? receiveFilePath) onComplete}) {
    _coreMgr.listenDeviceTranFileToApp(progressCallback: (double progress) {
      //final rs = progress / 100.0;
      logger?.d("device file -> app progress: $progress");
      onProgress(progress);
    }, statusCallback: (int error, int errorVal) {
      logger?.d("device file -> app error:$error");
      if (error == 0) {
        if (item.filePath != null && File(item.filePath!).existsSync()) {
          onComplete(true, item.filePath);
        }else {
          onComplete(false, null);
          logger?.d("device file -> app ${item.filePath} not exists");
        }
      }else {
        onComplete(false, null);
      }
    });
    final rs = _coreMgr.device2AppDataTranRequestReply(0);
    logger?.d("device file -> app allowReceiveFile rs:$rs");
    return rs == 0;
  }

  /// 拒绝接收文件
  bool rejectReceiveFile() {
    final rs = _coreMgr.device2AppDataTranRequestReply(1);
    logger?.d("device file -> app rejectReceiveFile rs:$rs");
    return rs == 0;
  }

  /// APP主动停止设备传输文件到APP
  bool stopReceiveFile() {
    final rs = _coreMgr.device2AppDataTranManualStop();
    logger?.d("device file -> app call stop() rs:$rs");
    return rs == 0;
  }
}
