import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:alexa_net/alexa_net.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ido_logger/ido_logger.dart';
import 'package:protocol_alexa/src/module/auth.dart';
import 'package:protocol_alexa/src/module/upload_directives.dart';
import 'package:protocol_alexa/src/module/voice.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'package:native_channel/native_channel.dart';

import '../../protocol_alexa.dart';
import '../private/local_storage/local_storage.dart';
import '../private/logger/logger.dart';
import '../private/reachability/alexa_reachability.dart';
import '../service/model/directive_model.dart';
import '../service/model/timer_model.dart';
import '../service/model/voicealarm_model.dart';
import '../service/service_manager.dart';
import '../private/tools/data_box.dart';
import 'capabilities_report.dart';
import 'down_directives.dart';

part 'inner/client_impl.dart';

abstract class AlexaClient {
  factory AlexaClient() => _AlexaClient();

  IDOAlexaDelegate? delegate;

  /// 当前上行流消息id
  String get messageId;

  bool? isSmartHomeSkill;

  String? lastTimerToken;

  List alarmArr = [];

  List reminderArr = [];

  Voice get voice;

  Auth get auth;

  UploadDirectivesAnalysis get uploadDirectivesAnalysis;

  /// 计时器
  List createTimerArr();

  /// 闹钟
  Future<List> createAlarmArr(bool isCreate);

  /// 创建下行流
  Future<bool> createNewDirectives();

  /// 监听下行流通道数据
  StreamSubscription listenDirectiveData(
      void Function(DirectiveModel model) func);

  /// 监听Alexa语音上传后的回复数据
  StreamSubscription listenUploadVoiceData(
      void Function(VoiceReceivedData receivedData) func);

  /// 设置log
  static Future<bool> setLog(writeToFile, bool outputToConsole,
      {LoggerLevel logLevel = LoggerLevel.verbose}) async {
    return _AlexaClient._setLog(writeToFile, outputToConsole, logLevel: logLevel);
  }
}
