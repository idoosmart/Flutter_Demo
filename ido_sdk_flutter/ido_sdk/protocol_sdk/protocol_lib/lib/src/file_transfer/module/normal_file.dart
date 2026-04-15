import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:protocol_lib/src/alexa_bridge/alexa_bridge.dart';

import 'package:protocol_core/protocol_core.dart';

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

    var originalFilePath = item.filePath;
    if (item.fileType == FileTransType.fw) {
      aFilePath = '$rootPath/0${path.extension(item.filePath)}';
    } else if(item.fileType == FileTransType.map || item.fileType == FileTransType.gpx) {
      originalFilePath = _compressFileToLZ(filePath: originalFilePath, endName: 'lz', blockSize: 4096) ?? '';
      aFilePath = '$rootPath/0.${type.name}.lz';
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
    await copyFileIfNeed(originalFilePath, aFilePath);
    return Future(() => newItem);
  }

  String? _compressFileToLZ({
    required String filePath,
    required String endName,
    required int blockSize
  }) {
    final rs = coreMgr.compressFileToLZ(fileName: filePath, endName: endName, blockSize: blockSize);
    if(rs == 0) {
      final aFilePath = '$filePath.lz';
      final aFile = File(aFilePath);
      if(!aFile.existsSync()) {
        throw Exception('failed to compress ,file not exists: $aFilePath');
      }
      fileItem.fileSize = aFile.lengthSync();
      return aFilePath;
    }else {
      throw Exception('failed to compress file code: $rs');
    }
  }
}
