import 'dart:async';
import 'package:dio/dio.dart';
import 'default_retry_evaluator.dart';
import 'http_status_codes.dart';

typedef RetryEvaluator = FutureOr<bool> Function(DioError error, int attempt);

/// 参考项目  https://github.com/rodion-m/dio_smart_retry
/// An interceptor that will try to send failed request again
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.logPrint,
    RetryEvaluator? retryEvaluator,
    this.ignoreRetryEvaluatorExceptions = false,
    this.retryExtraStatuses = const {},
  }) : _retryEvaluator = retryEvaluator ??
      DefaultRetryEvaluator({
        ...defaultRetryableStatuses,
        ...retryExtraStatuses,
      }).evaluate {
    if (retryEvaluator != null && retryExtraStatuses.isNotEmpty) {
      throw ArgumentError(
        '[retryableExtraStatuses] works only if [retryEvaluator] is null.'
            ' Set either [retryableExtraStatuses] or [retryEvaluator].'
            ' Not both.',
        'retryableExtraStatuses',
      );
    }
  }

  /// The original dio
  final Dio dio;

  /// For logging purpose
  final void Function(String message)? logPrint;

  /// Ignore exception if [_retryEvaluator] throws it (not recommend)
  final bool ignoreRetryEvaluatorExceptions;

  /// Evaluating if a retry is necessary.regarding the error.
  ///
  /// It can be a good candidate for additional operations too, like
  ///   updating authentication token in case of a unauthorized error
  ///   (be careful with concurrency though).
  ///
  /// Defaults to [DefaultRetryEvaluator.evaluate]
  ///   with [defaultRetryableStatuses].
  final RetryEvaluator _retryEvaluator;

  /// Specifies an extra retryable statuses,
  ///   which will be taken into account with [defaultRetryableStatuses]
  /// IMPORTANT: THIS SETTING WORKS ONLY IF [_retryEvaluator] is null
  final Set<int> retryExtraStatuses;

  /// Redirects to [DefaultRetryEvaluator.evaluate]
  ///   with [defaultRetryableStatuses]
  static final FutureOr<bool> Function(DioError error, int attempt)
  defaultRetryEvaluator =
      DefaultRetryEvaluator(defaultRetryableStatuses).evaluate;

  Future<bool> _shouldRetry(DioError error, int attempt) async {
    try {
      return await _retryEvaluator(error, attempt);
    } catch (e) {
      logPrint?.call('There was an exception in _retryEvaluator: $e');
      if (!ignoreRetryEvaluatorExceptions) {
        rethrow;
      }
    }
    return true;
  }

  @override
  Future<dynamic> onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.requestOptions.disableRetry) {
      return super.onError(err, handler);
    }
    bool isRequestedCancelled() =>
        err.requestOptions.cancelToken?.isCancelled == true;

    final attempt = err.requestOptions._attempt + 1;
    final retries = err.requestOptions._retries;
    final shouldRetry = attempt <= retries && await _shouldRetry(err, attempt);
    if (!shouldRetry) {
      return super.onError(err, handler);
    }
    err.requestOptions._attempt = attempt;
    final delay = err.requestOptions._retriesDelay;
    logPrint?.call(
      '[${err.requestOptions.path}] An error occurred during request, '
          'trying again '
          '(attempt: $attempt/$retries, '
          'wait ${delay.inMilliseconds} ms, '
          'error: ${err.error})',
    );

    if (delay != Duration.zero) {
      await Future<void>.delayed(delay);
    }
    if (isRequestedCancelled()) {
      logPrint?.call('Request was cancelled. Cancel retrying.');
      return super.onError(err, handler);
    }
    try {
      await dio
          .fetch<void>(err.requestOptions)
          .then((value) => handler.resolve(value));
    } on DioError catch (e) {
      super.onError(e, handler);
    }
  }

}

const _kDisableRetryKey = 'ro_disable_retry';
const _kRetriesKey = 'ro_retry';
const _kRetriesDelayKey = "ro_retries_delay";

extension RequestOptionsX on RequestOptions {
  static const _kAttemptKey = 'ro_attempt';

  int get _attempt => (extra[_kAttemptKey] as int?) ?? 0;

  set _attempt(int value) => extra[_kAttemptKey] = value;

  bool get disableRetry => (extra[_kDisableRetryKey] as bool?) ?? true;

  set disableRetry(bool value) => extra[_kDisableRetryKey] = value;

  int get _retries =>(extra[_kRetriesKey] as int?) ?? 0;

  set retries(int value) =>  extra[_kRetriesKey] = value;

  Duration get _retriesDelay =>(extra[_kRetriesDelayKey] as Duration?) ?? Duration.zero;

  set retriesDelay(Duration duration) => extra[_kRetriesDelayKey] = duration;
}

extension OptionsX on Options {

  bool get disableRetry => (extra?[_kDisableRetryKey] as bool?) ?? true;

  set disableRetry(bool value) => extra?[_kDisableRetryKey] = value;

  int get retries =>(extra?[_kRetriesKey] as int?) ?? 0;

  set retries(int value) =>  extra?[_kRetriesKey] = value;

  Duration get retriesDelay =>(extra?[_kRetriesDelayKey] as Duration?) ?? Duration.zero;

  set retriesDelay(Duration duration) => extra?[_kRetriesDelayKey] = duration;

}
