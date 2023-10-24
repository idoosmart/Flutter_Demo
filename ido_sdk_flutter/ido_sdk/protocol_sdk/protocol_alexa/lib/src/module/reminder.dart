import 'dart:convert';

import 'package:protocol_lib/protocol_lib.dart';

import '../private/logger/logger.dart';
import '../service/model/remind_model.dart';
import 'client.dart';
part 'inner/reminder_impl.dart';

/// 提醒
abstract class AlexaReminder {
  factory AlexaReminder() => _AlexaReminder();
  void addReminder({required Map func});
  void deleteDirectivesReminderWihtTokens({required List tokens});
}
