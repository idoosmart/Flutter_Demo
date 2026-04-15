import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as path;
import 'package:native_channel/native_channel.dart';
import 'package:protocol_core/protocol_core.dart';
import 'package:protocol_ffi/protocol_ffi.dart';

import '../logger/logger.dart';

import 'base_task.dart';

class FileTask extends BaseTask {
  TaskStatus _status = TaskStatus.waiting;
  final FileTranItem fileTranItem;
  final FileTranProgressCallback progressCallback;
  final FileTranStatusCallback statusCallback;
  late final bool _useSpp = (Platform.isAndroid && fileTranItem.useSpp);
  late final bool _isAlexaVoice =
      (fileTranItem.dataType == FileTranDataType.voice_alexa);
  Completer<CmdResponse>? _completer;
  Timer? _timerVoiceSetParam;
  late final _subscriptionList = <StreamSubscription>[];
  late final _coreMgr = IDOProtocolCoreManager();

  //节流日志打印
  var _lastLoggedState = OTAUpdateState.init;

  FileTask.create(this.fileTranItem, this.statusCallback, this.progressCallback)
      : super.create();

  @override
  Future<CmdResponse> call() async {
    return _exec();
  }

  @override
  cancel() {
    _status = TaskStatus.canceled;

    if (_isAlexaVoice) {
      _cancelVoice();
    } else if (_isSilfiOta()) {
      _cancelSilfi();
    } else if (_isNordicOta()) {
      _cancelNordic();
    } else {
      _cancelNormal();
    }

    if (_completer != null && !_completer!.isCompleted) {
      final res = CmdResponse(code: ErrorCode.canceled);
      _completer!.complete(res);
      _completer = null;
    }
  }

  @override
  TaskStatus get status => _status;
}

extension _FileTask on FileTask {
  Future<CmdResponse> _exec() async {
    _status = TaskStatus.running;
    logger?.d(
        'start _FileTask filePath:${fileTranItem.filePath}  fileName:${fileTranItem.fileName}');

    _completer = Completer<CmdResponse>();

    if (_isAlexaVoice) {
      return _execVoice();
    } else if (_isSilfiOta()) {
      return _execSilfi();
    } else if (_isNordicOta()) {
      return _execNordic();
    } else {
      return _execNormal();
    }
  }

  /// 根据文件类型获取相应buff类型
  int _dataType() {
    // TODO 说是type未使用， 用的是文件后缀名
    /* buff 类型
    无效 0x00
    分区表 0x01
    agps 文件 0x02
    gps固件 0x03
    支持文件 0xff
    离线地图 .db \ .idx \ .mlp ⼀个离线地图是⼀个⽬录，⽬录下还有⼦⽬录，然后有系列⽂件 0x1A
    轨迹⽂件 .GPX 0x1B
    吃药提醒图⽚ .medic 0x1C
    */
    switch (fileTranItem.dataType) {
      case FileTranDataType.unknown:
        return 0x00;
      case FileTranDataType.agps:
        return 0x02;
      case FileTranDataType.gps_fw:
        return 0x03;
      case FileTranDataType.dial:
      case FileTranDataType.word:
      case FileTranDataType.photo:
      case FileTranDataType.fw:
        return 0xff;
      case FileTranDataType.voice_alexa:
        return 0xff;
      case FileTranDataType.map:
        return 0x1A;
      case FileTranDataType.gpx:
        return 0x1B;
      case FileTranDataType.medic:
        return 0x1C;
    }
  }

  int _compressionType() {
    switch (fileTranItem.compressionType) {
      case FileTranCompressionType.none:
        return 0;
      case FileTranCompressionType.zlib:
        return 1;
      case FileTranCompressionType.fastlz:
        return 2;
    }
  }

  bool _isSilfiOta() {
    // 98: 思澈1, 99: 思澈2
    if ((fileTranItem.platform == 98 || fileTranItem.platform == 99) && fileTranItem.dataType == FileTranDataType.fw) {
      return true;
    }
    return false;
  }

  bool _isNordicOta() {
    // 1: Nordic Zephyr DFU
    if (fileTranItem.platform == 1 && fileTranItem.dataType == FileTranDataType.fw) {
      return true;
    }
    return false;
  }
}

/// 普通文件
extension _FileTaskNormal on FileTask {
  _cancelNormal() {
    // 停止数据传输
    if (_useSpp) {
      logger?.d('stop tran file - spp');
      sppTransManager.sppTranDataManualStop();
    } else {
      logger?.d('stop tran file - ble');
      coreManager.cLib.tranDataManualStop();
    }
  }

