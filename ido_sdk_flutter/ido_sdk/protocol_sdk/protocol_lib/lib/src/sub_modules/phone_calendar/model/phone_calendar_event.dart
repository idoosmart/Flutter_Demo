/// 手机日历日程项（全量同步）
/// Phone calendar event item for full sync
class PhoneCalendarEvent {
  /// 全量同步时 `state` 固定为 `2`，构造时不可传入
  /// Sync `state` is fixed to `2`; not settable via constructor
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

  /// 备注，UTF-8；默认空串；空串时不同步该字段
  /// Note (UTF-8); defaults to empty; omitted when empty
  final String note;

  /// 是否全天：`0` 否、`1` 是；默认 `0` / All-day flag: 0=no, 1=yes; default 0
  final int isAllday;

  /// 提前提醒分钟数；默认空列表；空列表时不同步该字段
  /// Advance reminder minutes; omitted when empty
  final List<int> advanceReminderMinutes;

  /// 异常日期（被跳过的重复发生时间），UTC Unix 秒；默认空；空列表时不同步该字段
  /// Exception dates (skipped occurrence timestamps) as UTC Unix seconds
  final List<int> exceptionDates;

  /// 重复规则 / Recurrence rule
  final PhoneCalendarRecurrence? recurrence;

  /// 重复结束 / Recurrence end
  final PhoneCalendarRecurrenceEnd? recurrenceEnd;

  const PhoneCalendarEvent({
    required this.startTime,
    required this.endTime,
    required this.eventId,
    required this.calendarId,
    this.title = '',
    this.note = '',
    this.isAllday = 0,
    this.advanceReminderMinutes = const [],
    this.exceptionDates = const [],
    this.recurrence,
    this.recurrenceEnd,
  });

  /// 由 `.cal` / 全量同步 JSON 构造；`state` 忽略，全量同步固定为 `2`
  /// Build from full-sync JSON; `state` is ignored (always 2)
  factory PhoneCalendarEvent.fromJson(Map<String, dynamic> json) {
    final rec = json['recurrence'];
    final recEnd = json['recurrence_end'];
    return PhoneCalendarEvent(
      startTime: _asInt(json['start_time']),
      endTime: _asInt(json['end_time']),
      eventId: _asString(json['event_id']),
      calendarId: _asString(json['calendar_id']),
      title: _asString(json['title']),
      note: _asString(json['note']),
      isAllday: _asInt(json['is_allday']),
      advanceReminderMinutes: _asIntList(json['advance_reminder_minutes']),
      exceptionDates: _asIntList(json['exception_dates']),
      recurrence: rec is Map
          ? PhoneCalendarRecurrence.fromJson(Map<String, dynamic>.from(rec))
          : null,
      recurrenceEnd: recEnd is Map
          ? PhoneCalendarRecurrenceEnd.fromJson(
              Map<String, dynamic>.from(recEnd),
            )
          : null,
    );
  }

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
    if (exceptionDates.isNotEmpty) {
      json['exception_dates'] = exceptionDates;
    }
    if (recurrence != null) {
      json['recurrence'] = recurrence!.toJson();
    }
    if (recurrenceEnd != null) {
      json['recurrence_end'] = recurrenceEnd!.toJson();
    }
    return json;
  }
}

/// 重复规则 / Recurrence rule
class PhoneCalendarRecurrence {
  /// 重复类型：`0` 无；`1` 每日；`2` 每周；`3` 每月按日；`4` 每月按周；
  /// `5` 每年按日；`6` 每年按周；`0xFE` 兜底
  final int kind;

  /// 间隔，默认 `1` / Interval; default 1
  final int interval;

  /// 周几列表：`0`=周日 … `6`=周六（kind=2/4/6）
  final List<int> daysOfWeek;

  /// 月第几周：`1`~`5`；`-1`=最后一周（kind=4/6）
  final List<int> weeksOfMonth;

  /// 月内日号：`1`~`31`（kind=3/5）
  final List<int> daysOfMonth;

  /// 月份：`1`~`12`（kind=5/6）
  final List<int> monthsOfYear;

  const PhoneCalendarRecurrence({
    required this.kind,
    this.interval = 1,
    this.daysOfWeek = const [],
    this.weeksOfMonth = const [],
    this.daysOfMonth = const [],
    this.monthsOfYear = const [],
  });

  factory PhoneCalendarRecurrence.fromJson(Map<String, dynamic> json) {
    final interval = _asInt(json['interval'], 1);
    return PhoneCalendarRecurrence(
      kind: _asInt(json['kind']),
      interval: interval <= 0 ? 1 : interval,
      daysOfWeek: _asIntList(json['days_of_week']),
      weeksOfMonth: _asIntList(json['weeks_of_month']),
      daysOfMonth: _asIntList(json['days_of_month']),
      monthsOfYear: _asIntList(json['months_of_year']),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'kind': kind,
      'interval': interval <= 0 ? 1 : interval,
    };
    if (daysOfWeek.isNotEmpty) {
      json['days_of_week'] = daysOfWeek;
    }
    if (weeksOfMonth.isNotEmpty) {
      json['weeks_of_month'] = weeksOfMonth;
    }
    if (daysOfMonth.isNotEmpty) {
      json['days_of_month'] = daysOfMonth;
    }
    if (monthsOfYear.isNotEmpty) {
      json['months_of_year'] = monthsOfYear;
    }
    return json;
  }
}

/// 重复结束规则 / Recurrence end rule
class PhoneCalendarRecurrenceEnd {
  /// `0` 一直；`1` 重复 [count] 次；`2` 至 [untilTime]
  final int kind;

  /// `kind=1` 时有效
  final int count;

  /// `kind=2` 时有效，UTC Unix 秒
  final int untilTime;

  const PhoneCalendarRecurrenceEnd({
    required this.kind,
    this.count = 0,
    this.untilTime = 0,
  });

  factory PhoneCalendarRecurrenceEnd.fromJson(Map<String, dynamic> json) {
    return PhoneCalendarRecurrenceEnd(
      kind: _asInt(json['kind']),
      count: _asInt(json['count']),
      untilTime: _asInt(json['until_time']),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'kind': kind};
    if (kind == 1) {
      json['count'] = count;
    } else if (kind == 2) {
      json['until_time'] = untilTime;
    }
    return json;
  }
}

int _asInt(dynamic value, [int fallback = 0]) {
  if (value == null) {
    return fallback;
  }
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse('$value') ?? fallback;
}

String _asString(dynamic value, [String fallback = '']) {
  if (value == null) {
    return fallback;
  }
  return '$value';
}

List<int> _asIntList(dynamic value) {
  if (value is! List) {
    return const [];
  }
  return value.map(_asInt).toList();
}
