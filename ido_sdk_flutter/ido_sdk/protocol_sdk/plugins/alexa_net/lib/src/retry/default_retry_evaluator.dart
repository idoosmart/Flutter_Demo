import 'dart:async';

import 'package:dio/dio.dart';

class DefaultRetryEvaluator {
  DefaultRetryEvaluator(this._retryStatuses);

  final Set<int> _retryStatuses;

  bool evaluate(DioError error, int attempt) {
    bool shouldRetry;
    if (error.type == DioErrorType.badResponse) {
      final statusCode = error.response?.statusCode;
      if (statusCode != null) {
        shouldRetry = isCanRetry(statusCode);
      } else {
        shouldRetry = true;
      }
    } else {
      shouldRetry =
          error.type != DioErrorType.cancel && error.error is! FormatException;
    }
    return shouldRetry;
  }

  bool isCanRetry(int statusCode) => _retryStatuses.contains(statusCode);
}