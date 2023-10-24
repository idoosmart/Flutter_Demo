import 'dart:typed_data';
import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as pkg_ffi;

import '../../ido_protocol_fii.dart';
import '../../logger/logger.dart';

extension IDOProtocolAPIExtRegisterCallback on IDOProtocolAPI {
  /// 解析完固件返回的二进制数据,打包成json数据回调给SDK
  int registerJsonDataTransferCbEvt(
      {required CallbackJsonDataTransferCbEvt func}) {
    _jsonDataTransferCbEvt = func;
    final rs = bindings.JsonDataCallbackDataReg(
        ffi.Pointer.fromFunction(_registerJsonDataTransferCbEvt));
    logger?.d('call clib - JsonDataCallbackDataReg rs:$rs');
    return rs;
  }

  /// 解析完固件返回的v3同步健康数据二进制数据,打包成json数据回调给SDK
  int registerV3SyncHealthJsonDataCbHandle(
      {required CallbackJsonDataTransferCbEvt func}) {
    _jsonV3SyncHealthJsonDataCbHandle = func;
    return bindings.V3SyncHealthJsonDataCbReg(
        ffi.Pointer.fromFunction(_registerV3SyncHealthJsonDataCbHandle));
  }

  /// c库通知app事件回调注册
  int registerNoticeCallback({required CallbackNoticeCbHandle func}) {
    _callbackNoticeCbHandleFun = func;
    final rs = bindings.ProtocolNoticeCallbackReg(
        ffi.Pointer.fromFunction(_registerNoticeCallback));
    logger?.d('call clib - ProtocolNoticeCallbackReg rs:$rs');
    // logger?.d('call clib - c库通知app事件回调注册 rs:$rs');
    //logger?.d('call clib - 快速配置完成回调 1 - c函数注册 rs:$rs');
    return rs;
  }

  /// 文件传输完成事件回调注册
  int registerDataTranCompleteCallback({
    required CallbackDataTranCompleteCbHandle func,
  }) {
    _callbackDataTranCompleteCbHandle = func;
    return bindings.DataTranCompleteCallbackReg(
        ffi.Pointer.fromFunction(_registerDataTranCompleteCallback));
  }

  /// 文件传输进度事件回调注册
  int registerDataTranProgressCallbackReg({
    required CallbackDataTranProgressCbHandle func,
  }) {
    _callbackDataTranProgressCbHandle = func;
    return bindings.DataTranProgressCallbackReg(
      ffi.Pointer.fromFunction(_registerDataTranProgressCallbackReg),
    );
  }

  /// 文件传输完成事件回调注册
  int registerSppDataTranCompleteCallback({
    required CallbackDataTranCompleteCbHandle func,
  }) {
    _callbackSppDataTranCompleteCbHandle = func;
    return bindings.SppDataTranCompleteCallbackReg(
        ffi.Pointer.fromFunction(_registerSppDataTranCompleteCallback));
  }

  /// 文件传输进度事件回调注册
  int registerSppDataTranProgressCallbackReg({
    required CallbackDataTranProgressCbHandle func,
  }) {
    _callbackSppDataTranProgressCbHandle = func;
    return bindings.SppDataTranProgressCallbackReg(
      ffi.Pointer.fromFunction(_registerSppDataTranProgressCallbackReg),
    );
  }

  /// 同步v2活动数据进度回调注册
  int registerSyncV2ActivityProgressCallbackReg({
    required CallbackSyncActivityProgressCbHandle func,
  }) {
    _callbackSyncActivityProgressCbHandle = func;
    return bindings.SyncV2ActivityProgressCallbackReg(
      ffi.Pointer.fromFunction(_registerSyncV2ActivityProgressCallbackReg),
    );
  }

  /// 同步v2Gps数据进度回调注册
  int registerSyncV2GpsProgressCallbackReg({
    required CallbackSyncGpsProgressCbHandle func,
  }) {
    _callbackSyncGpsProgressCbHandle = func;
    return bindings.SyncV2GpsProgressCallbackReg(
      ffi.Pointer.fromFunction(_registerSyncV2GpsProgressCallbackReg),
    );
  }

  /// 同步v2活动数据完成回调注册
  int registerSyncV2ActivityCompleteCallbackReg({
    required CallbackSyncV2ActivityCompleteCbHandle func,
  }) {
    _callbackSyncV2ActivityCompleteCbHandle = func;
    return bindings.SyncV2ActivityCompleteCallbackReg(
      ffi.Pointer.fromFunction(_registerSyncV2ActivityCompleteCallbackReg),
    );
  }

