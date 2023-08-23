import 'dart:ffi' as ffi;

import '../logger/logger.dart';
import '../ido_protocol_fii.dart';
import 'callback/define_callback.dart';

// 定时器
extension IDOProtocolAPIExtTimer on IDOProtocolAPI {
  /// 初始化定时器模块
  int initTimer({
    required CallbackAppTimerCreateSt timerCreateSt,
    required CallbackAppTimerStartSt timerStartSt,
    required CallbackAppTimerStopSt timerStopSt,
  }) {
    _timerCreateSt = timerCreateSt;
    _timerStartSt = timerStartSt;
    _timerStopSt = timerStopSt;

    final rs = bindings.app_timer_init(
        ffi.Pointer.fromFunction(_createFun, 0),
        ffi.Pointer.fromFunction(_startFun, 0),
        ffi.Pointer.fromFunction(_stopFun, 0));
    // logger?.d('call _bindings.app_timer_init rs2 = $rs');
    logger?.d('call clib - app_timer_init rs:$rs');
    return rs;
  }

  // C库回调函数
  static int _createFun(
      ffi.Pointer<ffi.Uint32> timerId,
      ffi.Pointer<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>
          timeoutEvtFun) {
    if (_timerCreateSt == null) {
      final funPtrAddress = timeoutEvtFun.address;
      logger?.v('call clib - _timerCreateSt is null addr: 0x${funPtrAddress.toRadixString(16)}');
      return -1;
    }

    void innerTimeoutFun(int timerIdPtr) {
      final fun =
          timeoutEvtFun.asFunction<void Function(ffi.Pointer<ffi.Void>)>();
      final ptr = ffi.Pointer.fromAddress(timerIdPtr);
      fun(ptr.cast());
    }

    final funPtrAddress = timeoutEvtFun.address;
    //logger?.v('call clib - timerCreateSt addr: 0x${funPtrAddress.toRadixString(16)}');

    return _timerCreateSt!(timerId, innerTimeoutFun);
  }

  static int _startFun(int timerId, int ms, ffi.Pointer<ffi.Void> data) {
    if (_timerStartSt == null) {
      return -1;
    }
    return _timerStartSt!(timerId, ms, data.address);
  }

  static int _stopFun(int timerId) {
    if (_timerStopSt == null) {
      return -1;
    }
    return _timerStopSt!(timerId);
  }


  // 用于定时器相关回调
  static CallbackAppTimerCreateSt? _timerCreateSt;
  static CallbackAppTimerStartSt? _timerStartSt;
  static CallbackAppTimerStopSt? _timerStopSt;
}



