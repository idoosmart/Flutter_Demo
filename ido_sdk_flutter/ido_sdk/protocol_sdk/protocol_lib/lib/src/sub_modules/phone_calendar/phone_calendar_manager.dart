import 'dart:async';
import 'dart:convert';

import 'package:protocol_core/protocol_core.dart';

import '../../../protocol_lib.dart';
import '../../private/logger/logger.dart';

part 'private/phone_calendar_manager_impl.dart';

/// 手机日历全量 .cal 同步管理
abstract class IDOPhoneCalendarManager {
  factory IDOPhoneCalendarManager() => _IDOPhoneCalendarManager();

  /// 功能表是否支持手机日历提醒
  bool get isSupported;

  /// 是否正在同步/传输
  bool get isSyncing;

  /// 全量 .cal 同步：operate=1（内部，仅取 max_file_size）→ C 裁剪组包 → 文件传输
  ///
  /// [updateTime] 写入 `.cal` 文件头，由 App 传入（参考通讯录 `v2_conta.ml` 头时间）。
  Future<PhoneCalendarSyncResult> syncPhoneCalendar({
    required List<PhoneCalendarEvent> events,
    PhoneCalendarCropStrategy? strategy,
    void Function(double progress)? onTransferProgress,
    void Function(FileTransStatus status)? onTransferStatus,
  });

  /// 终止进行中的 .cal 传输
  void stopSync();
}