  /// 同步v2Gps数据完成回调注册
  int registerSyncV2GpsCompleteCallbackReg({
    required CallbackSyncV2GpsCompleteCbHandle func,
  }) {
    _callbackSyncV2GpsCompleteCbHandle = func;
    return bindings.SyncV2GpsCompleteCallbackReg(
      ffi.Pointer.fromFunction(_registerSyncV2GpsCompleteCallbackReg),
    );
  }

  /// 同步v2健康数据进度回调注册
  int registerSyncV2HealthProgressCallbackReg({
    required CallbackSyncV2HealthProgressCbHandle func,
  }) {
    _callbackSyncV2HealthProgressCbHandle = func;
    return bindings.SyncV2HealthProgressCallbackReg(
      ffi.Pointer.fromFunction(_registerSyncV2HealthProgressCallbackReg),
    );
  }

  /// 同步v2健康数据完成回调注册
  int registerSyncV2HealthCompleteCallbackReg({
    required CallbackSyncV2HealthCompleteCbHandle func,
  }) {
    _callbackSyncV2HealthCompleteCbHandle = func;
    return bindings.SyncV2HealthProgressCallbackReg(
      ffi.Pointer.fromFunction(_registerSyncV2HealthCompleteCallbackReg),
    );
  }

  /// 解析完固件返回的v2同步数据二进制数据,打包成json数据回调给SDK
  int registerV2SyncDataJsonDataCbReg(
      {required CallbackJsonDataTransferCbEvt func}) {
    _v2SyncDataJsonDataCbRegHandle = func;
    return bindings.V2SyncDataJsonDataCbReg(
        ffi.Pointer.fromFunction(_registerV2SyncDataJsonDataCbReg));
  }

  /// v3血压校准完成事件回调注册
  int registerProtocolV3BpCalCompleteCallbackReg({
    required CallbackBpCalCompleteCbHandle func,
  }) {
    _callbackBpCalCompleteCbHandle = func;
    return bindings.ProtocolV3BpCalCompleteCallbackReg(
      ffi.Pointer.fromFunction(_registerProtocolV3BpCalCompleteCallbackReg),
    );
  }

  /// 同步v3健康数据进度回调注册
  int registerSyncV3HealthDataProgressCallbackReg({
    required CallbackSyncV3HealthClientProgressCbHandle func,
  }) {
    _callbackSyncV3HealthClientProgressCbHandle = func;
    return bindings.SyncV3HealthDataProgressCallbackReg(
      ffi.Pointer.fromFunction(_registerSyncV3HealthDataProgressCallbackReg),
    );
  }

  /// 同步v3健康数据完成事件回调注册
  int registerSyncV3HealthDataCompleteCallbackReg({
    required CallbackSyncV3HealthClientCompleteCbHandle func,
  }) {
    _callbackSyncV3HealthClientCompleteCbHandle = func;
    return bindings.SyncV3HealthDataCompleteCallbackReg(
      ffi.Pointer.fromFunction(_registerSyncV3HealthDataCompleteCallbackReg),
    );
  }

  /// 同步v3健康数据完成事件回调注册
  int registerSyncV3HealthDataOneNoticeCompleteCbReg({
    required CallbackSyncV3HealthClientOneNoticeCompleteCbHandle func,
  }) {
    _callbackSyncV3HealthClientOneNoticeCompleteCbHandle = func;
    return bindings.SyncV3HealthDataOneNoticeCompleteCbReg(
      ffi.Pointer.fromFunction(_registerSyncV3HealthDataOneNoticeCompleteCbReg),
    );
  }

  /// 获取flashlog完成回调注册
  int registerFlashLogTranCompleteCbHandle({
    required CallbackFlashLogTranCompleteCbHandle func,
  }) {
    _callbackFlashLogTranCompleteCbHandle = func;
    return bindings.FlashLogTranCompletCallbackReg(
      ffi.Pointer.fromFunction(_registerFlashLogTranCompleteCbHandle),
    );
  }

  /// 获取电池日志完成回调注册
  int registerBatteryLogGetCompletedCallbackReg({
    required CallbackBatteryLogInfoCompleteCbHandle func,
  }) {
    _callbackBatteryLogInfoCompleteCbHandle = func;
    return bindings.BatteryLogGetCompletCallbackReg(
      ffi.Pointer.fromFunction(_registerBatteryLogGetCompletedCallbackReg),
    );
  }

