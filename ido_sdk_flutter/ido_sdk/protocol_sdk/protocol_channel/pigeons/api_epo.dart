import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class ApiEpoManagerDelegate {
  /// 升级状态
  void onEpoStatusChanged(ApiEpoUpgradeStatus status);

  /// 下载进度
  void onEpoDownloadProgress(double progress);

  /// 发送进度
  void onEpoSendProgress(double progress);

  /// 升级完成（成功或失败）
  /// errorCode：0 升级成功，非0升级失败
  void onEpoComplete(int errorCode);

  /// app提供当前手机gps信息，用于设备快速定位
  @async
  ApiOTAGpsInfo? onGetGps();
}

@FlutterApi()
abstract class ApiEPOManager {

  /// 启用自动epo升级，默认为 关
  ///
  /// ```dart
  /// 触发条件：
  /// 1、每次快速配置完成后倒计时1分钟；
  /// 2、数据同步完成后立即执行；
  /// ```
  bool enableAutoUpgrade();

  /// 启用自动epo升级，默认为 关
  ///
  /// ```dart
  /// 触发条件：
  /// 1、每次快速配置完成后倒计时1分钟；
  /// 2、数据同步完成后立即执行；
  /// ```
  void setEnableAutoUpgrade(bool value);

  /// 获取最后一次更新的时间戳，单位：秒
  ///
  /// 无记录则返回0
  @async
  int lastUpdateTimestamp();

  /// 是否需要更新
  @async
  bool shouldUpdateForEPO(bool isForce);

  /// 启动升级任务
  ///
  /// ```dart
  /// isForce 是否强制更新
  /// retryCount 重试次数，默认0次
  /// ```
  void willStartInstall(bool isForce, int retryCount);

  /// 停止升级任务
  ///
  /// 注：只支持下载中和发送中的任务，不支持正在升级的任务
  void stop();
}


/// EPO升级状态
enum ApiEpoUpgradeStatus {
  /// 空闲
  idle,
  /// 准备更新
  ready,
  /// 下载中
  downing,
  /// 制作中
  making,
  /// 发送中
  sending,
  /// 安装中
  installing,
  /// 成功
  success,
  /// 失败
  failure,
}

class ApiOTAGpsInfo {
  ///	晶振偏移
  int? tcxoOffset;
  /// 经度
  double? longitude;
  /// 纬度
  double? latitude;
  /// 海拔高度
  double? altitude;
}