part of dial_manager;

/// 照片表盘选图：按表盘包参考尺寸 centerCrop 并输出 PNG
class _PhotoDialImageProcessor {
  _PhotoDialImageProcessor._();

  static const _defaultPreviewSize = (200, 200);

  /// 解析背景/预览目标尺寸（优先 preset 已落盘图，否则读内层表盘 zip）
  static Future<(int width, int height)?> resolveTargetSize({
    required String dialName,
    required bool isPreview,
    IDOPhotoDialUiPreset? preset,
  }) async {
    if (preset != null) {
      final ref = isPreview ? preset.preview : preset.bg;
      if (ref.isNotEmpty && File(ref).existsSync()) {
        final size = await _WallpaperDialManager.getImageSize(ref);
        if (size != null && size.$1 > 0 && size.$2 > 0) return size;
      }
    }
    return _sizeFromInnerDialPack(dialName, isPreview);
  }

  /// centerCrop + 缩放到目标尺寸，写入 PNG
  static Future<String?> cropSelectedImageToPng({
    required String dialName,
    required String sourcePath,
    required bool isPreview,
    IDOPhotoDialUiPreset? preset,
    String? outputPath,
  }) async {
    if (!File(sourcePath).existsSync()) return null;
    final target = await resolveTargetSize(
      dialName: dialName,
      isPreview: isPreview,
      preset: preset,
    );
    if (target == null) return null;
    final out = outputPath ??
        '${await _WallpaperDialManager.tempCwdBaseDir()}photo_dial_${isPreview ? 'preview' : 'bg'}_${DateTime.now().millisecondsSinceEpoch}.png';
    return _centerCropResizeToPngFile(
      sourcePath: sourcePath,
      targetWidth: target.$1,
      targetHeight: target.$2,
      cornerRadius: _cornerRadius(isPreview: isPreview, preset: preset),
      outputPath: out,
    );
  }

  /// 预览图用 previewRadius；背景图用 screen_corner（无则回退 previewRadius）
  static double _cornerRadius({
    required bool isPreview,
    IDOPhotoDialUiPreset? preset,
  }) {
    if (preset == null) return 0;
    if (isPreview) return preset.previewRadius;
    if (preset.screenCorner > 0) return preset.screenCorner;
    return preset.previewRadius;
  }

  static Future<(int, int)?> _sizeFromInnerDialPack(
    String dialName,
    bool isPreview,
  ) async {
    var packPath = await _WallpaperDialManager.deviceCwdPackPath(dialName);
    if (!File(packPath).existsSync()) {
      final imported = await _WallpaperDialManager.cwdPackFilePath(dialName);
      if (!File(imported).existsSync()) return null;
      packPath = imported;
    }

    if (isPreview) {
      if (libManager.deviceInfo.isSilfiPlatform()) {
        final size = await _imageSizeFromZipEntry(
          packPath,
          _WallpaperDialManager.tempPreviewImageBmp,
        );
        return size ?? _defaultPreviewSize;
      }
      final iwf = await _readJsonFromZip(packPath, 'iwf.json');
      final name =
          iwf?['preview'] as String? ?? _WallpaperDialManager.tempPreviewImageBmp;
      final size = await _imageSizeFromZipEntry(packPath, name);
      return size ?? _defaultPreviewSize;
    }

    if (libManager.deviceInfo.isSilfiPlatform()) {
      final cfg = await _readJsonFromZip(packPath, 'dial_config.json');
      final rows = cfg?['dial_data'] as List?;
      for (final raw in rows ?? <dynamic>[]) {
        if (raw is! Map) continue;
        final file = (raw['file'] as String? ?? '').toLowerCase();
        if (file != _WallpaperDialManager.tempBackgroundBin &&
            file != 'background.png' &&
            file != 'bg.bmp') {
          continue;
        }
        final w = (raw['w'] as num?)?.toInt() ?? 0;
        final h = (raw['h'] as num?)?.toInt() ?? 0;
        if (w > 0 && h > 0) return (w, h);
      }
      final bgBmpSize =
          await _imageSizeFromZipEntry(packPath, _WallpaperDialManager.tempBgBmp);
      return bgBmpSize ?? await _previewSizeFromPack(packPath);
    }

    final iwf = await _readJsonFromZip(packPath, 'iwf.json');
    for (final raw in (iwf?['item'] as List?) ?? <dynamic>[]) {
      if (raw is! Map) continue;
      if (raw['type'] != IDOPhotoDialIwfItemType.icon) continue;
      final bg = raw['bg'] as String?;
      if (bg != null && bg.isNotEmpty) {
        final size = await _imageSizeFromZipEntry(packPath, bg);
        if (size != null) return size;
      }
    }
    final fallbackBg =
        await _imageSizeFromZipEntry(packPath, _WallpaperDialManager.tempBgBmp);
    return fallbackBg ?? await _previewSizeFromPack(packPath);
  }

