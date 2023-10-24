import 'dart:io';
import 'dart:convert';

import 'package:protocol_core/protocol_core.dart';

import 'base_file.dart';
import '../model/base_file_model.dart';
import '../model/message_file_model.dart';
import '../model/tran_config_reply.dart';
import '../../type_define/image_type.dart';
import '../../private/logger/logger.dart';

class MsgFile extends BaseFile {
  TranConfigReply? _configReply;

  MsgFile(super.type, super.fileItem);

  @override
  Future<BaseFileModel> makeFileIfNeed() {
    return _createMsgFile();
  }

  @override
  Future<bool> configParamIfNeed() async {
    logger?.d("call configParamIfNeed ${fileItem.fileType}");
    final sport = fileItem as MessageFileModel;
    final map = {
      "type": 0,
      "evt_type": sport.evtType,
      "sport_type": 0
    };
    final json = jsonEncode(map);
    _configReply = await getTranConfigReply(json);
    return Future(() => _configReply != null);
  }
}

extension _MsgFileFileExt on MsgFile {
  Future<BaseFileModel> _createMsgFile() async {
    final item = fileItem;
    // 文件hash
    final fileHash = await getFileChecksum(File(item.filePath));
    // 创建目录
    final rootPath = await createTransferDirIfNeed(subPath: fileHash);
    // 副本文件
    final aFilePath = '$rootPath/0.png';
    // .msg文件
    final msgFilePath = '$rootPath/message.msg';

    final msgItem = item as MessageFileModel;
    final newItem = MessageFileModel(
        filePath: msgFilePath,
        fileName: item.fileName,
        evtType: msgItem.evtType,
        packName: msgItem.packName,
        fileSize: item.fileSize);
    newFileItem = newItem;
    // 存在缓存
    if (useCache && await File(msgFilePath).exists()) {
      return Future(() => newItem);
    }

    // 复制要处理的文件
    await copyFileIfNeed(item.filePath, aFilePath);

    // 制作msg文件
    await _makeMsgFile(aFilePath, msgFilePath);

    if (hasCleanTampFile) {
      // 删除副本数据
      await removeFile(aFilePath);
    }

    return Future(() => newItem);
  }

  _makeMsgFile(String imgFilePath, String msgFilePath) async {
    int rs = coreMgr.makeFileCompression(
        fileName: imgFilePath,
        endName: '.msg',
        format: ImageFormatType.rgb565.realValue);
    if (rs != 0 || !await File(imgFilePath).exists()) {
      logger?.d('failed to make .msg file');
      throw UnsupportedError('failed to make .msg file');
    }

    final newFile = File('$imgFilePath..msg'); // c库多加了个.
    if (!await newFile.exists()) {
      logger?.d('failed to make .msg file');
      throw UnsupportedError('failed to make .msg file');
    }

    // rename
    await newFile.rename(msgFilePath);
    if (await File(msgFilePath).exists()) {
      return Future(() => true);
    } else {
      logger?.d('file rename failed');
      throw UnsupportedError('file rename failed');
    }
  }
}
