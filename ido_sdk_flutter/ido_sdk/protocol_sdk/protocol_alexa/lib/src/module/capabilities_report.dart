import 'dart:io';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:protocol_alexa/src/module/auth.dart';
import 'package:protocol_alexa/src/resource/range_controller_skill.dart';
import 'package:protocol_alexa/src/resource/toggle_controller_skillsport.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'package:native_channel/native_channel.dart';

import '../../protocol_alexa.dart';
import '../private/logger/logger.dart';
import '../resource/toggleControllerSkill_sport2.dart';
import '../service/service_manager.dart';
import '../private/tools/data_box.dart';
import '../resource/toggle_controller_skill.dart';
import '../private/tools/map_extension.dart';

part 'inner/capabilities_report_impl.dart';

abstract class CapabilitiesReport {
  factory CapabilitiesReport() => _CapabilitiesReport();
  /// 获取token
  Future<void> initUpdateDeviceCapabilities();
}