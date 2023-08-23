import 'package:dio/dio.dart';

abstract class BaseFileRequest {

  /// 重试次数
  final int retryTimes;
  /// 链接
  final String url;
  /// 参数
  final Map<String, dynamic> params;
  /// 头部参数
  final Map<String,dynamic> headers;

  final Dio? customDio;

  BaseFileRequest({required this.retryTimes,required this.url,required this.params, required this.headers, this.customDio});
}
