import 'package:flutter/cupertino.dart';

abstract class NetLog {
  void v(String info, {String methodName = "", String className = ""});

  void d(String info, {String methodName = "", String className = ""});

  void e(String info, {String methodName = "", String className = ""});
}

class DefaultLog extends NetLog {
  @override
  void v(String info, {String methodName = "", String className = ""}) {
    debugPrint(info);
  }

  @override
  void d(String info, {String methodName = "", String className = ""}) {
    debugPrint(info);
  }

  @override
  void e(String info, {String methodName = "", String className = ""}) {
    debugPrint(info);
  }
}
