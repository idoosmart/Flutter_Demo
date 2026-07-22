part of dial_manager;

/// 背景/预览图处理，对齐 Android [SifliPhotoDial] / [ActionsPhotoDial]
extension _PhotoDialImageHandler on _CommonPhotoDialDelegate {
  static const _defaultPreviewSize = (200, 200);

  /// iwf.json 预览图文件名与是否 bmp
  ({String name, bool isBmp}) _previewTargetFromIwf(
    Map<String, dynamic>? iwf,
  ) {
    var name = _WallpaperDialManager.tempPreviewImageBmp;
    var isBmp = false;
    if (iwf != null) {
      final preview = iwf['preview'] as String?;
      if (preview != null && preview.isNotEmpty) {
        name = preview;
        isBmp = preview.toLowerCase().endsWith('.bmp');
      }
    }
    return (name: name, isBmp: isBmp);
  }

  /// iwf.json 背景图文件名与是否 bmp（icon 项 bg 字段）
  ({String name, bool isBmp}) _bgTargetFromIwf(Map<String, dynamic>? iwf) {
    var name = _WallpaperDialManager.tempBgBmp;
    var isBmp = true;
    if (iwf == null) return (name: name, isBmp: isBmp);
    final items = iwf['item'] as List?;
    if (items == null) return (name: name, isBmp: isBmp);
    for (final raw in items) {
      if (raw is! Map) continue;
      if (raw['type'] != IDOPhotoDialIwfItemType.icon) continue;
      final bg = raw['bg'] as String?;
      if (bg != null && bg.isNotEmpty) {
        name = bg;
        isBmp = bg.toLowerCase().endsWith('.bmp');
      }
      break;
    }
    return (name: name, isBmp: isBmp);
  }

  /// 按表盘包内预置预览图尺寸缩放用户图，写入 zoom_preview.png
  Future<String> _scaleUserImageToZoomFile(
    String userImagePath,
    String previewNameInPack,
  ) async {
    final packPreviewPath =
        await _WallpaperDialManager.tempCwdPreviewImagePath(previewNameInPack);
    final size = await _WallpaperDialManager.getImageSize(packPreviewPath) ??
        _defaultPreviewSize;
    final scaled = await _loadAndScaleImage(
      userImagePath,
      size.$1,
      size.$2,
    );
    if (scaled == null) {
      throw Exception('savePreview Failed');
    }
    final zoomPath =
        await _WallpaperDialManager.tempCwdZoomedPreviewImagePath();
    final saved = await _saveScaledPng(scaled, zoomPath);
    if (saved == null) {
      throw Exception('savePreview Failed');
    }
    return saved;
  }

  /// Actions：缩放 → bmp/复制进临时表盘包 + 缓存 preview.bmp
  Future<void> _replaceActionsStylePreview(
    String userPreviewPath,
    Map<String, dynamic>? iwf,
  ) async {
    final target = _previewTargetFromIwf(iwf);
    saveDialLog(
      'savePreview start, isUsePreviewBmp = ${target.isBmp}, name = ${target.name}',
    );
    final zoomPath = await _scaleUserImageToZoomFile(
      userPreviewPath,
      target.name,
    );
    final packPreviewPath =
        await _WallpaperDialManager.tempCwdPreviewImagePath(target.name);
    final ok = await _WallpaperDialManager.replaceCwrPreviewImageWithTemp(
      zoomPath,
      packPreviewPath,
      target.isBmp,
    );
    if (!ok) throw Exception('savePreview Failed');
    await _stagePreviewCache(zoomPath, target.isBmp);
  }

