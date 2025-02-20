part of '../manager_clib.dart';

class _IDOProtocolClibManager implements IDOProtocolClibManager {
  final _cLib = IDOProtocolAPI();
  late final _streamWriteData =
      StreamController<Tuple2<Uint8List, int>>.broadcast();
  late final _streamReceiveData =
      StreamController<Tuple3<int, int, String>>.broadcast();
  late final _streamCNoticeCmd =
      StreamController<Tuple3<int, int, int>>.broadcast();
  late final _streamFastSyncComplete = StreamController<int>.broadcast();
  late final _streamCNoticeCmdExt =
      StreamController<Tuple3<int, int, int>>.broadcast();
  late final _streamListenReceiveData =
      StreamController<Tuple3<int, int, String>>.broadcast();
  late final _streamAlexaReportVoiceLostData =
      StreamController<Tuple2<int, int>>.broadcast();
  late final _streamAlexaReportVoiceOpusState =
      StreamController<int>.broadcast();
  late final _streamAlexaReportVoicePcmData =
      StreamController<Tuple2<Uint8List, int>>.broadcast();

  late final _streamDataTranToAppComplete = StreamController<int>.broadcast();

  late final _streamDataTranToAppProgress = StreamController<int>.broadcast();

  late final _streamDataTranToAppRequest = StreamController<String>.broadcast();

  late final _handleMap = <int, _TimerHandle>{};
  static int _lastTimerId = 1;
  bool _isInitClib = false;

  _IDOProtocolClibManager._internal();
  static final _instance = _IDOProtocolClibManager._internal();
  factory _IDOProtocolClibManager() => _instance;

  @override
  IDOProtocolAPI get cLib => _cLib;

  @override
  StreamController<Tuple2<Uint8List, int>> get streamWriteData =>
      _streamWriteData;

  @override
  StreamController<Tuple3<int, int, String>> get streamReceiveData =>
      _streamReceiveData;

  @override
  StreamController<Tuple3<int, int, int>> get streamCNoticeCmd =>
      _streamCNoticeCmd;

  @override
  StreamController<Tuple3<int, int, int>> get streamCNoticeCmdExt =>
      _streamCNoticeCmdExt;

  @override
  StreamController<int> get streamFastSyncComplete => _streamFastSyncComplete;

  @override
  StreamController<Tuple3<int, int, String>> get streamListenReceiveData =>
      _streamListenReceiveData;

  @override
  StreamController<Tuple2<int, int>> get streamAlexaReportVoiceLostData =>
      _streamAlexaReportVoiceLostData;

  @override
  StreamController<int> get streamAlexaReportVoiceOpusState =>
      _streamAlexaReportVoiceOpusState;

  @override
  StreamController<Tuple2<Uint8List, int>> get streamAlexaReportVoicePcmData =>
      _streamAlexaReportVoicePcmData;

  @override
  StreamController<int> get streamDataTranToAppComplete => _streamDataTranToAppComplete;

  @override
  StreamController<int> get streamDataTranToAppProgress => _streamDataTranToAppProgress;

  @override
  StreamController<String> get streamDataTranToAppRequest => _streamDataTranToAppRequest;

