import 'dart:typed_data';

import 'package:alexa_net/alexa_net.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:http_parser/http_parser.dart';

import '../model/auth_model.dart';
import '../model/pair_code.dart';

part 'service_http1.g.dart';

// use: dart run build_runner build --delete-conflicting-outputs

@RestApi()
abstract class ServiceHttp1 {
  factory ServiceHttp1(Dio dio) => _ServiceHttp1(dio);

  static ServiceHttp1? _instance;
  static ServiceHttp1 get instance =>
      _instance ??= ServiceHttp1(HttpClient.getInstance().dio);

  /// 授权请求
  @FormUrlEncoded()
  @POST("/auth/O2/create/codepair")
  Future<String> createCodePair(
      @Header(urlType) String header,
      @Body() Map<String, dynamic> params,
      @CancelRequest() CancelToken? cancelToken);

  /// 获取AccessToken
  @FormUrlEncoded()
  @POST("/auth/O2/token")
  Future<String> getAccessToken(
      @Header(urlType) String header,
      @Body() Map<String, dynamic> params,
      @CancelRequest() CancelToken? cancelToken);

  /// 获取自定义功能（IDO)
  @FormUrlEncoded()
  @POST("/avs/directive/get")
  Future<BaseEntity<String>> getCustomFunc(
      @Header(urlType) String header,
      @Field("directiveId") String sessionId,
      @CancelRequest() CancelToken? cancelToken);

  //
}
