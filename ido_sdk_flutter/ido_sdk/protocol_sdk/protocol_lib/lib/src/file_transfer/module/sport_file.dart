import 'dart:convert';
import 'dart:io';

import 'package:protocol_core/protocol_core.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'package:image/image.dart' as pkg_img;

import 'base_file.dart';
import '../model/tran_config_reply.dart';
import '../../private/logger/logger.dart';

class SportFile extends BaseFile {
  TranConfigReply? _configReply;
  SportFile(super.type, super.fileItem);

  @override
  Future<BaseFileModel> makeFileIfNeed() {
    return _createSportOrSports();
  }

  @override
  Future<bool> configParamIfNeed() async {
    logger?.d("call configParamIfNeed ${fileItem.fileType}");
    final rs = await _getTranConfigReplyIfNeed(fileItem);
    return Future(() => rs != null);
  }
}

extension _SportFileExt on SportFile {
  Future<SportFileModel> _createSportOrSports() async {
    bool isSports = (type == FileTransType.sports);
    final item = fileItem;
    final sportItem = item as SportFileModel;
    // 文件hash
    final fileHash = await getFileChecksum(File(item.filePath));
    // 创建目录 (相同文件，根据iconType不同制作不同图标，此处需做区分）
    final rootPath = await createTransferDirIfNeed(subPath: '${fileHash}_${sportItem.iconType}');
    // .img文件 (原图）
    final imgFilePath = '$rootPath/0.bmp';
    // .img文件 (裁剪后）
    final cropImgFilePath = '$rootPath/1.bmp';
    // .sport文件
    final sportFilePath = '$rootPath/0.${isSports ? 'sports' : 'sport'}';

    final newItem = SportFileModel(
        iconType: sportItem.iconType,
        fileName: item.fileName,
        filePath: sportFilePath,
        sportType: sportItem.sportType,
        isSports: sportItem.isSports,
        fileSize: item.fileSize);
    newFileItem = newItem;

    // 存在缓存
    if (useCache && await File(sportFilePath).exists()) {
      return Future(() => newItem);
    }

    // 复制要处理的图片
    await copyFileIfNeed(item.filePath, imgFilePath);

    // 获取配置信息
    await _getTranConfigReplyIfNeed(item);

    // 制作运动图标
    if (isSports) {
      await _makeSports(imgFilePath, sportFilePath);
    } else {
      // 图片裁剪
      final config = CropImageConfig(
          imgFilePath,
          cropImgFilePath,
          _configReply!.iconWidth!,
          _configReply!.iconHeight!,
          libManager.deviceInfo.deviceShapeType == 1);
      // final config = CropImageConfig(imgFilePath, cropImgFilePath, 94, 94,
      //     libManager.deviceInfo.deviceShapeType == 1);
      await cropImage(config);
      // await _cropImage(imgFilePath, cropImgFilePath);
      await _makeSport(cropImgFilePath, sportFilePath);
    }

    if (hasCleanTampFile) {
      // 删除副本数据
      await removeFile(imgFilePath);
      await removeFile(cropImgFilePath);
    }

    return Future(() => newItem);
  }

  _makeSport(String cropImgFilePath, String sportFilePath) async {
    int rs = coreMgr.makeFileCompression(
        fileName: cropImgFilePath,
        endName: 'sport',
        format: _configReply!.format ?? ImageFormatType.mono4.realValue);

    final file = File('$cropImgFilePath.sport');
    if (rs != 0 || !await file.exists()) {
      logger?.d('Failed to make sport file');
      throw UnsupportedError('Failed to make sport file');
    }
    // rename
    await file.rename(sportFilePath);
    // 删除c库生成的temp文件
    // await removeFile('$cropImgFilePath.temp');
    if (await File(sportFilePath).exists()) {
      return Future.value();
    } else {
      logger?.d('Failed to make sports file');
      throw UnsupportedError('Failed to make sports file');
    }
  }

  _makeSports(String imgFilePath, String sportFilePath) async {
    final image = pkg_img.decodeImage(await File(imgFilePath).readAsBytes());
    if (image == null) {
      logger?.d('Failed to get image size');
      throw UnsupportedError('Failed to get image size');
    }
    final num = image.height ~/ image.width;
    logger?.d('picture num is: $num');
    int rs = coreMgr.makeSportFileCompression(
        fileName: imgFilePath,
        endName: 'sports',
        format: _configReply!.format ?? ImageFormatType.mono4.realValue,
        picNum: num);

    final file = File('$imgFilePath.sports');
    if (rs != 0 || !await file.exists()) {
      logger?.d('Failed to make sports file');
      throw UnsupportedError('Failed to make sports file');
    }
    // rename
    await file.rename(sportFilePath);
    // 删除c库生成的temp文件
    // await removeFile('$cropImgFilePath.temp');
    if (await File(sportFilePath).exists()) {
      return Future.value();
    } else {
      logger?.d('Failed to make sports file');
      throw UnsupportedError('Failed to make sports file');
    }
  }

  Future<TranConfigReply?> _getTranConfigReplyIfNeed(BaseFileModel item) async {
    //return Future(() => null);
    if (!libMgr.funTable.getNotifyIconAdaptive) {
      // 不支持
      //return Future(() => null);
      logger?.d('Does not support getting configuration information');
      throw UnsupportedError('Does not support getting configuration information');
    }
    final sport = item as SportFileModel;
    final map = {
      "type": sport.iconType,
      "evt_type": 0,
      "sport_type": sport.sportType
    };
    final json = jsonEncode(map);
    _configReply = await getTranConfigReply(json);
    if (_configReply == null) {
      logger?.d('Failed to get configuration information');
      throw UnsupportedError('Failed to get configuration information');
    }
    return Future(() => _configReply!);
  }
}