  /// 获取flashlog完成回调注册
  int registerHeatLogGetCompletCallbackReg({
    required CallbackHeatLogInfoCompleteCbHandle func,
  }) {
    _callbackHeatLogInfoCompleteCbHandle = func;
    return bindings.HeatLogGetCompletCallbackReg(
      ffi.Pointer.fromFunction(_registerHeatLogGetCompletedCallbackReg),
    );
  }

  /// 响应原始数据回调
  void registerResponseRawData({
    required CallbackDataResponseHandle func,
  }) {
    _callbackDataResponseHandle = func;
    bindings.responseRawData(
      ffi.Pointer.fromFunction(_registerResponseRawData),
    );
  }

  /// 回调处理函数,音频采样率转换完成回调
  void registerMp3ToMp3Complete({
    required CallbackMp3ToMp3CompleteCbHandle func,
  }) {
    _callbackMp3ToMp3CompleteCbHandle = func;
    bindings.AudioSRConversionCompletCallbackReg(
      ffi.Pointer.fromFunction(_registerMp3ToMp3Complete),
    );
  }

  // ----------------------------- Alexa -----------------------------

  /// app传输语音文件状态回调注册
  void registerVoiceFileTranToBleStateCbReg(
    CallbackReportVoiceFileTranStatusCbHandle func,
  ) {
    _callbackReportVoiceFileTranStatusCbHandle = func;
    bindings.voiceFileTranToBleStateCbReg(
      ffi.Pointer.fromFunction(_registerReportVoiceFileTranStatusCbHandle),
    );
  }

  /// app传输语音文件操作固件回复结果回调注册
  void registerVoiceFileTranToBleSendOperateReplyCbReg(
    CallbackReportVoiceFileTranSendOptReplyCbHandle func,
  ) {
    _callbackReportVoiceFileTranSendOptReplyCbHandle = func;
    bindings.voiceFileTranToBleSendOperateReplyCbReg(
      ffi.Pointer.fromFunction(
          _registerReportVoiceFileTranSendOptReplyCbHandle),
    );
  }

  /// 上报接收到的opus语音文件状态回调注册
  void registerReportVoiceDataFromBleOpusStateCbReg(
    CallbackReportOpusVoiceFileTranStatusCbHandle func,
  ) {
    _callbackReportOpusVoiceFileTranStatusCbHandle = func;
    final rs = bindings.reportVoiceDataFromBleOpusStateCbReg(
      ffi.Pointer.fromFunction(_registerReportOpusVoiceFileTranStatusCbHandle),
    );
    logger?.d('call clib - reportVoiceDataFromBleOpusStateCbReg rs:$rs');
  }

  /// 上报接收的opus语音文件丢包率回调注册
  void registerReportVoiceDataFromBleLostDataCbReg(
    CallbackReportOpusVoiceFileTranLostDataCbHandle func,
  ) {
    _callbackReportOpusVoiceFileTranLostDataCbHandle = func;
    final rs = bindings.reportVoiceDataFromBleLostDataCbReg(
      ffi.Pointer.fromFunction(
          _registerReportOpusVoiceFileTranLostDataCbHandle),
    );
    logger?.d('call clib - reportVoiceDataFromBleLostDataCbReg rs:$rs');
  }

  /// 上报接收opus语音文件每段pcm编码数据回调注册
  void registerReportVoiceDataFromBleEachPcmDataCbReg(
    CallbackReportOpusVoiceFileTranDataCbHandle func,
  ) {
    _callbackReportOpusVoiceFileTranDataCbHandle = func;
    bindings.reportVoiceDataFromBleEachPcmDataCbReg(
      ffi.Pointer.fromFunction(_registerReportOpusVoiceFileTranDataCbHandle),
    );
  }

  /// 上报接收的opus上报语音文件数据回调注册
  void registerReportVoiceDataFromBleDataCbReg(
    CallbackReportOpusVoiceFileTranDataCbHandle func,
  ) {
    _callbackReportOpusVoiceFileTranDataCbHandle1 = func;
    bindings.reportVoiceDataFromBleDataCbReg(
      ffi.Pointer.fromFunction(_registerReportOpusVoiceFileTranDataCbHandle1),
    );
  }