  Future<CmdResponse> _execNormal() async {
    try {
      // 检查文件是否存在
      final file = File(fileTranItem.filePath);
      if (!await file.exists()) {
        logger?.e(
            'file not exits filePath:${fileTranItem.filePath}  fileName:${fileTranItem.fileName}');
        _status = TaskStatus.stopped;
        final res = CmdResponse(code: ErrorCode.failed, msg: 'file not exits');
        _completer!.complete(res);
        return _completer!.future;
      }

      // 读取文件大小
      final fileLength = await file.length();
      logger?.d('fileLength len:$fileLength');
      final dataType = _dataType();
      final compressionType = _compressionType();

      logger?.v('_useSpp: $_useSpp');
      // 安卓使用spp传输音乐
      if (_useSpp) {
        // 文件传输进度事件回调
        sppTransManager.registerSppDataTranProgressCallbackReg(
            func: (int progress) {
          //logger?.d('file tran progress：$progress');
          progressCallback(progress / 100.0);
        });

        // 文件传输完成事件回调
        sppTransManager.registerSppDataTranCompleteCallback(
            func: (int error, int errorVal) {
          //logger?.d('file tran state error: $error errorVal: $errorVal');
          statusCallback(error, errorVal);
          _status = TaskStatus.finished;
          final res = CmdResponse(code: error);
          _completer?.complete(res);
          _completer = null;
        });

        logger?.v('call sppTranDataSetBuffByPath');
        // 设置buff
        final rs = sppTransManager.sppTranDataSetBuffByPath(
            dataType: dataType,
            srcPath : fileTranItem.filePath,
            fileName: fileTranItem.fileName,
            compressionType: compressionType,
            oriSize: fileTranItem.originalFileSize ?? 0);
        if(rs!=ErrorCode.success)
        {
          final res = CmdResponse(code: ErrorCode.failed);
          _completer!.complete(res);
        }
        // 设置prn
        sppTransManager.sppTranDataSetPRN(10);

        // 启动传输
        sppTransManager.sppTranDataStart();
      } else {
        // 文件传输进度事件回调
        coreManager.cLib.registerDataTranProgressCallbackReg(
            func: (int progress) {
          //logger?.d('file tran progress：$progress');
          progressCallback(progress / 100.0);
        });

        // 文件传输完成事件回调
        coreManager.cLib.registerDataTranCompleteCallback(
            func: (int error, int errorVal) {
          if (_completer != null && !_completer!.isCompleted) {
            //logger?.d('file tran state error: $error errorVal: $errorVal');
            statusCallback(error, errorVal);
            _status = TaskStatus.finished;
            final res = CmdResponse(code: error);
            _completer?.complete(res);
            _completer = null;
          }
        });

        logger?.v('call tranDataSetBuffByPath');
         final rs = coreManager.cLib.tranDataSetBuffByPath(
            dataType: dataType,
            srcPath : fileTranItem.filePath,
            fileName: fileTranItem.fileName,
            compressionType: compressionType,
            oriSize: fileTranItem.originalFileSize ?? 0);
        if(rs!=ErrorCode.success)
        {
          final res = CmdResponse(code: ErrorCode.failed);
          _completer!.complete(res);
        }
        // logger?.v('call tranDataSetBuff');
        // // 设置buff
        // coreManager.cLib.tranDataSetBuff(
        //     data: fileData,
        //     dataType: dataType,
        //     fileName: fileTranItem.fileName,
        //     compressionType: compressionType,
        //     oriSize: fileTranItem.originalFileSize ?? 0);

        // 设置prn
        coreManager.cLib.tranDataSetPRN(10);

        // 启动传输
        coreManager.cLib.tranDataStart();
      }
    } catch (e) {
      logger?.e(e.toString());
      _status = TaskStatus.stopped;
      final res = CmdResponse(code: ErrorCode.failed, msg: e.toString());
      _completer!.complete(res);
    }

    return _completer!.future;
  }
}

/// alexa 语音传输
extension _FileTaskVoice on FileTask  {
  _cancelVoice() {
    logger?.d('alexa - stop tran voice file');
    coreManager.cLib.voiceFileTranToBleStop();
  }

