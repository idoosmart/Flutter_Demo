/// CGM 手机下发指令（V3 0x33/0x95，协议 15.107）
/// CGM phone command (V3 cmd_id 0x95, protocol 15.107)

/// 业务 operate，与 C 层 `PROTOCOL_V3_CGM_PHONE_COMMAND_OPERATE_*` 一致
class CgmPhoneCommandOperate {
  CgmPhoneCommandOperate._();

  /// 设置密钥与 CGM 设备名
  static const int setKeyAndDevice = 1;

  /// 删除密钥与设备名
  static const int deleteKeyAndDevice = 2;

  /// 连接 CGM（手表侧流程）
  static const int connectCgm = 3;

  /// 断开 CGM
  static const int disconnectCgm = 4;
}

/// 业务 err_code，与 C 层 `PROTOCOL_V3_CGM_ERR_*` 一致
class CgmPhoneCommandErrCode {
  CgmPhoneCommandErrCode._();

  static const int success = 0x00;
  static const int invalidKey = 0x01;
  static const int invalidDeviceName = 0x02;
  static const int storageFail = 0x03;
  static const int noKey = 0x04;
  static const int busy = 0x05;
  static const int scanTimeout = 0x06;
  static const int pairFlag = 0x07;
  static const int connectFail = 0x08;
  static const int keyReadFail = 0x09;
  static const int protocolFail = 0x0A;
  static const int disconnectFail = 0x0B;

  static bool isSuccess(int? errCode) => errCode == success;

  static String? errorSymbol(int? errCode) {
    switch (errCode) {
      case invalidKey:
        return 'ERR_INVALID_KEY';
      case invalidDeviceName:
        return 'ERR_INVALID_DEVICE_NAME';
      case storageFail:
        return 'ERR_STORAGE_FAIL';
      case noKey:
        return 'ERR_NO_KEY';
      case busy:
        return 'ERR_BUSY';
      case scanTimeout:
        return 'ERR_SCAN_TIMEOUT';
      case pairFlag:
        return 'ERR_PAIR_FLAG';
      case connectFail:
        return 'ERR_CONNECT_FAIL';
      case keyReadFail:
        return 'ERR_KEY_READ_FAIL';
      case protocolFail:
        return 'ERR_PROTOCOL_FAIL';
      case disconnectFail:
        return 'ERR_DISCONNECT_FAIL';
      default:
        return null;
    }
  }
}
