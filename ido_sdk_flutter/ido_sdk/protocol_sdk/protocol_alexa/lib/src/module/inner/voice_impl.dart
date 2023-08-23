part of '../voice.dart';

class _Voice implements Voice {
  late final _alexaDelegate = _AlexaDelegate();
  bool _isStopped = true;

  late final _subjectUploadVoiceData =
      StreamController<VoiceReceivedData>.broadcast();

  late final _subjectVoiceStateChanged =
      StreamController<VoiceState>.broadcast();

  static final _instance = _Voice._internal();
  _Voice._internal() {
    startMonitor();
  }
  factory _Voice() => _instance;

  // 语音状态
  var __voiceState = VoiceState.none;
  set _voiceState(VoiceState state) {
    final isChanged = __voiceState != state;
    __voiceState = state;
    logger?.v('__voiceState: $state');
    if (isChanged && _subjectVoiceStateChanged.hasListener) {
      _subjectVoiceStateChanged.add(__voiceState);
    }
  }

  @override
  AlexaDelegate get alexaDelegate => _alexaDelegate;

  @override
  String get uniqueID => _alexaDelegate.uniqueID;

  // @override
  void startMonitor() {
    _isStopped = false;
  }

  // @override
  void stopMonitor() {
    _isStopped = true;
  }

  @override
  void stopUpload() {
    logger?.v('stopUpload');
    _alexaDelegate._stopUpload();
  }

  @override
  void endUpload(String dialogRequestId) async {
    if (dialogRequestId != uniqueID) {
      logger?.d('dislocation uniqueID $dialogRequestId != $uniqueID');
      return;
    }
    logger?.v('StopCapture endUpload');
    // _alexaDelegate._endUpload();
    alexaOperator?.stopReceiveVoiceDataFromBle();
    logger?.v('停止识别 -- stopReceiveVoiceDataFromBle');
  }

  @override
  void test() async {
    // 分块流上传
    final dir = await getApplicationDocumentsDirectory();
    final pcmPathLocal = '${dir.path}/files_trans/pcm/181247.pcm';
    final pcmPath = pcmPathLocal; //_alexaDelegate._lastPcm ?? pcmPathLocal;
    final file = io.File(pcmPath);
    final fileStream = file.openRead();
    final fileSize = await file.length();
    const size = 10 * 1024 * 1024;

    logger?.v('pcmPath:$pcmPath\nfileSize:$fileSize size:$size');
    logger?.v('size: $size');
    _VoiceUploadClient().uploadVoiceStream(fileStream, _alexaDelegate.uniqueID);
    // _Http2Client()._tranFile(pcmPath);
  }

  @override
  Future<bool> testUploadPCM(String pcmPath) async {
    final file = io.File(pcmPath);
    final fileStream = file.openRead();
    final fileSize = await file.length();
    const size = 10 * 1024 * 1024;
    logger?.v('pcmPath:$pcmPath\nfileSize:$fileSize size:$size');
    final rs = await _VoiceUploadClient().uploadVoiceStream(fileStream, _alexaDelegate.uniqueID);
    return rs.status == 0 || rs.status == 200;
  }

  @override
  StreamSubscription listenUploadVoiceData(
      void Function(VoiceReceivedData receivedData) func) {
    return _subjectUploadVoiceData.stream.listen(func);
  }

  @override
  StreamSubscription listenVoiceStateChanged(
      void Function(VoiceState state) func) {
    return _subjectVoiceStateChanged.stream.listen(func);
  }

  @override
  AlexaOperator? alexaOperator;
}

// 代理 用于和lib层数据交换
class _AlexaDelegate implements AlexaDelegate {
  late final _uploadClient = _VoiceUploadClient();
  // 当前上行消息id，传输结束会重新分配
  late var uniqueID =
      DataBox.messageId(); // StringAlexaExtension.randomString();
  // 存储从设备收到的pcm数据到文件（debug模式下有效）
  final FileTool? _fileTool =
      kDebugMode ? FileTool(fileName: 'ask', ext: 'pcm') : null;

  // 传输前的数据缓冲
  late final _askPcmBufferData = <int>[];
  // 实时数据流管理
  StreamController<List<int>>? _askPcmStreamCtl;
  bool _isUsedBuffer = false;
  int _sizeAllPkg = 0;
  String? _lastPcm;
  int _pcmDataSize = 0;
  // 开始传输时间点 毫秒值
  int _startTime = 0;

