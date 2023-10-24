part of '../timer.dart';

class _AlexaTimer implements AlexaTimer {

  late List _timerArr = AlexaClient().createTimerArr();

  void addTimer({required Map func}) {
    String token = func["token"];
    String scheduledTime = func["scheduledTime"];

    logger?.v('添加秒表 -- addTimer = ${scheduledTime}');

    if(token!= null && token == AlexaClient().lastTimerToken){
      return;
    }
    AlexaClient().lastTimerToken = token;

    int time = getLocalDateFormateUTCDate(scheduledTime: scheduledTime);
    var timer ;
    for(AlexaTimerModel obj in  _timerArr){
      /**<  过滤相同timer */
      if(obj.token == token)return;
      /**<  清除过期timer */
      int outDateTime = getLocalDateFormateUTCDate(scheduledTime: obj.scheduledTime);
      if(outDateTime==0)obj.isOpen = false;
      if(obj.isOpen==false){
        timer = obj;
      }
    }

    if(timer == null){
      timer =  _timerArr.first;
    }

    if(timer != null){
      timer?.token = token;
      timer.scheduledTime = scheduledTime;
      timer.delayTime = time;
      timer.isOpen = true;
    }

    logger?.v('添加秒表 -- send setControllAlexaStopwatch time = ${time},timeIndex = ${timer.index}');

    //缺少， 有三个秒表
    libManager
        .send(
        evt: CmdEvtType.setControllAlexaStopwatch,
        json:
        '{"delay_time":${time}, "index":${timer.index}, "operate_timer_flag":0}')
        .listen((event) {
      logger?.v('添加秒表 -- setControllAlexaStopwatch = ${event.toString()}');
    });
  }

  void deleteTimer({required List tokens}) {
    if(tokens == null || tokens.length == 0){
      return;
    }

    //缺少， 有三个秒表
    libManager
        .send(
        evt: CmdEvtType.setControllAlexaStopwatch,
        json:
        '{"delay_time":0, "index":0, "operate_timer_flag":2}')
        .listen((event) {
      logger?.v('删除秒表 -- setControllAlexaStopwatch = ${event.toString()}');
      for(AlexaTimerModel obj in  _timerArr){
        obj.isOpen = false;
      }

    });

  }
  int getLocalDateFormateUTCDate({ String? scheduledTime}) {
    if(scheduledTime == null)return 0;
    DateTime lastDateTime = DateTime.parse(scheduledTime);
    DateTime nowDateTime = DateTime.now().toUtc();
    int difference = lastDateTime.difference(nowDateTime).inSeconds;
    if(difference<0)difference= 0;
    return difference;
  }
}