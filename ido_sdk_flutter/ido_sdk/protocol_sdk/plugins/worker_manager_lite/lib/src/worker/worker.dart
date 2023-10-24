import 'dart:async';
import 'package:flutter/cupertino.dart';

import '../scheduling/task.dart';

abstract class Worker {
  int? get runnableNumber;

  int? get evtType;

  Future<O> work<A, B, C, D, O, T>(Task<A, B, C, D, O, T> task);

  void kill();

  factory Worker() => _Worker();
}

class _Worker implements Worker {
  late Completer<Object?> _result;
  Function? _onUpdateProgress;
  int? _runnableNumber;
  Task? _task;

  @override
  int? get runnableNumber => _runnableNumber;

  void _cleanOnNewMessage() {
    _runnableNumber = null;
    _onUpdateProgress = null;
  }

  // dart --enable-experiment=variance
  // need invariant support to apply onUpdateProgress generic type
  // inout T
  @override
  Future<O> work<A, B, C, D, O, T>(Task<A, B, C, D, O, T> task) async {
    _task = task;
    _runnableNumber = task.number;
    _onUpdateProgress = task.onUpdateProgress;
    _result = Completer<Object?>();
    try {
      final result = await task.runnable();
      if (!_result.isCompleted) {
        _result.complete(result);
      }else{
        debugPrint('存在Completer调度异常 worker.dart 44行');
      }
      _cleanOnNewMessage();
    } catch (error) {
      if (!_result.isCompleted) {
        _result.completeError(error);
      }else{
        debugPrint('存在Completer调度异常 worker.dart 51行');
      }
    }

    final resultValue = await (_result.future as Future<O>);
    return resultValue;
  }

  @override
  void kill() {
    if (_task != null && !_task!.runnable.streamController.isClosed) {
      _task!.runnable.streamController.sink.add('kill');
      _task!.runnable.streamController.close();
    }
    _cleanOnNewMessage();
  }

  @override
  int? get evtType => _task?.runnable.arg2;

}
