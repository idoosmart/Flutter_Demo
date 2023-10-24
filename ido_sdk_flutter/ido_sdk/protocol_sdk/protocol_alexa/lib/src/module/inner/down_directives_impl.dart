part of '../down_directives.dart';

class _DownDirectivesAnalysis implements DownDirectivesAnalysis {
  /**< 下行流技能分析 */
  void receiveDirectives({required DirectiveModel model}) {
    Map directive = typeInDirectivesWithData(model: model);
    if (directive != null) {
      voiceRecognitionWithType(func: directive);
    }
  }

  /**< 技能 -- 系统和自定义技能分析判断 */
  void voiceRecognitionWithType({required Map func}) {
    logger?.v('voiceRecognitionWithType = $func');
    final nameType = func["name"];
    if (nameType == "TurnOn" ||
        nameType == "TurnOff" ||
        nameType == "SetRangeValue" ||
        nameType == "AdjustRangeValue") {
      smartHomeSkills(func: func);
      return;
    }
    final type = func["type"];
    if (type == null) {
      return;
    }
    /**< 系统技能 */
    if (type == "TIMER") {
      /**< 秒表 */
      AlexaTimer().addTimer(func: func);
    } else if (type == "ALARM") {
      /**< 闹钟 */
      AlexaVoiceAlarm().makeAlarmDateFormateUTCDate(func: func);
    } else if (type == "DeleteAlerts" || type == "DeleteAlert") {
      List tokens = func["token"];
      if (tokens.first is String) {
        String tokenStr = tokens.first;
        if (tokenStr.contains("Alarm")) {
          /**< 取消闹钟 */
          AlexaVoiceAlarm().deleteAlarmWihtTokens(tokens: tokens);
        } else if (tokenStr.contains("Reminder")) {
          /**< 取消提醒 */
          AlexaReminder().deleteDirectivesReminderWihtTokens(tokens: tokens);
        } else if (tokenStr.contains("Notification")) {
          /**< 取消秒表 */
          AlexaTimer().deleteTimer(tokens: tokens);
        }
      }
    } else if (type == "REMINDER") {
      /**< 提醒 */
      AlexaReminder().addReminder(func: func);
    } else if (type == "ResetUserInactivity") {
      /**< 挤退 */
      /**< token失效 */
      /**< 发空语音包检查token是否有效 */
      //缺少403退出
      logger?.v('ResetUserInactivity 挤退');
      final reportMap = returnNullMap();
      ServiceManager().sendEventPart(
          accessToken: Auth().accessToken!,
          dataBody: reportMap.toData(),
          label: 'reportMap').then((value) {
            if (value.httpCode == 403){
              logger?.v('ResetUserInactivity 挤退 -- 403退出');
              AlexaClient().auth.logout();
            }
      });
    } else if (type == "SetIndicator") {
      /**< 设置通知 */
      IndicatorPoint().setIndicator();
    } else if (type == "ClearIndicator") {
      /**< 清除通知 */
      IndicatorPoint().clearIndicator();
    } else if (type == "StopCapture") {
      /**< 已识别指令 */
      // libManager
      //     .send(
      //     evt: CmdEvtType.setVoiceFileTranStop,
      //     json:
      //     '')
      //     .listen((event) {
      //   logger?.v('停止识别 -- setVoiceFileTranStop = ${event.toString()}');
      // });
      AlexaClient().voice.endUpload(func['dialogRequestId'] ?? '');
    }
  }

  /**< 自定义技能分析判断 */
  void smartHomeSkills({required Map func}) {
    //判断技能
    Map funcDic = searchSkillInJson(map: func);
    startCustomFuncSendToDevice(customFunc: funcDic);
  }

