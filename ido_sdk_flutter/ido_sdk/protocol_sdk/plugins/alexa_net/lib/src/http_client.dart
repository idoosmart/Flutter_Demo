import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';

import '../alexa_net.dart';

/// 头部参数回调
typedef HeaderParams = Future<Map<String, dynamic>> Function();

/// 拼接参数回调
typedef UrlParams = Future<Map<String, dynamic>> Function();

const urlType = "urlType";

class HttpClient {
  static HttpClient? _instance;
  static bool _init = false;
  static bool _needPrintLog = false;

  static HeaderParams? _headerParams;
  static UrlParams? _urlParams;
  static late NetLog _netLog;
  static late Duration _connectTimeout;

  final _dioV2ChangeStreamCtl = StreamController<int>.broadcast();

  /// 先初始化init
  static void init(
      {HeaderParams? headers,
      UrlParams? urls,
      Duration connectTimeout = const Duration(seconds: 30),
      NetLog? netLog,
      bool needPrintLog = false}) {
    if (_init) {
      return;
    }
    _init = true;
    _needPrintLog = needPrintLog;
    _netLog = netLog ?? DefaultLog();
    _headerParams = headers;
    _urlParams = urls;
    _connectTimeout = connectTimeout;
    HttpClient.getInstance()._initDio(headerParams: headers,
        urlParams: urls);
  }

  HttpClient._();

  static HttpClient getInstance() {
    assert(_init, 'has call HttpClient.init(...) first');
    return _instance ??= HttpClient._();
  }

  final Dio _dio = Dio(BaseOptions());
  Dio? _dioV2;

  LogInterceptor? _logInterceptor;
  PrettyDioLogger? _prettyDioLogger;

  void _initDio(
      {HeaderParams? headerParams,
      UrlParams? urlParams}) {
    _dio._setupOptions(
        headerParams: headerParams,
        urlParams: urlParams,
        connectTimeout: _connectTimeout);

    final logInterceptor = LogInterceptor(_netLog);
    _logInterceptor = logInterceptor;
    _dio.interceptors.add(logInterceptor);

    if (_needPrintLog) {
      final dioLogger = PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 180, logPrint: _curtomPrint);
      _dio.interceptors.add(dioLogger);
      _prettyDioLogger = dioLogger;
    }

    // if (kDebugMode) {
    //   // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
    //   (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
    //       (client) {
    //     client.findProxy = (url) {
    //       return 'PROXY 10.1.2.152:8888'; //这里将localhost设置为自己电脑的IP，其他不变，注意上线的时候一定记得把代理去掉
    //     };
    //     //client.idleTimeout = const Duration(seconds: 5);
    //     //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
    //     client.badCertificateCallback =
    //         (X509Certificate cert, String host, int port) => true;
    //     return client;
    //   };
    // }

    _createNewDioV2();
  }

  HttpClient addAllCustomerInterceptor(List<Interceptor> interceptors) {
    dio.interceptors.addAll(interceptors);
    return this;
  }

  doRecreateDioV2() {
    // 重置 dioV2实例
    log.e("reset dioV2 instance");
    HttpClient.getInstance()._createNewDioV2();
    if (HttpClient.getInstance()._dioV2ChangeStreamCtl.hasListener &&
        !HttpClient.getInstance()._dioV2ChangeStreamCtl.isClosed) {
      HttpClient.getInstance()._dioV2ChangeStreamCtl.add(0);
    }
  }

  Dio get dio => _dio;
  Dio get dioV2 => _dioV2!;

  NetLog get log => _netLog;

  // !!! 处理flutter http 以下异常问题：
  // flutter SocketException: Bad file descriptor (OS Error: Bad file descriptor, errno = 9)
  // 解决思路：出现该问题后，此处重新创建_dioV2实例并通知到外部（alexa收到后需重新创建下行流通道）
  /// dioV2 实例变更通知
  StreamSubscription listenDioV2InstanceChanged(void Function(int) func) {
    return _dioV2ChangeStreamCtl.stream.listen(func);
  }

  void _curtomPrint(Object? object) {
    String line = "$object";
    log.v(line);
  }

  /// 创建diov2
  void _createNewDioV2() {
    _dioV2 = Dio(BaseOptions());
    _dioV2?._setupOptions(
        headerParams: _headerParams,
        urlParams: _urlParams,
        connectTimeout: _connectTimeout);
    if (_logInterceptor != null) {
      _dioV2?.interceptors.add(_logInterceptor!);
    }
    if (_prettyDioLogger != null) {
      _dioV2?.interceptors.add(_prettyDioLogger!);
    }

    _dioV2?.httpClientAdapter = Http2Adapter(ConnectionManager(
      idleTimeout: const Duration(seconds: 60),
      // Ignore bad certificate
      onClientCreate: (_, config) {
        config.onBadCertificate = (_) => true;
        //config.proxy = Uri.parse('http://10.1.2.152:8888');
      },
    ));
  }
}

