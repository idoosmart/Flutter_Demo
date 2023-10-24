part of '../service_manager.dart';

class _ServiceManager implements ServiceManager {
  late final _http1 = ServiceHttp1.instance;
  late ServiceHttp2 _http2 = ServiceHttp2(HttpClient.getInstance().dioV2);

  _ServiceManager._internal() {
    _initClient();
  }
  static final _instance = _ServiceManager._internal();
  factory _ServiceManager() => _instance;

  @override
  Future<BaseEntity<PairCode>> createCodePair(
      {required String clientId,
      required String productId,
      required String deviceSerialNumber,
      CancelToken? cancelToken}) async {
    final param = {
      'response_type': 'device_code',
      'client_id': clientId,
      'scope': 'alexa:all',
      'scope_data': jsonEncode({
        'alexa:all': {
          "productID": productId,
          "productInstanceAttributes": {
            "deviceSerialNumber": deviceSerialNumber
          }
        }
      })
    };

    logger?.d('http createCodePair body:${jsonEncode(param)}');
    return _http1
        .createCodePair(AlexaAppUrlType.alexaApiAmazon.name, param, cancelToken)
        .cast((map) => PairCode.fromJson(map));
  }

  @override
  Future<BaseEntity<AuthModel>> getAccessToken(
      {required String deviceCode,
      required String userCode,
      CancelToken? cancelToken}) {
    final param = {
      'grant_type': 'device_code',
      'device_code': deviceCode,
      'user_code': userCode,
    };
    logger?.d('http getAccessToken body:${jsonEncode(param)}');
    return _http1
        .getAccessToken(AlexaAppUrlType.alexaApiAmazon.name, param, cancelToken)
        .cast((map) => AuthModel.fromJson(map));
  }

  @override
  Future<BaseEntity<AuthModel>> refreshAccessToken(
      {required String clientId,
      required String refreshToken,
      CancelToken? cancelToken}) {
    final param = {
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken,
      'client_id': clientId,
    };
    logger?.d('http refreshAccessToken body:${jsonEncode(param)}');
    return _http1
        .getAccessToken(AlexaAppUrlType.alexaApiAmazon.name, param, cancelToken)
        .cast((map) => AuthModel.fromJson(map));
  }

  @override
  Future<BaseEntity<String>> ping(
      {required String accessToken, CancelToken? cancelToken}) {
    final token = 'Bearer $accessToken';
    return _http2
        .ping(AlexaAppUrlType.alexaGateway.name, token, cancelToken)
        .cast((map) => jsonEncode(map));
  }

  @override
  Future<BaseEntity<String>> getCustomFunc(
      {required String sessionId, CancelToken? cancelToken}) {
    return _http1.getCustomFunc(
        AlexaAppUrlType.idoCloudAlexa.name, sessionId, cancelToken);
  }

  @override
  Future<BaseEntity<String>> setTextBackCapabilities(
      {required String accessToken, CancelToken? cancelToken}) {
    final map = {
      'envelopeVersion': '20160207',
      'capabilities': [
        {
          'interface': 'SpeechSynthesizer',
          'type': 'AlexaInterface',
          'version': '1.3'
        },
        {
          'configurations': {
            'maximumAlerts': {'alarms': 50, 'overall': 53, 'timers': 3}
          },
          'interface': 'Alerts',
          'type': 'AlexaInterface',
          'version': '1.3'
        },
        {
          'interface': 'AudioPlayer',
          'type': 'AlexaInterface',
          'version': '1.4'
        },
        {
          'interface': 'Notifications',
          'type': 'AlexaInterface',
          'version': '1.0'
        },
        {
          'type': 'AlexaInterface',
          'interface': 'SpeechRecognizer',
          'version': '2.3'
        },
        {
          'interface': 'TemplateRuntime',
          'type': 'AlexaInterface',
          'version': '1.2'
        },
        {
          'interface': 'Alexa.DoNotDisturb',
          'type': 'AlexaInterface',
          'version': '1.0'
        }
      ]
    };
    //logger?.v(jsonEncode(map));
    logger?.d('http setTextBackCapabilities body:${jsonEncode(map)}');
    return _http2
        .setTextBackCapabilities(AlexaAppUrlType.alexaRESTAPI.name,
            map.toData().length, accessToken, map, cancelToken)
        .cast((map) => jsonEncode(map));
  }

  @override
  Future<BaseEntity<String>> deleteAllAlarms(
      {required String accessToken, CancelToken? cancelToken}) {
    return _http2
        .deleteAllAlarms(
            AlexaAppUrlType.alexaRESTAPI.name, accessToken, cancelToken)
        .cast((map) => jsonEncode(map));
  }

