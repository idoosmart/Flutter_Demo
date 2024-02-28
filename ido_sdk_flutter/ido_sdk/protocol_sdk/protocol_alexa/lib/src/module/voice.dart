import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:math';
import 'dart:typed_data';

import 'package:native_channel/native_channel.dart';
import 'package:flutter/foundation.dart';
import 'package:alexa_net/alexa_net.dart';
import 'package:dio/dio.dart';
import 'package:protocol_alexa/src/module/client.dart';
import 'package:protocol_lib/protocol_lib.dart';

import '../../protocol_alexa.dart';
import '../private/reachability/alexa_reachability.dart';
import '../service/model/directive_model.dart';
import '../private/tools/data_box.dart';
import '../private/tools/uint8list_extension.dart';
import '../private/tools/file_tool.dart';
import '../private/logger/logger.dart';
import '../service/service_manager.dart';
import 'auth.dart';

part 'inner/voice_impl.dart';

/// 语音数据
abstract class Voice {
  factory Voice() => _Voice();

  String get uniqueID;

  AlexaDelegate get alexaDelegate;

  AlexaOperator? alexaOperator;

  bool get isOnListening;

  /// 监听Alexa语言上传后的反馈数据
  StreamSubscription listenUploadVoiceData(
      void Function(VoiceReceivedData receivedData) func);

  /// 监听语音状态
  StreamSubscription listenVoiceStateChanged(
      void Function(VoiceState state) func);

  // /// 启动监听
  // void startMonitor();
  //
  // /// 停止监听
  // void stopMonitor();

  /// 停止上传
  void stopUpload();

  /// 结束上传
  void endUpload(String dialogRequestId);

  void test();

  /// 测试pcm上传 (内部使用)
  Future<bool> testUploadPCM(String pcmPath);
}

/// 语音收到的回复数据
class VoiceReceivedData {
  final VoiceReceivedCode code;
  final List<DirectiveModel>? modelList;
  final Uint8List? audioData;
  final String? audioFilePath;

  VoiceReceivedData(
      {this.code = VoiceReceivedCode.successful,
      this.modelList,
      this.audioData,
      this.audioFilePath});

  Map<String, dynamic> toMapBlurry() {
    return {
      'code': code.name,
      'modelList': modelList?.map((map) => map.toJson()).toList(),
      'audioData len': audioData?.length,
      'audioFilePath': audioFilePath,
    };
  }

  @override
  String toString() {
    return 'VoiceReceivedData{modelList count: ${modelList?.length}, audioFilePath: $audioFilePath audioData len:${audioData?.length} code:$code';
  }
}

/// 状态码
enum VoiceReceivedCode {
  /// 成功
  successful,

  /// 识别失败
  recognitionFailed,

  /// 超时
  timeout,

  /// 数据解析失败
  parseJsonFailed,
}
