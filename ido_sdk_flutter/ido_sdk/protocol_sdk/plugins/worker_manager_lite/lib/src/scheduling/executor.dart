part of '../../worker_manager_lite.dart';

abstract class Executor {
  factory Executor() => _Executor();

  Cancelable<O> execute<A, B, C, D, O, T>({
    A arg1,
    B arg2,
    C arg3,
    D arg4,
    Fun0<O, T> fun0,
    Fun1<A, O, T> fun1,
    Fun2<A, B, O, T> fun2,
    Fun3<A, B, C, O, T> fun3,
    Fun4<A, B, C, D, O, T> fun4,
    WorkPriority priority = WorkPriority.high,
    Duration? interval,
    void Function(T value)? notification,
    O Function([bool? stop])? onDispose,
  });

  void pause();

  void resume();

  void dispose();

  bool get isPaused;

  static bool showLog = true;

  /// 查找指定任务数量
  int findTaskCount({required int evtBase, required int evtType, String? json});

  /// 获取当前队列的指令列表
  List<int> getQueueList();

  int? getCurrentWorkTask();
}

class _Executor implements Executor {
  final _queue = PriorityQueue<Task>();
  final _worker = Worker();
  final _pausedTaskBuffer = <int, Task>{};
  var _paused = false;
  var _taskNumber = pow(-2, 15);
  Duration? _interval;
  Task? _currentTask;

  @override
  bool get isPaused => _paused;

  @override
  Cancelable<O> execute<A, B, C, D, O, T>({
    A? arg1,
    B? arg2,
    C? arg3,
    D? arg4,
    Fun0<O, T>? fun0,
    Fun1<A, O, T>? fun1,
    Fun2<A, B, O, T>? fun2,
    Fun3<A, B, C, O, T>? fun3,
    Fun4<A, B, C, D, O, T>? fun4,
    WorkPriority priority = WorkPriority.high,
    Duration? interval,
    void Function(T value)? notification,
    O Function([bool? stop])? onDispose,
  }) {
    _interval = interval;
    final task = Task(
      _taskNumber.toInt(),
      runnable: Runnable<A, B, C, D, O, T>(
        arg1: arg1,
        arg2: arg2,
        arg3: arg3,
        arg4: arg4,
        fun0: fun0,
        fun1: fun1,
        fun2: fun2,
        fun3: fun3,
        fun4: fun4,
      ),
      workPriority: priority,
      onUpdateProgress: notification,
      onDispose: onDispose,
    );

    Cancelable<O> executing() {
      _logInfo('added task with number $_taskNumber hashCode:$hashCode');
      _taskNumber++;
      _queue.add(task);
      _printQueueInfo();
      final cancelable = Cancelable(
        task.resultCompleter,
        onCancel: () => _cancel(task),
        onPause: () => _pause(task),
        onResume: () => _resume(task),
      );
      _schedule();
      return cancelable;
    }

    return executing();
  }

  void _schedule() {
    if (_queue.isNotEmpty && !_paused) {
      if (_worker.runnableNumber == null) {
        final task = _queue.removeFirst();
        _currentTask = task;
        _logInfo('task number ${task.number} begins work');
        _printQueueInfo();
        _worker.work(task).then((result) {
          if (!task.resultCompleter.isCompleted) {
            task.resultCompleter.complete(result);
          }
          _currentTask = null;
        }).catchError((Object error) {
          _logInfo('task number ${task.number} ERROR: $error');
          _printQueueInfo();
          if (!task.resultCompleter.isCompleted) {
            task.resultCompleter.completeError(error);
          }
          _currentTask = null;
        }).whenComplete(() {
          _logInfo('task number ${task.number} ends work');
          _printQueueInfo();
          if (_interval != null) {
            Future.delayed(_interval!).then((value) => _schedule());
          } else {
            _schedule();
          }
        });
      }
    }
  }

  void _cancel(Task task) {
    if (!task.resultCompleter.isCompleted) {
      task.resultCompleter.completeError(CanceledError());
    }
    if (_pausedTaskBuffer[task.number] != null) {
      _logInfo('task with number ${task.number} removed from _pausedTaskBuffer');
      _pausedTaskBuffer.remove(task.number);
    }
    if (_queue.contains(task)) {
      _logInfo('task with number ${task.number} removed from queue');
      _queue.remove(task);
    } else {
      if (_worker.runnableNumber == task.number) {
        _logInfo('number ${_worker.runnableNumber} killed');
        _worker.kill();
        _schedule();
      }
    }
  }


  void _pause(Task task) {
    if (_worker.runnableNumber != task.number) {
      _logInfo("${task.number} pause");
      _pausedTaskBuffer[task.number] = task;
      _queue.remove(task);
    }
    _schedule();
  }

  void _resume(Task task) {
    if (_worker.runnableNumber != task.number) {
      final removedTask = _pausedTaskBuffer.remove(task.number);
      if (removedTask != null) {
        _queue.add(removedTask);
        _logInfo("${removedTask.number} resume");
      }
    }
    _schedule();
  }

  @override
  void pause() {
    _paused = true;
    _logInfo("queue paused");
  }

  @override
  void resume() {
    _paused = false;
    _schedule();
    _logInfo("queue resumed");
  }

  @override
  void dispose() {
    _paused = false;
    // 从队列移除的同时回调
    _queue.toList().forEach((task) {
      _logInfo('cancel task ${task.number}');
      if (!task.resultCompleter.isCompleted && task.onDispose != null) {
        task.resultCompleter.complete(task.onDispose!());
      }
    });
    _queue.clear();
    _worker.kill();
    _taskNumber = pow(-2, 15);

    // 执行中的task被kill发出响应
    if (_currentTask != null) {
      _logInfo('_currentTask response ${_currentTask!.number}');
      if (!_currentTask!.resultCompleter.isCompleted && _currentTask!.onDispose != null) {
        _currentTask!.resultCompleter.complete(_currentTask!.onDispose!(true));
      }
      _currentTask = null;
    }
    _logInfo('queue dispose');
  }

  @override
  int findTaskCount({required int evtBase, required int evtType, String? json}) {
    int count = 0;
    _queue.toList().forEach((task) {
      if (task.runnable.arg1 is int && task.runnable.arg2 is int && task.runnable.arg3 is String &&
          evtBase == task.runnable.arg1 && evtType == task.runnable.arg2 && json == task.runnable.arg3) {
        count++;
        _logInfo('find task ${task.number} evtType:$evtType json:$json');
      }
    });
    return count;
  }

  @override
  List<int> getQueueList() {
    return _queue.toList().map((e) => e.runnable.arg2 as int).toList();
  }

  @override
  int? getCurrentWorkTask() {
    return _worker.evtType;
  }

  void _logInfo(String info) {
    if (Executor.showLog) {
      print('--------- $info');
    }
  }

  void _printQueueInfo(){
    if (_queue.isNotEmpty) {
      _logInfo('queue wait list: ${_queue.toList().map((e) => e.number).toList()}');
    }else {
      _logInfo('queue wait list: []');
    }
  }

}
