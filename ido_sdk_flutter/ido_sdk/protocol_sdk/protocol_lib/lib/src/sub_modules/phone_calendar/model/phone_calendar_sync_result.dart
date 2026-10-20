/// 手机日历全量同步结果
class PhoneCalendarSyncResult {
  /// 错误码：0 成功；1 参数；2 不支持或获取容量失败；3 裁剪后无日程；4 组包/传输失败；5 未连接
  final int errCode;

  /// 裁剪后实际同步的条数
  final int? packedItemCount;

  const PhoneCalendarSyncResult({
    required this.errCode,
    this.packedItemCount,
  });

  bool get isSuccess => errCode == 0;
}

/// 同步错误码
abstract final class PhoneCalendarSyncErrCode {
  static const int success = 0;
  static const int invalidParam = 1;
  static const int notSupportedOrMetaFailed = 2;
  static const int noEventsAfterCrop = 3;
  static const int packOrTransferFailed = 4;
  static const int deviceNotConnected = 5;
}
