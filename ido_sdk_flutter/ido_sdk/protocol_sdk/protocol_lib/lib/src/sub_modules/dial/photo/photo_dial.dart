/// 照片表盘相关功能接口
import 'photo_dial_config.dart';
import 'photo_dial_ui_preset.dart';

abstract class IDOPhotoDial {
  /// 同步解析表盘配置包（需 SDK 已初始化；推荐优先使用 [prepare]）
  /// [dialName] OTA 表盘名
  /// [dialPackagePath] 表盘外壳 zip 路径
  IDOPhotoDialUiPreset? prepareSync(String dialName, String dialPackagePath);

  /// 异步解析表盘配置包
  Future<IDOPhotoDialUiPreset?> prepare(String dialName, String dialPackagePath);

  /// 安装表盘
  void install(
    IDOPhotoDialConfig config, {
    void Function()? onSuccess,
    void Function(int errCode, Object errMsg)? onFailed,
    void Function(int progress)? onProgress,
  });

  /// 取消安装
  void cancelInstall();

  /// 清理本地表盘包缓存（解压目录、外壳 zip、temp 工作区），重新选包前调用
  Future<void> clearLocalResources(String dialName);

  /// 将用户选图按表盘包参考尺寸 centerCrop 为 PNG（需先 [prepare]）
  Future<String?> cropSelectedImage({
    required String dialName,
    required String sourcePath,
    required bool isPreview,
    IDOPhotoDialUiPreset? preset,
    String? outputPath,
  });
}
