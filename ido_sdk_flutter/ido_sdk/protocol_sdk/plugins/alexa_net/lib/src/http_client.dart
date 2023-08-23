import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
// import 'package:native_dio_adapter/native_dio_adapter.dart';

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

  static late NetLog _netLog;

  /// 先初始化init
  static void init(
      {HeaderParams? headers,
      UrlParams? urls,
      connectTimeout = 30 * 1000,
      NetLog? netLog,
      bool needPrintLog = false}) {
    if (_init) {
      return;
    }
    _init = true;
    _needPrintLog = needPrintLog;
    _netLog = netLog ?? DefaultLog();
    HttpClient.getInstance()._initDio(headerParams: headers, urlParams: urls);
  }

  HttpClient._();

  static HttpClient getInstance() {
    assert(_init, 'has call HttpClient.init(...) first');
    return _instance ??= HttpClient._();
  }

  final Dio _dio = Dio(BaseOptions());
  final Dio _dioV2 = Dio(BaseOptions());

  void _initDio(
      {HeaderParams? headerParams,
      UrlParams? urlParams,
      int connectTimeout = 30 * 1000}) {
    _dio._setupOptions(
        headerParams: headerParams,
        urlParams: urlParams,
        connectTimeout: connectTimeout);
    _dioV2._setupOptions(
        headerParams: headerParams,
        urlParams: urlParams,
        connectTimeout: connectTimeout);

    final logInterceptor = LogInterceptor(_netLog);
    _dio.interceptors.add(logInterceptor);
    _dioV2.interceptors.add(logInterceptor);

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
      _dioV2.interceptors.add(dioLogger);
    }

    dioV2.httpClientAdapter = Http2Adapter(ConnectionManager(
      idleTimeout: const Duration(seconds: 30),
      // Ignore bad certificate
      onClientCreate: (_, config) {
        config.onBadCertificate = (_) => true;
        //config.proxy = Uri.parse('http://10.1.2.152:8888');
      },
    ));

    // dioV2.httpClientAdapter = NativeAdapter();

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
  }

  HttpClient addAllCustomerInterceptor(List<Interceptor> interceptors) {
    dio.interceptors.addAll(interceptors);
    return this;
  }

  Dio get dio => _dio;
  Dio get dioV2 => _dioV2;

  NetLog get log => _netLog;

  void _curtomPrint(Object? object) {
    String line = "$object";
    log.v(line);
  }
}

/// 记录log
class LogInterceptor extends Interceptor {
  final NetLog log;

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
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    if (err.response?.statusCode != 200) {
      log.e(
          "NetWork 返回接口失败 url = ${err.response?.requestOptions.uri.toString()} -- "
          " DioErrorType:${err.type} "
          "请求数据 = ${err.response?.requestOptions.data} statusCode = ${err.response?.statusCode} "
          "${err.error != null ? 'err:${err.error?.toString()}' : ''}",
          methodName: "onError",
          className: "LogInterceptor");
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
      int connectTimeout = 30 * 1000}) {
    options.connectTimeout = Duration(milliseconds: connectTimeout);
    options.receiveTimeout = const Duration(milliseconds: 30 * 1000);
    options.baseUrl = "-";
    interceptors.add(HeaderInterceptor(params: headerParams));
    interceptors.add(BaseInterceptor());
    interceptors.add(RetryInterceptor(
      dio: this,
    ));
    interceptors.add(UrlParamsInterceptor(params: urlParams));
  }
}
