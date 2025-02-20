import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:protocol_core/protocol_core.dart';
import 'package:rxdart/rxdart.dart';

import '../../protocol_lib.dart';
import '../private/logger/logger.dart';
import '../private/local_storage/local_storage.dart';

part 'part/device_bind_impl.dart';

typedef BindValueCallback<T> = void Function(T value);

abstract class IDODeviceBind {
  factory IDODeviceBind() => _IDODeviceBind();

  /// 绑定状态
  Future<bool> get isBinded;

  /// 是否在绑定中 (绑定中，切换设备将受到限制）
  bool get isBinding;

  /// 发起绑定
  /// osVersion: 系统版本 (取主版本号)
  /// userId: 用户ID，最大14字节（超过14字节会提取后14字节）
  Stream<BindStatus> startBind(
      {required int osVersion,
      required BindValueCallback<IDODeviceInfo> deviceInfo,
      required BindValueCallback<IDOFunctionTable> functionTable,
      String? userId});

  /// 终止绑定操作（仅限sdk内部使用）
  void stopBindIfNeed();

  /// APP下发绑定结果(仅限需要app确认绑定结果的设备使用)
  /// ```
  /// 注：当startBind(...) 返回BindStatus.needAuthByApp 时，APP需要发送
  /// CmdEvtType.sendBindResult指令，在调用成功后，再调用appMarkBindResult方法
  /// ```
  void appMarkBindResult({required bool success});

  /// 发起解绑
  ///
  /// macAddress: 设备Mac地址
  /// isForceRemove：强制删除设备，设备无响应也删除
  Future<bool> unbind({required String macAddress, bool isForceRemove = false});

  /// 发送授权配对码
  /// code 配对码
  /// osVersion: 系统版本 (取主版本号)
  Stream<bool> setAuthCode(String code, int osVersion);

  /// 监听更新mode (SDK内部使用）
  ///
  /// 设置c库绑定模式 mode: 0 没有绑定, 1 已经绑定, 2 升级模式, 3 重连, 4 泰凌微
  StreamSubscription listenUpdateSetModeNotification(
      void Function(int mode) func);

  /// 监听解绑 (SDK内部使用）
  StreamSubscription listenUnbindNotification(
      void Function(String macAddress) func);
}
