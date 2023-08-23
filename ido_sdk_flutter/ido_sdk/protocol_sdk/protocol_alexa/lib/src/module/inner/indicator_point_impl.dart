part of '../indicator_point.dart';

class _IndicatorPoint implements IndicatorPoint {

  @override
  setIndicator(){
   libManager.send(evt: CmdEvtType.setAlexaIndecator,json: '{"notify_flag":1}').listen((event) {
     logger?.v('设置通知 -- clearIndicator = ${event.toString()}');
   });

  }

  @override
  clearIndicator(){
    libManager.send(evt: CmdEvtType.setAlexaIndecator,json: '{"notify_flag":2}').listen((event) {
      logger?.v('清除通知 -- clearIndicator = ${event.toString()}');
    });

  }
}