  /**< 发送技能数据到固件 */
  void startCustomFuncSendToDevice({required Map customFunc}) async {
    logger?.v('发送技能数据到固件 参数 ${customFunc.toString()}');

    String func = customFunc["func"] ?? '';
    String type = customFunc["type"] ?? '';
    String subType = customFunc["subType"] ?? '';
    bool is100Sport = customFunc["is100Sport"] ?? false;
    String instance = customFunc["instance"] ?? '';
    String turnState = customFunc["turnState"] ?? '';

    int typeInt = int.parse(type);

    if (func == '2') {
      /**< 计时器 */
      int time = typeInt;
      libManager
          .send(
              evt: CmdEvtType.setControllCountDown,
              json: '{"total_time":${time}}')
          .listen((event) {
        logger?.v('计时器 -- setControllCountDown = ${event.toString()}');
      });
    } else if (func == '4') {
      /**< 多运动 */

      if (is100Sport) {
        //100种自定义运动 （支持100种运动排序或者100种运动跳转，PS：id = 7553是沃尔s2项目，虽然不支持100种运动，但是需要实现相关功能）
        if(libManager.funTable.setSet100SportSort == false && libManager.deviceInfo.deviceId != 7553 && libManager.funTable.alexaGetUIControllSports == false){
          logger?.v('not support alexaControll100sports');
        }else{
          final map = {"sports_type":0x2a,
            "v2_sport_type":typeInt
          };
          final json = jsonEncode(map);
          AlexaClient().isSmartHomeSkill = true;
          logger?.v('isSmartHomeSkill = true');
          libManager
              .send(
              evt: CmdEvtType.setControllSports,
              json: json).listen((event) {
            logger?.v('多运动 -- setControllSports v2 = ${event.toString()}');
          });
        }
      } else {
        final map = {"sports_type":typeInt
        };
        final json = jsonEncode(map);
        AlexaClient().isSmartHomeSkill = true;
        logger?.v('isSmartHomeSkill = true');
        libManager
            .send(
                evt: CmdEvtType.setControllSports,
                json: json)
            .listen((event) {
          logger?.v('多运动 -- setControllSports = ${event.toString()}');
        });
      }
    } else if (func == '5') {
      /**< 多运动UI跳转 */
      if (instance == "Wakeup Gesture") {
        int turnOnState = 0; //0:抬腕亮屏开启 1:抬腕亮屏关闭
        if (turnState == "TurnOff") {
          turnOnState = 1;
        }
        libManager
            .send(
                evt: CmdEvtType.setVoiceControlUi,
                json: '{"ui_type":3, "operation_type":${turnOnState}, "cmd":0}')
            .listen((event) {
          logger?.v('抬腕亮屏 -- setVoiceControlUi = ${event.toString()}');
          libManager.send(
              evt: CmdEvtType.setVoiceReplyTxtV3,
              json:
                  '{"version":2,"flag_is_continue":0,"title":"","text_content":"OK"}');
        });
      } else {
        /**< 跳转UI */
        AlexaClient().isSmartHomeSkill = true;
        logger?.v('isSmartHomeSkill = true');
        libManager
            .send(
                evt: CmdEvtType.setControllUIJump, json: '{"type":${typeInt}}')
            .listen((event) {
          logger?.v('多运动UI跳转 -- setControllUIJump = ${event.toString()}');
        });
      }
    } else if (func == '6') {
      /**< 控制音乐 */
      int onOff = 1;

      libManager
          .send(
              evt: CmdEvtType.setMusicOnOff,
              json: '{"on_off":${onOff},"phone_type":${onOff}}')
          .listen((event) {
        logger?.v('setMusicOnOff = ${event.toString()}');

        //接口参数还没处理
        int MusicWithType = controlMusic(type: typeInt);
        libManager
            .send(
                evt: CmdEvtType.setControllAlexaMusic,
                json: '{"type":${MusicWithType}}')
            .listen((event) {
          logger?.v('控制音乐 -- setControllAlexaMusic = ${event.toString()}');
        });
      });
    } else if (func == '7') {
      /**< 勿扰 */
      final map = {"ui_type":2,
        "operation_type":typeInt,
        "cmd":0,
      };
      final json = jsonEncode(map);

      libManager
          .send(
              evt: CmdEvtType.setVoiceControlUi,
              json: json).listen((event) {
        logger?.v('勿扰 -- setVoiceControlUi = ${event.toString()}');
      });
    } else if (func == '8') {
      /**< 调节亮度 */
      int subTypeInt = 0;
      if (subType != null && subType != "null") {
        subTypeInt = (double.tryParse(subType) ?? 0.0).toInt();
      }
      final map = {"ui_type":1,
        "operation_type":typeInt,
        "cmd":subTypeInt,
      };
      final json = jsonEncode(map);

      libManager
          .send(
              evt: CmdEvtType.setVoiceControlUi,
              json: json).listen((event) {
        logger?.v('调节亮度 -- setVoiceControlUi = ${event.toString()}');
      });
    } else if (func == '9') {
      /**< 获取心率 bpm */
      if(typeInt>0 && AlexaClient().delegate?.getHrValue != null) {
        AlexaHRTimeType timeType = AlexaHRTimeType.today;
        if(typeInt ==1){
          timeType = AlexaHRTimeType.today;
        }else if(typeInt ==2){
          timeType = AlexaHRTimeType.week;
        }else if(typeInt ==3){
          timeType = AlexaHRTimeType.mouth;
        }else if(typeInt ==4){
          timeType = AlexaHRTimeType.year;
        }
        int? value = await AlexaClient()
            .delegate
            ?.getHrValue(AlexaHRDataType.avg, timeType);
        String hrValue = "${value} bpm";
        final map = {"version":2,
          "flag_is_continue":0,
          "title":"",
          "text_content":hrValue
        };
        final json = jsonEncode(map);

        libManager.send(
            evt: CmdEvtType.setVoiceReplyTxtV3,
            json: json).listen((event) {
          logger?.v('心率 -- setVoiceReplyTxtV3 = ${event.toString()}');
        });

      }
    } else if (func == 'TurnOff') {
      /**< 关闭界面 */
      int onOff = 0x55;
      final map = {"type":typeInt,
        "on_off":onOff,
      };
      final json = jsonEncode(map);
      libManager
          .send(
              evt: CmdEvtType.setControllAlexaOnOff,
              json: json).listen((event) {
        logger?.v('关闭界面 -- setControllAlexaOnOff = ${event.toString()}');
      });
    }
  }