/// 记录log
class LogInterceptor extends Interceptor {
  final NetLog log;
  bool isOnDioCreating = false; // 重新创建dio实例中

  LogInterceptor(this.log);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {

    final uri = options.uri;
    final method = options.method;
    log.d('Request $method ${uri.toString()}');

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      super.onResponse(response, handler);

      final uri = response.requestOptions.uri;
      final method = response.requestOptions.method;
      log.d('Response $method Status: ${response.statusCode} ${response.statusMessage} ${uri.toString()}');

      if (response.statusCode == 200) {
        response.data ??= '{}';
      } else if (response.statusCode == 204 || response.statusCode == 202) {
        // 204 no content
        if (response.data is String && (response.data as String).isEmpty) {
          // 空字符串会导致解析异常
          response.data = '{}';
        } else {
          response.data ??= '{}';
        }
      }
    } catch (e) {
      log.e("NetWork 请求接口失败 ${e.toString()}");
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    if (err.response?.statusCode != 200) {
      log.e(
          "NetWork 返回接口失败 url = ${err.response?.requestOptions.uri.toString()} -- "
          " DioErrorType:${err.type} "
          "请求数据 = ${err.response?.requestOptions.data} statusCode = ${err.response?.statusCode} "
          "${err.error != null ? 'err:${err.error?.toString()}' : ''}",
          methodName: "onError",
          className: "LogInterceptor");

      // 异常处理 flutter SocketException: Bad file descriptor (OS Error: Bad file descriptor, errno = 9)
      if (err.error != null && err.error is SocketException) {
          final exception = err.error as SocketException;
          if (exception.osError?.errorCode == 9 && !isOnDioCreating) {
            // 重置 dioV2实例
            log.e("reset dioV2 instance");
            isOnDioCreating = true;
            HttpClient.getInstance()._createNewDioV2();
            if (HttpClient.getInstance()._dioV2ChangeStreamCtl.hasListener) {
              HttpClient.getInstance()._dioV2ChangeStreamCtl.add(0);
            }
            isOnDioCreating = false;
          }
      }
    }
  }
}

/// 处理服务器参数等拦截器
class BaseInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final serverBase = AlexaServerManager().getServer();
    String? urlTypeValue;
    String? baseUrl;

    if (options.headers.containsKey(urlType)) {
      urlTypeValue = options.headers[urlType];
    }

    if (urlTypeValue != null) {
      final type = AlexaAppUrlType.convertForName(urlTypeValue);
      if (type != null) {
        baseUrl = serverBase.getBaseUrl(type);
      }
    }

    if (baseUrl != null) {
      options.baseUrl = baseUrl;
    } else {
      HttpClient.getInstance().log.e('base url is null');
    }

    super.onRequest(options, handler);
  }
}

/// 处理统一params
class UrlParamsInterceptor extends Interceptor {
  final UrlParams? params;

  UrlParamsInterceptor({required this.params});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    Map<String, dynamic> queryParams = {};
    queryParams.addAll(options.queryParameters);
    if (params != null) {
      queryParams.addAll(await params!());
    }
    options.queryParameters = queryParams;
    super.onRequest(options, handler);
  }
}

/// 处理统一头部
class HeaderInterceptor extends Interceptor {
  final HeaderParams? params;

  HeaderInterceptor({required this.params});

  String _getHbType() {
    if (Platform.isAndroid) {
      return "ayb-android";
    } else if (Platform.isIOS) {
      return "ayb-ios";
    }
    return "ayb-android";
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    Map<String, dynamic> headers = {};
    if (options.headers['Content-Type'] == null) {
      headers["Content-Type"] = "application/json;charset=UTF-8";
    }
    //headers["Accept-Encoding"] = "";
    // headers["Connection"] = "keep-alive";
    headers["Accept"] = "*/*";
    headers['accept-encoding'] = 'gzip, deflate, br';
    // headers['accept-language'] = 'zh-CN,zh-Hans;q=0.9';
    //headers["X-HB-Client-Type"] = _getHbType();
    if (params != null) {
      headers.addAll(await params!());
    }
    headers.addAll(options.headers);
    options.headers = headers;
    super.onRequest(options, handler);
  }
}

extension _DioSetupOptions on Dio {
  void _setupOptions(
      {HeaderParams? headerParams,
      UrlParams? urlParams,
      required Duration connectTimeout}) {
    options.connectTimeout = connectTimeout;
    options.receiveTimeout = const Duration(seconds: 60);
    options.baseUrl = "https://api.amazonalexa.com";
    interceptors.add(HeaderInterceptor(params: headerParams));
    interceptors.add(BaseInterceptor());
    interceptors.add(RetryInterceptor(
      dio: this,
    ));
    interceptors.add(UrlParamsInterceptor(params: urlParams));
  }
}
