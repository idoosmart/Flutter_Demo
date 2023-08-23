import 'dart:io';

import 'package:protocol_core/protocol_core.dart';

import 'base_file.dart';
import '../model/base_file_model.dart';
import '../model/music_file_model.dart';
import '../../private/logger/logger.dart';

class MusicFile extends BaseFile {
  MusicFile(super.type, super.fileItem);

  @override
  Future<BaseFileModel> makeFileIfNeed() {
    return _createMusicFile();
  }
}

extension _MusicFileExt on MusicFile {
  Future<BaseFileModel> _createMusicFile() async {
    //throw UnsupportedError('mp3 rename failed');
    final item = fileItem;
    // 文件hash
    final fileHash = await getFileChecksum(File(item.filePath));
    // 创建目录
    final rootPath = await createTransferDirIfNeed(subPath: fileHash);
    // 副本文件
    final aFilePath = '$rootPath/tmp.mp3';
    // 转换后文件
    final musicFilePath = '$rootPath/0.mp3';

    final musicItem = item as MusicFileModel;
    final newItem = MusicFileModel(
        filePath: musicFilePath,
        fileName: item.fileName,
        musicId: musicItem.musicId,
        fileSize: musicItem.fileSize,
        singerName: musicItem.singerName,
        useSpp: item.useSpp);
    newFileItem = newItem;

    // 存在缓存
    if (useCache && await File(musicFilePath).exists()) {
      return Future(() => newItem);
    }

    // 复制要处理的文件
    await copyFileIfNeed(item.filePath, aFilePath);

    // 转换文件
    await _makeMp3FileIfNeed(aFilePath, musicFilePath, rootPath);

    if (hasCleanTampFile) {
      // 删除副本数据
      await removeFile(aFilePath);
    }

    return Future(() => newItem);
  }

  /// 制作44.1k采样率mp3
  _makeMp3FileIfNeed(
      String aFilePath, String musicFilePath, String rootPath) async {
    final file = File(aFilePath);
    final rate = coreMgr.audioGetMp3SamplingRate(mp3FilePath: aFilePath);
    // 是否符合固件44.1k采样率
    if (rate != 44100) {
      logger?.d('create 44.1k rate mp3...');
      // 将采样率转化为44.1khz
      final rs = coreMgr.audioSamplingRateConversion(
          inPath: aFilePath,
          outPath: musicFilePath,
          fileSize: file.lengthSync());
      if (rs != 0) {
        logger?.e('failed to convert 44.1k sample rate');
        await removeFile(musicFilePath);
        throw UnsupportedError('failed to convert 44.1k sample rate');
      }
      // 删除c库生成的pcm文件
      //await removeFile('$rootPath/music_1.pcm');
      await removeFile('$rootPath/music_2.pcm');
    } else {
      // logger?.d('44.1k采样率mp3 无需转换');
      // rename
      await file.rename(musicFilePath);
      if (!await File(musicFilePath).exists()) {
        logger?.e('mp3 rename failed');
        throw UnsupportedError('mp3 rename failed');
      }
    }
  }
}
