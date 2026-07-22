/// 手机日历全量同步结果（15.110.1 §5.2）
class PhoneCalendarSyncResult {
  /// C err_code：0 成功；1 参数；2 不支持/operate=1 失败；3 裁剪后无日程；4 组包/传输失败；5 未连接
  final int errCode;

  /// 裁剪后实际写入 .cal 的条数
  final int? packedItemCount;

  const PhoneCalendarSyncResult({
    required this.errCode,
    this.packedItemCount,
  });

  bool get isSuccess => errCode == 0;
}

/// err_code 常量
abstract final class PhoneCalendarSyncErrCode {
  static const int success = 0;
  static const int invalidParam = 1;
  static const int notSupportedOrMetaFailed = 2;
  static const int noEventsAfterCrop = 3;
  static const int packOrTransferFailed = 4;
  static const int deviceNotConnected = 5;
}
