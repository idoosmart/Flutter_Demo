/// 照片表盘 UI 预置配置（扁平模型），对齐 Android [IDOPhotoDialPresetConfig.kt]
class IDOPhotoDialUiPreset {
  final String dialName;
  final String bg;
  final String preview;
  final int position;
  final List<int> supportPositions;
  final String timeColor;
  final List<String> timeColorList;

  /// 是否支持功能选择，对齐 [CommonPhotoDialDelegate.isSupportWallpaperFunction]
  /// `cloudWallpaper.function_support == 1 || function_support_new == 1`
  final bool supportFunctionType;

  final int defaultFunctionType;
  final String defaultFunctionWidgetColor;

  /// 可选功能 id 列表（1~6），对齐 Android generateConfig 固定六项
  final List<int> supportFunctionTypeList;
  final List<String> functionWidgetColorList;

  /// 是否支持功能颜色，对齐 [CommonPhotoDialDelegate.isSupportWallpaperFunctionColorSetting]
  final bool supportFunctionColorSetting;

  /// 是否支持位置，对齐 [CommonPhotoDialDelegate.isSupportWallpaperLocation]
  /// `cloudWallpaper.no_support_location == 0`
  final bool supportLocation;

  /// 是否支持颜色设置，对齐 [CommonPhotoDialDelegate.isSupportWallpaperSetting]
  /// `cloudWallpaper.no_support_colors == 0`
  final bool supportColorSetting;

  final double previewRadius;
  /// 表盘屏幕圆角，对齐 app.json [screen_corner]
  final double screenCorner;
  final bool supportPreviewBorder;
  final double previewBorderRadius;
  final double previewBorderWidth;
  final String previewBorderColor;

  const IDOPhotoDialUiPreset({
    required this.dialName,
    required this.bg,
    required this.preview,
    required this.position,
    required this.supportPositions,
    required this.timeColor,
    required this.timeColorList,
    required this.supportFunctionType,
    required this.defaultFunctionType,
    required this.defaultFunctionWidgetColor,
    required this.supportFunctionTypeList,
    required this.functionWidgetColorList,
    required this.supportFunctionColorSetting,
    required this.supportLocation,
    required this.supportColorSetting,
    this.previewRadius = 16,
    this.screenCorner = 0,
    this.supportPreviewBorder = false,
    this.previewBorderRadius = 16,
    this.previewBorderWidth = 16,
    this.previewBorderColor = '#7F7F7F',
  });

  /// 是否展示功能选择 UI，对齐 Android Demo `isSupportFunctionSet && list 非空`
  bool get canSelectFunction =>
      supportFunctionType && supportFunctionTypeList.isNotEmpty;
}