  /// 思澈：缩放 → preview.bin（savePngByBin）+ 缓存 preview.bmp
  Future<void> _replaceSifliStylePreview(String userPreviewPath) async {
    const previewName = _WallpaperDialManager.tempPreviewImageBmp;
    final zoomPath = await _scaleUserImageToZoomFile(
      userPreviewPath,
      previewName,
    );
    final binPath =
        await _WallpaperDialManager.tempCwdPreviewImagePathByBin();
    final ok = await _WallpaperDialManager.savePngByBin(zoomPath, binPath);
    if (!ok) throw Exception('savePreview bin Failed');
    await _stagePreviewCache(zoomPath, true);
  }

  /// Actions：png2Bmp 或 copy 进临时表盘包
  Future<void> _replaceActionsStyleBackground(
    String userBgPath,
    Map<String, dynamic>? iwf,
  ) async {
    final target = _bgTargetFromIwf(iwf);
    final des =
        await _WallpaperDialManager.tempCwdBgImagePath(target.name);
    saveDialLog('replaceCwrBgImageWithTemp：des = $des, isUseBmpBg = ${target.isBmp}');
    final ok = await _WallpaperDialManager.replaceCwrBgImageWithTemp(
      userBgPath,
      des,
      target.isBmp,
    );
    if (!ok) throw Exception('replaceCwrBgImageWithTemp failed');
    await _stageBgCache(userBgPath);
  }

  /// 思澈：savePngByBin → background.bin
  Future<void> _replaceSifliStyleBackground(String userBgPath) async {
    saveDialLog('convertImage2Bmp start imageTempPath = $userBgPath');
    final des = await _WallpaperDialManager.tempCwdBgImagePath(
      _WallpaperDialManager.tempBackgroundBin,
    );
    final ok = await _WallpaperDialManager.savePngByBin(userBgPath, des);
    if (!ok) throw Exception('replaceCwrBgImageWithTemp failed');
    await _stageBgCache(userBgPath);
  }

  /// 缓存用户背景到 temp/bg.png，供安装成功后写入 images/bg.png
  Future<void> _stageBgCache(String userBgPath) async {
    if (userBgPath.isEmpty || !File(userBgPath).existsSync()) return;
    final des = await _WallpaperDialManager.tempBgImagePath();
    await _FileManager.createDirToDocument(path.dirname(des));
    if (File(des).existsSync()) {
      File(des).deleteSync();
    }
    await File(userBgPath).copy(des);
    saveDialLog('stageBgCache: $des');
  }

  /// 缓存缩放预览到 temp/preview.bmp，对齐 getTempCwdPreviewImagePath()
  Future<void> _stagePreviewCache(String zoomPath, bool isUseBmp) async {
    final cachePath =
        await _WallpaperDialManager.tempCwdPreviewImagePathDefault();
    final ok = await _WallpaperDialManager.replaceCwrPreviewImageWithTemp(
      zoomPath,
      cachePath,
      isUseBmp,
    );
    if (ok) {
      saveDialLog('stagePreviewCache: $cachePath');
    }
  }

  /// 安装成功后持久化 images/bg.png、images/preview.png
  Future<void> _persistImagesAfterInstall() async {
    if (dialFaceName == null || dialFaceName!.isEmpty) return;
    saveDialLog('拷贝背景图/预览图到表盘包 images/');
    final bgSrc = await _WallpaperDialManager.tempBgImagePath();
    final bgDes = await _WallpaperDialManager.deviceBackgroundImageWritePath(
      dialFaceName!,
    );
    await _FileManager.createDirToDocument(path.dirname(bgDes));
    if (File(bgSrc).existsSync()) {
      await _WallpaperDialManager.copyFile(bgSrc, bgDes);
    }
    try {
      final previewSrc =
          await _WallpaperDialManager.tempCwdPreviewImagePathDefault();
      final previewDes =
          await _WallpaperDialManager.devicePreviewImageWritePath(dialFaceName!);
      if (File(previewSrc).existsSync()) {
        await _WallpaperDialManager.copyFile(previewSrc, previewDes);
      }
    } catch (e) {
      saveDialLog('预览图拷贝失败: $e');
    }
  }
}
