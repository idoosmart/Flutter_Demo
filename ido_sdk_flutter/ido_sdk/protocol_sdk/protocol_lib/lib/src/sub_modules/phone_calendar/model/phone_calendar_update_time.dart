/// `.cal` 文件头修改时间（7 字节，与 operate=1 / 通讯录 v2_conta.ml 头一致）
/// Update time written to `.cal` file header (7 bytes; same layout as contact file)
class PhoneCalendarUpdateTime {
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final int second;

  const PhoneCalendarUpdateTime({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.second,
  });

  /// 由本地 [DateTime] 构造（通常取 App 触发同步时刻）
  /// Build from local [DateTime] (typically sync trigger time on App side)
  factory PhoneCalendarUpdateTime.fromDateTime(DateTime dateTime) {
    return PhoneCalendarUpdateTime(
      year: dateTime.year,
      month: dateTime.month,
      day: dateTime.day,
      hour: dateTime.hour,
      minute: dateTime.minute,
      second: dateTime.second,
    );
  }

  /// year 为 0 时 C 库视为无效，且 `phone_calendar_cal_is_need` 恒需下发
  bool get isValid =>
      year > 0 &&
      month >= 1 &&
      month <= 12 &&
      day >= 1 &&
      day <= 31 &&
      hour >= 0 &&
      hour <= 23 &&
      minute >= 0 &&
      minute <= 59 &&
      second >= 0 &&
      second <= 59;

  Map<String, dynamic> toJson() => {
        'year': year,
        'month': month,
        'day': day,
        'hour': hour,
        'minute': minute,
        'second': second,
      };
}
