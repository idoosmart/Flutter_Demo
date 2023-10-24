part of '../alarm.dart';

class _AlexaVoiceAlarm implements AlexaVoiceAlarm {

  /**<  添加闹钟 */
  void makeAlarmDateFormateUTCDate({required Map func}) async {
    List? alexaAlarmList = await _queryAlexaAlarm();

    int alexaAlarmListCount = 0;
    if (alexaAlarmList != null){
      List Alarms = alexaAlarmList.map((e) => VoiceAlarmModel.fromJson(e)).toList();
      for(VoiceAlarmModel item in  Alarms) {
        if (item.status == 85){
          alexaAlarmListCount ++;
        }
      }
    }
    logger?.v('闹钟已经设置的个数 = ${alexaAlarmListCount}');

    if(alexaAlarmListCount >= 10){
      AlexaClient().isSmartHomeSkill = true;
      logger?.v('makeAlarmDateFormateUTCDate --> isSmartHomeSkill = true');
      String alarmCountStr = "Set up to ${alexaAlarmListCount} alarms";
      libManager.send(
          evt: CmdEvtType.setVoiceReplyTxtV3,
          json:
          '{"version":2,"flag_is_continue":0,"title":"","text_content":"${alarmCountStr}"}')
          .listen((event) {
        logger?.v('闹钟设置上限，不能超过10个 = ${event.toString()}');
      });
      return;
    }

    String token = func["token"];
    String scheduledTime = func["scheduledTime"];

    List? alexaAlarmCacheArr = await AlexaClient().createAlarmArr(true);

    if(alexaAlarmListCount > 0){//---
      for(AlexaAlarmModel obj in  alexaAlarmCacheArr){
        /**<  过滤相同timer */
        if(obj.token == token){
          logger?.v('闹钟alexa有相同的token ，不重复设置');
          return;
        }
      }
    }

    DateTime now = DateTime.parse(scheduledTime).toLocal();
    List? alarms = alexaAlarmList?.map((e) => VoiceAlarmModel.fromJson(e)).toList();
    VoiceAlarmModel item = VoiceAlarmModel();
    item.year = now.year;
    item.month = now.month;
    item.day = now.day;
    item.hour = now.hour;
    item.minute = now.minute;
    item.status = 85;
    item.repeat = repeatToOperation([1,0,0,0,0,0,0,0]);
    item.alarmId = 0;
    if ( alarms!= null){
      /**< 找到要设置闹钟的ID */
      for(int i = 0; i < alarms.length; i++){
        VoiceAlarmModel infoModel = alarms[i];
        /**< 相同的闹钟不设置 */
        if (infoModel.status == item.status && infoModel.year == item.year && infoModel.month == item.month && infoModel.day == item.day && infoModel.hour == item.hour && infoModel.minute == item.minute) {
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
    }

    /**< 插入成功 */
    if (item.alarmId != null && item.alarmId! > 0) {
      /**< 本地保存 */
      for (AlexaAlarmModel alarm in alexaAlarmCacheArr) {
        if (alarm.alarmId == item.alarmId) {
          alarm.token = token;
        }
      }
      //保存持久化数据
      storage?.saveAlarmDataToDisk(libManager.deviceInfo.macAddress,alexaAlarmCacheArr);

      List alarmModelList = [];
      if (alarms != null){
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
      }

      logger?.v('添加闹钟 -- setAlexaAlarmV3 --> ${alarmModelList.toString()}');

      Map alarmModel = {"version":2,"item":alarmModelList};
      libManager
          .send(
          evt: CmdEvtType.setAlexaAlarmV3,
          json: jsonEncode(alarmModel))
          .listen((event) {
            getAlarmDetail(token: token, alexaAlarmCacheArr: alexaAlarmCacheArr);
            logger?.v('添加闹钟 -- setAlexaAlarmV3 = ${event.code}');
      });
    }
  }

  /**< 获取闹钟详情 并设置重复 */
  void getAlarmDetail({required String token, List? alexaAlarmCacheArr})  {
    List<String> arr = token.split("#");

    final map = {
      "messageId": DataBox.kUUID
    };

    ServiceManager().getAlarms(accessToken: Auth().accessToken!, id: arr.last).then((value) async {
      if (value.isOK) {
        if (alexaAlarmCacheArr != null){
          /**< 找到要修改的闹钟 */
          for(AlexaAlarmModel model in  alexaAlarmCacheArr){
            /**<  过滤相同timer */
            if(model.token == token){
              List? alexaAlarmList = await _queryAlexaAlarm();
              if (alexaAlarmList != null){
                List Alarms = alexaAlarmList.map((e) => VoiceAlarmModel.fromJson(e)).toList();
                for(VoiceAlarmModel item in  Alarms) {
                  if (model.alarmId == item.alarmId) {
                    if (value.result != null){
                      final dic = jsonDecode(value.result as String);
                      if (dic is Map) {
                        final trigger = dic["trigger"];
                        if (trigger is Map) {
                          final recurrence = trigger["recurrence"];
                          if (recurrence is Map) {
                            final byDay = recurrence["byDay"];
                            final freq = recurrence["freq"];
                            List<int> repeat = operationToRepeat(item.repeat!) ;
                            if (freq == "DAILY"){
                              repeat = [1,1,1,1,1,1,1,1];//最高位是open开关状态
                            }else if (byDay is List){
                              /**< 获取重复 */
                              if (byDay.contains("MO")){
                                repeat[1] = 1;
                              }
                              if (byDay.contains("TU")){
                                repeat[2] = 1;
                              }
                              if (byDay.contains("WE")){
                                repeat[3] = 1;
                              }
                              if (byDay.contains("TH")){
                                repeat[4] = 1;
                              }
                              if (byDay.contains("FR")){
                                repeat[5] = 1;
                              }
                              if (byDay.contains("SA")){
                                repeat[6] = 1;
                              }
                              if (byDay.contains("SU")){
                                repeat[7] = 1;
                              }
                            }
                            item.repeat = repeatToOperation(repeat);
                            Map alarmModel = {"version":2,"item":Alarms};

                            libManager
                                .send(
                                evt: CmdEvtType.setAlexaAlarmV3,
                                json: jsonEncode(alarmModel))
                                .listen((event) {
                              logger?.v('添加闹钟 (重复日期) -- setAlexaAlarmV3 = ${jsonEncode(alarmModel)}, code = ${event.code}');

                            });

                          }
                        }
                      }
                    }
                  }
                }
              }

            }
          }
        }

      }
    });


  }

    /**< 删除闹钟 */
  void deleteAlarmWihtTokens({required List tokens}) async {
    /**< 查询删除哪些闹钟 */
    List deleteAlarms = [];
    List? alexaAlarmCacheArr = await AlexaClient().createAlarmArr(true);
    for (String token in tokens) {
      for (AlexaAlarmModel alarm in alexaAlarmCacheArr) {
        if (alarm.token == token) {
          alarm.token = null;
          deleteAlarms.add(alarm.alarmId);
        }
      }
    }

    //保存持久化数据
    storage?.saveAlarmDataToDisk(libManager.deviceInfo.macAddress,alexaAlarmCacheArr);

    if (deleteAlarms.length > 0) {
      /**< 删除闹钟 */
      Map alarmModel = {"version":2};

      List alexaAlarmList = await _queryAlexaAlarm()??[];
      List alarmItems = [];
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
        alarmItems.add(voiceAlarmModelMap);
      }

      alarmModel["item"] = alarmItems;
      logger?.v('删除闹钟 -- voicealarmModel = ${alarmModel.toString()}');

      libManager
          .send(
          evt: CmdEvtType.setAlexaAlarmV3,
          json: jsonEncode(alarmModel))
          .listen((event) {
        logger?.v('删除闹钟 -- setAlexaAlarmV3 --> alarmModel = ${alarmModel.toString()}, event = ${event.toString()}');
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
      final result = alarmList.where((e) => e['status'] == 1).toList();
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