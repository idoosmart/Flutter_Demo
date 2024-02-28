// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:native_channel/native_channel.dart';

import '../../../protocol_alexa.dart';
import 'list_extension.dart';
import 'map_extension.dart';
import 'string_extension.dart';

/// 常用数据定义
abstract class DataBox {
  static const _uuid = Uuid();

  static final kUUID = _uuid.v4().toUpperCase();

  // 缺省设备序列号
  static const kDeviceSerialNumber = 'ID2021SMARTALEXA';

  // 音频格式
  static const kPCM = 'AUDIO_L16_RATE_16000_CHANNELS_1';
  static const kOPUS = 'OPUS';
  static const kChunkSize = 320;

  // 场景
  static const kCloseTalk = 'CLOSE_TALK';
  static const kNearField = 'NEAR_FIELD';
  static const kFarField = 'FAR_FIELD';

  // 亮度等级
  static const kBrightness3 = 3;
  static const kBrightness5 = 5;
  static const kBrightness100 = 100;

  // 边界 / 分隔符
  static const kBoundaryMark = 'BOUNDARY_TERM_HERE';
  static const kSeparatorBegin = '--------abcde123';
  static const kSeparatorEnd = '--------abcde123--';
  static const kSeparatorVoice = 'Content-Type: application/octet-stream';

  /// 检查网关
  static Uint8List verifyGateway() {
    return {
      'context': [],
      'event': {
        'payload': {},
        'header': {
          'namespace': 'Alexa.ApiGateway',
          'name': 'VerifyGateway',
          'messageId': DataBox.kUUID
        },
      }
    }.toData();
  }

  /// 同步
  static Uint8List synchronizeWithContext(int isEnabled) {
    return {
      'context': [
        {
          'header': {'namespace': 'Notifications', 'name': 'IndicatorState'},
          'payload': {'isEnabled': (isEnabled), 'isVisualIndicatorPersisted': 1}
        }
      ],
      'event': {
        'header': {
          'namespace': 'System',
          'name': 'SynchronizeState',
          'messageId': DataBox.kUUID
        },
        'payload': {}
      }
    }.toData();
  }

  /// 时区
  static Future<Uint8List> timeZoneChanged() async {
    final String currentTimeZone = await ToolsImpl().getCurrentTimeZone();

    return {
      'context': [],
      'event': {
        'header': {
          'namespace': 'System',
          'name': 'TimeZoneChanged',
          'messageId': DataBox.kUUID
        },
        'payload': {'timeZone': currentTimeZone}
      }
    }.toData();
  }

  /// 修改语言
  static Uint8List localesChanged(String language) {
    return {
      "event": {
        "payload": {
          "locales": [language]
        },
        "header": {
          "namespace": "System",
          "name": "LocalesChanged",
          "messageId": DataBox.kUUID
        }
      }
    }.toData();
  }

  // -------------------------- 流协议 --------------------------

  /// 流上传请求头
  static Uint8List streamEventBody(String uniqueID) {
    if (uniqueID.isEmpty) {
      uniqueID = DataBox.kUUID;
    }
    final bytes = BytesBuilder();
    //bytes.add(_beginBoundaryMark());
    bytes.add(_jsonHeaders());
    bytes.add(streamContent(uniqueID));
    //bytes.add(_beginBoundaryMark());
    bytes.add(_binaryAudioHeaders());
    final rs = bytes.toBytes();
    debugPrint('streamEventBody:\n${utf8.decode(rs)}');
    return rs;
  }

  /// 音频数据
  // static Uint8List streamEventAudio(Uint8List audioData) {
  //   final bytes = BytesBuilder();
  //   //bytes.add(_segmentationData());
  //   //bytes.add(_jsonHeaders());
  //   // bytes.add(_jsonContent());
  //   // bytes.add(_segmentationData());
  //   //bytes.add(_binaryAudioHeaders());
  //   //bytes.add(_binaryAudioContent(audioData));
  //   bytes.add(audioData);
  //   //bytes.add(_endData());
  //   final rs = bytes.toBytes();
  //   debugPrint('streamEventAudio:\n${utf8.decode(rs)}');
  //   return rs;
  // }

  // /// 添加边界数据
  // static Uint8List packBoundaryData(Map<String, dynamic> map) {
  //   final bytes = BytesBuilder();
  //   //bytes.add(_segmentationData());
  //   // bytes.add(_jsonHeaders());
  //   bytes.add(map.toData());
  //   //bytes.add(_endData());
  //   final rs = bytes.toBytes();
  //   debugPrint('packBoundaryData:\n${utf8.decode(rs)}');
  //   return rs;
  // }

  static String _messageId() {
    return DateTime.now().toString();
    // return StringAlexaExtension.randomString();
    //return 'FD590B99-1D03-4F0D-97B9-B00${StringAlexaExtension.randomString().toUpperCase()}';
  }

  static String messageId() {
    // return DateTime.now().millisecond.toString();
    return (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    // return StringAlexaExtension.randomString();
    //return 'FD590B99-1D03-4F0D-97B9-B00${StringAlexaExtension.randomString().toUpperCase()}';
  }

// ------------------------- 私有方法 -------------------------

  static Uint8List _jsonHeaders() {
    return [
      'Content-Disposition: form-data; name="metadata"\r\n',
      'Content-Type: application/json; charset=UTF-8\r\n\r\n'
    ].toData();
  }

  static Uint8List _jsonContent() {
    final msgId = _messageId();
    return {
      'context': [
        {
          'header': {
            'namespace': 'SpeechRecognizer',
            'name': 'RecognizerState'
          },
          'payload': {'wakeword': 'ALEXA'}
        }
      ],
      'event': {
        'header': {
          'namespace': 'SpeechRecognizer',
          'name': 'Recognize',
          'messageId': msgId,
          'dialogRequestId': msgId
        },
        'payload': {'profile': DataBox.kNearField, 'format': DataBox.kPCM}
      }
    }.toData();
  }

  static Uint8List _binaryAudioHeaders() {
    return [
      'Content-Disposition: form-data; name="audio"\r\n',
      'Content-Type: application/octet-stream\r\n\r\n'
    ].toData();
  }

  //
  static Uint8List _binaryAudioContent(Uint8List data) {
    final bytes = BytesBuilder();
    bytes.add(data);
    bytes.add('\r\n\r\n'.toData());
    final rs = bytes.toBytes();
    debugPrint('streamEventBody:\n${utf8.decode(rs)}');
    return rs;
  }

  static Uint8List streamContent(String uniqueID) {
    if (uniqueID.isEmpty) {
      uniqueID = DataBox.kUUID;
    }
    final rs = {
      'context': [
        {
          'header': {'name': 'IndicatorState', 'namespace': 'Notifications'},
          'payload': {'isEnabled': 0, 'isVisualIndicatorPersisted': 0}
        }
      ],
      'event': {
        'header': {
          'dialogRequestId': uniqueID,
          'messageId': uniqueID,
          'name': 'Recognize',
          'namespace': 'SpeechRecognizer'
        },
        'payload': {
          'format': DataBox.kPCM,
          'initiator': {'type': 'TAP'},
          'profile': DataBox.kNearField
        }
      }
    }.toData();
    debugPrint('streamContent:\n${utf8.decode(rs)}');
    return rs;
  }

  // 边界
  static Uint8List _beginBoundaryMark() {
    return '\r\n--$kBoundaryMark\r\n'.toData();
  }

  static Uint8List _endBoundaryData() {
    return '\r\n\r\n--$kBoundaryMark--\r\n'.toData();
  }
}
