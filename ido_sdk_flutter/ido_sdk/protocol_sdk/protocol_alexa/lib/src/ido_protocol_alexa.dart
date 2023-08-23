import 'dart:async';
import 'dart:io';

import 'package:alexa_net/alexa_net.dart';
import 'package:flutter/foundation.dart';
import 'package:ido_logger/ido_logger.dart';
import 'package:protocol_lib/protocol_lib.dart';

import 'module/identity_log_report.dart';
import 'type_define/alexa_type.dart';
import 'service/service_manager.dart';
import 'private/local_storage/local_storage.dart';
import 'private/logger/logger.dart';
import 'private/tools/string_extension.dart';
import 'module/auth.dart';
import 'module/client.dart';
import 'private/tools/lan_type_ext.dart';
import 'private/tools/data_box.dart';

part 'private/protocol_alexa_impl.dart';

abstract class IDOProtocolAlexa {
  factory IDOProtocolAlexa() => _IDOProtocolAlexa();

  /// 获取sdk版本信息
  ///
  /// 形如：1.0.0
  String get getSdkVersion;

  /// 是否已登录
  bool get isLogin;

  /// 获取当前语言
  AlexaLanguageType get currentLanguage;

  /// 指定代理
  set delegate(IDOAlexaDelegate delegate);

  /// 注册alexa
  /// ```dart
  /// clientId Alexa后台生成的ID
  /// writeToFile 写log文件
  /// outputToConsole 打印到控制台
  /// logLevel 日志级别（该值只会在debug模式下有效）
  /// ```
  static Future<void> registerAlexa(
      {required String clientId,
      bool outputToConsole = true}) async {
    await _IDOProtocolAlexa.initLog(
        outputToConsole: outputToConsole);
    await _IDOProtocolAlexa.registerAlexa(clientId: clientId);
  }

  /// 切换语言 默认英语
  static Future<bool> changeLanguage(AlexaLanguageType type) {
    return _IDOProtocolAlexa.changeLanguage(type);
  }

  /// Alexa CBL授权
  /// ```dart
  /// productId 在alexa后台注册的产品ID
  /// func 回调Alexa认证需要打开的url和userCode
  /// ```
  Future<LoginResponse> authorizeRequest(
      {required String productId, required CallbackPairCode func});

  /// 停止登录 (结束当前执行中的相关登录操作)
  void stopLogin();

  /// 退出登录
  void logout();

  /// 监听登录状态
  StreamSubscription listenLoginStateChanged(
      void Function(LoginState state) func);

  /// 监听语音状态
  StreamSubscription listenVoiceStateChanged(
      void Function(VoiceState state) func);

  // ---------------------- 内部测试使用 ----------------------

  /// 是否支持语音测试
  Future<bool> get isSupportAudioTesting;

  /// 测试pcm上传 (内部使用)
  Future<bool> testUploadPCM(String pcmPath);

  debugTest();
  refreshToken();
}

abstract class IDOAlexaDelegate {
  /// 获取健康数据
  Future<int> getHealthValue(AlexaGetValueType valueType);

  /// 获取心率
  Future<int> getHrValue(AlexaHRDataType dataType, AlexaHRTimeType timeType);

  /// 功能控制
  void foundationControl(AlexaFoundationType foundationType);
}
