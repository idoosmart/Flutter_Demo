import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:path/path.dart' as path;

import 'base_file.dart';
import '../model/base_file_model.dart';
import '../model/normal_file_model.dart';
import '../../type_define/event_type.dart';

class AGpsFile extends BaseFile {
  AGpsFile(super.type, super.filePaths);

  @override
  Future<BaseFileModel> makeFileIfNeed() {
    return _createAgpsFile();
  }

  @override
  Future<bool> writeFileIfNeed() async {
    const w = '{"operate": 1,"type": 3}';
    const r = '{"operate": 2,"type": 3}';
    final res = await Rx.concat([
      libMgr.send(evt: CmdEvtType.setGpsControl, json: w),
      libMgr
          .send(evt: CmdEvtType.setGpsControl, json: r)
          .delay(const Duration(seconds: 3))
    ]).last;
    return Future(() => res.code == 0);
  }
}

extension _AGpsFileExt on AGpsFile {
  Future<BaseFileModel> _createAgpsFile() async {
    // 文件hash
    final fileHash = await getFileChecksum(File(fileItem.filePath));
    // 创建目录
    final rootPath = await createTransferDirIfNeed(subPath: fileHash);
    // .agps文件
    final agpsFilePath = '$rootPath/agps.ubx';

    final newItem = NormalFileModel(
        fileType: fileItem.fileType,
        fileName: fileItem.fileName,
        filePath: agpsFilePath,
        fileSize: fileItem.fileSize);
    newFileItem = newItem;
    // 存在缓存
    if (useCache && await File(agpsFilePath).exists()) {
      return Future(() => newItem);
    }

    // 复制要处理的文件
    await copyFileIfNeed(fileItem.filePath, agpsFilePath);
    return Future(() => newItem);
  }
}
