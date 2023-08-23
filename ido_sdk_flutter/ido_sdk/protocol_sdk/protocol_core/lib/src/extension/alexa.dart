// ignore_for_file: constant_identifier_names

import 'dart:typed_data';

import 'package:protocol_ffi/protocol_ffi.dart';

import '../../protocol_core.dart';
import '../manager/manager_clib.dart';

extension IDOProtocolCoreManagerExtAlexa on IDOProtocolCoreManager {
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
    return IDOProtocolClibManager()
        .cLib
        .voiceFileTranToBleSetParam(prn, voiceType, fileLen);
  }

  /// app开始传输语音文件
  /// ```dart
  /// filePath 需要传输的语音文件完整路径 包括文件名
  /// 返回 0 成功
  /// ```
  int voiceFileTranToBleStart(
    String filePath,
  ) {
    return IDOProtocolClibManager().cLib.voiceFileTranToBleStart(filePath);
  }

  /// app停止发送语音数据
  ///
  /// 返回 0 成功
  int voiceFileTranToBleStop() {
    return IDOProtocolClibManager().cLib.voiceFileTranToBleStop();
  }

  /// 通知ble停止传输opus数据(语音数据)
  ///
  /// 返回 0 成功
  int stopReceiveVoiceDataFromBle() {
    return IDOProtocolClibManager().cLib.stopReceiveVoiceDataFromBle();
  }

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
  void listenAlexaReportVoiceOpusState(void Function(int state) func) {
    IDOProtocolClibManager()
        .streamAlexaReportVoiceOpusState
        .stream
        .listen((state) {
      func.call(state);
    });
  }

  /// 上报接收的opus语音文件丢包率
  void listenAlexaReportVoiceLostData(
     void Function(int sizeLostPkg, int sizeAllPkg) func) {
    IDOProtocolClibManager()
        .streamAlexaReportVoiceLostData
        .stream
        .listen((tuple) {
      func.call(tuple.item1, tuple.item2);
    });
  }

  /// 上报接收opus语音文件每段pcm编码数据
  void listenAlexaReportVoicePcmData(void Function(Uint8List data, int len) func) {
    IDOProtocolClibManager()
        .streamAlexaReportVoicePcmData
        .stream
        .listen((tuple) {
      func.call(tuple.item1, tuple.item2);
    });
  }
}
