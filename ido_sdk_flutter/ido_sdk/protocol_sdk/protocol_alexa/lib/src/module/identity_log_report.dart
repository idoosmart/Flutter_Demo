
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:protocol_alexa/src/private/tools/data_box.dart';
import 'package:protocol_lib/protocol_lib.dart';
import '../private/logger/logger.dart';
import '../service/service_manager.dart';
import '../private/tools/map_extension.dart';
import '../private/tools/string_extension.dart';
import 'auth.dart';

part 'inner/identity_log_report_impl.dart';

abstract class IdentityLogReport {
  factory IdentityLogReport() => _IdentityLogReport();
  //alexa活跃度上报，每小时上传一次
  void userInactivityReport({required int inactiveTimeInSeconds});
  //固件版本上报
  void userSoftwareInfoReport();
  //固件音量变化上报
  void volumeChangedInfoReport({required String volumeJsonStr});
}