  /**< 查找json文件里对应的技能 */
  Map<String, dynamic> searchSkillInJson({required Map map}) {
    final name = map["name"];
    String instance = map["instance"];
    var func;
    var type;
    String subType = "";
    String turnState = "";
    bool is100Sport = false;
    var toggleSkill;

    if (name == "TurnOn" || name == "TurnOff") {
      bool is100Sport1 = isToggleControllerSkill_sport(instance: instance);
      bool is100Sport2 = isToggleControllerSkill_sport2(instance: instance);

      if (is100Sport1) {
        ///**< 100 sport ToggleController */
        is100Sport = is100Sport1;
        toggleSkill =
            ToggleControllerSkillSport.getToggleControllerSkillSport();
      }else if (is100Sport2){
        is100Sport = is100Sport2;
        toggleSkill =
            ToggleControllerSkillSport2.getToggleControllerSkillSport2();
      } else {
        ///**< ToggleController */
        toggleSkill = ToggleControllerSkill.getToggleControllerSkill();
      }
      turnState = name;
    } else if (name == "SetRangeValue" || name == "AdjustRangeValue") {
      ///**< RangeControllerSkill */
      toggleSkill = RangeControllerSkill.getRangeControllerSkill();
    }

    /**< 查找json文件里对应的技能 */
    List toggleArr = toggleSkill["skill"];
    for (Map skill in toggleArr) {
      List capabilityArr = skill["capability"];
      func = skill["type"];
      for (Map capability in capabilityArr) {
        if (instance == capability["instance"]) {
          if (name == "TurnOff") {
            type = capability["stopcmd"];
            func = "TurnOff";
          } else {
            type = capability["sutype"];
          }
          break;
        }
      }
      if (type != null) {
        break;
      }
    }

    /**< 亮度 */
    if (instance == "brightness") {
      type = exchangeBrightnessSkill(map: map);
      subType = map["rangeValue"];
      final rangeValueDelta = double.tryParse(map["rangeValueDelta"]) ?? 0;
      if (subType == null &&
          (rangeValueDelta == 3 ||
              rangeValueDelta == 5 ||
              rangeValueDelta == 100)) {
        subType = "$rangeValueDelta";
      }
    }

    final funcDic = {
      "func": func,
      "type": type,
      "subType": subType,
      "is100Sport": (is100Sport),
      "instance": instance,
      "turnState": turnState
    };

    return funcDic;
  }

