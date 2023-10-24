
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'dart:typed_data';
import 'dart:io' as io;


import 'package:protocol_alexa/src/module/voice.dart';
import 'package:protocol_alexa/src/private/tools/map_extension.dart';
import 'package:protocol_lib/protocol_lib.dart';

import '../private/logger/logger.dart';
import '../service/model/directive_model.dart';
import '../service/service_manager.dart';
import 'auth.dart';
import 'client.dart';

part 'inner/upload_directives_impl.dart';

abstract class UploadDirectivesAnalysis {
  factory UploadDirectivesAnalysis() => _UploadDirectivesAnalysis();
  /**< 解析上行流语音文本数据 */
  void parsingTextDirectivesAnalysis(
      {required VoiceReceivedData directives});

  /// 取消音频上传至设备
  void cancelMp3Upload();
}