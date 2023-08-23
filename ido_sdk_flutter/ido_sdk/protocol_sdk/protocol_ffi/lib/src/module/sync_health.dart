import 'dart:typed_data';
import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as pkg_ffi;

import '../ido_protocol_fii.dart';

// 同步健康数据
extension IDOProtocolAPIExtSyncHealthData on IDOProtocolAPI {
  // /// 开始同步配置信息,如果app需要绑定,不要调用此函数同步,发送事件BIND_EVT_START
  // int startSyncConfigInfo() {
  //   return bindings.StartSyncConfigInf;
  // }
  //
  // /// 停止配置信息
  // int stopSyncConfigInfo() {
  //   return bindings.StopSyncConfigInfo();
  // }

  /// 开始同步V2健康数据
  int startSyncV2HealthData() {
    return bindings.StartSyncV2HealthData();
  }

  /// 停止同步V2健康数据
  int stopSyncV2HealthData() {
    return bindings.StopSyncV2HealthData();
  }

  /// 设置同步健康数据偏移
  ///
  /// type  0 运动数据 , 1 睡眠数据,不支持, 2 心率数据
  int setSyncV2HealthOffset({required int type, required int value}) {
    return bindings.SetSyncV2HealthOffset(type, value);
  }

  /// 解绑清除v3缓存健康数据
  int unBindClearV3HealthData() {
    return bindings.unBindClearV3HealthData();
  }

  /// 开始同步v3健康数据
  int startSyncV3HealthData() {
    return bindings.startSyncV3HealthData();
  }

  /// app每半个小时主动更新 开始同步V3数据，睡眠数据不返回
  int startAutomaticSyncV3HealthData() {
    return bindings.startAutomaticSyncV3HealthData();
  }

  /// 停止同步v3健康数据
  int stopSyncV3HealthData() {
    return bindings.stopSyncV3HealthData();
  }
}