  /// 用时（从创建并起动语音上传开始计时）
  int get _useTime => DateTime.now().millisecondsSinceEpoch - _startTime;

  /// 过早结束的（小于500毫秒）
  bool get _isTooEarlyEnd => _useTime < 500;

  @override
  void onAlexaReportVoiceOpusState(int state) async {
    /*上报接收到的opus语音文件状态
      0 空闲态 1 开始
      2 停止状态 正常的停止的 3 超时 4 断线
      5 登录状态 6 开始 7 app发起开始失败 8 停止状态 9 app发起结束失败
      10 ALEXA 按钮退出到主界面
      11 固件修改alexa设置的闹钟，需要重新获取alexa的闹钟数据*/
    logger?.d('alexa - report voice opus state: $state');
    if (state == 2 || state == 3 || state == 4 || state == 10) {
      if (state == 2) {
        // 2 停止状态 正常的停止的
        logger?.d("alexa - 录音用时: $_useTime 毫秒");
        if (_isTooEarlyEnd) {
          logger?.d("alexa - too early end");
          return;
        }
      }
      if (state == 10) {
        // 10 ALEXA 按钮退出到主界面
        _stopUpload();
      } else {
        _endUpload();
      }
    } else if (state == 1) {
      // 1 开始
      if (_isTooEarlyEnd) {
        logger?.d('alexa - continuous early start');
      } else {
        _createAndStartUploadStream();
      }
    } else if (state == 5) {
      // 5 登录状态
      _sendLoginStateToDevice();
    } else if (state == 8) {
      // 8 停止状态
      //_stopUpload();
    }
  }

  @override
  Future<void> onAlexaReportVoicePcmData(Uint8List data, int len) async {
    if (_Voice()._isStopped) {
      //logger?.d('_Voice()._isStopped, return');
      return;
    }

    // 写文件
    _fileTool?.writeData(data);

    if (_askPcmStreamCtl == null) {
      //logger?.d('_streamController is null, return');
      return;
    }

    _pcmDataSize += data.length;
    if (_askPcmStreamCtl!.hasListener) {
      if (_pcmDataSize % (1024 * 2) == 0) {
        logger?.v('alexa - ${_pcmDataSize / 1024} KB send');
      }
      if (_askPcmBufferData.isNotEmpty && !_isUsedBuffer) {
        _askPcmStreamCtl?.sink.add(_askPcmBufferData);
        //_buffData.clear(); // 此处清理会导致上传数据不完整 (待确定）
        _isUsedBuffer = true;
      }
      _askPcmStreamCtl?.sink.add(data);
    } else {
      logger?.v(
          'alexa - len: ${(_pcmDataSize / 1024).toStringAsFixed(1)} KB buffer');
      _askPcmBufferData.addAll(data);
    }
  }

  @override
  void onAlexaReportVoiceLostData(int sizeLostPkg, int sizeAllPkg) {
    logger?.d('alexa - sizeLostPkg: $sizeLostPkg sizeAllPkg:$sizeAllPkg');
    _sizeAllPkg = sizeAllPkg;
  }

  /// 创建并起动语音上传
  void _createAndStartUploadStream() {
    _Voice().startMonitor();
    _Voice()._voiceState = VoiceState.starting;
    // 重新分配消息id
    uniqueID = DataBox.messageId(); // StringAlexaExtension.randomString();
    logger?.d('_createAndStartUploadStream messageId:$uniqueID');
    _cleanBuffer();
    _askPcmStreamCtl?.close();
    _askPcmStreamCtl = StreamController(onListen: () {
      logger?.v('onListen ask pcm hashCode:${_askPcmStreamCtl?.hashCode}');
    }, onCancel: () {
      logger?.v('onCancel ask pcm hashCode:${_askPcmStreamCtl?.hashCode}');
    });
    logger?.v('create ask pcm hashCode:${_askPcmStreamCtl?.hashCode}');
    _uploadClient
        .uploadVoiceStream(_askPcmStreamCtl!.stream, uniqueID)
        .then((value) => null);
    _startTime = DateTime.now().millisecondsSinceEpoch;
  }

