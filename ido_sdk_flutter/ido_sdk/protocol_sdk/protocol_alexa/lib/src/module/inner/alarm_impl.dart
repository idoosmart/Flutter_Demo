part of '../alarm.dart';

class _AlexaVoiceAlarm implements AlexaVoiceAlarm {

  /**<  添加闹钟 */
  void makeAlarmDateFormateUTCDate({required Map func}) async {
    List? alexaAlarmList = await _queryAlexaAlarm();
    if(alexaAlarmList == null || alexaAlarmList.isEmpty){
      libManager.send(
          evt: CmdEvtType.setVoiceReplyTxtV3,
          json:
          '{"version":2,"flag_is_continue":0,"title":"","text_content":"0"}')
          .listen((event) {
        logger?.v('闹钟不支持alexa -- setVoiceReplyTxtV3 = ${event.toString()}');
      });
      return;
    }

    String token = func["token"];
    String scheduledTime = func["scheduledTime"];

    var alermmodel ;
    for(AlexaAlarmModel obj in  AlexaClient().alarmArr){
      /**<  过滤相同timer */
      if(obj.token == token){
        alermmodel = obj;
        return;
      }
    }

    DateTime now = DateTime.parse(scheduledTime).toLocal();
    List alarms = alexaAlarmList.map((e) => VoiceAlarmModel.fromJson(e)).toList();
    VoiceAlarmModel item = VoiceAlarmModel();
    item.year = now.year;
    item.month = now.month;
    item.day = now.day;
    item.hour = now.hour;
    item.minute = now.minute;
    item.status = 85;
    item.repeat = repeatToOperation([1,0,0,0,0,0,0,0]);
    item.alarmId = 0;
    /**< 找到要设置闹钟的ID */
    for(int i = 0; i < alarms.length; i++){
      VoiceAlarmModel infoModel = alarms[i];
      /**< 相同的闹钟不设置 */
      if (infoModel.year == item.year && infoModel.month == item.month && infoModel.day == item.day && infoModel.hour == item.hour && infoModel.minute == item.minute) {
        break;
      }
      /**< 过滤过期闹钟 */
      if(isOverdueAlarm(infoModel: infoModel) && infoModel.alarmId != null){
        infoModel.status = 170;
      }
      /**< 插入到数组 alarmId = 0是无效闹钟 */
      if (infoModel.alarmId == 0 || infoModel.alarmId == null) {
        item.alarmId = i+1;
        alarms.removeAt(i);
        alarms.insert(i, item);
        break;
      }else if(infoModel.status == 170){
        item.alarmId = infoModel.alarmId;
        alarms.removeAt(i);
        alarms.insert(i, item);
        break;
      }
    }

    /**< 插入成功 */
    if (item.alarmId != null && item.alarmId! > 0) {
      /**< 本地保存 */
      for (AlexaAlarmModel alarm in AlexaClient().alarmArr) {
        if (alarm.alarmId == item.alarmId) {
          alarm.token = token;
        }
      }

      List alarmModelList = [];
      for(int i = 0; i < alarms.length; i++){
        VoiceAlarmModel infoModel = alarms[i];
        Map voiceAlarmModelMap = {
          "alarm_id":infoModel.alarmId,
          "status":infoModel.status,
          "year":infoModel.year,
          "month":infoModel.month,
          "day":infoModel.day,
          "hour":infoModel.hour,
          "minute":infoModel.minute,
          "repeat":infoModel.repeat
        };
        alarmModelList.add(voiceAlarmModelMap);
      }

      Map alarmModel = {"version":2,"item":alarmModelList};
      final result = await libManager
          .send(
          evt: CmdEvtType.setAlexaAlarmV3,
          json: jsonEncode(alarmModel))
          .first;
      logger?.v('添加闹钟 -- setAlexaAlarmV3 = ${result.code}');
    }
  }

  /**< 删除闹钟 */
  void deleteAlarmWihtTokens({required List tokens}) async {
    /**< 查询删除哪些闹钟 */
    List deleteAlarms = [];
    for (String token in tokens) {
      for (AlexaAlarmModel alarm in AlexaClient().alarmArr) {
        if (alarm.token == token) {
          deleteAlarms.add(alarm.alarmId);
        }
      }
    }

    if (deleteAlarms.length > 0) {
      /**< 删除闹钟 */
      Map alarmModel = {"version":2};

      List alexaAlarmList = await _queryAlexaAlarm()??[];
      List alarms = alexaAlarmList.map((e) => VoiceAlarmModel.fromJson(e)).toList();
      for(int i = 0; i < alexaAlarmList.length; i++){
        VoiceAlarmModel item = alarms[i];
        if (deleteAlarms.contains(item.alarmId)) {
          item.status = 170;
        }

        Map voiceAlarmModelMap = {
          "alarm_id":item.alarmId,
          "status":item.status,
          "year":item.year,
          "month":item.month,
          "day":item.day,
          "hour":item.hour,
          "minute":item.minute,
          "repeat":item.repeat
        };
        alarmModel.addAll(voiceAlarmModelMap);
      }

      libManager
          .send(
          evt: CmdEvtType.setAlexaAlarmV3,
          json: jsonEncode(alarmModel))
          .listen((event) {
        logger?.v('删除闹钟 -- setAlexaAlarmV3 = ${event.toString()}');
      });
  }
  }

  Future<List?> _queryV3Alarm() async {
    final value = await libManager
        .send(evt: CmdEvtType.getAlarmV3, json: jsonEncode({'flag': 0}))
        .first;
    if (value.code == 0 && value.json != null) {
      final a = jsonDecode(value.json!);
      final alarmList = a['item'] as List;
      final result = alarmList.where((e) => e['status'] == 0x55).toList();
      return result;
    }
    return null;
  }

  Future<List?> _queryAlexaAlarm() async {
    final value = await libManager
        .send(evt: CmdEvtType.getAlexaAlarmV3, json: jsonEncode({'flag': 0}))
        .first;
    if (value.code == 0 && value.json != null) {
      final a = jsonDecode(value.json!);
      final alarmList = a['item'] as List;
      return alarmList;
    }
    return null;
  }

  bool isOverdueAlarm({required VoiceAlarmModel infoModel}) {
    DateTime lastDateTime = DateTime(infoModel.year!,infoModel.month!,infoModel.day!, infoModel.hour!, infoModel.minute!,);
    DateTime nowDateTime = DateTime.now();
    int difference = lastDateTime.difference(nowDateTime).inSeconds;
    if(difference<0)return true;
    return false;
  }

  int repeatToOperation(List<int> repeat){
    int b = 0;
    for(int i = 0 ; i < repeat.length ; i ++ ){
      int c = repeat[i];
      c = c << i;
      b = b + c;
    }
    return b;
  }

  List<int> operationToRepeat(int operation){
    List<int> repeat = [];
    for(int i = 0 ; i < 8 ;i ++){
      final a = operation >> i;
      final b = a & 1;
      repeat.add(b);
    }
    return repeat.toList();
  }
}