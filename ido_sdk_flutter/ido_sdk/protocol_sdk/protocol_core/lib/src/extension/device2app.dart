// ignore_for_file: constant_identifier_names

import 'dart:typed_data';

import 'package:protocol_ffi/protocol_ffi.dart';

import '../../protocol_core.dart';
import '../manager/manager_clib.dart';

extension IDOProtocolCoreManagerExtDevice2App on IDOProtocolCoreManager {
  // ------------------------------ 设备传输文件到APP ------------------------------


  /// APP回复设备传输文件到APP的请求
  /// ```dart
  /// errorCode 0回复握手成功 非0失败，拒绝传输
  /// @return:SUCCESS(0)成功
  /// ```
  int device2AppDataTranRequestReply(int errorCode) {
    return IDOProtocolClibManager().cLib.device2AppDataTranRequestReply(errorCode);
  }

  /// APP主动停止设备传输文件到APP
  ///
  /// @return:SUCCESS(0)成功
  int device2AppDataTranManualStop() {
    return IDOProtocolClibManager().cLib.device2AppDataTranManualStop();
  }
}
