import '../type_define/type_define.dart';

abstract class BaseFileModel {
  /// 文件类型
  final FileTransType fileType;

  /// 文件绝对地址
  final String filePath;

  /// 文件名
  final String fileName;

  /// 文件大小
  int? fileSize;

  /// 原始文件大小（压缩前）,暂时只用于表盘
  int? originalFileSize;

  BaseFileModel(
      {required this.fileType,
      required this.fileName,
      required this.filePath,
      this.fileSize});
}
