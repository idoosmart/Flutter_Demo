/// 配置类，用于存储照片表盘的相关配置
class PhotoDialConfig {
  /// 背景图路径
  String? bgPicPath;

  /// 预览图路径
  String? previewPicPath;

  /// 时间颜色
  int timeColor;

  /// 功能颜色
  int functionColor;

  /// 位置 [PhotoDialConstants.WidgetPosition]
  int position;

  /// 要展示的功能，不支持功能则不传 [PhotoDialConstants.WidgetFunction]
  int showFunction;

  /// 基础表盘包路径，如果不传或传空串，则默认使用 [IPhotoDial.prepare] 解析出来的基础表盘包
  String? baseDialPackagePath;

  /// 构造函数
  PhotoDialConfig({
    this.bgPicPath,
    this.previewPicPath,
    required this.timeColor,
    required this.functionColor,
    required this.position,
    this.showFunction = 1,
    this.baseDialPackagePath = '',
  });
}