import 'package:dio/dio.dart';

import '../http_client.dart';
import '../retry/retry_interceptor.dart';
import 'download_request.dart';

class DownloadTask {
  final CancelToken _cancelToken = CancelToken();

  /// 开始下载任务
  Future<Response> startDownload(
      {required DownloadRequest downloadRequest}) async {
    var dio = downloadRequest.customDio ?? HttpClient.getInstance().dio;
    Options options = Options(
      headers: downloadRequest.headers,
    )
      ..retries = downloadRequest.retryTimes
      ..disableRetry = false
      ..retriesDelay = const Duration(milliseconds: 500);
    Response response = await dio.download(
        downloadRequest.url, downloadRequest.savePath,
        queryParameters: downloadRequest.params,
        options: options,
        cancelToken: _cancelToken, onReceiveProgress: (received, total) {
      if (downloadRequest.listener != null) {
        downloadRequest.listener!(received, total);
      }
    });
    return response;
  }

  /// 取消下载
  void cancelTask([dynamic reason]) {
    _cancelToken.cancel(reason);
  }
}
