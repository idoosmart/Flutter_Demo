import 'dart:async';

import 'package:native_channel/native_channel.dart';
import 'package:protocol_alexa/protocol_alexa.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'package:rxdart/rxdart.dart';

import '../private/logger/logger.dart';
import '../private/local_storage/local_storage.dart';
import '../service/model/auth_model.dart';
import '../service/service_manager.dart';
import '../type_define/alexa_type.dart';
import '../private/reachability/alexa_reachability.dart';
import 'client.dart';

part 'inner/auth_impl.dart';

/// 认证、授权管理
abstract class Auth {
  factory Auth() => _Auth();

  /// 是否已登录
  bool get isLogin;

  String get clientId;

  String? get accessToken;

  String get productId;

  /// 登录Alexa
  Future<LoginResponse> login(
      {required String productId, required CallbackPairCode func});

  /// 停止登录
  void stopLogin();

  /// 退出登录
  void logout();

  /// 刷新token (仅供内部使用)
  Future<bool> refreshToken();

  /// 监听登录状态
  StreamSubscription listenLoginStateChanged(
      void Function(LoginState state) func);

  Future<void> setClientID(String clientId);
}
