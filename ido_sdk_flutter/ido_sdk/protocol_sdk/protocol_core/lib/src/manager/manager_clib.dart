import 'dart:async';
import 'dart:typed_data';
import 'dart:ffi';

import 'package:tuple/tuple.dart';
import 'package:protocol_ffi/protocol_ffi.dart';
import '../logger/logger.dart';

part 'part/manager_clib_impl.dart';
part 'part/timer_clib.dart';

/// C库管理类
///
/// 仅供内部使用
abstract class IDOProtocolClibManager {
  factory IDOProtocolClibManager() => _IDOProtocolClibManager();

  IDOProtocolAPI get cLib;

  /// 初始化c库
  Future<bool> initClib();

  /// 数据下发
  ///
  /// ```dart
  /// Tuple2(Uint8List data, int type)
  /// ```
  StreamController<Tuple2<Uint8List, int>> get streamWriteData;

  /// 下发指令后设备响应数据
  ///
  /// ```dart
  /// 返回 Tuple3(int code, int evtType, String json)
  /// ```
  StreamController<Tuple3<int, int, String>> get streamReceiveData;

  /// 命令JSON数据
  ///
  /// ```dart
  /// 返回 Tuple3(int evtType, int error, int val)
  /// ```
  StreamController<Tuple3<int, int, int>> get streamCNoticeCmd;

  /// c库通知（排除快速配置）
  ///
  /// ```dart
  /// 返回 Tuple3(int evtType, int error, int val)
  /// ```
  StreamController<Tuple3<int, int, int>> get streamCNoticeCmdExt;

  /// 快速配置完成
  ///
  /// ```dart
  /// 返回 errCode
  /// ```
  StreamController<int> get streamFastSyncComplete;

  /// 监听设备响应数据往上层报
  ///
  /// ```dart
  /// 返回 Tuple3(int code, int evtType, String json)
  /// ```
  StreamController<Tuple3<int, int, String>> get streamListenReceiveData;

  // ------------------------------- Alexa -------------------------------
  /// 上报接收到的opus语音文件状态
  ///
  /// ```dart
  /// Tuple2(int state)
  /// ```
  StreamController<int> get streamAlexaReportVoiceOpusState;

  /// 上报接收的opus语音文件丢包率
  ///
  /// ```dart
  /// Tuple2(int sizeLostPkg, int sizeAllPkg)
  /// ```
  StreamController<Tuple2<int, int>> get streamAlexaReportVoiceLostData;

  /// 上报接收opus语音文件每段pcm编码数据
  ///
  /// ```dart
  /// Tuple2(Uint8List data, int len)
  /// ```
  StreamController<Tuple2<Uint8List, int>> get streamAlexaReportVoicePcmData;
}
