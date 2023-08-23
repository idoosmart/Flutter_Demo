import 'dart:io';

import 'package:protocol_core/protocol_core.dart';
import 'package:protocol_lib/src/private/local_storage/local_storage.dart';

import 'base_file.dart';
import '../../../protocol_lib.dart';
import '../../private/logger/logger.dart';

class VoiceFile extends BaseFile {
  VoiceFile(super.type, super.fileItem);

  @override
  Future<BaseFileModel> makeFileIfNeed() {
    return _createVoiceFile();
  }
}

extension _VoiceFileExt on VoiceFile {
  Future<BaseFileModel> _createVoiceFile() async {
    //throw UnsupportedError('mp3 rename failed');
    final item = fileItem;
    // 文件hash
    //final fileHash = await getFileChecksum(File(item.filePath));
    // 创建目录
    final rootPath = await _createTransferDirIfNeed();
    // 副本文件
    final aFilePath = '$rootPath/0.mp3';
    // pcm
    final tmpPcmFilePath = '$rootPath/audio.pcm'; // 需和pcm_config.ini相同
    // 转换后文件
    final pcmFilePath = '$rootPath/out.pcm'; // 需和pcm_config.ini相同

    final newItem = NormalFileModel(
        fileType: item.fileType,
        fileName: item.fileName,
        filePath: pcmFilePath,
        fileSize: item.fileSize);
    newFileItem = newItem;

    // 存在缓存  (Alexa 不适合使用缓存，实时语音）
    // if (useCache && await File(pcmFilePath).exists()) {
    //   return Future(() => newItem);
    // }

    // 如果是pcm文件不走转换流程
    if (item.filePath.endsWith('.pcm')) {
      // 复制要处理的文件
      await copyFile(item.filePath, pcmFilePath);
    } else {
      // 复制要处理的文件
      await copyFile(item.filePath, aFilePath);

      // mp3 转 pcm
      await _mp3ToPcmFileIfNeed(aFilePath, tmpPcmFilePath, rootPath);

      // pcm采样率转换
      await _makePcmFileIfNeed(tmpPcmFilePath, pcmFilePath, rootPath);
    }

    if (hasCleanTampFile) {
      // 删除副本数据
      await removeFile(aFilePath);
      await removeFile(tmpPcmFilePath);
    }

    return Future(() => newItem);
  }

  /// 转换文件
  _mp3ToPcmFileIfNeed(
      String aFilePath, String tmpPcmFilePath, String rootPath) async {
    final rs = coreMgr.audioFormatConversionMp32Pcm(
        inPath: aFilePath, outPath: tmpPcmFilePath);
    //await removeFile('$rootPath/music_2.pcm');
    if (rs != 0) {
      logger?.d('alexa - mp3 to pcm failed');
      throw UnsupportedError('alexa - mp3 to pcm failed');
    }
  }

  /// 制作16k采样率的pcm
  _makePcmFileIfNeed(
      String tmpPcmFilePath, String musicFilePath, String rootPath) async {
    final configPath = await _createConfigFileIfNeed();
    // pcm采样率调整为 16kHz
    final rs = coreMgr.pcmFileSamplingRateConversion(
        configPath: configPath, outPath: rootPath);
    if (rs != 0) {
      await removeFile(musicFilePath);
      logger?.d('alexa - pcm SamplingRateConversion failed rs:$rs');
      throw UnsupportedError('alexa - pcm SamplingRateConversion failed');
    }
    final outFile = File(musicFilePath);
    final isExists = await outFile.exists();
    final fileSize = await outFile.length();
    if (!(isExists && fileSize > 0)) {
      // out.pcm 不存在 或 size 为 0
      logger?.d('alexa - out.pcm: $isExists len:$fileSize');
      //removeFile(musicFilePath);
      throw UnsupportedError('alexa - out.pcm: $isExists len:$fileSize');
    }
  }

  /// 获取pcm配置文件
  Future<String> _createConfigFileIfNeed() async {
    final dir = await storage?.pathDevices();
    if (dir == null) {
      logger?.e('pcm config.ini not exists');
      throw UnsupportedError('pcm config.ini not exists');
    }
    final file = File('$dir/config.ini');
    if (!file.existsSync()) {
      // 建议保持现有格式
      const body = '''# AudioResamplerate
\n[audio]
channels = 1;
input_sample_rate  = 24000;
output_sample_rate = 16000;
\n[path]
input  = audio.pcm;
output = out.pcm;
\n[type]
input  = pcm;
output = pcm;
\n# left blank lines in the last line\n''';
      final f = await file.writeAsString(body, flush: true);
      if (!f.existsSync()) {
        logger?.e('pcm config.ini create failed');
        throw UnsupportedError('pcm config.ini create failed');
      }
    }
    return Future(() => file.path);
  }

  /// 获取文件传输临时目录
  ///
  /// 返回 根据文件类型生成的目录绝对路径
  Future<String> _createTransferDirIfNeed() async {
    if (storage == null) {
      return Future.error('storage不能为空，检查IDOProtocolLibManager macAddress是否为空');
    }
    final rootPath = await storage!.pathAlexa();
    final dir = Directory('$rootPath/tran_cache');
    final path = (await dir.create(recursive: true)).path;
    return Future(() => path);
  }
}
