import 'dart:typed_data';

import '../pigeon_generate/alexa.g.dart';

typedef BlockDownStreamData = void Function(Uint8List data);
typedef BlockReplyAudioData = void Function(String messageId, Uint8List data, bool isEnd);
typedef BlockUploadStreamError = void Function(ApiAlexaError error);
typedef BlockAlexaChannelLog = void Function(String logMsg);

class AlexaChannelImpl extends ApiAlexaFlutter {

  late final alexaHost = ApiAlexaHost();
  static AlexaChannelImpl? _instance;
  factory AlexaChannelImpl() => _instance ??= AlexaChannelImpl._internal();
  AlexaChannelImpl._internal();

  BlockDownStreamData? blockDownStreamData;
  BlockUploadStreamError? blockDownStreamError;
  BlockReplyAudioData? blockReplyAudioData;
  BlockUploadStreamError? blockUploadStreamError;
  BlockAlexaChannelLog? blockAlexaChannelLog;

  @override
  void downStreamData(Uint8List data) {
    blockDownStreamData?.call(data);
  }

  @override
  void onDownStreamError(ApiAlexaError error) {
    blockDownStreamError?.call(error);
  }

  @override
  void onUploadStreamError(ApiAlexaError error) {
    blockUploadStreamError?.call(error);
  }

  @override
  void replyAudioData(String messageId, Uint8List data, bool isEnd) {
    blockReplyAudioData?.call(messageId, data, isEnd);
  }

  @override
  void log(String logMsg) {
    blockAlexaChannelLog?.call(logMsg);
  }
  
}