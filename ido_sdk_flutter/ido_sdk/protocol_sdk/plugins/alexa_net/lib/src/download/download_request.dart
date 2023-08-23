import 'package:alexa_net/alexa_net.dart';
import 'package:dio/dio.dart';

import '../bean/base_file_request.dart';
import '../retry/retry_interceptor.dart';

typedef OnReceiveProgressListener = Function(int progress, int total);

class DownloadRequest extends BaseFileRequest {
  /// 保存路径
  final String savePath;

  /// 进度回调
  final OnReceiveProgressListener? listener;

  DownloadRequest(
      {required this.savePath,
      this.listener,
      super.customDio,
      required super.retryTimes,
      required super.url,
      required super.params,
      required super.headers});
}
