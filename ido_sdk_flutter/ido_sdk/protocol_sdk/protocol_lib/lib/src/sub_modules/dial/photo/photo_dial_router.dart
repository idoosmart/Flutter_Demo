part of dial_manager;

/// 照片表盘路由：按平台分流至思澈 / Actions 实现
class _PhotoDialRouter implements IDOPhotoDial {
  _PhotoDialRouter._();
  static final instance = _PhotoDialRouter._();

  _CommonPhotoDialDelegate get _delegate =>
      libManager.deviceInfo.isSilfiPlatform()
          ? _SifliPhotoDial.instance
          : _ActionsPhotoDial.instance;

  @override
  Future<IDOPhotoDialUiPreset?> prepare(
    String dialName,
    String dialPackagePath,
  ) =>
      _delegate.prepareCwdAppResource(dialName, dialPackagePath);

  @override
  IDOPhotoDialUiPreset? prepareSync(String dialName, String dialPackagePath) =>
      null;

  @override
  void install(
    IDOPhotoDialConfig config, {
    void Function()? onSuccess,
    void Function(int errCode, Object errMsg)? onFailed,
    void Function(int progress)? onProgress,
  }) {
    _delegate.installPhotoDial(
      config,
      onSuccess: onSuccess,
      onFailed: onFailed,
      onProgress: onProgress,
    );
  }

  @override
  void cancelInstall() => _delegate.cancelInstall();

  @override
  Future<void> clearLocalResources(String dialName) =>
      _delegate.clearLocalDialResources(dialName);

  @override
  Future<String?> cropSelectedImage({
    required String dialName,
    required String sourcePath,
    required bool isPreview,
    IDOPhotoDialUiPreset? preset,
    String? outputPath,
  }) =>
      _PhotoDialImageProcessor.cropSelectedImageToPng(
        dialName: dialName,
        sourcePath: sourcePath,
        isPreview: isPreview,
        preset: preset,
        outputPath: outputPath,
      );
}

/// 图片缩放工具（照片表盘：centerCrop 后铺满目标尺寸，对齐 Android BmpUtil.centerCropBitmap）
class IDOPhotoDialImageUtils {
  static Future<ui.Image> scale(ui.Image image, ui.Size size) =>
      centerCropResize(image, size);

  static Future<ui.Image> centerCropResize(ui.Image image, ui.Size size) async {
    final tw = size.width;
    final th = size.height;
    final srcRatio = image.width / image.height;
    final targetRatio = tw / th;
    late double cropW;
    late double cropH;
    late double cropX;
    late double cropY;
    if (srcRatio > targetRatio) {
      cropH = image.height.toDouble();
      cropW = cropH * targetRatio;
      cropX = (image.width - cropW) / 2;
      cropY = 0;
    } else {
      cropW = image.width.toDouble();
      cropH = cropW / targetRatio;
      cropX = 0;
      cropY = (image.height - cropH) / 2;
    }
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(cropX, cropY, cropW, cropH),
      Rect.fromLTWH(0, 0, tw, th),
      Paint(),
    );
    final picture = recorder.endRecording();
    return picture.toImage(tw.toInt(), th.toInt());
  }

  /// 圆角裁剪，对齐 Android [ImageUtil.transform2CornerBitmap]
  static Future<ui.Image> applyRoundedCorners(
    ui.Image image,
    double radius,
  ) async {
    if (radius <= 0) return image;
    final w = image.width.toDouble();
    final h = image.height.toDouble();
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..isAntiAlias = true;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      Radius.circular(radius),
    );
    canvas.clipRRect(rrect, doAntiAlias: true);
    canvas.drawImage(image, Offset.zero, paint);
    final picture = recorder.endRecording();
    return picture.toImage(image.width, image.height);
  }
}