  _initialize() {
    // 初始化定时器
    cLib.initTimer(
        timerCreateSt: (Pointer<Uint32> timerId, HandleAppTimerTimeoutEvt fn) {
      final tid = _IDOProtocolClibManager._lastTimerId++;
      timerId.value = tid;
      _handleMap[tid] = _TimerHandle(timerId: tid, fn: fn);
      //logger?.v('timerCreateSt timerId:${timerId.value} func:${_handleMap[tid]?._timeoutEvtFun.hashCode ?? -1}');
      return 0;
    }, timerStartSt: (int timerId, int ms, int dataPtr) {
      final funHashCode = _handleMap[timerId]?._timeoutEvtFun.hashCode ?? -1;
      //logger?.v('timerStartSt timerId:$timerId ms:$ms func:$funHashCode');
      _handleMap[timerId]?.start(ms: ms);
      return 0;
    }, timerStopSt: (int timerId) {
      final funHashCode = _handleMap[timerId]?._timeoutEvtFun.hashCode ?? -1;
      //logger?.v('timerStopSt timerId:$timerId func:$funHashCode');
      _handleMap[timerId]?.stop();
      return 0;
    });

    // writeJsonData 回调 注：返回需要传给设备的二进制数据)
    cLib.initCLib((Uint8List data, int len, int type) {
      // logger?.d('core callbackWriteDataHandle: data:$data, len:$len type:$type');
      if (_streamWriteData.hasListener) {
        // logger?.d(
        //     'core_streamWriteData.sink.add() : data:$data, len:$len hashCode:${data.hashCode}');
        _streamWriteData.sink.add(Tuple2(data, type));
      }
    });

    // 解析完固件返回的二进制数据,打包成json数据回调给SDK
    // 回调 注：返回解析后的json
    cLib.registerJsonDataTransferCbEvt(func: (String json, int evt, int code) {
      logger?.d('call JsonDataCallback ${[code, evt]}');
      if (_streamReceiveData.hasListener) {
        _streamReceiveData.sink.add(Tuple3(code, evt, json));
      } else {
        //logger?.d('streamReceiveData.hasListener false');
      }
      if (_streamListenReceiveData.hasListener) {
        _streamListenReceiveData.sink.add(Tuple3(code, evt, json));
      } else {
        //logger?.d('streamListenReceiveData.hasListener false');
      }
    });

    //注册C库请求通知回调
    cLib.registerNoticeCallback(
        func: (int evtBase, int evtType, int error, int val) {
      if (evtBase == 0x2600) {
        //logger?.d('registerCrequest evtType:$evtType errro:$error val:$val');
        //C库请求 9728 命令快速配置
        if (_streamCNoticeCmd.hasListener) {
          _streamCNoticeCmd.sink.add(Tuple3(evtType, error, val));
        }
      } else if (evtBase == 0x2300) {
        //通知 8960
        if (evtType == 11) {
           logger?.d('core registerFastComplete evtType:$evtType errro:$error val:$val');
          //快速配置完成
          if (_streamFastSyncComplete.hasListener) {
            //logger?.d('core 快速配置完成回调 3 error:$error');
            _streamFastSyncComplete.sink.add(error);
          }else {
            logger?.e('core 快速配置完成回调 3 失败');
            logger?.e('core _streamFastSyncComplete.hasListener is NO, evtType:$evtType errro:$error val:$val');
          }
        } else {
          if (_streamCNoticeCmdExt.hasListener) {
            _streamCNoticeCmdExt.sink.add(Tuple3(evtType, error, val));
          }
        }
      }
    });

    // ------------------------------- 设备传文件到app -------------------------------

    // 设备->app文件传输完成事件回调注册
    cLib.registerDataTranToAppCompleteCallback(func: (int error) {
        _streamDataTranToAppComplete.sink.add(error);
    });

    // 设备->app文件传输进度事件回调注册
    cLib.registerDataTranToAppProgressCallbackReg(func: (int progress) {
        _streamDataTranToAppProgress.sink.add(progress);
    });

    // 设备->app, 设备传输文件到APP的传输请求事件回调注册
    cLib.registerDevice2AppDataTranRequestCallbackReg(func: (String json) {
        _streamDataTranToAppRequest.sink.add(json);
    });

    // ------------------------------- Alexa -------------------------------

    // 上报接收到的opus语音文件状态回调注册
    cLib.registerReportVoiceDataFromBleOpusStateCbReg((int status) {
      //logger?.d('alexa - OpusState: $status');
      if (_streamAlexaReportVoiceOpusState.hasListener) {
        _streamAlexaReportVoiceOpusState.sink.add(status);
      } else {
        logger?.d('alexa - _streamAlexaReportVoiceOpusState.hasListener false');
      }
    });

    // 上报接收的opus语音文件丢包率回调注册
    cLib.registerReportVoiceDataFromBleLostDataCbReg(
        (int sizeLostPkg, int sizeAllPkg) {
      //logger?.d('alexa - LostData - sizeLostPkg:$sizeLostPkg sizeAllPkg:$sizeAllPkg');
      if (_streamAlexaReportVoiceLostData.hasListener) {
        _streamAlexaReportVoiceLostData.add(Tuple2(sizeLostPkg, sizeAllPkg));
      } else {
        logger?.d('alexa - _streamAlexaReportVoiceLostData.hasListener false');
      }
    });

    // 上报接收opus语音文件每段pcm编码数据回调注册
    cLib.registerReportVoiceDataFromBleEachPcmDataCbReg(
        (Uint8List data, int len) {
      if (_streamAlexaReportVoicePcmData.hasListener) {
        _streamAlexaReportVoicePcmData.add(Tuple2(data, len));
      } else {
        logger?.d('alexa - _streamAlexaReportVoicePcmData.hasListener false');
      }
    });

    _isInitClib = true;
  }

  @override
  Future<bool> initClib() async {
    print('initClib - _IDOProtocolClibManager');
    if (!_isInitClib) {
      _initialize();
    }
    return true;
  }
}
