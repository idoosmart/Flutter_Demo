/// 手机日历日程项（全量 .cal 同步，15.110）
/// Phone calendar event item for full .cal file sync
class PhoneCalendarEvent {
  /// 全量同步写入 .cal 的 state，固定为 2，构造时不可传入
  /// Fixed state value (2) written to .cal; not settable via constructor
  static const int state = 2;

  /// 开始时间，UTC Unix 秒 / Start time as UTC Unix seconds
  final int startTime;

  /// 结束时间，UTC Unix 秒 / End time as UTC Unix seconds
  final int endTime;

  /// 系统日历事件 ID / System calendar event ID
  final String eventId;

  /// 系统日历 ID / System calendar ID
  final String calendarId;

  /// 标题，UTF-8；默认空串 / Title (UTF-8); defaults to empty
  final String title;

  /// 备注，UTF-8；默认空串，非空时才写入 JSON / Note (UTF-8); omitted from JSON when empty
  final String note;

  /// 是否全天：`0` 否、`1` 是；默认 `0` / All-day flag: 0=no, 1=yes; default 0
  final int isAllday;

  /// 提前提醒分钟数；默认空列表，非空时才写入 JSON
  /// Advance reminder minutes; omitted from JSON when empty
  final List<int> advanceReminderMinutes;

  /// 重复规则；key 见 [PhoneCalendarRecurrenceFields]
  /// Recurrence rule map; keys defined in [PhoneCalendarRecurrenceFields]
  final Map<String, dynamic>? recurrence;

  /// 重复结束；key 见 [PhoneCalendarRecurrenceEndFields]；写入 JSON 时 key 为 `recurrence_end`
  /// Recurrence end map; keys in [PhoneCalendarRecurrenceEndFields]; JSON key is `recurrence_end`
  final Map<String, dynamic>? recurrenceEnd;

  const PhoneCalendarEvent({
    required this.startTime,
    required this.endTime,
    required this.eventId,
    required this.calendarId,
    this.title = '',
    this.note = '',
    this.isAllday = 0,
    this.advanceReminderMinutes = const [],
    this.recurrence,
    this.recurrenceEnd,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'start_time': startTime,
      'end_time': endTime,
      'event_id': eventId,
      'calendar_id': calendarId,
      'title': title,
      'is_allday': isAllday,
      'state': state,
    };
    if (note.isNotEmpty) {
      json['note'] = note;
    }
    if (advanceReminderMinutes.isNotEmpty) {
      json['advance_reminder_minutes'] = advanceReminderMinutes;
    }
    if (recurrence != null) {
      json['recurrence'] = recurrence;
    }
    if (recurrenceEnd != null) {
      json['recurrence_end'] = recurrenceEnd;
    }
    return json;
  }
}

/// [PhoneCalendarEvent.recurrence] 的 Map 字段（15.110）
/// Map field names for [PhoneCalendarEvent.recurrence] (protocol 15.110)
abstract final class PhoneCalendarRecurrenceFields {
  /// 重复类型：`0` 无；`1` 每日；`2` 每周；`3` 每月按日；`4` 每月按周；
  /// `5` 每年按日；`6` 每年按周；`0xFE` 兜底
  /// Recurrence kind: 0=none, 1=daily, 2=weekly, 3=monthly by day, 4=monthly by week,
  /// 5=yearly by day, 6=yearly by week, 0xFE=fallback
  static const String kind = 'kind';

  /// 间隔，默认 `1` / Interval; default 1 (e.g. every 2 weeks → 2)
  static const String interval = 'interval';

  /// 每周重复时的星期位图，默认 `0` / Days-of-week bitmask for weekly recurrence
  static const String daysOfWeek = 'days_of_week';

  /// 每月按周重复时的第几周，默认 `0` / Week of month for monthly-by-week recurrence
  static const String weekOfMonth = 'week_of_month';

  /// 每月按日/每年按日的日；系统日历 `-1`（月末）映射为 `255`
  /// Day of month; system calendar -1 (last day) maps to 255
  static const String dayOfMonth = 'day_of_month';

  /// 每年重复时的月份，默认 `0` / Month for yearly recurrence; default 0
  static const String month = 'month';

  /// 每月按周重复时的星期，默认 `0` / Weekday for monthly-by-week recurrence
  static const String weekday = 'weekday';
}

/// [PhoneCalendarEvent.recurrenceEnd] 的 Map 字段（15.110）
/// Map field names for [PhoneCalendarEvent.recurrenceEnd] (protocol 15.110)
abstract final class PhoneCalendarRecurrenceEndFields {
  /// 结束方式：`0` 一直重复；`1` 重复 [count] 次；`2` 重复至 [untilTime]
  /// End kind: 0=forever, 1=repeat [count] times, 2=until [untilTime]
  static const String kind = 'kind';

  /// `kind=1` 时有效，重复次数；其它情况默认 `0`
  /// Repeat count when kind=1; default 0 otherwise
  static const String count = 'count';

  /// `kind=2` 时有效，结束时间 UTC Unix 秒；其它情况默认 `0`
  /// End time (UTC Unix seconds) when kind=2; default 0 otherwise
  static const String untilTime = 'until_time';
}
