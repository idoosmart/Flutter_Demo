import 'dart:io';
import 'dart:typed_data';

import 'package:protocol_lib/protocol_lib.dart';

import '../logger/logger.dart';

class FileTool {
  final String _ext;
  final String _fileName;
  String? dir;

  IOSink? _ioSink;
  File? _file;

  FileTool({required String fileName, required String ext, String? dir})
      : _fileName = fileName,
        _ext = ext;

  /// 写文件
  writeData(Uint8List data) async {
    if (_ioSink == null) {
      _file = await _createFile();
      _ioSink = _file?.openWrite();
    }
    _ioSink?.add(data.toList());
  }

  /// 保存文件
  ///
  /// 调用前，文件是先写入 {fileName}.tmp 临时文件
  /// 调用后，会把{fileName}.tmp更名为{fileName}
  Future<String?> saveFile() async {
    try {
      await _ioSink?.flush();
      if (_file != null && _file!.existsSync()) {
        final newPath = _file!.path.replaceAll('.tmp', '');
        final newFile = await _file!.rename(newPath);
        return newFile.path;
      }
    } catch (e) {
      logger?.e(e.toString());
    } finally {
      await close();
    }
    return null;
  }

  /// 写入文件并释放相关资源
  close() async {
    await _ioSink?.close();
    _ioSink = null;
    _file = null;
  }

  /// 创建文件名 HHmmss
  static String newFileName() {
    final date = DateTime.now();
    final hms =
        '${date.hour.toString().padLeft(2, '0')}${date.minute.toString().padLeft(2, '0')}${date.second.toString().padLeft(2, '0')}';
    return hms;
  }
}

extension _FileTool on FileTool {
  /// 创建文件
  Future<File?> _createFile() async {
    try {
      File file;
      if (dir == null) {
        final dirPath = await libManager.cache.alexaPath();
        final voicePath = '$dirPath/voice/${_tmpFileName()}';
        file = File(voicePath);
      } else {
        file = File('${dir!}/${_tmpFileName()}');
      }
      // await file.delete();
      final voiceFile = await file.create(recursive: true);
      if (voiceFile.existsSync()) {
        return voiceFile;
      }
    } catch (e) {
      logger?.e(e.toString());
    }
    return null;
  }

  String _tmpFileName() {
    return '$_fileName.$_ext.tmp'; // 固定名称
  }
}
