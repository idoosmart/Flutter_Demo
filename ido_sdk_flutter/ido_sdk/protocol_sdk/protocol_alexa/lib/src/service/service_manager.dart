import 'dart:async';
import 'dart:convert';

import 'package:alexa_net/alexa_net.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:native_channel/native_channel.dart';

import '../private/logger/logger.dart';
import '../private/tools/map_extension.dart';
import 'inner/service_http1.dart';
import 'inner/service_http2.dart';
import 'model/auth_model.dart';
import 'model/pair_code.dart';

part 'inner/service_manager_impl.dart';

abstract class ServiceManager {
  factory ServiceManager() => _ServiceManager();

  /// 请求授权
  Future<BaseEntity<PairCode>> createCodePair(
      {required String clientId,
      required String productId,
      required String deviceSerialNumber,
      CancelToken? cancelToken});

  /// 获取token
  Future<BaseEntity<AuthModel>> getAccessToken(
      {required String deviceCode,
      required String userCode,
      CancelToken? cancelToken});

  /// 刷新token
  Future<BaseEntity<AuthModel>> refreshAccessToken(
      {required String clientId,
      required String refreshToken,
      CancelToken? cancelToken});

  /// 创建下行流
  Future<BaseEntity<ResponseBody>> createDirectives(
      {required String accessToken, CancelToken? cancelToken});

  /// event
  Future<BaseEntity<String>> sendEventPart(
      {required String accessToken,
      required Uint8List dataBody,
      String? label,
      CancelToken? cancelToken});

  /// event 音频流上传
  Future<BaseEntity<ResponseBody>> uploadAudioStream(
      {required String accessToken,
      required Uint8List jsonBody,
      required Stream<List<int>> stream,
      required int length,
      CancelToken? cancelToken});

  /// ping
  Future<BaseEntity<String>> ping(
      {required String accessToken, CancelToken? cancelToken});

  /// v3 event
  Future<BaseEntity<String>> sendV3Event(
      {required String accessToken, CancelToken? cancelToken});

  /// 计时器
  Future<BaseEntity<String>> timers(
      {required String accessToken,
      required Map<String, dynamic> mapBody,
      CancelToken? cancelToken});

  /// 闹钟
  Future<BaseEntity<String>> alarms(
      {required String accessToken,
      required Map<String, dynamic> mapBody,
      CancelToken? cancelToken});

  /// 获取闹钟
  Future<BaseEntity<String>> getAlarms(
      {required String accessToken,
        required String id,
        CancelToken? cancelToken});

  /// 提醒
  Future<BaseEntity<String>> reminders(
      {required String accessToken,
      required Map<String, dynamic> mapBody,
      CancelToken? cancelToken});

  /// 设置返回文字
  Future<BaseEntity<String>> setTextBackCapabilities(
      {required String accessToken, CancelToken? cancelToken});

  /// 删除Alexa上全部闹钟
  Future<BaseEntity<String>> deleteAllAlarms(
      {required String accessToken, CancelToken? cancelToken});

  /// 获取自定义功能 (IDO)
  Future<BaseEntity<String>> getCustomFunc(
      {required String sessionId, CancelToken? cancelToken});
}
