library dial_manager;

import 'photo/photo_dial.dart';

part 'dial_manager_impl.dart';

abstract class IDODialManager {
  factory IDODialManager() => _IDODialManager();

  /// 照片表盘
  IPhotoDial get dialPhoto;

}