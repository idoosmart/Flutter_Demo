import 'dart:convert';
import 'dart:io';

import 'package:protocol_core/protocol_core.dart';

import 'base_file.dart';
import '../model/base_file_model.dart';
import '../model/normal_file_model.dart';
import '../../private/logger/logger.dart';

class ContactFile extends BaseFile {
  ContactFile(super.type, super.filePaths);

  @override
  Future<BaseFileModel> makeFileIfNeed() {
    return _createContactFile();
  }
}

extension _ContactFileExt on ContactFile {
  Future<BaseFileModel> _createContactFile() async {
    final item = fileItem;
    // 文件hash
    final fileHash = await getFileChecksum(File(item.filePath));
    // 创建目录
    final rootPath = await createTransferDirIfNeed(subPath: fileHash);
    // 副本文件
    final aFilePath = '$rootPath/0.json';
    // .ml文件
    final mlFilePath = '$rootPath/contact.ml';

    final newItem = NormalFileModel(
        fileType: item.fileType,
        fileName: item.fileName,
        filePath: mlFilePath,
        fileSize: item.fileSize);
    newFileItem = newItem;
    // 存在缓存
    if (useCache && await File(mlFilePath).exists()) {
      return Future(() => newItem);
    }

    // 复制要处理的文件
    await copyFileIfNeed(item.filePath, aFilePath);

    // 制作xx.ml文件
    await _makeContactFile(aFilePath, mlFilePath);

    if (hasCleanTampFile) {
      // 删除副本数据
      await removeFile(aFilePath);
    }

    return Future(() => newItem);
  }

  Future<void> _makeContactFile(String jsonFilePath, String mlFilePath) async {
    // logger?.d('制作.ml文件...');
    final file = File(jsonFilePath);
    final json = await file.readAsString();
    if (json.isEmpty || jsonDecode(json) == null) {
      logger?.d('json data error');
      throw UnsupportedError('json data error');
    }

    final newPath = coreMgr.makeContactFile(jsonData: json);
    if (newPath == null) {
      logger?.d('create .ml file failed');
      throw UnsupportedError('create .ml file failed');
    }
    final newFile = File(newPath);
    if (!await newFile.exists() || await newFile.length() == 0) {
      logger?.d('create .ml file failed');
      throw UnsupportedError('create .ml file failed');
    }

    // rename
    await newFile.copy(mlFilePath);
    if (await File(mlFilePath).exists()) {
      return Future(() => true);
    } else {
      logger?.d('file rename failed');
      throw UnsupportedError('file rename failed');
    }
  }
}
