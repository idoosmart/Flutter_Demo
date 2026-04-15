
import 'package:pigeon/pigeon.dart';

@FlutterApi()
abstract class Cache {
  /// 获取log根路径
  @async
  String logPath();

  /// 获取alexa根路径
  @async
  String alexaPath();

  /// 获取alexa测试目录
  @async
  String alexaTestPath();

  /// 获取当前设备缓存根路径
  @async
  String currentDevicePath();

  /// 导出日志 返回压缩后日志zip文件绝对路径
  @async
  String exportLog();

  /// 加载指定设备绑定状态
  @async
  bool loadBindStatus(String macAddress);

  /// 获取最后连接的设备(json)
  @async
  String? lastConnectDevice();

  /// 获取连接过的设备列表(List[json])
  @async
  List<String>? loadDeviceExtListByDisk(bool sortDesc);
}