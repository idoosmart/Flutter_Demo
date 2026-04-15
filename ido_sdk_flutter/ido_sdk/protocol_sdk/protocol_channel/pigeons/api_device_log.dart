import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class DeviceLogDelegate {

  /// 监听日志获取状态
  void listenLogStatus(bool status);

  /// 监听日志目录地址
  void listenLogDirPath(String dirPath);

  /// 日志整体进度 0-100
  void callbackLogProgress(double progress);
}

@FlutterApi()
abstract class DeviceLog {
  /// 判断日志状态
  bool getLogIng();

  /// 获取所有日志目录地址，每个日志目录下存放以时间戳命名的文件
  /// flash 日志目录 =>  Flash
  /// 电池日志目录 => Battery
  /// 过热日志目录 => Heat
  /// 旧的重启日志目录 => Reboot
  @async
  String logDirPath();

  /// 开始获取日志
  /// type 1: 旧的重启日志 2: 通用日志 3: 复位日志
  /// 4: 硬件日志 5: 算法日志 6: 新重启日志 7:电池日志 8: 过热日志
  @async
  bool startGet(List<int> types ,int timeOut);

  /// 取消
  void cancel();
}

