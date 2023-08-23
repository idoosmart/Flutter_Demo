import 'package:alexa_net/src/bean/base_file_request.dart';

typedef UploadProgressListener = Function(int progress, int total);

/// 上传请求
class UploadRequest extends BaseFileRequest {
  /// 上传文件路径
  final String filePath;

  /// 上传文件名称
  final String fileName;
  final UploadProgressListener? listener;

  UploadRequest(
      {required this.filePath,
      required this.fileName,
      this.listener,
      super.customDio,
      required super.retryTimes,
      required super.url,
      required super.params,
      required super.headers});
}
