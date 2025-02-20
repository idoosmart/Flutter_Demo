import 'dart:io';
import 'dart:async';

import 'package:protocol_lib/protocol_lib.dart';
import 'package:protocol_lib/src/private/logger/logger.dart';

import 'base_file.dart';
import '../model/base_file_model.dart';
import '../model/normal_file_model.dart';

class EpoFile extends BaseFile {
  Completer<bool>? _completerWriteFile;
  StreamSubscription? subscriptEpoWrite;
  Timer? _timerWriteFileWait;
  EpoFile(super.type, super.fileItem, bool needCheckWriteFileComplete) {
    _needCheckWriteFileComplete = needCheckWriteFileComplete;
  }

  bool _needCheckWriteFileComplete = true;

  @override
  Future<BaseFileModel> makeFileIfNeed() {
    return _createEpoFile();
  }

  @override
  Future<bool> writeFileIfNeed() async {
    // 不需要等待epo写完成结果
    if (!_needCheckWriteFileComplete) {
      return super.writeFileIfNeed();
    }

    // 45s超时处理(当收不到0740时触发超时)
    _timerWriteFileWait?.cancel();
    _timerWriteFileWait = Timer(const Duration(seconds: 45), () {
      _timerWriteFileWait = null;
      if (_completerWriteFile != null && !_completerWriteFile!.isCompleted) {
        logger?.d('tran epo 0740 timeout');
        _completerWriteFile?.complete(false);
        subscriptEpoWrite?.cancel();
        _completerWriteFile = null;
        subscriptEpoWrite = null;
      }
    });

    logger?.d('call writeFileIfNeed()');
    _completerWriteFile = Completer();
    subscriptEpoWrite = coreMgr.listenDeviceStateChanged((code) {
      logger?.d('tran writeFileIfNeed code:$code');
      if (code == 44) {
        _completerWriteFile?.complete(true);
        subscriptEpoWrite?.cancel();
        _completerWriteFile = null;
        subscriptEpoWrite = null;
        _timerWriteFileWait?.cancel();
      } else if (code == 43) {
        _completerWriteFile?.complete(false);
        subscriptEpoWrite?.cancel();
        _completerWriteFile = null;
        subscriptEpoWrite = null;
        _timerWriteFileWait?.cancel();
      }
    });

    return _completerWriteFile!.future;
  }

  @override
  void cancel() {
    super.cancel();
    _timerWriteFileWait?.cancel();
    _timerWriteFileWait = null;
    subscriptEpoWrite?.cancel();
    subscriptEpoWrite = null;
    logger?.i('epo_file call cancel');
    _completerWriteFile?.complete(false);
    _completerWriteFile = null;
  }
}

extension _EpoFileExt on EpoFile {
  Future<BaseFileModel> _createEpoFile() async {
    final item = fileItem;
    // 文件hash
    final fileHash = await getFileChecksum(File(item.filePath));
    // 创建目录
    final rootPath = await createTransferDirIfNeed(subPath: fileHash);
    // eop文件
    final epoFilePath = '$rootPath/EPO.DAT';

    final newItem = NormalFileModel(
        fileType: item.fileType,
        fileName: item.fileName,
        filePath: epoFilePath,
        fileSize: item.fileSize);
    newFileItem = newItem;
    // 存在缓存
    if (useCache && await File(epoFilePath).exists()) {
      return Future(() => newItem);
    }

    // 复制要处理的文件
    await copyFileIfNeed(item.filePath, epoFilePath);

    return Future(() => newItem);
  }

}