  Future<CmdResponse> _execVoice() async {
    try {
      // 检查文件是否存在
      final file = File(fileTranItem.filePath);
      if (!await file.exists()) {
        logger?.e(
            'alexa - file not exits filePath:${fileTranItem.filePath}  fileName:${fileTranItem.fileName}');
        _status = TaskStatus.stopped;
        final res = CmdResponse(code: ErrorCode.failed, msg: 'file not exits');
        _completer!.complete(res);
        return _completer!.future;
      }

      final fileLen = await file.length();
      logger?.d('alexa - fileLen:$fileLen \n\t path:${file.path}');

      /*
      /// VOICE_TO_BLE_STATE_IDLE         = 0, //空闲态
      /// VOICE_TO_BLE_STATE_START        = 1, //开始
      /// VOICE_TO_BLE_STATE_END          = 2, //停止状态 正常的停止的
      /// VOICE_TO_BLE_STATE_TIME_OUT     = 3, //超时
      /// VOICE_TO_BLE_STATE_DISCONNECT   = 4, //断线*/
      coreManager.cLib.registerVoiceFileTranToBleStateCbReg((status) {
        logger?.d('alexa - voice tran state: $status');
        switch (status) {
          case 0:
            break;
          case 1:
            break;
          case 2:
            _markCompleterSuccessful();
            break;
          case 3:
          case 4:
            _markCompleterFailed();
            break;
        }
      });

      /*
      /// VBUS_EVT_VOICE_TRAN_TO_BLE_START(7633)、
      /// VBUS_EVT_VOICE_TRAN_TO_BLE_ABNORMAL_END(7636)、
      /// VBUS_EVT_VOICE_TRAN_TO_BLE_END(7635)
      /// 备注：使用voiceFileTranToBleSetParam方法 固件返回结果事件号对应VBUS_EVT_VOICE_TRAN_TO_BLE_START
      /// 使用voiceFileTranToBleStop方法 固件返回结果事件号对应VBUS_EVT_VOICE_TRAN_TO_BLE_END
      /// VBUS_EVT_VOICE_TRAN_TO_BLE_ABNORMAL_END事件对应的是传输过程中,固件回应包携带的错误码上报*/
      // app传输语音文件操作固件回复结果回调注册
      coreManager.cLib
          .registerVoiceFileTranToBleSendOperateReplyCbReg((event, errorCode) {
        logger?.d(
            'alexa - voice operate reply event: $event errorCode:$errorCode');
        switch (event) {
          case 7633:
            _stopTimerVoiceSetParam();
            if (errorCode == 0) {
              coreManager.cLib.voiceFileTranToBleStart(fileTranItem.filePath);
            } else {
              _markCompleterFailed();
            }
            break;
          case 7636:
            // VBUS_EVT_VOICE_TRAN_TO_BLE_ABNORMAL_END
            break;
          case 7635:
            // VBUS_EVT_VOICE_TRAN_TO_BLE_END
            break;
        }
      });

      coreManager.streamReceiveData.stream.listen((tuple3) {
        if (tuple3.item2 == 7633 && tuple3.item1 != 0) {
          // 传输失败
          logger?.d('alexa - voice tran state error: ${tuple3.item1}');
        }
      });

      // voiceType 传输类型  0:无效 1:sbc 2:opus 3:mp3
      coreManager.cLib.voiceFileTranToBleSetParam(10, 1, fileLen);
      _startTimerVoiceSetParam();
    } catch (e) {
      logger?.e(e.toString());
      _status = TaskStatus.stopped;
      final res = CmdResponse(code: ErrorCode.failed, msg: e.toString());
      _completer!.complete(res);
    }

    return _completer!.future;
  }

  void _startTimerVoiceSetParam() {
    _timerVoiceSetParam?.cancel();
    _timerVoiceSetParam = Timer(const Duration(seconds: 5), () {
      _markCompleterFailed();
    });
  }

  void _stopTimerVoiceSetParam() {
    _timerVoiceSetParam?.cancel();
    _timerVoiceSetParam = null;
  }

  void _markCompleterFailed() {
    if (_completer != null && !_completer!.isCompleted) {
      logger?.d('alexa - voice tran state error: -2');
      statusCallback(ErrorCode.failed, ErrorCode.failed);
      _status = TaskStatus.stopped;
      final res = CmdResponse(code: ErrorCode.failed);
      _completer?.complete(res);
      _completer = null;
    }
  }

  void _markCompleterSuccessful() {
    if (_completer != null && !_completer!.isCompleted) {
      logger?.d('alexa - voice tran state error: 0');
      statusCallback(ErrorCode.success, 0);
      _status = TaskStatus.finished;
      final res = CmdResponse(code: ErrorCode.success);
      _completer?.complete(res);
      _completer = null;
    }
  }


}

/// 思澈平台（OTA文件传输）
extension _FileTaskSilfi on FileTask {
  _cancelSilfi() {
    // 停止数据传输
    logger?.d('silfi - stop transfer file');
    _coreMgr.sifliChannel?.sifliHost.stop();
    if (_completer != null && !_completer!.isCompleted) {
      statusCallback(ErrorCode.failed, 0);
      _status = TaskStatus.finished;
      final res = CmdResponse(code: ErrorCode.failed, msg: "call stop transfer");
      _completer?.complete(res);
      _completer = null;
    }
  }

