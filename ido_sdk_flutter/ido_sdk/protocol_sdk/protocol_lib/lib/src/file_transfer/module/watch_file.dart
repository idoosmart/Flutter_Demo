import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:protocol_core/protocol_core.dart';
import 'package:protocol_lib/protocol_lib.dart';

import 'base_file.dart';
import '../../private/local_storage/local_storage.dart';
import '../../private/logger/logger.dart';

const _keyDialInfo = 'dial_info';

class WatchFile extends BaseFile {
  WatchFile(super.type, super.fileItem);

  @override
  Future<BaseFileModel> makeFileIfNeed() {
    if (type == FileTransType.iwf_lz) {
      return _createIwfLz();
    } else if (type == FileTransType.wallpaper_z) {
      return _createWallpaperZ();
    } else {
      logger?.d('type mismatch');
      throw ArgumentError('类型不匹配');
    }
  }
}

extension _WatchFileExt on WatchFile {
  /// 表盘文件制作压缩
  Future<BaseFileModel> _createIwfLz() async {
    final item = fileItem;
    // 文件hash
    final fileHash = await getFileChecksum(File(item.filePath));
    // 创建目录
    final rootPath = await createTransferDirIfNeed(subPath: fileHash);
    // 解压缩目录
    final unzipDir = '$rootPath/unzip/';
    // .iwf.lz文件
    final iwfLzFilePath = '$rootPath/0.iwf.lz';
    // 压缩前文件大小
    final fileSizeBeforeZip = '$rootPath/0.iwf.size';

    final newItem = NormalFileModel(
        fileType: item.fileType,
        fileName: item.fileName,
        filePath: iwfLzFilePath);
    newFileItem = newItem;

    // 存在缓存
    if (useCache && await File(iwfLzFilePath).exists() && await File(fileSizeBeforeZip).exists()) {
      newItem.fileSize = await File(iwfLzFilePath).length();
      // 保存文件大小
      final sizeStr = await File(fileSizeBeforeZip).readAsString();
      newItem.originalFileSize = int.parse(sizeStr);
      return Future(() => newItem);
    }

    // 解压缩
    await unzipFileIfNeed(item.filePath, unzipDir);

    // 由于制作表盘人员并不一定会按照表盘的目录格式进行压缩，因此需要做兼容处理
    // 在解压缩后的目录下，递归找到iwf.json所在目录即可
    final newUnzipDir = (await findIwfJsonDirectory(unzipDir)) ?? unzipDir;

    // 表盘信息
    final json = await _getWatchDialInfoIfNeed();
    int format = json['format'] as int;
    int blockSize = json['block_size'] as int;

    // 制作.iwf.lz文件
    final originalSize = await _makeIwfLzIfNeed(
        newUnzipDir, 'dial.iwf', format, blockSize, iwfLzFilePath);

    newItem.originalFileSize = originalSize;
    // 保存文件大小
    await File(fileSizeBeforeZip).writeAsString(newItem.originalFileSize.toString());

    if (hasCleanTampFile) {
      // 删除副本数据
      await removeDir(unzipDir);
    }

    return Future(() => newItem);
  }

  /// 壁纸表盘制作压缩
  Future<BaseFileModel> _createWallpaperZ() async {
    final item = fileItem;
    // 文件hash
    final fileHash = await getFileChecksum(File(item.filePath));
    // 创建目录
    final rootPath = await createTransferDirIfNeed(subPath: fileHash);
    // .img文件
    final imgFilePath = '$rootPath/0.png';
    // 压缩后img文件
    final imgFilePathComp = '$rootPath/1.png';
    // .wallpaper.z文件
    final imgLzFilePath = '$rootPath/0.iwf.lz';
    // 压缩前文件大小
    final fileSizeBeforeZip = '$rootPath/0.iwf.size';

    final newItem = NormalFileModel(
        fileType: item.fileType,
        filePath: imgLzFilePath,
        fileName: item.fileName,
        fileSize: item.fileSize);
    newFileItem = newItem;

    // 存在缓存
    if (useCache && await File(imgLzFilePath).exists()) {
      // 保存文件大小
      final sizeStr = await File(fileSizeBeforeZip).readAsString();
      newItem.originalFileSize = int.parse(sizeStr);
      return Future(() => newItem);
    }

    // 复制要处理的文件
    await copyFileIfNeed(item.filePath, imgFilePath);

    // 图片压缩
    await _compressToPNG(imgFilePath, imgFilePathComp);

    // 制作壁纸表盘
    final originalSize = await _makeWallpaper(imgFilePathComp, item.fileName, imgLzFilePath);

    // 获取压缩前文件大小
    newItem.originalFileSize = originalSize;

    // 保存文件大小
    await File(fileSizeBeforeZip).writeAsString(newItem.originalFileSize.toString());

    if (hasCleanTampFile) {
      // 删除副本数据
      await removeFile(imgFilePath);
      await removeFile(imgFilePathComp);
    }

    return Future(() => newItem);
  }