  static CallbackReportOpusVoiceFileTranDataCbHandle?
      _callbackReportOpusVoiceFileTranDataCbHandle1;
  static void _registerReportOpusVoiceFileTranDataCbHandle1(
      ffi.Pointer<ffi.Char> tranData, int len) {
    if (_callbackReportOpusVoiceFileTranDataCbHandle1 != null) {
      final dataUint8 = tranData.cast<ffi.Uint8>();
      final data = dataUint8.asTypedList(len);
      _callbackReportOpusVoiceFileTranDataCbHandle1!(data, len);
    } else {
      logger?.e('_callbackReportOpusVoiceFileTranDataCbHandle1 is null');
    }
  }

  /// 上报接收的opus上报每帧的语音文件数据回调注册
  void reportVoiceDataFromBleEachEncodeDataCbReg(
    CallbackReportOpusVoiceFileTranDataCbHandle func,
  ) {
    _callbackReportOpusVoiceFileTranDataCbHandle2 = func;
    bindings.reportVoiceDataFromBleDataCbReg(
      ffi.Pointer.fromFunction(_registerReportOpusVoiceFileTranDataCbHandle2),
    );
  }

  static CallbackReportOpusVoiceFileTranDataCbHandle?
      _callbackReportOpusVoiceFileTranDataCbHandle2;
  static void _registerReportOpusVoiceFileTranDataCbHandle2(
      ffi.Pointer<ffi.Char> tranData, int len) {
    if (_callbackReportOpusVoiceFileTranDataCbHandle2 != null) {
      final dataUint8 = tranData.cast<ffi.Uint8>();
      final data = dataUint8.asTypedList(len);
      _callbackReportOpusVoiceFileTranDataCbHandle2!(data, len);
    } else {
      logger?.e('_callbackReportOpusVoiceFileTranDataCbHandle2 is null');
    }
  }

  static CallbackReportOpusVoiceFileTranDataCbHandle?
      _callbackReportOpusVoiceFileTranDataCbHandle;
  static void _registerReportOpusVoiceFileTranDataCbHandle(
      ffi.Pointer<ffi.Char> tranData, int len) {
    if (_callbackReportOpusVoiceFileTranDataCbHandle != null) {
      final dataUint8 = tranData.cast<ffi.Uint8>();
      final data = dataUint8.asTypedList(len);
      _callbackReportOpusVoiceFileTranDataCbHandle!(data, len);
    } else {
      logger?.e('_callbackReportOpusVoiceFileTranDataCbHandle is null');
    }
  }

  static CallbackReportOpusVoiceFileTranLostDataCbHandle?
      _callbackReportOpusVoiceFileTranLostDataCbHandle;
  static void _registerReportOpusVoiceFileTranLostDataCbHandle(
      int sizeLostPkg, int sizeAllPkg) {
    if (_callbackReportOpusVoiceFileTranLostDataCbHandle != null) {
      _callbackReportOpusVoiceFileTranLostDataCbHandle!(
          sizeLostPkg, sizeAllPkg);
    } else {
      logger?.e('_callbackReportOpusVoiceFileTranLostDataCbHandle is null');
    }
  }

  static CallbackReportOpusVoiceFileTranStatusCbHandle?
      _callbackReportOpusVoiceFileTranStatusCbHandle;
  static void _registerReportOpusVoiceFileTranStatusCbHandle(int status) {
    if (_callbackReportOpusVoiceFileTranStatusCbHandle != null) {
      _callbackReportOpusVoiceFileTranStatusCbHandle!(status);
    } else {
      logger?.e('_callbackReportOpusVoiceFileTranStatusCbHandle is null');
    }
  }

  static CallbackReportVoiceFileTranSendOptReplyCbHandle?
      _callbackReportVoiceFileTranSendOptReplyCbHandle;
  static void _registerReportVoiceFileTranSendOptReplyCbHandle(
      int event, int errorCode) {
    if (_callbackReportVoiceFileTranSendOptReplyCbHandle != null) {
      _callbackReportVoiceFileTranSendOptReplyCbHandle!(event, errorCode);
    } else {
      logger?.e('_callbackReportVoiceFileTranSendOptReplyCbHandle is null');
    }
  }

  static CallbackReportVoiceFileTranStatusCbHandle?
      _callbackReportVoiceFileTranStatusCbHandle;
  static void _registerReportVoiceFileTranStatusCbHandle(int retCode) {
    if (_callbackReportVoiceFileTranStatusCbHandle != null) {
      _callbackReportVoiceFileTranStatusCbHandle!(retCode);
    } else {
      logger?.e('_callbackReportVoiceFileTranStatusCbHandle is null');
    }
  }

