import 'dart:ui';

class VoiceAlarmModel{
  //170不显示(删除) 85显示
  int? status;
  int? year;
  int? month;
  int? day;
  int? hour;
  int? minute;
  int? alarmId;
  int? repeat;

  VoiceAlarmModel({
    this.status,
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.alarmId,
    this.repeat,
  });

  factory VoiceAlarmModel.fromJson(Map<String, dynamic> json) => VoiceAlarmModel(
    status: json["status"],
    year: json["year"],
    month: json["month"],
    day: json["day"],
    hour: json["hour"],
    minute: json["minute"],
    alarmId: json["alarm_id"],
    repeat: json["repeat"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "year": year,
    "month": month,
    "day": day,
    "hour": hour,
    "minute": minute,
    "alarm_id": alarmId,
    "repeat": repeat,
  };
}

class AlexaAlarmModel{
  int? alarmId;
  String? token;
}