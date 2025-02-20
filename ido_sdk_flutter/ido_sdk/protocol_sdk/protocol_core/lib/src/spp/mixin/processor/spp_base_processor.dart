import 'package:flutter/foundation.dart';
import 'package:protocol_core/src/logger/logger.dart';

import '../../model/spp_cmd.dart';
import '../../model/type_def.dart';
import '../spp_get/spp_mtu_get.dart';

///
/// @author tianwei
/// @date 2024/3/22 16:55
/// @desc
///

abstract class BaseSppProcessor with SppMtuGet {
  BleDataWriter? _bleDataWriter;
  BoolCallback? _inOTAMode;
  BoolCallback? _supportContinueTrans;

  String toHexString(Uint8List bytes) {
    String hexString =
        bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
    return hexString.toUpperCase();
  }

  @protected
  void writeDataToBle(Uint8List data) {
    if (_bleDataWriter != null) {
      _bleDataWriter!(data);
    }
  }

  void setProtocolCoreBridge(
      {BoolCallback? inOtaMode,
      BoolCallback? supportContinueTrans,
      BleDataWriter? writer}) {
    _bleDataWriter = writer;
    _inOTAMode = inOtaMode;
    _supportContinueTrans = supportContinueTrans;
  }

  @protected
  bool supportSendOriginalSize() {
    //TODO 是否支持发送原始大小，spp暂不支持
    return false;
  }

  @protected
  bool supportSppDataTransContinue() {
    final support =  _supportContinueTrans != null ? _supportContinueTrans!() : false;
    logger?.i("support continue trans support:$support");
    return support;
  }

  bool isInOTAMode() {
    final yes = _inOTAMode != null ? _inOTAMode!() : false;
    if (yes) {
      logger?.i("device in ota mode");
    }
    return yes;
  }

  @protected
  bool initProcessor();

  @protected
  int processReceivedSppCmd(SppCmd cmd);

  @protected
  int processDataTransComplete();
}
