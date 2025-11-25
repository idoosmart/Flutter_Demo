library dial_manager;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:archive/archive_io.dart';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;

import '../../../../protocol_lib.dart';
import '../../private/logger/logger.dart';
import '../../private/local_storage/local_storage.dart';
import '../extension/completer_ext.dart';

import 'constants/dial_constants.dart';
import 'photo/photo_dial.dart';
import 'photo/photo_dial_preset_config.dart';
import 'photo/photo_dial_config.dart';
import 'photo/photo_dial_iwf_config.dart';

part 'utils/json_helper.dart';
part 'utils/ido_file_manager.dart';
part 'utils/dial_extensions.dart';
part 'photo/photo_dial_impl.dart';

abstract class IDODialManager {
  factory IDODialManager() => _IDODialManager();

  /// 照片表盘
  IPhotoDial get dialPhoto;
}

class _IDODialManager implements IDODialManager {
  _IDODialManager._();
  static final _instance = _IDODialManager._();
  factory _IDODialManager() => _instance;

  @override
  IPhotoDial get dialPhoto => _PhotoDialImpl();
}