import 'dart:io';

import 'package:path/path.dart' as path;
import '../../../protocol_lib.dart';
import 'base_file.dart';

class NormalFile extends BaseFile {
  NormalFile(super.type, super.fileItem);

  @override
  Future<BaseFileModel> makeFileIfNeed() {
    return _createFiles();
  }
}

extension _NormalFileExt on NormalFile {
  Future<BaseFileModel> _createFiles() async {
    final item = fileItem;
    // 文件hash
    final fileHash = await getFileChecksum(File(item.filePath));
    // 创建目录
    final rootPath = await createTransferDirIfNeed(subPath: fileHash);
    // 副本文件
    var aFilePath = '$rootPath/0.${type.name}';

    if (item.fileType == FileTransType.fw) {
      aFilePath = '$rootPath/0${path.extension(item.filePath)}';
    }

    final newItem = NormalFileModel(
        fileType: item.fileType,
        fileName: item.fileName,
        filePath: aFilePath,
        fileSize: item.fileSize);
    newFileItem = newItem;

    // 存在缓存
    if (useCache && await File(aFilePath).exists()) {
      return Future(() => newItem);
    }

    // 复制要处理的文件
    await copyFileIfNeed(item.filePath, aFilePath);
    return Future(() => newItem);
  }
}
