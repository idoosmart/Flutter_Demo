import 'dart:convert';
import 'dart:io';

import 'package:protocol_core/protocol_core.dart';

import 'base_file.dart';
import '../model/base_file_model.dart';
import '../model/medicine_file_model.dart';
import '../model/tran_config_reply.dart';
import '../../private/logger/logger.dart';
import '../../type_define/image_type.dart';

/// 吃药提醒图标：2.28（medicine_type=1）→ 压缩 `.medic` → 传输 `0x1C`
class MedicFile extends BaseFile {
  /// 2.28 入参 medicine_type，当前固定为 1
  static const int medicineTypeConfig = 1;

  TranConfigReply? _configReply;

  MedicFile(super.type, super.fileItem);

  @override
  Future<BaseFileModel> makeFileIfNeed() {
    return _createMedicFile();
  }

  @override
  Future<bool> configParamIfNeed() async {
    logger?.d('call configParamIfNeed ${fileItem.fileType}');
    if (!libMgr.funTable.getNotifyIconAdaptive) {
      logger?.d('Does not support getting configuration information, skip 2.28');
      return true;
    }
    final map = {
      'type': 0,
      'evt_type': 0,
      'sport_type': 0,
      'medicine_type': medicineTypeConfig,
    };
    _configReply = await getTranConfigReply(jsonEncode(map));
    return _configReply != null;
  }
}

extension _MedicFileExt on MedicFile {
  Future<BaseFileModel> _createMedicFile() async {
    final item = fileItem;
    final fileHash = await getFileChecksum(File(item.filePath));
    final rootPath = await createTransferDirIfNeed(subPath: fileHash);
    final srcCopyPath = '$rootPath/0.png';
    final medicFilePath = '$rootPath/0.medic';

    final newItem = MedicineFileModel(
      filePath: medicFilePath,
      fileName: item.fileName,
      fileSize: item.fileSize,
    );
    newFileItem = newItem;

    await copyFileIfNeed(item.filePath, srcCopyPath);
    await _makeMedicFile(srcCopyPath, medicFilePath);

    if (hasCleanTampFile) {
      await removeFile(srcCopyPath);
    }

    final size = await File(medicFilePath).length();
    newItem.fileSize = size;
    return newItem;
  }

  Future<void> _makeMedicFile(String imgFilePath, String medicFilePath) async {
    final format =
        _configReply?.format ?? ImageFormatType.rgb565.realValue;
    final rs = coreMgr.makeFileCompression(
      fileName: imgFilePath,
      endName: 'medic',
      format: format,
    );
    if (rs != 0) {
      logger?.d('failed to make .medic file, rs=$rs');
      throw UnsupportedError('failed to make .medic file');
    }

    // C 库输出路径因平台而异：`.medic` / `..medic` / `.temp.medic`
    final candidates = [
      '$imgFilePath.medic',
      '$imgFilePath..medic',
      '$imgFilePath.temp.medic',
    ];
    File? compressed;
    for (final path in candidates) {
      final file = File(path);
      if (await file.exists()) {
        compressed = file;
        break;
      }
    }
    if (compressed == null) {
      logger?.d('failed to find compressed .medic file');
      throw UnsupportedError('failed to make .medic file');
    }

    await compressed.rename(medicFilePath);
    if (!await File(medicFilePath).exists()) {
      logger?.d('file rename failed');
      throw UnsupportedError('file rename failed');
    }
  }
}
