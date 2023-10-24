import 'package:protocol_lib/src/private/logger/logger.dart';

import 'base_file_model.dart';

import '../type_define/type_define.dart';

/// 音乐
class MusicFileModel extends BaseFileModel {
  /// 音乐id
  final int musicId;

  /// 歌手名
  final String? singerName;

  /// 使用SPP传输
  bool useSpp;

  MusicFileModel(
      {required super.filePath,
        required super.fileName,
        required this.musicId,
        this.singerName = 'unknown',
        this.useSpp = false,
        super.fileSize})
      : super(fileType: FileTransType.mp3);

  @override
  String toString() {
    return 'MusicFileModel{musicId: $musicId, singerName: $singerName, useSpp: $useSpp '
        ', fileType: $fileType, filePath: $filePath, fileName: $fileName, '
        'fileSize: $fileSize, originalFileSize: $originalFileSize}';
  }
}