  Future<CmdResponse> _execSilfi() async {
    try {
      final file = File(fileTranItem.filePath);
      // 检查是否为zip文件
      if (!file.path.endsWith('.zip')) {
        logger?.e('silfi - not zip file');
        _status = TaskStatus.stopped;
        final res = CmdResponse(code: ErrorCode.failed, msg: 'not zip file');
        _completer!.complete(res);
        return _completer!.future;
      }

      // 检查文件是否存在
      if (!await file.exists()) {
        logger?.e(
            'silfi - file not exits filePath:${fileTranItem.filePath}  fileName:${fileTranItem.fileName}');
        _status = TaskStatus.stopped;
        final res = CmdResponse(code: ErrorCode.failed, msg: 'silfi - file not exits');
        _completer!.complete(res);
        return _completer!.future;
      }
      logger?.d("silfi - 1");
      // 创建临时目录
      final tmpDir = "${path.dirname(fileTranItem.filePath)}/silfi_tmp";
      await _createDir(tmpDir);

      // 解压文件
      await _unzipFile(fileTranItem.filePath, tmpDir);
      // 兼容多级目录情况，找到bin文件所在的目录并返回
      final fileList = await _getDirFiles(tmpDir);
      if (fileList == null || fileList.isEmpty) {
        logger?.e('silfi - unzip files is empty');
        _status = TaskStatus.stopped;
        final res = CmdResponse(code: ErrorCode.failed, msg: 'silfi - unzip files is empty');
        _completer!.complete(res);
        return _completer!.future;
      } else {
        final fileListName = fileList.map((e) {
          final name = path.basename(e);
          return name;
        }).toList();
        logger?.d('silfi - unzip files count:${fileList.length} \n\tfileListName:$fileListName');
      }
      logger?.d("silfi - 2");
      _coreMgr.sifliChannel?.logBlock = (String logMsg) {
        logger?.d("silfi - native - $logMsg");
      };

      _coreMgr.sifliChannel?.stateBlock = (OTAUpdateState state, String desc) {
        if (_lastLoggedState != state) {
          logger?.d("silfi - state:${state.toString()}  desc:$desc");
          _lastLoggedState = state;
        }
        if (state == OTAUpdateState.completed) {
          if (_completer != null && !_completer!.isCompleted) {
            statusCallback(ErrorCode.success, 0);
            _status = TaskStatus.finished;
            final res = CmdResponse(code: ErrorCode.success, msg: desc);
            _completer?.complete(res);
            _completer = null;
          }
        }else if(state == OTAUpdateState.fail || state == OTAUpdateState.noFile){
          if (_completer != null && !_completer!.isCompleted) {
            statusCallback(ErrorCode.failed, 0);
            _status = TaskStatus.finished;
            final res = CmdResponse(code: ErrorCode.failed, msg: desc);
            _completer?.complete(res);
            _completer = null;
          }
        }
      };
      logger?.d("silfi - 3");
      _coreMgr.sifliChannel?.progressBlock = (double progress, String message) {
        progressCallback(progress);
      };
      logger?.d("silfi - 4, ${Platform.isAndroid?"macAddress: ":"uuid: "}${fileTranItem.macAddress}");
      _lastLoggedState = OTAUpdateState.init;
      await _coreMgr.sifliChannel?.sifliHost.startOTANor(fileList, fileTranItem.macAddress!,  fileTranItem.platform!, true);
    } catch (e) {
      logger?.e("silfi -$e");
      _status = TaskStatus.stopped;
      final res = CmdResponse(code: ErrorCode.failed, msg: e.toString());
      _completer!.complete(res);
    }

    return _completer!.future;
  }

  Future<void> _unzipFile(String zipFilePath, String targetDir) async {
    final dir = Directory(targetDir);
    await _removeDir(targetDir);
    await dir.create(recursive: true);
    final inputStream = InputFileStream(zipFilePath);
    final archive = ZipDecoder().decodeBuffer(inputStream);
    logger?.d('silfi - unzip $zipFilePath \n\t to $targetDir');
    await extractArchiveToDisk(archive, targetDir);
    // 目标目录为空，记录日志
    if (dir.listSync().isEmpty) {
      logger?.e(
          'silfi - error: The file is too small, and an exception may exist.');
    }
  }