  /// 转换亮度技能
  String exchangeBrightnessSkill({required Map map}) {
    /**< 亮度增减 */
    final rangeValue = map["rangeValue"];
    if (rangeValue != null && rangeValue != "null") {
      if (libManager.funTable.setAlexaControll100brightness) {
        return "8";
      }
      return "4";
    }
    String rangeValueDeltaStr = map["rangeValueDelta"];
    final rangeValueDelta = (double.tryParse(rangeValueDeltaStr) ?? 0).toInt();
    if (rangeValueDelta == 1) {
      if (libManager.funTable.setAlexaControll100brightness) {
        return "6";
      }
      return "0";
    }
    if (rangeValueDelta == -1) {
      if (libManager.funTable.setAlexaControll100brightness) {
        return "7";
      }
      return "1";
    }

    return "";
  }

  /**< 是否100种运动 */
  bool isToggleControllerSkill_sport({required String instance}) {
    ///**< 100 sport ToggleController */
    final Map toggle100JsonResult =
        ToggleControllerSkillSport.getToggleControllerSkillSport();
    ;
    List toggle100SkillList = toggle100JsonResult["skill"];
    final skill = toggle100SkillList.first;
    List capability = skill["capability"];
    for (Map item in capability) {
      String itemInstance = item["instance"];
      if (instance == itemInstance) {
        return true;
      }
    }
    return false;
  }

  /**< 是否100种运动 */
  bool isToggleControllerSkill_sport2({required String instance}) {
    ///**< 100 sport ToggleController */
    final Map toggle100JsonResult =
    ToggleControllerSkillSport2.getToggleControllerSkillSport2();
    ;
    List toggle100SkillList = toggle100JsonResult["skill"];
    final skill = toggle100SkillList.first;
    List capability = skill["capability"];
    for (Map item in capability) {
      String itemInstance = item["instance"];
      if (instance == itemInstance) {
        return true;
      }
    }
    return false;
  }

  /**< 解析下行流语音文本数据, 组建Map数据，供下面方法使用 */
  Map<dynamic, dynamic> typeInDirectivesWithData(
      {required DirectiveModel model}) {
    //缺少，有可能为字符串Valid_Authorization

    if (model != null) {
      Header? header = model.header;
      Payload? payload = model.payload;
      String? name = header?.name;
      var detail;
      /**< 设置 */
      if (name == "SetAlert") {
        String? type = payload?.type;
        String? scheduledTime = payload?.scheduledTime;
        if (type != null && scheduledTime != null) {
          detail = payload?.toJson();
        }
      } /**< 删除 */
      else if (name == "DeleteAlerts" || name == "DeleteAlert") {

        if(payload?.token != null){
          var payloadtoken = payload?.token;
          if (payloadtoken is String){
            detail = {"type":name,"token":[payloadtoken]};
          }else if (payloadtoken is List){
            detail = {"type":name,"token":[payloadtoken?.first]};
          }
        }else if (payload?.tokens != null){
          var payloadtoken = payload?.tokens;
          if (payloadtoken is String){
            detail = {"type":name,"token":[payloadtoken]};
          }else if (payloadtoken is List){
            detail = {"type":name,"token":payloadtoken};
          }
        }
      }
      /**< 挤退 */
      else if (name == "ResetUserInactivity") {
        detail = {"type": name};
      }
      /**< 设置通知 */
      else if (name == "SetIndicator") {
        detail = {"type": name};
      }
      /**< 清除通知 */
      else if (name == "ClearIndicator") {
        detail = {"type": name};
      }
      /**< smart home */
      else if (name == "TurnOn" ||
          name == "TurnOff" ||
          name == "SetRangeValue" ||
          name == "AdjustRangeValue") {
        double? rangeValue = payload?.rangeValue;
        double? rangeValueDelta = payload?.rangeValueDelta;
        String rangeValueStr = "${rangeValue}";
        String rangeValueDeltaStr = "${rangeValueDelta}";

        if(rangeValueStr == null) rangeValueStr = "";
        if(rangeValueDeltaStr == null) rangeValueDeltaStr = "";

        detail = {
          "instance": header?.instance,
          "name": name,
          "rangeValue": rangeValueStr,
          "rangeValueDelta": rangeValueDeltaStr
        };
        AlexaClient().isSmartHomeSkill = true;
        logger?.v('isSmartHomeSkill = true');
        final reportMap = smartHomeReport(model: model);
        logger?.v('上报开关数据 -- smartHomeReport  = ${reportMap.toJsonString()}');
        ServiceManager().sendEventPart(
            accessToken: Auth().accessToken!,
            dataBody: reportMap.toData(),
            label: "smartHomeReport");
      } else if (name == "ReportState" && header?.correlationToken != null) {
        smartHomeReportState(model: model);
      }
      /**< 结束语音 */
      else if (name == "StopCapture") {
        detail = {"type": name, "dialogRequestId": header?.dialogRequestId};
      }
      return detail ?? {};
    }
    return {};
  }

