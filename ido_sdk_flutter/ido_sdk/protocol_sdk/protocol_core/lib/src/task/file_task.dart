import 'dart:async';
import 'dart:io';

import 'package:protocol_ffi/protocol_ffi.dart';

import '../manager/response.dart';
import '../logger/logger.dart';

import 'base_task.dart';
import '../model/file_item.dart';
import '../manager/type_define.dart';

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
    支持文件 0xff */
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
        return 0xff;
      case FileTranDataType.voice_alexa:
        return 0xff;
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
}

extension _FileTaskNormal on FileTask {
  _cancelNormal() {
    // 停止数据传输
    if (_useSpp) {
      logger?.d('stop tran file - spp');
      coreManager.cLib.sppTranDataManualStop();
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
        coreManager.cLib.registerSppDataTranProgressCallbackReg(
            func: (int progress) {
          logger?.d('file tran progress：$progress');
          progressCallback(progress);
        });

        // 文件传输完成事件回调
        coreManager.cLib.registerSppDataTranCompleteCallback(
            func: (int error, int errorVal) {
          logger?.d('file tran state error: $error errorVal: $errorVal');
          statusCallback(error, errorVal);
          _status = TaskStatus.finished;
          final res = CmdResponse(code: error);
          _completer?.complete(res);
          _completer = null;
        });

        logger?.v('call sppTranDataSetBuffByPath');
        // 设置buff
        final rs = coreManager.cLib.sppTranDataSetBuffByPath(
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
        coreManager.cLib.sppTranDataSetPRN(10);

        // 启动传输
        coreManager.cLib.sppTranDataStart();
      } else {
        // 文件传输进度事件回调
        coreManager.cLib.registerDataTranProgressCallbackReg(
            func: (int progress) {
          logger?.d('file tran progress：$progress');
          progressCallback(progress);
        });

        // 文件传输完成事件回调
        coreManager.cLib.registerDataTranCompleteCallback(
            func: (int error, int errorVal) {
          if (_completer != null && !_completer!.isCompleted) {
            logger?.d('file tran state error: $error errorVal: $errorVal');
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

extension _FileTaskVoice on FileTask {
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
