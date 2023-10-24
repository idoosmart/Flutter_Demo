part of '../reminder.dart';

class _AlexaReminder implements AlexaReminder {
  void addReminder({required Map func}) {
    String label = func["label"];
    String scheduledTime = func["scheduledTime"];
    String token = func["token"];
    /**< 删除过期REMINDER */
    deleteOverdueReminder();
    AlexaReminderModel reminder = AlexaReminderModel();
    reminder.label = label;
    reminder.scheduledTime = scheduledTime;
    reminder.token = token;

    DateTime utcDateTime = DateTime.parse(scheduledTime);
    DateTime localDateTime = utcDateTime.toLocal();
    int curTimestamp = localDateTime.millisecondsSinceEpoch;
    reminder.timestamp = curTimestamp;

    AlexaClient().reminderArr.insert(0, reminder);
    /**< 设置REMINDER */
    setReminder();
  }


  /**< 设置REMINDER 最多5个 */
  void setReminder() {
    List allReminders = AlexaClient().reminderArr;
    List voiceReminders = [];


    List remindersItem = [];

    for (int i = 0; i < 5; i++) {
      VoiceReminderItemModel model = VoiceReminderItemModel();
      model.remindId = i + 1;
      /**< 取本地数据赋值到model 如果没有就初始化一个 */
      if (allReminders.length >= i + 1) {
        AlexaReminderModel item = allReminders[i];
        model.isOpen = true;
        DateTime datetime =
            DateTime.fromMillisecondsSinceEpoch(item.timestamp!);

        model.year = datetime.year;
        model.month = datetime.month;
        model.day = datetime.day;
        model.minute = datetime.minute;
        model.hour = datetime.hour;
        model.second = datetime.second;
        model.reminderStr =
            subStringByByteAtIndex(index: 128, content: item.label!);
      } else {
        model.isOpen = false;
      }

      int status = 0x55;
      if(model.isOpen==false)status = 0xaa;
      if(model.reminderStr == null)model.reminderStr="";
      Map voiceReminderModelMap = {
        "reminder_id":model.remindId,
        "status":status,
        "year":model.year,
        "month":model.month,
        "day":model.day,
        "hour":model.hour,
        "minute":model.minute,
        "sec":model.second,
        "reminder_string":model.reminderStr,
      };
      remindersItem.add(voiceReminderModelMap);
    }

    Map remindersModel = {"version":1,"item":remindersItem};

    libManager
        .send(
        evt: CmdEvtType.setVoiceAlarmReminderV3,
        json: jsonEncode(remindersModel))
        .listen((event) {
      logger?.v('添加提醒 -- setVoiceAlarmReminderV3 = ${event.toString()} remindersModel = ${remindersModel.toString()}');
    });

  }

  /**< 下行流删除REMINDER */
  void deleteDirectivesReminderWihtTokens({required List tokens}) {
    /**< 删除过期REMINDER */
    deleteOverdueReminder();

    /**< 根据token删除 */
    List arr = AlexaClient().reminderArr;
    List deleteArr = [];

    for (String token in tokens) {
      for (int i = 0; i < arr.length; i++) {
        AlexaReminderModel reminder = arr[i];
        if (reminder.token == token) {
          deleteArr.add(reminder);
        }
      }
    }

    if (deleteArr.length > 0) {
      AlexaClient().reminderArr.remove(deleteArr);
      /**< 设置REMINDER */
      setReminder();
    }
  }

  /**< 删除过期REMINDER */
  void deleteOverdueReminder() {
    int curTimestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
    if (AlexaClient().reminderArr.length > 0){
      AlexaClient().reminderArr.removeWhere((element) => element.timestamp! <= curTimestamp);
    }
  }

  String subStringByByteAtIndex({required int index, required String content}) {
    if (content.length <= index) {
      return content;
    }

    int numOfBytes = 0;
    List<int> codeUnits = content.codeUnits;

    for (int i = 0; i < codeUnits.length; i++) {
      String character = String.fromCharCodes([codeUnits[i]]);
      List<int> bytes = utf8.encode(character);
      numOfBytes += bytes.length;

      if (numOfBytes > index) {
        return content.substring(0, i);
      }
    }

    return content;

  }
  int convertToInt({required String strtemp}) {
    if(strtemp.isEmpty)return 0;
    return utf8.encode(strtemp).length;
  }
}
