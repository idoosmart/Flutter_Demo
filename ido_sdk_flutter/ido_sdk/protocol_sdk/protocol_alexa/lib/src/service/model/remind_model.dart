
class AlexaReminderModel{
  /**
   *  提醒内容
   */
  String? label;
  /**
   *  提醒时间 UTC
   */
  int? timestamp;
  /**
   *  时间戳
   */
  String? scheduledTime;
  /**
   *  token
   */
  String? token;
}

class VoiceReminderItemModel{
  /**
      开关 | Switch
   */
  bool? isOpen;
  bool? isShow;
  int? year;
  int? month;
  int? day;
  int? hour;
  int? minute;
  int? second;
  /**
   * 提醒ID  设置范围1-10
   * remind ID   Set the range to 1-10
   */
  int? remindId;
  /**
   * 提醒消息 支持128字节
   * reminder message support 128 byte
   */
  String? reminderStr;
}