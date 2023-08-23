import 'package:dio/dio.dart';

import '../bean/base_entity.dart';
import '../http_client.dart';
import '../retry/retry_interceptor.dart';
import 'upload_request.dart';

/// 創建上傳任務
class UploadTask {
  CancelToken cancelToken = CancelToken();

  /// 开始上传
  Future<BaseEntity<T>> startUpload<T>(
      {required UploadRequest uploadRequest}) async {
    var dio = uploadRequest.customDio ?? HttpClient.getInstance().dio;
    uploadRequest.params['file'] = await MultipartFile.fromFile(
        uploadRequest.filePath,
        filename: uploadRequest.fileName);
    FormData formData = FormData.fromMap(uploadRequest.params);
    Options options = Options(headers: uploadRequest.headers,)
      ..retries = uploadRequest.retryTimes
      ..disableRetry = false
      ..retriesDelay = const Duration(milliseconds: 500);

    Response response = await dio.post(uploadRequest.url,
        cancelToken: cancelToken,
        options: options,
        data: formData, onSendProgress: (int progress, int total) {
      if (uploadRequest.listener != null) {
        uploadRequest.listener!(progress, total);
      }
    });
    final value = BaseEntity<T>.fromJson(
      response.data!,
      (json) => json as T,
    );
    return value;
  }

  /// 取消上传
  void cancelTask([dynamic reason]) {
    cancelToken.cancel(reason);
  }
}
