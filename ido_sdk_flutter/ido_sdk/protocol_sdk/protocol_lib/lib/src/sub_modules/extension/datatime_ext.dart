extension IDODateTimeExtension on DateTime {
  ///是否同一天
  bool isSameYear(DateTime date) {
    return year == date.year;
  }

  ///是否同一月
  bool isSameMonth(DateTime date) {
    return year == date.year && month == date.month;
  }

  ///是否同一天
  bool isSameDay(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  ///当前时间离timestamp已超过N小时
  bool isAfterHour(int timestamp, [int hour = 1]) {
    // 60 * 60 * 1000
    return millisecondsSinceEpoch - timestamp < (hour * 60 * 60 * 1000);
  }

  ///当前时间已过去4小时
  bool isAfter4Hour(int timestamp) {
    return millisecondsSinceEpoch - timestamp < (4 * 60 * 60 * 1000);
  }

  ///当前时间离timestamp已超过24小时
  bool isAfter24Hour(int timestamp) {
    return millisecondsSinceEpoch - timestamp < 24 * 60 * 60 * 1000;
  }

  ///是否是未来的某一天
  bool isInFutureDay(int day) {
    int sec = (DateTime.now().millisecond - millisecond) ~/ 1000;
    return sec - day * 24 * 3600 <= 0;
  }

  ///当前时间是否比传进来的时间大
  bool isAfterThanDay(DateTime dateTime) {
    if (isSameDay(dateTime)) {
      return false;
    }

    if (year < dateTime.year) {
      return false;
    }

    if (year > dateTime.year) {
      return true;
    }

    if (month < dateTime.month) {
      return false;
    }

    if (month > dateTime.month) {
      return true;
    }
    return day > dateTime.day;
  }

  ///当前时间是否比传进来的时间小
  bool isBeforeThanDay(DateTime dateTime) {
    return startOfDay.compareTo(dateTime.startOfDay) < 0;
  }

  ///当月天数
  int get daysInMonth {
    return DateTime(year, month + 1, 0).day;
  }

  ///当天开始时间
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  ///当天结束时间
  DateTime get endOfDay {
    return DateTime(year, month, day + 1).subtract(const Duration(milliseconds: 1));
  }

  ///当月开始时间
  DateTime get startOfMonth {
    return DateTime(year, month, 1);
  }

  ///当月结束时间
  DateTime get endOfMonth {
    return DateTime(year, month + 1, 0).endOfDay;
  }

  ///当年开始时间
  DateTime get startOfYear {
    return DateTime(year, 1, 1);
  }

  ///当年结束时间
  DateTime get endOfYear {
    return DateTime(year + 1, 1, 1).subtract(const Duration(days: 1)).endOfDay;
  }

  ///当周开始时间
  DateTime get startOfWeek {
    return subtract(Duration(days: weekday - 1)).startOfDay;
  }

  ///当周结束时间
  DateTime get endOfWeek {
    return startOfWeek.add(const Duration(days: 6)).endOfDay;
  }

  ///根据周开始日获取当周的开始时间
  DateTime getStartOfWeek([int weekStart = DateTime.sunday]) {
    return subtract(Duration(days: (weekday - weekStart + 7) % 7)).startOfDay;
  }

  ///根据周开始日获取当周的结束时间
  DateTime getEndOfWeek([int weekStart = DateTime.sunday]) {
    return getStartOfWeek(weekStart).add(const Duration(days: 6)).endOfDay;
  }

  ///根据年月日时间yyyy-MM-dd转成DateTime格式的时间
  static DateTime? dateTimeWithString(String dateStr) {
    List<String> dateItems = dateStr.split("-").toList();
    if (dateItems.length != 3) {
      throw Exception("请传入yyyy-MM-dd 格式的日期");
      return null;
    }

    int year = int.parse(dateItems.first);
    int month = int.parse(dateItems[1]);
    int day = int.parse(dateItems.last);
    DateTime dateTime = DateTime(year, month, day);
    return dateTime;
  }

  ///根据年月日时间yyyy-MM-dd hh:mm:ss 转成DateTime格式的时间
  static DateTime dateTimeYYYYMMDDHHMMSSWithString(String dateStr) {
    List<String> dateItems = dateStr.split(" ").toList();
    if (dateItems.length != 2) {
      //debugPrint("请传入yyyy-MM-dd hh:mm:ss 格式的日期");
      return DateTime.now();
    }

    String ymdStr = dateItems.first;
    List<String> ymdList = ymdStr.split("-").toList();
    int year = int.parse(ymdList.first);
    int month = int.parse(ymdList[1]);
    int day = int.parse(ymdList.last);

    String hmsStr = dateItems.last;
    List<String> hmsList = hmsStr.split(":").toList();
    int hour = int.parse(hmsList.first);
    int minute = int.parse(hmsList[1]);
    int second = int.parse(hmsList.last);

    DateTime dateTime = DateTime(year, month, day, hour, minute, second);
    return dateTime;
  }

  /// 根据周开始日获取当年的第几周
  String getWeekNumberByWeekStart(int weekStart) {
    DateTime firstDay = DateTime(year, 1, 1);
    int daysDiff = difference(firstDay).inDays;
    int weekOfYear = ((daysDiff + firstDay.weekday - weekStart + 7) / 7).floor();
    if (weekOfYear == 0) {
      DateTime lastDay = firstDay.add(const Duration(days: -1));
      firstDay = DateTime(year - 1, 1, 1);
      daysDiff = lastDay.difference(firstDay).inDays;
      weekOfYear = ((daysDiff + firstDay.weekday - weekStart + 7) / 7).floor();
    }
    return '${firstDay.year}-${weekOfYear.toString().padLeft(2, '0')}';
  }

  /// 返回今天的几月前
  DateTime fromMonth(int month) {
    return DateTime(year, month, day);
  }

  /// 返回今天的几年前
  DateTime fromYear(int year) {
    return DateTime(year, month, day);
  }

  /// 返回当月的某天
  DateTime fromDay(int day) {
    return DateTime(year, month, day);
  }

  /// 返回当天的某个时间
  DateTime fromHourMinute(int hour, int minute) {
    return DateTime(year, month, day, hour, minute);
  }
}