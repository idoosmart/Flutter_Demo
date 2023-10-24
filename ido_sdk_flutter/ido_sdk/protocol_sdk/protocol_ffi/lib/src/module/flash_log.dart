import 'package:ffi/ffi.dart' as pkg_ffi;

import '../ido_protocol_fii.dart';

// 文件操作
extension IDOProtocolAPIExtFlashLog on IDOProtocolAPI {
  ///  获取flash日志开始
  /// @param type 日志类型
  /// ```dart
  /// {PROTOCOL_FLASH_LOG_TYPE_GENERAL   =  0,    //通用log
  /// PROTOCOL_FLASH_LOG_TYPE_RESET      =  1,    //复位log
  /// PROTOCOL_FLASH_LOG_TYPE_ALGORITHM  =   2,    //算法
  /// PROTOCOL_FLASH_LOG_TYPE_HARDWARE   =   3,    //硬件
  /// PROTOCOL_FLASH_LOG_TYPE_REBOOT     =   4,    //重启log}
  /// @param file_name 文件路径 包括文件名及后缀
  /// @return int SUCCESS(0)成功  ERROR_BUSY(17)日志正在获取
  /// ```
  int startGetFlashLog({required int type, required String fileName}) {
    final fileNameUtf8 = fileName.toNativeUtf8();
    return bindings.ProtocolGetFlashLogStart(type, fileNameUtf8.cast());
  }

  /// 获取flash日志停止
  int stopGetFlashLog() {
    return bindings.ProtocolGetFlashLogStop();
  }

  /// 获取电池日志信息
  int getBatteryLogInfo() {
    return bindings.ProtocolGetBatteryLogInfo();
  }

  /// 获取过热日志信息
  int getHeatLogInfo() {
    return bindings.ProtocolGetHeatLogInfo();
  }

  /// 设置flash获取时间，单位秒，默认一分钟
  /// return int SUCCESS(0)成功
  int setProtocolGetFlashLogSetTime(int time) {
    return bindings.ProtocolGetFlashLogSetTime(time);
  }
}
