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

  // ---------------------------- 设备传文件到app ----------------------------

  /// 设备->app文件传输完成事件回调注册
  ///
  /// ```dart
  /// 返回 Tuple2(int error, int errorVal)
  /// ```
  StreamController<int> get streamDataTranToAppComplete;

  /// 设备->app文件传输进度事件回调注册
  ///
  /// ```dart
  /// 返回 int progress
  /// ```
  StreamController<int> get streamDataTranToAppProgress;

  /// 设备->app, 设备传输文件到APP的传输请求事件回调注册
  ///
  /// ```dart
  /// 返回 json string
  /// ```
  StreamController<String> get streamDataTranToAppRequest;


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