  /// 清理缓存数据
  void _cleanBuffer() {
    _pcmDataSize = 0;
    _isUsedBuffer = false;
    _askPcmBufferData.clear();
    logger?.v('_cleanBuffer()');
  }

  /// 发送登录状态到设备
  void _sendLoginStateToDevice() async {
    _Voice()._voiceState = VoiceState.ready;
    // log_state 0：正常状态（登录） 1：未登录 2：网络断连 3：未获取状态
    final param = {"log_state": IDOProtocolAlexa().isLogin ? 0 : 1};
    await libManager
        .send(
            evt: CmdEvtType.alexaVoiceBleGetPhoneLoginState,
            json: jsonEncode(param))
        .first;
  }

  /// 上传完成
  void _endUpload() async {
    logger?.v('begin _endUpload');
    await _askPcmStreamCtl?.close();
    _askPcmStreamCtl = null;
    final a = await _fileTool?.saveFile();
    logger?.v('===save to file: $a');
    _lastPcm = a;
    _Voice()._voiceState = VoiceState.finished;
    logger?.v('end _endUpload');
  }

  /// 停止上传
  void _stopUpload() {
    logger?.v('begin _stopUpload');
    _uploadClient.stop();
    _askPcmStreamCtl?.close();
    _askPcmStreamCtl = null;
    _cleanBuffer();
    _Voice()._voiceState = VoiceState.finished;
    logger?.v('end _stopUpload');
  }
}

// 音频上传
class _VoiceUploadClient {
  late final _voice = _Voice();
  late final _service = ServiceManager();
  late final _receivedData = BytesBuilder();
  Completer<BaseEntity<String>>? _completer;
  CancelToken? _cancelToken;
  UploadTask? _uploadTask;
  FileTool? _fileReceive;
  StreamSubscription? _subscriptTrans;

  // 使用dio testSendStreamPartCustom
  Future<BaseEntity<String>> uploadVoiceStream(
      Stream<List<int>> aStream, String uniqueID) async {
    _completer = Completer();
    _receivedData.clear();
    logger?.v('call uploadVoiceStream uniqueID:$uniqueID');
    _exec(aStream, uniqueID);
    return _completer!.future;
  }

  void stop() {
    //client.close(force: true);
    _cancelToken?.cancel();
    _receivedData.clear();
    _fileReceive?.close();
    _subscriptTrans?.cancel();
  }

  /// 执行上传
  _exec(Stream<List<int>> aStream, String uniqueID) async {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();
    try {
      logger?.v('call service.uploadAudioStream');
      // 音频上传到alexa
      final rs = await _service.uploadAudioStream(
          accessToken: Auth().accessToken!,
          jsonBody: DataBox.streamContent(uniqueID),
          stream: aStream,
          length: 20 * 1024 * 1024,
          cancelToken: _cancelToken);
      logger?.v("uploadAudioStream rs: $rs");
      if (rs.result != null) {
        rs.result?.stream.listen((data) {
          logger?.v('uploadDataOnDio response data:${data.length}');
          _receivedData.add(data);
        }, onDone: () async {
          logger?.v(
              'uploadDataOnDio response done , data len:${(_receivedData.length / 1024).toStringAsFixed(1)} KB');
          await _parseReceiveData();
          _completer?.complete(
              BaseEntity(status: rs.status, result: null, message: ''));
          _completer = null;
        }, onError: (e) {
          logger?.e('uploadDataOnDio response error: ${e.toString()}');
          throw e;
        });
      } else {
        logger?.v('uploadDataOnDio response code:${rs.status} data: null');
        _voice._subjectUploadVoiceData.add(VoiceReceivedData(
            code: rs.status == 204
                ? VoiceReceivedCode.recognitionFailed
                : VoiceReceivedCode.timeout));
        _completer?.complete(
            BaseEntity(status: rs.status, result: null, message: ''));
        _completer = null;
      }
    } catch (e) {
      _voice._subjectUploadVoiceData
          .add(VoiceReceivedData(code: VoiceReceivedCode.parseJsonFailed));
      _completer?.complete(
          BaseEntity(status: -1, result: null, message: e.toString()));
      _completer = null;
      _uploadTask?.cancelTask();
      logger?.e(e);
    }
  }

