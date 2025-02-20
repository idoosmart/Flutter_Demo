import 'dart:async';
import 'dart:isolate';

class AppLogIsolate {
  final SendPort sendPort;

  AppLogIsolate({required this.sendPort});

  Future<O> execute<A, O>({A? args, Fun1<A, O>? fun1}) {
    final task = _Task<A, O>(runnable: _Runnable<A, O>(args: args, fun1: fun1));
    Future<O> executing() async {
      ReceivePort receivePort = ReceivePort();
      task.runnable.typeSendPort = _TypeSendPort(receivePort.sendPort);
      sendPort.send(task);
      return receivePort.first as Future<O>;
    }

    return executing();
  }
}

/// 创建isolate
Future<AppLogIsolate> createIsolate() async {
  var ourFirstReceivePort = ReceivePort();
  await Isolate.spawn(_isolate, [ourFirstReceivePort.sendPort]);
  var sendPort = (await ourFirstReceivePort.first) as SendPort;
  return AppLogIsolate(sendPort: sendPort);
}

/// 独立的isolate
Future _isolate(List<dynamic> args) async {
  var ourReceivePort = ReceivePort();
  final sendPort = args[0] as SendPort;
  sendPort.send(ourReceivePort.sendPort);
  await for (var msg in ourReceivePort) {
    unawaited(() async {
      if (msg is _Task) {
        _Task task = msg;
        var result = await task.runnable.call();
        task.runnable.typeSendPort.send(result);
      }
    }());
  }
}

class _Task<A, O> {
  final _Runnable<A, O> runnable;

  _Task({required this.runnable});
}

typedef Fun1<A, O> = FutureOr<O> Function(A arg1);

class _Runnable<A, O> {
  final A? args;
  final Fun1<A, O>? fun1;
  late _TypeSendPort<O> typeSendPort;

  _Runnable({this.args, this.fun1});

  FutureOr<O> call() {
    final args = this.args;
    final fun1 = this.fun1;
    if (args != null && fun1 != null) {
      return fun1(args);
    }
    throw ArgumentError("execute method arguments of function miss match");
  }
}

class _TypeSendPort<T> {
  final SendPort? sendPort;

  void send(T value) => sendPort?.send(value);

  _TypeSendPort(this.sendPort);
}
