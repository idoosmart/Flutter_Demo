import 'package:protocol_alexa/src/module/auth.dart';
import 'package:protocol_lib/protocol_lib.dart';

import '../private/logger/logger.dart';
import '../service/model/timer_model.dart';
import '../service/service_manager.dart';
import 'client.dart';

part 'inner/timer_impl.dart';

/// 计时器 秒表
abstract class AlexaTimer {
  factory AlexaTimer() => _AlexaTimer();
  void addTimer({required Map func});
  void deleteTimer({required List tokens});
}
