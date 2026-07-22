import 'dart:io';

import '../../../protocol_lib.dart';
import '../../private/local_storage/local_storage.dart';
import 'base_file.dart';

/// 手机日历 `.cal` 传输：固定写入 `tran_cache/phone_calendar.cal`，覆盖旧文件。
///
/// C 库组包输出在 `c_files/phone_calendar.cal`（供 is_need 持久化）；
/// 传输层仅保留 tran_cache 下单一临时副本，避免 NormalFile 按 hash 创建多个子目录。
class CalFile extends BaseFile {
  CalFile(super.type, super.fileItem);

  static const _tranCalFileName = 'phone_calendar.cal';

  @override
  Future<BaseFileModel> makeFileIfNeed() async {
    final item = fileItem;
    if (storage == null) {
      return Future.error('storage不能为空，检查IDOProtocolLibManager macAddress是否为空');
    }

    final rootPath = await storage!.pathRoot();
    final tranCacheDir = Directory('$rootPath/tran_cache');
    await tranCacheDir.create(recursive: true);

    // 清理旧版 NormalFile 产生的 tran_cache/cal/{hash}/ 目录
    final legacyDir = Directory('${tranCacheDir.path}/cal');
    if (await legacyDir.exists()) {
      await legacyDir.delete(recursive: true);
    }

    final targetPath = '${tranCacheDir.path}/$_tranCalFileName';
    await copyFileIfNeed(item.filePath, targetPath);
    final fileSize = await File(targetPath).length();

    final newItem = NormalFileModel(
      fileType: item.fileType,
      fileName: item.fileName,
      filePath: targetPath,
      fileSize: fileSize,
    );
    newFileItem = newItem;
    return newItem;
  }

  @override
  bool get hasCleanTampFile => false;
}
