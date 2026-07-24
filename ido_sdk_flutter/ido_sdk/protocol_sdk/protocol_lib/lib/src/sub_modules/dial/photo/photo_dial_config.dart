import 'photo_dial_constants.dart';

/// 用户安装照片表盘时的配置，对齐 Android [IDOPhotoDialConfig.java]
class IDOPhotoDialConfig {
  /// 表盘名称（OTA face name）
  String? dialName;

  /// 背景图路径
  String? bgPicPath;

  /// 预览图路径
  String? previewPicPath;

  /// 时间颜色（#RRGGBB）
  String timeColor;

  /// 功能颜色（#RRGGBB）
  String functionColor;

  /// 位置 [IDOPhotoDialWidgetPosition]
  int position;

  /// 要展示的功能 [IDOPhotoDialWidgetFunction]
  int showFunction;

  IDOPhotoDialConfig({
    this.dialName,
    this.bgPicPath,
    this.previewPicPath,
    required this.timeColor,
    required this.functionColor,
    required this.position,
    this.showFunction = IDOPhotoDialWidgetFunction.weekDate,
  });

  @override
  String toString() {
    return 'IDOPhotoDialConfig{dialName: $dialName, bgPicPath: $bgPicPath, previewPicPath: $previewPicPath, timeColor: $timeColor, functionColor: $functionColor, position: $position, showFunction: $showFunction}';
  }
}
