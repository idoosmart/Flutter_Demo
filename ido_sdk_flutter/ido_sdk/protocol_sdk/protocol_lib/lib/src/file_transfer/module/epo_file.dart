import 'dart:io';
import 'dart:async';

import 'package:protocol_lib/src/private/logger/logger.dart';

import 'base_file.dart';
import '../model/base_file_model.dart';
import '../model/normal_file_model.dart';

class EpoFile extends BaseFile {
  Completer<bool>? _completerWriteFile;

  EpoFile(super.type, super.fileItem);

  @override
  Future<BaseFileModel> makeFileIfNeed() {
    return _createEpoFile();
  }

  @override
  Future<bool> writeFileIfNeed() async {
    logger?.d('call writeFileIfNeed()');
    _completerWriteFile = Completer();
    StreamSubscription? subscript;
    subscript = coreMgr.listenDeviceStateChanged((code) {
      logger?.d('tran writeFileIfNeed code:$code');
      if (code == 44) {
        // 成功
        _completerWriteFile?.complete(true);
        subscript?.cancel();
      } else if (code == 43) {
        // 失败
        _completerWriteFile?.complete(false);
        subscript?.cancel();
      }
    });

    return _completerWriteFile!.future;
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
