import 'package:pigeon/pigeon.dart';

@FlutterApi()
abstract class Bind {
  /// 绑定状态
  @async
  bool isBinded();

  /// 是否在绑定中 (绑定中，切换设备将受到限制）
  bool isBinding();

  /// 0 绑定失败 1绑定成功 2已经绑定 3需要授权码绑定 4拒绝绑定 5绑定错误设备 6授权码校验失败
  /// 7取消绑定 8绑定失败（获取功能表失败) 9绑定失败（获取设备信息失败)
  /// 10绑定超时（支持该功能的设备专用）
  /// 11新账户绑定，用户确定删除设备数据（支持该功能的设备专用）
  /// 12新账户绑定，用户不删除设备数据，绑定失败（支持该功能的设备专用）
  /// 13新账户绑定，用户不选择，设备超时（支持该功能的设备专用）
  /// 14设备同意配对(绑定)请求，等待APP下发配对结果（支持该功能的设备专用）
  @async
  int bind(int osVersion);

  void cancelBind();

  /// APP下发绑定结果(仅限需要app确认绑定结果的设备使用)
  /// ```
  /// 注：当startBind(...) 返回BindStatus.needAuthByApp 时，APP需要发送
  /// CmdEvtType.sendBindResult指令，在调用成功后，再调用appMarkBindResult方法
  /// ```
  void appMarkBindResult(bool success);

  @async
  bool unbind(String macAddress, bool isForceRemove);

  @async
  bool setAuthCode(String code, int osVersion);
}