  /// 删除指定目录
  _removeDir(String dirPath) async {
    final dir = Directory(dirPath);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  _createDir(String dirPath) async {
    final dir = Directory(dirPath);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
    await dir.create(recursive: true);
  }

  Future<List<String>?> _getDirFiles(String dirPath) async {
    final dir = Directory(dirPath);
    if (await dir.exists()) {
      final entities = await dir.list(recursive: true).toList();
      return entities.whereType<File>().map((e) => e.path).toList();
    }
    return null;
  }

  // /// 获取.bin文件目录
  // Future<String?> findBinFileDirectory(String startPath) async {
  //   final dir = Directory(startPath);
  //   try {
  //     await for (final entity in dir.list(recursive: true)) {
  //       if (entity is File && path.extension(entity.path) == '.bin') {
  //         return "${path.dirname(entity.path)}/";
  //       }
  //     }
  //   } catch (e) {
  //     logger?.e('findBinFileDirectory: $e');
  //   }

  //   return null;
  // }
}

/// Nordic Zephyr DFU（OTA文件传输）
extension _FileTaskNordic on FileTask {
  _cancelNordic() {
    logger?.d('nordic - stop DFU');
    _coreMgr.nordicChannel?.nordicHost.stopDFU();
    if (_completer != null && !_completer!.isCompleted) {
      statusCallback(ErrorCode.failed, 0);
      _status = TaskStatus.finished;
      final res = CmdResponse(code: ErrorCode.failed, msg: "call stop DFU");
      _completer?.complete(res);
      _completer = null;
    }
  }

  Future<CmdResponse> _execNordic() async {
    final future = _completer!.future;
    try {
      final file = File(fileTranItem.filePath);

      // 检查文件是否存在
      if (!await file.exists()) {
        logger?.e(
            'nordic - file not exists filePath:${fileTranItem.filePath}  fileName:${fileTranItem.fileName}');
        _status = TaskStatus.stopped;
        final res = CmdResponse(code: ErrorCode.failed, msg: 'nordic - file not exists');
        _completer!.complete(res);
        return future;
      }

      // 检查 macAddress
      if (fileTranItem.macAddress == null || fileTranItem.macAddress!.isEmpty) {
        logger?.e('nordic - macAddress/uuid is null or empty');
        _status = TaskStatus.stopped;
        final res = CmdResponse(code: ErrorCode.failed, msg: 'nordic - macAddress/uuid is null');
        _completer!.complete(res);
        return future;
      }

      logger?.d("nordic - 1");

      // 设置日志回调
      _coreMgr.nordicChannel?.logBlock = (String logMsg) {
        logger?.d("nordic - native - $logMsg");
      };

      // 设置状态回调
      _coreMgr.nordicChannel?.stateBlock = (NordicDFUState state, String errorMessage) {
        logger?.d("nordic - state:${state.toString()}  errorMessage:$errorMessage");
        if (state == NordicDFUState.completed) {
          if (_completer != null && !_completer!.isCompleted) {
            statusCallback(ErrorCode.success, 0);
            _status = TaskStatus.finished;
            final res = CmdResponse(code: ErrorCode.success, msg: 'DFU completed');
            _completer?.complete(res);
            _completer = null;
          }
        } else if (state == NordicDFUState.failed) {
          if (_completer != null && !_completer!.isCompleted) {
            statusCallback(ErrorCode.failed, 0);
            _status = TaskStatus.finished;
            final res = CmdResponse(code: ErrorCode.failed, msg: errorMessage);
            _completer?.complete(res);
            _completer = null;
          }
        } else if (state == NordicDFUState.cancelled) {
          if (_completer != null && !_completer!.isCompleted) {
            statusCallback(ErrorCode.canceled, 0);
            _status = TaskStatus.finished;
            final res = CmdResponse(code: ErrorCode.canceled, msg: 'DFU cancelled');
            _completer?.complete(res);
            _completer = null;
          }
        }
      };

      logger?.d("nordic - 2");

      // 设置进度回调
      _coreMgr.nordicChannel?.progressBlock = (double progress, String speed) {
        progressCallback(progress / 100.0);
      };

      logger?.d("nordic - 3, ${Platform.isAndroid ? "macAddress: " : "uuid: "}${fileTranItem.macAddress}");

      // 启动 Nordic DFU
      await _coreMgr.nordicChannel?.nordicHost.startDFU(
        fileTranItem.macAddress!,
        fileTranItem.filePath,
        _coreMgr.mtu
      );
    } catch (e) {
      logger?.e("nordic - $e");
      _status = TaskStatus.stopped;
      if (_completer != null && !_completer!.isCompleted) {
        final res = CmdResponse(code: ErrorCode.failed, msg: e.toString());
        _completer!.complete(res);
      }
    }

    return future;
  }
}