  static CallbackMp3ToMp3CompleteCbHandle? _callbackMp3ToMp3CompleteCbHandle;
  static void _registerMp3ToMp3Complete(int retCode) {
    if (_callbackMp3ToMp3CompleteCbHandle != null) {
      //logger?.d('call _callbackMp3ToMp3CompleteCbHandle');
      _callbackMp3ToMp3CompleteCbHandle!(retCode);
    } else {
      //logger?.d('call _callbackMp3ToMp3CompleteCbHandle is null');
    }
  }

  static CallbackJsonDataTransferCbEvt? _jsonDataTransferCbEvt;
  static void _registerJsonDataTransferCbEvt(
      ffi.Pointer<ffi.Char> jsonData, int evt, int retCode) {
    if (_jsonDataTransferCbEvt != null) {
      //logger?.v('call _registerJsonDataTransferCbEvt');
      try {
        final json = jsonData.cast<pkg_ffi.Utf8>().toDartString();
        //logger?.v('call _registerJsonDataTransferCbEvt2');
        _jsonDataTransferCbEvt!(json, evt, retCode);
      } catch (e) {
        _jsonDataTransferCbEvt!('{}', evt, 11); // 11 无效数据
        logger?.e('error: ${e.toString()}');
      }
      //logger?.v('call _registerJsonDataTransferCbEvt3');
    } else {
      logger?.v('func _registerJsonDataTransferCbEvt is null');
    }
  }

  static CallbackJsonDataTransferCbEvt? _jsonV3SyncHealthJsonDataCbHandle;
  static void _registerV3SyncHealthJsonDataCbHandle(
      ffi.Pointer<ffi.Char> jsonData, int evt, int retCode) {
    if (_jsonV3SyncHealthJsonDataCbHandle != null) {
      //logger?.d('call _registerV3SyncHealthJsonDataCbHandle');
      final json = jsonData.cast<pkg_ffi.Utf8>().toDartString();
      _jsonV3SyncHealthJsonDataCbHandle!(json, evt, retCode);
    } else {
      logger?.d('func _registerV3SyncHealthJsonDataCbHandle is null');
    }
  }

  static CallbackNoticeCbHandle? _callbackNoticeCbHandleFun;
  static void _registerNoticeCallback(int evt, int type, int error, int val) {
    if (_callbackNoticeCbHandleFun != null) {
      //logger?.d('ffi _registerNoticeCallback evt:$evt type:$type error:$error val:$val');
      _callbackNoticeCbHandleFun!(evt, type, error, val);
    } else {
      //logger?.d('ffi _registerNoticeCallback is null');
    }
  }

  static CallbackDataTranCompleteCbHandle? _callbackDataTranCompleteCbHandle;
  static void _registerDataTranCompleteCallback(int error, int errVal) {
    if (_callbackDataTranCompleteCbHandle != null) {
      //logger?.d('call _registerDataTranCompleteCallback');
      _callbackDataTranCompleteCbHandle!(error, errVal);
    } else {
      //logger?.d('call _registerDataTranCompleteCallback is null');
    }
  }

  static CallbackSyncGpsProgressCbHandle? _callbackDataTranProgressCbHandle;
  static void _registerDataTranProgressCallbackReg(int rate) {
    if (_callbackDataTranProgressCbHandle != null) {
      //logger?.d('call _registerDataTranProgressCallbackReg');
      _callbackDataTranProgressCbHandle!(rate);
    } else {
      //logger?.d('call _registerDataTranProgressCallbackReg is null');
    }
  }

  static CallbackDataTranCompleteCbHandle? _callbackSppDataTranCompleteCbHandle;
  static void _registerSppDataTranCompleteCallback(int error, int errVal) {
    if (_callbackSppDataTranCompleteCbHandle != null) {
      //logger?.d('call _registerDataTranCompleteCallback');
      _callbackSppDataTranCompleteCbHandle!(error, errVal);
    } else {
      //logger?.d('call _registerDataTranCompleteCallback is null');
    }
  }

  static CallbackSyncGpsProgressCbHandle? _callbackSppDataTranProgressCbHandle;
  static void _registerSppDataTranProgressCallbackReg(int rate) {
    if (_callbackSppDataTranProgressCbHandle != null) {
      //logger?.d('call _registerDataTranProgressCallbackReg');
      _callbackSppDataTranProgressCbHandle!(rate);
    } else {
      //logger?.d('call _registerDataTranProgressCallbackReg is null');
    }
  }

