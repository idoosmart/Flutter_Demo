import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

import 'package:native_channel/native_channel.dart';

import '../../private/logger/logger.dart';

part 'private/utils_make_dial.dart';
part 'private/utils_manager_impl.dart';

class IDOTrackLocation {
  final double longitude;
  final double latitude;

  IDOTrackLocation(this.longitude, this.latitude);
}

abstract class IDOUtilsManager {
  factory IDOUtilsManager() => _IDOUtilsManager();

  /// 生成自定义表盘文件，数据采用大端模式 （杰里平台）
  ///
  /// ```dart
  /// [dialFilePath] 表盘文件保存路径
  /// [bgPath] 背景图片路径
  /// [previewPath] 预览图图片路径，覆盖在背景图上方，透明只带时间组件
  /// [color] 字体颜色
  /// [baseBinPath] 基础bin包文件路径
  /// ```
  Future<bool> toJieLiDialFile({
    required String dialFilePath,
    String? bgPath,
    String? previewPath,
    required int color,
    required String baseBinPath,
  });

  /// 将经纬度列表写入文件（小端模式）
  /// 
  /// ```dart
  /// [coordinates] 经纬度列表，每个元素是IDOTrackLocation(经度, 纬度)
  /// [filePath] 完整文件路径
  /// @return 是否写入成功
  /// ```
  Future<bool> writeCoordinatesToFile(List<IDOTrackLocation> coordinates, String filePath);


}