  /**< smartHome 技能拼接上传 */
  Map<String, dynamic> smartHomeReport({required DirectiveModel model}) {
    Header? header = model.header;
    String? name = header?.name;
    String? instance = header?.instance;
    String? namespace = header?.namespace;
    if (instance == null) instance = "";

    String utcTimer = getTimeOfSample();

    var dic;
    Map context = {};
    if (name == "TurnOn" || name == "TurnOff") {
      String value = "ON";
      if (name == "TurnOff") {
        value = "OFF";
      }
      context = {
        "properties": [
          {
            "instance": instance,
            "name": "toggleState",
            "namespace": namespace,
            "timeOfSample": utcTimer,
            "uncertaintyInMilliseconds": 500,
            "value": value
          }
        ]
      };
    } else if (name == "SetRangeValue" || name == "AdjustRangeValue") {
      Payload? payload = model.payload;
      double? rangeValue = payload?.rangeValue;
      String rangeValueStr = "${rangeValue}";

      if (rangeValue == null) {
        rangeValueStr = "1";
      }
      context = {
        "properties": [
          {
            "instance": instance,
            "name": "rangeValue",
            "namespace": namespace,
            "timeOfSample": utcTimer,
            "uncertaintyInMilliseconds": 500,
            "value": rangeValueStr
          }
        ]
      };
    }
    dic = reportStateDicWithName(
        name: "Response", context: context, state: model);
    return dic;
  }

  /**< 上报状态 */
  void smartHomeReportState({required DirectiveModel model}) async {
    Header? header = model.header;
    Endpoint? endpoint = model.endpoint;
    String? endpointId = endpoint?.endpointId;
    String? instance = header?.instance;

    if (instance == null) {
      List? instanceArr = endpointId?.split(" -"); //不用空格键
      if (instanceArr != null && instanceArr.length >= 2) {
        instance = instanceArr.last;
      }
    }

    Map context;
    if (instance == null || instance == "Sport" || instance == "Sport2") {
      context = uploadAllToggleControllerState();
    } else {
      int value = await getHealthValue(instance: instance) as int;
      /**< 收到reportState后对rangeControllerSkill中type为5的技能打开响应的UI */
      rangeControllerSkillJumpUI(instance);
      setBPMWithValue(value as int, instance);

      String utcTimer = getTimeOfSample();

      if (instance == null) instance = "";

      context = {
        "properties": [
          {
            "instance": instance,
            "name": "rangeValue",
            "namespace": "Alexa.RangeController",
            "timeOfSample": utcTimer,
            "uncertaintyInMilliseconds": 500,
            "value": value
          }
        ]
      };
    }

    final dic = reportStateDicWithName(
        name: "StateReport", context: context, state: model);

    logger?.v('上报状态参数 -- reportStateDicWithName  = ${dic}');

    ServiceManager()
        .sendEventPart(
            accessToken: Auth().accessToken!,
            dataBody: dic.toData(),
            label: 'smartHomeReportState')
        .then((value) {
      logger?.v('上报状态 -- smartHomeReportState  = ${value}');
    });
  }

