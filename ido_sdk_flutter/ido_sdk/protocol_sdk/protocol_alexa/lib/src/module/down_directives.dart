
import 'dart:convert';
import 'package:protocol_alexa/src/module/reminder.dart';
import 'package:protocol_alexa/src/module/timer.dart';
import 'package:protocol_alexa/src/private/tools/map_extension.dart';
import 'package:protocol_lib/protocol_lib.dart';

import '../../protocol_alexa.dart';
import '../private/logger/logger.dart';
import '../private/tools/data_box.dart';
import '../resource/range_controller_skill.dart';
import '../resource/toggleControllerSkill_sport2.dart';
import '../resource/toggle_controller_skill.dart';
import '../resource/toggle_controller_skillsport.dart';
import '../service/model/directive_model.dart';
import '../service/service_manager.dart';
import 'alarm.dart';
import 'auth.dart';
import 'client.dart';
import 'indicator_point.dart';

part 'inner/down_directives_impl.dart';

abstract class DownDirectivesAnalysis {
  factory DownDirectivesAnalysis() => _DownDirectivesAnalysis();
  /**< 解析下行流数据 */
  void receiveDirectives({required DirectiveModel model});
}