  @override
  Future<BaseEntity<ResponseBody>> createDirectives(
      {required String accessToken, CancelToken? cancelToken}) async {
    final token = 'Bearer $accessToken';
    final dio = HttpClient.getInstance().dioV2;
    final headers = <String, dynamic>{
      r'urlType': AlexaAppUrlType.alexaGateway.name,
      r'Authorization': token,
      r'Connection': 'keep-alive',
    };
    final result = await dio
        .fetch(_setStreamType(Options(
                method: 'GET',
                headers: headers,
                responseType: ResponseType.stream)
            .compose(dio.options, '/v20160207/directives',
                cancelToken: cancelToken)
            .copyWith(baseUrl: dio.options.baseUrl)))
        .catchError((e) {
      if (e is DioError) {
        return e.response ??
            Response(statusCode: -1, requestOptions: e.requestOptions);
      }
      return Response(statusCode: -1, requestOptions: RequestOptions());
    });
    if (result.statusCode == 200) {
      return BaseEntity(
          status: 0, result: result.data as ResponseBody, message: '');
    } else {
      return BaseEntity(
          status: result.statusCode ?? -1,
          result: null,
          message: result.statusMessage ?? '');
    }
  }

  @override
  Future<BaseEntity<String>> sendV3Event(
      {required String accessToken, CancelToken? cancelToken}) {
    final token = 'Bearer $accessToken';
    return _http2
        .sendEventV3(AlexaAppUrlType.alexaRESTAPI.name, token, cancelToken)
        .cast((map) => jsonEncode(map));
  }

  // @override
  // Future<BaseEntity<String>> sendEventPart(
  //     {required String accessToken,
  //     required Uint8List dataBody,
  //     String? label = '/v20160207/events',
  //     CancelToken? cancelToken}) {
  //   final token = 'Bearer $accessToken';
  //   logger?.v(' $label - httpBody: ${utf8.decode(dataBody)}');
  //   logger?.v('发送 \'$label\' 请求');
  //   return _http2
  //       .sendEvent(
  //           AlexaAppUrlType.alexaGateway.name, token, dataBody, cancelToken)
  //       .cast((map) => jsonEncode(map), label);
  // }

  @override
  Future<BaseEntity<String>> sendEventPart(
      {required String accessToken,
      required Uint8List dataBody,
      String? label = '/v20160207/events',
      CancelToken? cancelToken}) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final token = 'Bearer $accessToken';
    if (dataBody.length < 2000) {
      logger?.v('发送 \'$label\' 请求 - httpBody: ${utf8.decode(dataBody)}');
    } else {
      logger?.v('发送 \'$label\' 请求 - httpBody: 内容过长忽略显示');
    }
    final headers = <String, dynamic>{
      r'urlType': AlexaAppUrlType.alexaGateway.name,
      r'Authorization': token,
    };
    headers.removeWhere((k, v) => v == null);
    final data = FormData();
    final dio = HttpClient.getInstance().dioV2;
    data.files.add(MapEntry(
        'metadata',
        MultipartFile.fromBytes(
          dataBody,
          filename: null,
          contentType: MediaType.parse('application/json; charset=UTF-8'),
        )));
    final result = await dio
        .fetch<String>(_setStreamType<String>(Options(
      method: 'POST',
      headers: headers,
      extra: extra,
      contentType: 'multipart/form-data',
    )
            .compose(
              dio.options,
              '/v20160207/events',
              queryParameters: queryParameters,
              data: data,
              cancelToken: cancelToken,
            )
            .copyWith(baseUrl: dio.options.baseUrl)))
        .catchError((e) {
      if (e is DioError) {
        return Response<String>(
            statusCode: e.response?.statusCode ?? -1,
            requestOptions: e.requestOptions);
      }
      return Response<String>(statusCode: -1, requestOptions: RequestOptions());
    });

    BaseEntity<String>? rs;
    if (result.statusCode == 200) {
      rs = BaseEntity(
          status: 0, result: result.data as String, message: '', httpCode: 200);
    } else {
      rs = BaseEntity(
          status: result.statusCode ?? -1,
          result: null,
          message: result.statusMessage ?? '',
          httpCode: result.statusCode);
    }