  String getTimeOfSample() {
    DateTime now = DateTime.now().toUtc();
    String utcTimer =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}Z";
    return utcTimer;
  }

  Future<int?> getHealthValue({String? instance}) async {
    int? value = 0;
    if (instance == "brightness") {
      final envent =
          await libManager.send(evt: CmdEvtType.getScreenBrightness, json: '').first;
      if (envent.code == 0 && envent.json != null) {
        Map json = jsonDecode(envent.json!);
        int levelValue =  json['level'];
        /**< 亮度等级转换 */
        int i = libManager.funTable.setScreenBrightness5Level ? 20 : 33;
        if(libManager.funTable.setAlexaControll100brightness){
          i = 1;
        }
        value = levelValue~/i;
      }

      return value;
    }

    if (AlexaClient().delegate?.getHealthValue == null) {
      return value;
    }

    if (instance == "Pedometer") {
      value = await AlexaClient()
          .delegate
          ?.getHealthValue(AlexaGetValueType.pedometer);
    } else if (instance == "Calorie Statistics Sensor") {
      value = await AlexaClient()
          .delegate
          ?.getHealthValue(AlexaGetValueType.calorie);
    } else if (instance == "Heart Rate Sensor") {
      value = await AlexaClient()
          .delegate
          ?.getHealthValue(AlexaGetValueType.heartRate);
    } else if (instance == "SpO2 Sensor") {
      value =
          await AlexaClient().delegate?.getHealthValue(AlexaGetValueType.spO2);
    } else if (instance == "Kilometer Statistics Sensor") {
      value = await AlexaClient()
          .delegate
          ?.getHealthValue(AlexaGetValueType.kilometer);
    } else if (instance == "Swimming Statistics Sensor") {
      value = await AlexaClient()
          .delegate
          ?.getHealthValue(AlexaGetValueType.swimmingDistance);
    } else if (instance == "Sleep Score Sensor") {
      value = await AlexaClient()
          .delegate
          ?.getHealthValue(AlexaGetValueType.sleepScore);
    } else if (instance == "Running Count Sensor") {
      value = await AlexaClient()
          .delegate
          ?.getHealthValue(AlexaGetValueType.runningCount);
    } else if (instance == "Swimming Count Sensor") {
      value = await AlexaClient()
          .delegate
          ?.getHealthValue(AlexaGetValueType.swimmingCount);
    } else if (instance == "Workout Count Sensor") {
      value = await AlexaClient()
          .delegate
          ?.getHealthValue(AlexaGetValueType.dayWorkoutCount);
    } else if (instance == "Health Data") {
      value = await AlexaClient()
          .delegate
          ?.getHealthValue(AlexaGetValueType.calorie);
    } else if (instance == "Workout History") {
      value = await AlexaClient()
          .delegate
          ?.getHealthValue(AlexaGetValueType.weekWorkoutCount);
    } else if (instance == "Body Battery" || instance == "Body Energy") {
      value = await AlexaClient()
          .delegate
          ?.getHealthValue(AlexaGetValueType.bodyBattery);
    }

    if (AlexaClient().delegate?.getHrValue == null) {
      return value;
    }

    /**< 心率做特殊处理 不取alexa返回文字 */
    AlexaClient().isSmartHomeSkill = true;
    logger?.v('isSmartHomeSkill = true');
    if (instance == "Weekly Heartrate Sensor") {
      value = await AlexaClient()
          .delegate
          ?.getHrValue(AlexaHRDataType.avg, AlexaHRTimeType.week);
    } else if (instance == "Monthly Heartrate Sensor") {
      value = await AlexaClient()
          .delegate
          ?.getHrValue(AlexaHRDataType.avg, AlexaHRTimeType.mouth);
    } else if (instance == "Yearly Heartrate Sensor") {
      value = await AlexaClient()
          .delegate
          ?.getHrValue(AlexaHRDataType.avg, AlexaHRTimeType.year);
    }

    return value;
  }

  /**< 收到reportState后对rangeControllerSkill中type为5的技能打开响应的UI */
  void rangeControllerSkillJumpUI(String? instance) {
    ///**< RangeControllerSkill */
    final Map rangeJsonResult = RangeControllerSkill.getRangeControllerSkill();
    final toggleArr = rangeJsonResult["skill"];
    String type = "";
    for (Map skill in toggleArr) {
      String func = skill["type"];
      if (func != "5") {
        continue;
      }
      List capabilityArr = skill["capability"];
      for (Map capability in capabilityArr) {
        if (instance == capability["instance"]) {
          type = capability["sutype"];
          break;
        }
      }
      if (type.isNotEmpty) {
        break;
      }
    }
    if (type.length > 0) {
      Map customFuncMap = {"func": "5", "type": type, "subType": ""};
      startCustomFuncSendToDevice(customFunc: customFuncMap);
    }
  }

  /**< 获取心率 bpm smarthome */
  void setBPMWithValue(int value, String? instance) {
    if (instance == "Weekly Heartrate Sensor" ||
        instance == "Monthly Heartrate Sensor" ||
        instance == "Yearly Heartrate Sensor") {
      String hrStr = "${value} bpm";

      libManager
          .send(
              evt: CmdEvtType.setVoiceReplyTxtV3,
              json:
                  '{"version":2,"flag_is_continue":0,"title":"","text_content":"${hrStr}"}')
          .listen((event) {
        logger?.v('心率 setBPMWithValue rs  = ${event.toString()}');
      });
    }
  }

  /**< 上传所有ToggleController的state */
  Map<String, dynamic> uploadAllToggleControllerState() {
    ///**< ToggleController */
    final Map toggleJsonResult =
        ToggleControllerSkill.getToggleControllerSkill();
    final toggleSkillList = toggleJsonResult["skill"];

    ///**< 100 sport ToggleController */
    final Map toggle100JsonResult =
        ToggleControllerSkillSport.getToggleControllerSkillSport();
    final toggle100SkillList = toggle100JsonResult["skill"];

    ///**< 100 sport2 ToggleController */
    final Map toggle100JsonResult2 =
    ToggleControllerSkillSport2.getToggleControllerSkillSport2();
    final toggle100SkillList2 = toggle100JsonResult2["skill"];

    List allSkills = [];
    allSkills.addAll(toggleSkillList);
    allSkills.addAll(toggle100SkillList);
    allSkills.addAll(toggle100SkillList2);

    String utcTimer = getTimeOfSample();
    List instances = [];
    for (Map capability in allSkills) {
      List capabilityArr = capability["capability"];
      for (Map item in capabilityArr) {
        String instance = item["instance"];
        if (instance == null) instance = "";
        Map propertie = {
          "instance": instance,
          "name": "toggleState",
          "namespace": "Alexa.ToggleController",
          "timeOfSample": utcTimer,
          "uncertaintyInMilliseconds": 500,
          "value": "OFF"
        };
        instances.add(propertie);
      }
    }
    final context = {"properties": instances};
    return context;
  }

  Map<String, dynamic> reportStateDicWithName(
      {required String name, Map? context, DirectiveModel? state}) {
    Header? header = state?.header;
    Endpoint? endpoint = state?.endpoint;
    String? endpointId = endpoint?.endpointId;
    String? correlationToken = header?.correlationToken;
    if (endpointId == null) endpointId = "";
    if (correlationToken == null) correlationToken = "";
    if (endpointId == null) endpointId = "";

    final dic = {
      "event": {
        "header": {
          "namespace": "Alexa",
          "name": name,
          "payloadVersion": "3",
          "messageId": DataBox.kUUID,
          "correlationToken": correlationToken
        },
        "endpoint": {"endpointId": endpointId},
        "payload": {}
      },
      "context": context
    };
    return dic;
  }

  Map<String, dynamic> returnNullMap() {
    return {};
  }

  int controlMusic({required int type}) {
    /**< * 1  => 上一曲  2  => 下一曲 3  => 增加音量  4  => 减少音量 5  => 播放音乐 6 =>暂停音乐 */
    int i = 1;
    switch (type) {
      case 1:
        {
          i = 5;
        }
        break;
      case 2:
        {
          i = 1;
        }
        break;
      case 3:
        {
          i = 2;
        }
        break;
      case 4:
        {
          i = 6;
        }
        break;
      case 5:
        {
          i = 6;
        }
        break;
      case 6:
        {
          i = 5;
        }
        break;
      case 7:
        {
          i = 3;
        }
        break;
      case 8:
        {
          i = 4;
        }
        break;

      default:
        break;
    }
    return i;
  }
}