  /// 解析返回数据（json / audio data) 并分发至监听器
  _parseReceiveData() async {
    if (_receivedData.isEmpty) {
      logger?.d('receivedData.isEmpty');
      return;
    }

    try {
      final data = _receivedData.toBytes();

      logger?.d('上行流收到响应数据 长度: ${data.length} 字节');
      // 处理json数据
      List<DirectiveModel>? modelList;
      if (_voice._subjectUploadVoiceData.hasListener) {
        modelList = _parseJson(data);
      } else {
        logger?.e('未添加监听，不执行数据解析和回调');
      }

      // 提取音频数据
      final voiceData = data
          .sublistWithString(DataBox.kSeparatorVoice, DataBox.kSeparatorEnd)
          ?.trim('\r\n');

      // 音频数据保存成文件
      String? path;
      if (voiceData != null) {
        await _fileReceive?.close();
        _fileReceive ??= FileTool(fileName: 'reply', ext: 'mp3');
        await _fileReceive?.writeData(voiceData);
        path = await _fileReceive?.saveFile();
        logger?.v('save file: $path');
      } else {
        logger?.d('上行流收到响应数据 不包含音频数据');
      }
      _voice._subjectUploadVoiceData.add(VoiceReceivedData(
          modelList: modelList, audioData: voiceData, audioFilePath: path));
      // _tranFile(path); // TODO Test
    } catch (e) {
      logger?.e(e.toString());
      _voice._subjectUploadVoiceData
          .add(VoiceReceivedData(code: VoiceReceivedCode.parseJsonFailed));
      if (kDebugMode) {
        // 解析异常时，把数据保存成文件，用于排查原因
        final file = FileTool(fileName: 'tmp_debug', ext: 'data');
        await file.writeData(_receivedData.toBytes());
        await file.saveFile();
      }
    } finally {
      logger?.v('_receivedData.clear()');
      _receivedData.clear();
    }
  }

  /// 从字节数组中提取所有json并转成model
  List<DirectiveModel>? _parseJson(Uint8List data) {
    // 提取json相关内容
    logger?.v('parseJson data len: ${data.length}');
    final jsonData = data.sublistWithString(
        DataBox.kSeparatorBegin, DataBox.kSeparatorVoice,
        reverse: false);
    logger?.v('parseJson jsonData len: ${jsonData?.length}');
    if (jsonData == null) return null;

    // 字节数组转成字符串
    var str = utf8.decode(jsonData);
    logger?.v('parseJson str len: ${str.length}');

    // 分割多组json内容
    final list = str.split(DataBox.kSeparatorBegin);
    logger?.v('parseJson list count: ${list.length}');

    // 遍历解析具体json并转成model
    final rs = <DirectiveModel>[];
    for (var item in list) {
      final idxBegin = item.indexOf('{');
      final idxEnd = item.lastIndexOf('}');
      logger?.v('parseJson sub str len: ${item.length}');
      if (idxBegin == -1 || idxEnd == -1) continue;
      final jsonStr = item.substring(idxBegin, idxEnd + 1);
      logger?.v('parseJson jsonStr: $jsonStr');
      final map = jsonDecode(jsonStr);
      logger?.v('parseJson to map');
      final directive = map['directive'];
      if (directive != null && directive is Map<String, dynamic>) {
        logger?.v('parseJson to directive');
        rs.add(DirectiveModel.fromJson(directive));
      }
    }
    return rs.isNotEmpty ? rs : null;
  }

  _tranFile(String? path) async {
    if (path == null) {
      return;
    }

    final t = libManager.transFile.transferMultiple(
        fileItems: [
          NormalFileModel(
              fileType: FileTransType.voice, filePath: path, fileName: 'tmp')
        ],
        funcStatus: (index, FileTransStatus status) {
          debugPrint('状态： ${status.name}');
        },
        funcProgress: (int currentIndex, int totalCount, double currentProgress,
            double totalProgress) {
          debugPrint(
              '进度：${currentIndex + 1}/$totalCount $currentProgress $totalProgress');
        });

    _subscriptTrans = t.listen((event) {
      debugPrint('传输结束 结果:${event.toString()}');
    });
  }
}