  /// 图片压缩
  Future<bool> _compressToPNG(
      String imgFilePath, String imgFilePathComp) async {
    // 图片压缩
    int rs = coreMgr.compressToPNG(
        inputFilePath: imgFilePath, outputFilePath: imgFilePathComp);
    if (rs == 0 && await File(imgFilePathComp).exists()) {
      return Future(() => true);
    } else {
      logger?.d('image compression failure rs:$rs 0:$imgFilePath 1:$imgFilePathComp');
      //throw UnsupportedError('图片压缩失败');
      await copyFileIfNeed(imgFilePath, imgFilePathComp);
      return Future(() => true);
    }
  }

}

extension _WatchFileIwfLz on WatchFile {
  /// 获取表盘信息
  /// ```dart
  /// {
  ///     "blockSize": 1024,
  ///     "familyName": "ID205G",
  ///     "format": 133,
  ///     "height": 240,
  ///     "sizex100": 0,
  ///     "width": 240
  /// }
  /// ```
  Future<Map<String, dynamic>> _getWatchDialInfoIfNeed() async {
    final json = await storage?.getString(key: _keyDialInfo);
    if (json != null && useCache) {
      return jsonDecode(json);
    }
    final res = await libMgr.send(evt: CmdEvtType.getWatchDialInfo).first;
    if (res.code == 0 && res.json != null && res.json is String) {
      final json = jsonDecode(res.json!);
      // 缓存表盘信息
      await storage?.setString(key: _keyDialInfo, value: res.json!);
      return json;
    } else {
      logger?.e('failed to obtain dial information.');
      throw UnsupportedError('failed to obtain dial information.');
    }
  }

  /// 创建.iwf.lz文件
  Future<int> _makeIwfLzIfNeed(String iwfFilePath, String fileName, int format,
      int blockSize, String iwfLzFilePath) async {
    final iwfLzFile = File(iwfLzFilePath);
    // 制作表盘压缩文件(iwf.lz) 压缩文件会自动添加.lz后缀
    int rs = coreMgr.makeWatchDialFileCompression(
        filePath: iwfFilePath,
        saveFileName: fileName,
        format: format,
        blockSize: blockSize);
    final iwfFile = File('$iwfFilePath$fileName');
    if (rs != 0 || !await iwfFile.exists()) {
      logger?.d('failed to create .iwf file rs: $rs');
      throw UnsupportedError('failed to create .iwf file');
    }

    // 获取iwf文件大小
    final originalSize = await iwfFile.length();
    final newIwfLzFile = File('$iwfFilePath$fileName.lz');

    // rename
    await newIwfLzFile.rename(iwfLzFilePath);
    if (!await iwfLzFile.exists()) {
      logger?.d('failed to create .iwf.lz file');
      throw UnsupportedError('failed to create .iwf.lz file');
    }
    return Future.value(originalSize);
  }

  /// 获取.iwf.json文件目录
  Future<String?> findIwfJsonDirectory(String startPath) async {
    final dir = Directory(startPath);
    try {
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File && path.basename(entity.path) == 'iwf.json') {
          return "${path.dirname(entity.path)}/";
        }
      }
    } catch (e) {
      logger?.e('findIwfJsonDirectory: $e');
    }

    return null;
  }

}

extension _WatchFileWallpaperZ on WatchFile {
  /// 返回压缩前的.iwf文件大小
  Future<int> _makeWallpaper(String imgFilePath, String fileName, String imgLzFilePath) async {
    // 制作表盘压缩文件(iwf.lz) 压缩文件会自动添加.lz后缀
    int rs = coreMgr.makePhotoFile(
        filePath: imgFilePath, saveFilePath: imgLzFilePath);
    final file = File(imgLzFilePath);
    if (rs != 0 || !await file.exists()) {
      logger?.d('failed to compress to make wallpaper dial');
      throw UnsupportedError('failed to compress to make wallpaper dial');
    }

    final fileSize = await file.length();
    final newIwfLzFile = File('$imgLzFilePath.lz');
    // rename
    await newIwfLzFile.rename(imgLzFilePath);
    if (await File(imgLzFilePath).exists()) {
      return Future.value(fileSize);
    } else {
      logger?.d('failed to create .iwf.lz file');
      throw UnsupportedError('failed to create .iwf.lz file');
    }
  }
}