  static CallbackSyncActivityProgressCbHandle?
      _callbackSyncActivityProgressCbHandle;
  static void _registerSyncV2ActivityProgressCallbackReg(int progress) {
    if (_callbackSyncActivityProgressCbHandle != null) {
      //logger?.d('call _registerSyncV2ActivityProgressCallbackReg');
      _callbackSyncActivityProgressCbHandle!(progress);
    } else {
      //logger?.d('call _registerSyncV2ActivityProgressCallbackReg is null');
    }
  }

  static CallbackJsonDataTransferCbEvt? _v2SyncDataJsonDataCbRegHandle;
  static void _registerV2SyncDataJsonDataCbReg(
      ffi.Pointer<ffi.Char> jsonData, int evt, int retCode) {
    if (_v2SyncDataJsonDataCbRegHandle != null) {
      //logger?.d('call _registerV2SyncDataJsonDataCbReg');
      final json = jsonData.cast<pkg_ffi.Utf8>().toDartString();
      _v2SyncDataJsonDataCbRegHandle!(json, evt, retCode);
    } else {
      //logger?.d('call _registerV2SyncDataJsonDataCbReg is null');
    }
  }

  static CallbackSyncGpsProgressCbHandle? _callbackSyncGpsProgressCbHandle;
  static void _registerSyncV2GpsProgressCallbackReg(int progress) {
    if (_callbackSyncGpsProgressCbHandle != null) {
      //logger?.d('call _registerSyncV2GpsProgressCallbackReg');
      _callbackSyncGpsProgressCbHandle!(progress);
    } else {
      //logger?.d('call _registerSyncV2GpsProgressCallbackReg is null');
    }
  }

  static CallbackBpCalCompleteCbHandle? _callbackBpCalCompleteCbHandle;
  static void _registerProtocolV3BpCalCompleteCallbackReg(int errCode) {
    if (_callbackBpCalCompleteCbHandle != null) {
      //logger?.d('call registerProtocolV3BpCalCompleteCallbackReg');
      _callbackBpCalCompleteCbHandle!(errCode);
    } else {
      //logger?.d('call registerProtocolV3BpCalCompleteCallbackReg is null');
    }
  }

  static CallbackSyncV3HealthClientProgressCbHandle?
      _callbackSyncV3HealthClientProgressCbHandle;
  static void _registerSyncV3HealthDataProgressCallbackReg(int progress) {
    if (_callbackSyncV3HealthClientProgressCbHandle != null) {
      //logger?.d('call _registerSyncV3HealthDataProgressCallbackReg');
      _callbackSyncV3HealthClientProgressCbHandle!(progress);
    } else {
      //logger?.d('call _registerSyncV3HealthDataProgressCallbackReg is null');
    }
  }

  static CallbackSyncV3HealthClientCompleteCbHandle?
      _callbackSyncV3HealthClientCompleteCbHandle;
  static void _registerSyncV3HealthDataCompleteCallbackReg(int errCode) {
    if (_callbackSyncV3HealthClientCompleteCbHandle != null) {
      //logger?.d('call _registerSyncV3HealthDataCompleteCallbackReg');
      _callbackSyncV3HealthClientCompleteCbHandle!(errCode);
    } else {
      //logger?.d('call _registerSyncV3HealthDataCompleteCallbackReg is null');
    }
  }

  static CallbackSyncV3HealthClientOneNoticeCompleteCbHandle?
      _callbackSyncV3HealthClientOneNoticeCompleteCbHandle;
  static void _registerSyncV3HealthDataOneNoticeCompleteCbReg(int errCode) {
    if (_callbackSyncV3HealthClientOneNoticeCompleteCbHandle != null) {
      //logger?.d('call _registerSyncV3HealthDataOneNoticeCompleteCbReg');
      _callbackSyncV3HealthClientOneNoticeCompleteCbHandle!(errCode);
    } else {
      //logger?.d('call _registerSyncV3HealthDataOneNoticeCompleteCbReg is null');
    }
  }

