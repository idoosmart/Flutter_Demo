import 'base_file_model.dart';

/// 根据FileTransType区分
///
/// 以下类型需使用相应的分类：
/// - 消息图标 使用 MessageFileModel类
/// - 音乐 使用 MusicFileModel
/// - 运动图标 使用 SportFileModel
class NormalFileModel extends BaseFileModel {
  NormalFileModel(
      {required super.fileType,
      required super.filePath,
      required super.fileName,
      super.fileSize});
}
