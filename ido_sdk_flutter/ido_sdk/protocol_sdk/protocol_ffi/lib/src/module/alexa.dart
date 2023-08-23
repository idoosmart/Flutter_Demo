import 'package:ffi/ffi.dart' as pkg_ffi;

import '../ido_protocol_fii.dart';


// Alexa
extension IDOProtocolAPIExtAlexa on IDOProtocolAPI {

  /// app设置语音文件传输配置
  /// ```dart
  /// prn app控制ble接收几个包回复一次数据
  /// voiceType 传输类型  0:无效 1:sbc 2:opus 3:mp3
  /// fileLen 语音文件大小
  /// 返回 0 成功
  /// ```
  int voiceFileTranToBleSetParam(
      int prn,
      int voiceType,
      int fileLen,
      ) {
    return bindings.voiceFileTranToBleSetParam(prn, voiceType, fileLen);
  }


  /// app开始传输语音文件
  /// ```dart
  /// filePath 需要传输的语音文件完整路径 包括文件名
  /// 返回 0 成功
  /// ```
  int voiceFileTranToBleStart(
      String filePath,
      ) {
    final filePathUtf8 = filePath.toNativeUtf8();
    final rs = bindings.voiceFileTranToBleStart(filePathUtf8.cast());
    pkg_ffi.calloc.free(filePathUtf8);
    return rs;
  }


  /// app停止发送语音数据
  ///
  /// 返回 0 成功
  int voiceFileTranToBleStop() {
    return bindings.voiceFileTranToBleStop();
  }

  /// 通知ble停止传输opus数据(语音数据)
  ///
  /// 返回 0 成功
  int stopReceiveVoiceDataFromBle() {
    return bindings.stopReceiveVoiceDataFromBle();
  }
}