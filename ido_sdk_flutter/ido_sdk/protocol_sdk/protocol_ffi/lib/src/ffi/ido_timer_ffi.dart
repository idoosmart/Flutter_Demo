// ignore_for_file: always_specify_types
// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

import 'dart:ffi' as ffi;

import 'ido_protocol_ffi.g.dart';

class IDOProtocolFfiBindings extends ProtocolFfiBindings {
  late final ffi.Pointer<T> Function<T extends ffi.NativeType>(
      String symbolName) _lookup;

  IDOProtocolFfiBindings(ffi.DynamicLibrary dynamicLibrary)
      : super(dynamicLibrary) {
    _lookup = dynamicLibrary.lookup;
  }

  IDOProtocolFfiBindings.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : super.fromLookup(lookup) {
    _lookup = lookup;
  }

  /// 初始化定时器模块,用户不要使用
  int app_timer_init(
    app_timer_create_st create_func,
    app_timer_start_st start_func,
    app_timer_stop_st stop_func,
  ) {
    return _app_timer_init(
      create_func,
      start_func,
      stop_func,
    );
  }

  late final _app_timer_initPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(app_timer_create_st, app_timer_start_st,
              app_timer_stop_st)>>('app_timer_init');
  late final _app_timer_init = _app_timer_initPtr.asFunction<
      int Function(
          app_timer_create_st, app_timer_start_st, app_timer_stop_st)>();

  /// 创建定时器
  int app_timer_create(
    ffi.Pointer<ffi.Uint32> timer_id,
    app_timer_timeout_evt func,
  ) {
    return _app_timer_create(
      timer_id,
      func,
    );
  }

  late final _app_timer_createPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Pointer<ffi.Uint32>,
              app_timer_timeout_evt)>>('app_timer_create');
  late final _app_timer_create = _app_timer_createPtr.asFunction<
      int Function(ffi.Pointer<ffi.Uint32>, app_timer_timeout_evt)>();

  /// 启动定时器
  int app_timer_start(
    int timer_id,
    int ms,
    ffi.Pointer<ffi.Void> data,
  ) {
    return _app_timer_start(
      timer_id,
      ms,
      data,
    );
  }

  late final _app_timer_startPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Uint32, ffi.Uint32,
              ffi.Pointer<ffi.Void>)>>('app_timer_start');
  late final _app_timer_start = _app_timer_startPtr
      .asFunction<int Function(int, int, ffi.Pointer<ffi.Void>)>();

  /// 停止定时器
  int app_timer_stop(
    int timer_id,
  ) {
    return _app_timer_stop(
      timer_id,
    );
  }

  late final _app_timer_stopPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(ffi.Uint32)>>(
          'app_timer_stop');
  late final _app_timer_stop =
      _app_timer_stopPtr.asFunction<int Function(int)>();
}

// typedef uint32_t (*app_timer_start_st)(uint32_t timer_id,uint32_t ms,void *data); //开始定时器
typedef app_timer_start_st = ffi.Pointer<
    ffi.NativeFunction<
        ffi.Int Function(ffi.Uint32, ffi.Uint32, ffi.Pointer<ffi.Void>)>>;

// typedef uint32_t (*app_timer_stop_st)(uint32_t timer_id); //停止定时器
typedef app_timer_stop_st
    = ffi.Pointer<ffi.NativeFunction<ffi.Int Function(ffi.Uint32)>>;

// typedef void (*app_timer_timeout_evt)(void *data);
typedef app_timer_timeout_evt
    = ffi.Pointer<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>;

// typedef uint32_t (*app_timer_create_st)(uint32_t *timer_id,app_timer_timeout_evt func); //创建定时器
typedef app_timer_create_st = ffi.Pointer<
    ffi.NativeFunction<
        ffi.Int Function(ffi.Pointer<ffi.Uint32>, app_timer_timeout_evt)>>;
