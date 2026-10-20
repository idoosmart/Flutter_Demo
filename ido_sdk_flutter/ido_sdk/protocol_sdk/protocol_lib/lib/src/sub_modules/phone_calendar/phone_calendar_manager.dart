import 'dart:async';
import 'dart:convert';

import 'package:protocol_core/protocol_core.dart';

import '../../../protocol_lib.dart';
import '../../private/logger/logger.dart';

part 'private/phone_calendar_manager_impl.dart';

/// 手机日历全量同步管理
abstract class IDOPhoneCalendarManager {
  factory IDOPhoneCalendarManager() => _IDOPhoneCalendarManager();

  /// 功能表是否支持手机日历提醒
  bool get isSupported;

  /// 是否正在同步/传输
  bool get isSyncing;

  /// 全量同步日程到设备（可指定裁剪策略）。
  /// [events] 为 `null` 或空列表时清空设备日历（组包 JSON 分别为 `items: null` / `items: []`）。
  /// Full sync. Null or empty [events] clears device calendar (`items: null` / `items: []`).
  Future<PhoneCalendarSyncResult> syncPhoneCalendar({
    List<PhoneCalendarEvent>? events,
    PhoneCalendarCropStrategy? strategy,
    void Function(double progress)? onTransferProgress,
    void Function(FileTransStatus status)? onTransferStatus,
  });

  /// 终止进行中的同步传输
  void stopSync();
}