    if (label != null) {
      logger?.v('收到 \'$label\' 响应 result: $rs');
    }
    return rs;
  }

  @override
  Future<BaseEntity<String>> timers(
      {required String accessToken,
      required Map<String, dynamic> mapBody,
      CancelToken? cancelToken}) {
    return _http2
        .timers(AlexaAppUrlType.alexaRESTAPI.name, accessToken, mapBody,
            cancelToken)
        .cast((map) => jsonEncode(map));
  }

  @override
  Future<BaseEntity<String>> alarms(
      {required String accessToken,
      required Map<String, dynamic> mapBody,
      CancelToken? cancelToken}) {
    return _http2
        .alarms(AlexaAppUrlType.alexaRESTAPI.name, accessToken, mapBody,
            cancelToken)
        .cast((map) => jsonEncode(map));
  }

  @override
  Future<BaseEntity<String>> getAlarms(
      {required String accessToken,
        required String id,
        CancelToken? cancelToken}) {
    return _http2
        .getAlarms(AlexaAppUrlType.alexaRESTAPI.name, accessToken, id,
        cancelToken)
        .cast((map) => jsonEncode(map));
  }

  @override
  Future<BaseEntity<String>> reminders(
      {required String accessToken,
      required Map<String, dynamic> mapBody,
      CancelToken? cancelToken}) {
    return _http2
        .reminders(AlexaAppUrlType.alexaRESTAPI.name, accessToken, mapBody,
            cancelToken)
        .cast((map) => jsonEncode(map));
  }


  @override
  Future<BaseEntity<ResponseBody>> uploadAudioStream(
      {required String accessToken,
      required Uint8List jsonBody,
      required Stream<List<int>> stream,
      required int length,
      CancelToken? cancelToken}) async {
    // throw '';
    final token = 'Bearer $accessToken';

    final headers = <String, dynamic>{
      r'urlType': AlexaAppUrlType.alexaGateway.name,
      r'Authorization': token,
      //r'Transfer-Encoding': 'chunked',
      //r'ignoreContentLength': '1',
    };
    headers.removeWhere((k, v) => v == null);
    final data = FormData();
    data.files.add(MapEntry(
        'metadata',
        MultipartFile.fromBytes(
          jsonBody,
          filename: 'speech',
          contentType: MediaType.parse('application/json; charset=UTF-8'),
        )));
    data.files.add(MapEntry(
        'audio',
        MultipartFile(stream, length,
            contentType: MediaType.parse('application/octet-stream'))));

    final dio = HttpClient.getInstance().dioV2;
    final result = await dio
        .fetch(_setStreamType<String>(Options(
                method: 'POST',
                headers: headers,
                contentType: 'multipart/form-data',
                responseType: ResponseType.stream)
            .compose(
              dio.options,
              '/v20160207/events',
              data: data,
              cancelToken: cancelToken,
            )
            .copyWith(baseUrl: dio.options.baseUrl)))
        .catchError((e) {
      if (e is DioException) {
        return e.response ??
            Response(
                statusCode: e.response?.statusCode ?? -1,
                statusMessage: e.response?.statusMessage,
                requestOptions: e.requestOptions);
      }
      return Response(statusCode: -1, requestOptions: RequestOptions());
    });

    if (result.statusCode == 200) {
      return BaseEntity(
          status: 0, result: result.data as ResponseBody, message: '');
    } else {
      return BaseEntity(
          status: result.statusCode ?? -1,
          result: null,
          message: result.statusMessage ?? '');
    }
  }
}

extension _ServiceManagerExt on _ServiceManager {
  /// 初始化网络请求
  void _initClient() {
    HttpClient.init(needPrintLog: true, netLog: _AlexaNetLog());

    // 监听dio重新实例化
    HttpClient.getInstance().listenDioV2InstanceChanged((p0) {
      logger?.d('reset _http2');
      _http2 = ServiceHttp2(HttpClient.getInstance().dioV2);
    });
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}

class _NetManager {
  _NetManager._();

  static Future<BaseEntity<T>> handlerRequest<T>(Future<String?> originsRequest,
      T? Function(Map<String, dynamic> map) func, String? label) async {
    final resultData = originsRequest.then((response) {
      final result = func.call(response != null ? jsonDecode(response) : null);
      final rs = BaseEntity<T>(status: 0, result: result, message: '');
      if (label != null) {
        logger?.v('收到 \'$label\' 响应 result: $rs');
      }
      return rs;
    }).catchError((e) {
      int? statusCode;
      String? msg;
      if (e is DioException) {
        statusCode = e.response?.statusCode;
        msg = e.response?.statusMessage;
      }
      int code = statusCode ?? -1;
      return BaseEntity<T>(status: code, result: null, message: msg ?? 'error', httpCode: statusCode);
    });
    return resultData;
  }
}

extension _NetExtension<T> on Future<String?> {
  Future<BaseEntity<U>> cast<U>(U? Function(Map<String, dynamic> map) func,
      [String? label]) {
    return _NetManager.handlerRequest(this, func, label);
  }
}

class _AlexaNetLog extends NetLog {
  @override
  void v(String info, {String methodName = "", String className = ""}) {
    //debugPrint(info);
    logger?.v('alexa_net - $info');
  }

  @override
  void d(String info, {String methodName = "", String className = ""}) {
    //debugPrint(info);
    logger?.d('alexa_net - $info');
  }

  @override
  void e(String info, {String methodName = "", String className = ""}) {
    //debugPrint(info);
    logger?.e('alexa_net - $info');
  }
}
