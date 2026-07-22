import 'dart:async';
import 'dart:convert';

import 'package:protocol_core/protocol_core.dart';
import '../../../protocol_lib.dart';
import '../../private/logger/logger.dart';

part 'private/commands_manager_impl.dart';

/// 基础指令强类型化透传管理器
abstract class IDOCommandsManager {
  factory IDOCommandsManager() => _IDOCommandsManager();

  /// 功能表是否支持通知提醒（ancs）
  bool get isSupportNotice;

  /// 获取当前通知中心的状态
  Future<IDONoticeStatusModel?> getNoticeStatus();

  /// 设置当前通知中心的状态
  Future<IDOCommandResult?> setNoticeStatus(IDONoticeStatusModel model);
}
