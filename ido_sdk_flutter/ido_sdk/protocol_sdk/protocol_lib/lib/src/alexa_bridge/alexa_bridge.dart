import 'dart:typed_data';

import 'package:protocol_core/protocol_core.dart';

abstract class AlexaDelegate {
  /// 上报接收到的opus语音文件状态
  ///
  /// ```dart
  /// status：
  /// 0 空闲态
  /// 1 开始
  /// 2 停止状态 正常的停止的
  /// 3 超时
  /// 4 断线
  /// 5 登录状态
  /// 6 开始
  /// 7 app发起开始失败
  /// 8 停止状态
  /// 9 app发起结束失败
  /// 10 ALEXA 按钮退出到主界面
  /// 11 固件修改alexa设置的闹钟，需要重新获取alexa的闹钟数据
  /// ```
  void onAlexaReportVoiceOpusState(int state);

  /// 上报接收的opus语音文件丢包率
  void onAlexaReportVoiceLostData(int sizeLostPkg, int sizeAllPkg);

  /// 上报接收opus语音文件每段pcm编码数据
  void onAlexaReportVoicePcmData(Uint8List data, int len);
}

abstract class AlexaOperator {
  factory AlexaOperator() => _AlexaOperator();

  /// 通知ble停止传输opus数据(语音数据)
  ///
  /// 返回 0 成功
  int stopReceiveVoiceDataFromBle();
}

class _AlexaOperator implements AlexaOperator {
  late final _coreMgr = IDOProtocolCoreManager();
  @override
  int stopReceiveVoiceDataFromBle() {
    return _coreMgr.stopReceiveVoiceDataFromBle();
  }
}
