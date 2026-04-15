import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class ApiPhotoDialDelegate {
  void onSuccess();
  void onFailed(int errCode, Object errMsg);
}

@FlutterApi()
abstract class ApiPhotoDial {

  // /// 同步解析表盘配置包
  // /// [dialPackagePath] 表盘配置包路径
  // /// 返回表盘支持的一些配置项，如颜色、位置（坐标）、组件功能
  // PhotoDialPresetConfig? prepareSync(String? dialPackagePath);

  /// 异步解析表盘配置包
  /// [dialPackagePath] 表盘配置包路径
  /// 返回表盘支持的一些配置项，如颜色、位置（坐标），组件功能json
  @async
  String? prepare(String dialPackagePath);

  /// 安装表盘
  /// [config] 表盘配置
  void install(ApiPhotoDialConfig config);

  /// 取消安装
  void cancelInstall();

}

@HostApi()
class ApiPhotoDialConfig {
  /// 背景图路径
  String? bgPicPath;

  /// 预览图路径
  String? previewPicPath;

  /// 时间颜色
  int? timeColor;

  /// 功能颜色
  int? functionColor;

  /// 位置
  int? position;

  /// 要展示的功能，不支持功能则不传 [PhotoDialConstants.WidgetFunction]
  int? showFunction;
}