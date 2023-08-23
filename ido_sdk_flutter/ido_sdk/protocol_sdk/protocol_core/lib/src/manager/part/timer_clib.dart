part of '../manager_clib.dart';

/// 定时器，供c库使用
class _TimerHandle {
  Timer? _timer;
  late HandleAppTimerTimeoutEvt? _timeoutEvtFun;
  late int _timerId;

  _TimerHandle({required int timerId, HandleAppTimerTimeoutEvt? fn}) {
    _timerId = timerId;
    _timeoutEvtFun = fn;
  }

  /// 启动
  start({required int ms, int timeout = 10}) {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    if (ms <= 5) {
        ///小于5毫秒不再延时操作，初始化定时器，执行结束定时器，以达到最短时间延时效果
        ms = 0;
    }

    _timer = Timer(Duration(milliseconds: ms), () {
      stop();
      // 告知c库
      if (_timeoutEvtFun != null) {
        //logger?.d('timerId:$_timerId finished!~~ app_timer_timeout_evt:${_timeoutEvtFun!.hashCode}');
        _timeoutEvtFun!(_timerId);
      }else{
        //logger?.d('timerId:$_timerId finished!~~ app_timer_timeout_evt is null');
      }
    });
  }

  /// 停止定时器
  stop() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _timer = null;
    }
  }
}
