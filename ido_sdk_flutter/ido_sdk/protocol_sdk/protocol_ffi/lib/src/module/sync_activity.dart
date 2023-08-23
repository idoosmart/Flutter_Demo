import 'dart:typed_data';
import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as pkg_ffi;

import '../ido_protocol_fii.dart';


// 同步运动数据
extension IDOProtocolAPIExtSyncActivityData on IDOProtocolAPI {
  /// 开始同步v2运动数据
  int startSyncV2ActivityData() {
    return bindings.startSyncV2ActivityData();
  }

  /// 停止同步v2运动数据
  int stopSyncV2ActivityData() {
    return bindings.stopSyncV2ActivityData();
  }

  /// 获取v2同步运动状态
  bool isStartedSyncV2ActivityData() {
    return bindings.getSyncV2ActivityDataStatus() != 0;
  }

  /// 开始同步v2GPS数据
  int startSyncV2GpsData() {
    return bindings.startSyncV2GpsData();
  }

  /// 停止同步GPS数据
  int stopSyncV2GpsData() {
    return bindings.stopSyncV2GpsData();
  }
}