  static CallbackFlashLogTranCompleteCbHandle?
      _callbackFlashLogTranCompleteCbHandle;
  static void _registerFlashLogTranCompleteCbHandle(int errCode) {
    if (_callbackFlashLogTranCompleteCbHandle != null) {
      //logger?.d('call _registerFlashLogTranCompleteCbHandle');
      _callbackFlashLogTranCompleteCbHandle!(errCode);
    } else {
      //logger?.d('call _registerFlashLogTranCompleteCbHandle is null');
    }
  }

  static CallbackBatteryLogInfoCompleteCbHandle?
      _callbackBatteryLogInfoCompleteCbHandle;
  static void _registerBatteryLogGetCompletedCallbackReg(
      ffi.Pointer<ffi.Char> jsonData, int errCode) {
    if (_callbackBatteryLogInfoCompleteCbHandle != null) {
      //logger?.d('call _callbackBatteryLogInfoCompleteCbHandle');
      final json = jsonData.cast<pkg_ffi.Utf8>().toDartString();
      _callbackBatteryLogInfoCompleteCbHandle!(json, errCode);
    } else {
      //logger?.d('call _callbackBatteryLogInfoCompleteCbHandle is null');
    }
  }

  static CallbackHeatLogInfoCompleteCbHandle?
      _callbackHeatLogInfoCompleteCbHandle;
  static void _registerHeatLogGetCompletedCallbackReg(
      ffi.Pointer<ffi.Char> jsonData, int errCode) {
    if (_callbackHeatLogInfoCompleteCbHandle != null) {
      //logger?.d('call _callbackHeatLogInfoCompleteCbHandle');
      final json = jsonData.cast<pkg_ffi.Utf8>().toDartString();
      _callbackHeatLogInfoCompleteCbHandle!(json, errCode);
    } else {
      //logger?.d('call _callbackHeatLogInfoCompleteCbHandle is null');
    }
  }

  static CallbackDataResponseHandle? _callbackDataResponseHandle;
  static void _registerResponseRawData(ffi.Pointer<ffi.Int> jsonData, int len) {
    if (_callbackDataResponseHandle != null) {
      //logger?.d('call _callbackDataResponseHandle');
      final dataUint8 = jsonData.cast<ffi.Uint8>();
      final data = dataUint8.asTypedList(len);
      _callbackDataResponseHandle!(data, len);
    } else {
      //logger?.d('call _callbackDataResponseHandle is null');
    }
  }

  static CallbackSyncV2HealthCompleteCbHandle?
      _callbackSyncV2HealthCompleteCbHandle;
  static void _registerSyncV2HealthCompleteCallbackReg(int errCode) {
    if (_callbackSyncV2HealthCompleteCbHandle != null) {
      //logger?.d('call _callbackSyncV2HealthCompleteCbHandle');
      _callbackSyncV2HealthCompleteCbHandle!(errCode);
    } else {
      //logger?.d('call _callbackSyncV2HealthCompleteCbHandle is null');
    }
  }

  static CallbackSyncV2ActivityCompleteCbHandle?
      _callbackSyncV2ActivityCompleteCbHandle;
  static void _registerSyncV2ActivityCompleteCallbackReg(int errCode) {
    if (_callbackSyncV2ActivityCompleteCbHandle != null) {
      //logger?.d('call _registerSyncV2HealthDataCompleteCallbackReg');
      _callbackSyncV2ActivityCompleteCbHandle!(errCode);
    } else {
      //logger?.d('call _registerSyncV2HealthDataCompleteCallbackReg is null');
    }
  }

  static CallbackSyncV2GpsCompleteCbHandle? _callbackSyncV2GpsCompleteCbHandle;
  static void _registerSyncV2GpsCompleteCallbackReg(int errCode) {
    if (_callbackSyncV2GpsCompleteCbHandle != null) {
      //logger?.d('call _callbackSyncV2GpsCompleteCbHandle');
      _callbackSyncV2GpsCompleteCbHandle!(errCode);
    } else {
      //logger?.d('call _callbackSyncV2GpsCompleteCbHandle is null');
    }
  }

  static CallbackSyncV2HealthProgressCbHandle?
      _callbackSyncV2HealthProgressCbHandle;
  static void _registerSyncV2HealthProgressCallbackReg(int progress) {
    if (_callbackSyncV2HealthProgressCbHandle != null) {
      //logger?.d('call _callbackSyncV2HealthProgressCbHandle');
      _callbackSyncV2HealthProgressCbHandle!(progress);
    } else {
      //logger?.d('call _callbackSyncV2HealthProgressCbHandle is null');
    }
  }
}
