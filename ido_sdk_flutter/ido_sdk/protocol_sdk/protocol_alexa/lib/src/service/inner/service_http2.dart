import 'dart:async';

import 'package:alexa_net/alexa_net.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:http_parser/http_parser.dart';

part 'service_http2.g.dart';

// use: dart run build_runner build --delete-conflicting-outputs

@RestApi()
abstract class ServiceHttp2 {
  factory ServiceHttp2(Dio dio) => _ServiceHttp2(dio);

  // static ServiceHttp2? _instance;
  // static ServiceHttp2 get instance =>
  //     _instance ??= ServiceHttp2(HttpClient.getInstance().dioV2);

  /// ping
  @GET("/ping")
  Future<String> ping(
      @Header(urlType) String header,
      @Header('Authorization') String accessToken,
      @CancelRequest() CancelToken? cancelToken);

  /// 设置返回文字
  @PUT("/v1/devices/@self/capabilities")
  Future<String> setTextBackCapabilities(
      @Header(urlType) String header,
      @Header('Content-Length') int contentLength,
      @Header('x-amz-access-token') String accessToken,
      @Body() Map<String, dynamic> mapBody,
      @CancelRequest() CancelToken? cancelToken);

  /// event
  @POST("/v20160207/events")
  @MultiPart()
  Future<String?> sendEvent(
      @Header(urlType) String header,
      @Header('Authorization') String accessToken,
      @Part(contentType: 'application/json; charset=UTF-8') List<int> metadata,
      @CancelRequest() CancelToken? cancelToken);

  /// v3 event
  @POST("/v3/events")
  Future<String> sendEventV3(
      @Header(urlType) String header,
      @Header('Authorization') String accessToken,
      @CancelRequest() CancelToken? cancelToken);

  /// 删除Alexa上全部闹钟
  @DELETE("/v1/alerts/alarms?endpointId=@self")
  Future<String> deleteAllAlarms(
      @Header(urlType) String header,
      @Header('Authorization') String accessToken,
      @CancelRequest() CancelToken? cancelToken);

  /// 计时器
  @POST("/v1/alerts/timers")
  Future<String> timers(
      @Header(urlType) String header,
      @Header('Authorization') String accessToken,
      @Body() Map<String, dynamic> mapBody,
      @CancelRequest() CancelToken? cancelToken);

  /// 闹钟
  @POST("/v1/alerts/alarms")
  Future<String> alarms(
      @Header(urlType) String header,
      @Header('Authorization') String accessToken,
      @Body() Map<String, dynamic> mapBody,
      @CancelRequest() CancelToken? cancelToken);

  /// 获取闹钟
  @GET("/v1/alerts/alarms/{id}")
  Future<String> getAlarms(
      @Header(urlType) String header,
      @Header('Authorization') String accessToken,
      @Path('id') String id,
      @CancelRequest() CancelToken? cancelToken);

  /// 提醒
  @POST("/v1/alerts/reminders")
  Future<String> reminders(
      @Header(urlType) String header,
      @Header('Authorization') String accessToken,
      @Body() Map<String, dynamic> mapBody,
      @CancelRequest() CancelToken? cancelToken);
}