  static Future<(int, int)?> _previewSizeFromPack(String packPath) async {
    if (libManager.deviceInfo.isSilfiPlatform()) {
      final size = await _imageSizeFromZipEntry(
        packPath,
        _WallpaperDialManager.tempPreviewImageBmp,
      );
      return size ?? _defaultPreviewSize;
    }
    final iwf = await _readJsonFromZip(packPath, 'iwf.json');
    final name =
        iwf?['preview'] as String? ?? _WallpaperDialManager.tempPreviewImageBmp;
    final size = await _imageSizeFromZipEntry(packPath, name);
    return size ?? _defaultPreviewSize;
  }

  static Future<Map<String, dynamic>?> _readJsonFromZip(
    String zipPath,
    String entryName,
  ) async {
    try {
      final inputStream = InputFileStream(zipPath);
      final archive = ZipDecoder().decodeBuffer(inputStream);
      for (final file in archive) {
        if (!file.isFile) continue;
        final base = path.basename(file.name);
        if (base != entryName) continue;
        final content = file.content;
        if (content is! List<int>) continue;
        return jsonDecode(utf8.decode(content)) as Map<String, dynamic>;
      }
    } catch (e) {
      logger?.e('readJsonFromZip error: $e');
    }
    return null;
  }

  static Future<(int, int)?> _imageSizeFromZipEntry(
    String zipPath,
    String entryName,
  ) async {
    try {
      final inputStream = InputFileStream(zipPath);
      final archive = ZipDecoder().decodeBuffer(inputStream);
      for (final file in archive) {
        if (!file.isFile) continue;
        final base = path.basename(file.name);
        if (base != entryName) continue;
        final content = file.content;
        if (content is! List<int>) continue;
        final completer = Completer<ui.Image>();
        ui.decodeImageFromList(Uint8List.fromList(content), completer.complete);
        final image = await completer.future;
        if (image.width > 0 && image.height > 0) {
          return (image.width, image.height);
        }
      }
    } catch (e) {
      logger?.e('imageSizeFromZipEntry error: $e');
    }
    return null;
  }

  static Future<String?> _centerCropResizeToPngFile({
    required String sourcePath,
    required int targetWidth,
    required int targetHeight,
    required double cornerRadius,
    required String outputPath,
  }) async {
    final bytes = await File(sourcePath).readAsBytes();
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, completer.complete);
    final image = await completer.future;
    var scaled = await IDOPhotoDialImageUtils.centerCropResize(
      image,
      ui.Size(targetWidth.toDouble(), targetHeight.toDouble()),
    );
    if (cornerRadius > 0) {
      scaled = await IDOPhotoDialImageUtils.applyRoundedCorners(scaled, cornerRadius);
    }
    await _FileManager.createDirToDocument(path.dirname(outputPath));
    final byteData = await scaled.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;
    await File(outputPath).writeAsBytes(byteData.buffer.asUint8List());
    return outputPath;
  }
}
