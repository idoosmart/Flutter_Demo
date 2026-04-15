import 'package:pigeon/pigeon.dart';

@FlutterApi()
abstract class Cmd {
  /// 基础指令调用
  ///
  /// priority 优先级 null / 0: low， 1: normal， 2: high，3： veryHigh
  @async
  Response send(int evtType, String? json, CancelToken? cancelToken, int? priority);

  /// 根据token标识在字典中匹配实现
  void cancelSend(CancelToken cancelToken);
}

class CancelToken {
  String? token;
}

class Response {
  int? code;
  String? json;
}