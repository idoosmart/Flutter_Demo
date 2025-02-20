import 'type_define.dart';
import '../logger/logger.dart';

/// 指令响应
class CmdResponse {
  /// 错误码
  ///
  /// [cmdCode] 和 [code] 都可以用于结果判定
  /// 根据自己需要自行选择
  CmdCode get cmdCode => _mappingCmdCode();

  /// 原始错误码 - 由C库&固件返回
  ///
  /// ```dart
  ///  0 Successful command
  ///  1 SVC handler is missing
  ///  2 SoftDevice has not been enabled
  ///  3 Internal Error
  ///  4 No Memory for operation
  ///  5 Not found
  ///  6 Not supported
  ///  7 Invalid Parameter
  ///  8 Invalid state, operation disallowed in this state
  ///  9 Invalid Length
  ///  10 Invalid Flags
  ///  11 Invalid Data
  ///  12 Invalid Data size
  ///  13 Operation timed out
  ///  14 Null Pointer
  ///  15 Forbidden Operation
  ///  16 Bad Memory Address
  ///  17 Busy
  ///  18 Maximum connection count exceeded.
  ///  19 Not enough resources for operation
  ///  20 Bt Bluetooth upgrade error
  ///  21 Not enough space for operation
  ///  22 Low Battery
  ///  23 Invalid File Name/Format
  ///  24 空间够但需要整理
  ///  25 空间整理中
  ///
  ///  当指令发出前异常时:
  /// -1 取消
  /// -2 失败
  /// -3 指令已存在队列中
  /// -4 执行快速配置中，指令忽略
  /// -5 设备处于ota模式
  /// -6 未连接设备
  /// -7 执行中的指令被中断(由于发出的指令不能被实际取消，故存在修改指令被中断后可能还会导致设备修改生效的情况)
  /// -8 异常数据无法解析
  /// ```
  final int code;

  /// 事件号
  final int evtType;

  /// 信息
  String? msg;

  /// 对应json数据，
  final String? json;
  
  // @Deprecated('请使用json属性，下个版本将删除该data属性')
  // dynamic get data => json;

  /// 设备Mac地址
  final String? macAddress;

  bool get isOK => code == 0;

  CmdResponse(
      {required this.code,
      this.evtType = 0,
      this.msg,
      this.json,
      this.macAddress}) {
    msg ?? cmdCode.name;
    if (code != 0) {
      logger?.d("res set code: $code");
    }
  }

  /// 映射常用错误码
  CmdCode _mappingCmdCode() {
    CmdCode cc = CmdCode.failed;
    switch (code) {
      case 0:
        cc = CmdCode.successful;
        break;
      case -1:
        cc = CmdCode.canceled;
        break;
      case -2:
        cc = CmdCode.failed;
        break;
      case -3:
        cc = CmdCode.taskAlreadyExists;
        break;
      case 13:
        cc = CmdCode.timeout;
        break;
      case 7:
        cc = CmdCode.invalidParam;
        break;
      case 8:
        cc = CmdCode.invalidState;
        break;
      default:
        break;
    }
    return cc;
  }

  @override
  String toString() {
    return 'CmdResponse{code: $code, evtType: $evtType, msg: $msg, json: $json, macAddress: $macAddress}';
  }

}

/// 同步响应
class SyncResponse extends CmdResponse {
  SyncJsonType dataType = SyncJsonType.values[0];
  SyncType syncType = SyncType.values[0];

  SyncResponse(
      {required super.code,
      super.json,
      this.dataType = SyncJsonType.nullType,
      this.syncType = SyncType.init});
}

/// 日志响应
class LogResponse extends CmdResponse {
  LogType logType = LogType.values[0];
  String? logPath;

  LogResponse(
      {required super.code,
      super.json,
      this.logType = LogType.init,
      this.logPath = ''});
}
