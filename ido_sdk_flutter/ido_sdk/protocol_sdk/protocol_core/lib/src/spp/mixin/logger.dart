import 'dart:async';
import 'dart:typed_data';

import '../../logger/logger.dart';

///
/// @author tianwei
/// @date 2024/3/22 17:20
/// @desc
///
mixin Logger {
  initLog() {}

  logE(String message) {
    logger?.e(message);
    // controller.add(message);
  }

  logD(String message) {
    logger?.d(message);
    // controller.add(message);
  }

  logI(String message) {
    logger?.i(message);
    // controller.add(message);
  }

  debug(String message) {
    // debugPrint("DD:$message");
  }

  String toHexString(Uint8List bytes) {
    String hexString =
        bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
    return hexString.toUpperCase();
  }
}
