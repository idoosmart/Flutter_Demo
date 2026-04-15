import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class FuncTableDelegate {

  /// 功能表变更通知
  void listenFuncTableChanged(String funcTableJson);

  /// 绑定时获取的功能表通知(绑定专用)
  void listenFuncTableOnBind(String funcTableJson);
}

@FlutterApi()
abstract class FuncTable {
  /// 加载指定设备功能表 返回json
  @async
  String loadFuncTableByDisk(String macAddress);

  /// 导出功能表 返回json文件绝对路径
  @async
  String exportFuncTableFile(String macAddress);
}
