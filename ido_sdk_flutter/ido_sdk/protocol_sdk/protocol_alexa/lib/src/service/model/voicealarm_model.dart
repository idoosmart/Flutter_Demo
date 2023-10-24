import 'package:json_annotation/json_annotation.dart';

part 'voicealarm_model.g.dart';

@JsonSerializable()
class VoiceAlarmModel {
   int? status;
   int? year;
   int? month;
   int? day;
   int? hour;
   int? minute;
   @JsonKey(name: 'alarm_id')
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

  factory VoiceAlarmModel.fromJson(Map<String, dynamic> json) =>
      _$VoiceAlarmModelFromJson(json);

  Map<String, dynamic> toJson() => _$VoiceAlarmModelToJson(this);
}

@JsonSerializable()
class AlexaAlarmModel {
   int? alarmId;
   String? token;

   AlexaAlarmModel({
    this.alarmId,
    this.token,
  });

  factory AlexaAlarmModel.fromJson(Map<String, dynamic> json) =>
      _$AlexaAlarmModelFromJson(json);

  Map<String, dynamic> toJson() => _$AlexaAlarmModelToJson(this);
}