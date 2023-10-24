import 'dart:convert';

import 'package:protocol_lib/protocol_lib.dart';

import '../private/local_storage/local_storage.dart';
import '../private/logger/logger.dart';
import '../private/tools/data_box.dart';
import '../service/model/timer_model.dart';
import '../service/model/voicealarm_model.dart';
import '../service/service_manager.dart';
import 'auth.dart';
import 'client.dart';

part 'inner/alarm_impl.dart';

/// 闹钟
abstract class AlexaVoiceAlarm {
  factory AlexaVoiceAlarm() => _AlexaVoiceAlarm();
  /**< 添加闹钟 */
  void makeAlarmDateFormateUTCDate({required Map func});
  /**< 删除闹钟 */
  void deleteAlarmWihtTokens({required List tokens});
}
