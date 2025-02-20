import 'app_isolate.dart';

typedef IsolateFunctionHandler<DATA> = Future<dynamic> Function(
  Function(DATA) fun,
  DATA data,
);

class IsolateManager {
  IsolateManager._();

  static IsolateManager? _instance;

  static get instance => _instance ??= IsolateManager._();

  late AppLogIsolate _isolate;

  late IsolateFunctionHandler<dynamic>? handleFunctionInIsolate;

  /// 初始化
  Future init() async {
    _isolate = await createIsolate();
    handleFunctionInIsolate = (fun, data) async {
      return await _isolate.execute(args: data, fun1: (dynamic data) => fun(data));
    };
  }
}
