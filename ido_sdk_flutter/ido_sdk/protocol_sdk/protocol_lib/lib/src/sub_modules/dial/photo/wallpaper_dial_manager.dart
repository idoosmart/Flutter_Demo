part of dial_manager;

/// 壁纸表盘路径与文件工具，对齐 Android [WallpaperDialManager.kt]
class _WallpaperDialManager {
  _WallpaperDialManager._();

  static const _rootDir = '/wallpaper_defined/';
  static const _cwdPackSuffix = '.zip';
  static const _fileDirNameFunction = 'watchFileFunction';
  static const _cwdAppJson = 'app.json';
  static const _cwdDeviceJson = 'iwf.json';
  static const _cwdDeviceConfigJson = 'dial_config.json';
  static const _previewImageDir = 'images/';
  static const _zipDir = 'zip/';
  static const _tempDir = 'temp/';
  static const _tempName = 'temp';

  static const tempBgPng = 'bg.png';
  /// 部分自定义照片表盘包默认背景名为 images/image.png（非 bg.png）
  static const packageBackgroundImagePng = 'image.png';
  static const tempBackgroundBin = 'background.bin';
  static const tempBgBmp = 'bg.bmp';
  static const tempPreviewImageBmp = 'preview.bmp';
  static const tempPreviewImageBin = 'preview.bin';
  static const tempZoomedPreviewImage = 'zoom_preview.png';
  static const _previewPng = 'preview.png';

  static Future<String> _cwdRootDir() async {
    final root = await LocalStorage.pathSDKStatic();
    return '$root$_rootDir';
  }

  static String _deviceUniqueCode() =>
      libManager.deviceInfo.macAddress.replaceAll(':', '');

  static Future<String> cwdBaseDir() async => await _cwdRootDir();

  static Future<String> tempCwdBaseDir() async =>
      '${await _cwdRootDir()}$_tempDir';

  static Future<String> tempCwdDir() async =>
      '${await tempCwdBaseDir()}$_tempName/';

  static Future<String> tempZipPath() async =>
      '${await tempCwdBaseDir()}$_zipDir$_tempName$_cwdPackSuffix';

  static Future<String> tempBgImagePath() async =>
      '${await tempCwdBaseDir()}$tempBgPng';

  static Future<String> tempCornerBgImagePath() async =>
      '${await tempCwdBaseDir()}corner_bg.png';

  static Future<String> tempCwdZoomedPreviewImagePath() async =>
      '${await tempCwdBaseDir()}$tempZoomedPreviewImage';

  static Future<String> tempCwdPreviewImagePathByBin() async =>
      '${await tempCwdDir()}$tempPreviewImageBin';

  static Future<String> tempCwdBgImagePath(String fileName) async =>
      '${await tempCwdDir()}$fileName';

  static Future<String> tempCwdPreviewImagePath(String name) async =>
      '${await tempCwdDir()}$name';

  /// 临时目录 preview.bmp（无参版），对齐 getTempCwdPreviewImagePath()
  static Future<String> tempCwdPreviewImagePathDefault() async =>
      '${await tempCwdBaseDir()}$tempPreviewImageBmp';

  static Future<String> deviceTempJsonPath() async =>
      '${await tempCwdDir()}$_cwdDeviceJson';

  static Future<String> deviceTempConfigJsonPath() async =>
      '${await tempCwdDir()}$_cwdDeviceConfigJson';

  static Future<String> cwdPackDir() async =>
      '${await _cwdRootDir()}$_zipDir';

  static Future<String> cwdPackFilePath(String dialName) async =>
      '${await cwdPackDir()}${_deviceUniqueCode()}/$dialName$_cwdPackSuffix';

  static Future<String> deviceCwdBaseDir() async =>
      '${await _cwdRootDir()}${_deviceUniqueCode()}/$_fileDirNameFunction/';

  static Future<String> deviceCwdParentDir(String dialName) async =>
      '${await deviceCwdBaseDir()}$dialName/';

  static Future<String> deviceCwdPackPath(String dialName) async =>
      '${await deviceCwdParentDir(dialName)}$dialName$_cwdPackSuffix';

  static Future<String> appJsonPath(String dialName) async =>
      '${await deviceCwdParentDir(dialName)}$_cwdAppJson';

  static Future<String> deviceBackgroundImagePath(String dialName) async {
    final dir = await resolveDialPackageDir(dialName);
    if (dir == null) return '';
    return _resolvePackageBackgroundPath(dir) ?? '';
  }

  /// 外壳 images/ 下默认背景：优先 bg.png，其次 image.png
  static String? _resolvePackageBackgroundPath(String dialDir) {
    final imagesDir = path.join(dialDir, _previewImageDir);
    for (final name in [tempBgPng, packageBackgroundImagePng]) {
      final imagePath = path.join(imagesDir, name);
      if (File(imagePath).existsSync()) return imagePath;
    }
    return null;
  }

  static Future<String> devicePreviewImagePath(String dialName) async {
    final dir = await resolveDialPackageDir(dialName);
    if (dir == null) return '';
    final imagePath = path.join(dir, _previewImageDir, _previewPng);
    return File(imagePath).existsSync() ? imagePath : '';
  }

  static Future<String> deviceBackgroundImageWritePath(String dialName) async =>
      '${await deviceCwdParentDir(dialName)}$_previewImageDir$tempBgPng';

  static Future<String> devicePreviewImageWritePath(String dialName) async =>
      '${await deviceCwdParentDir(dialName)}${_previewImageDir}preview.png';

  static Future<bool> isCwdPackFileExistAsync(String dialName) async =>
      File(await cwdPackFilePath(dialName)).existsSync();

  static Future<bool> isDeviceCwdPackExist(String dialName) async =>
      File(await deviceCwdPackPath(dialName)).existsSync();

  static Future<bool> isDeviceCwdDirExist(String dialName) async =>
      Directory(await deviceCwdParentDir(dialName)).existsSync();

  static Future<void> copyFile(String src, des) async {
    await File(src).copy(des);
  }

  static Future<void> copyDir(String srcDir, desDir) async {
    final src = Directory(srcDir);
    if (!src.existsSync()) return;
    await _FileManager.createDirToDocument(desDir);
    await for (final entity in src.list(recursive: true)) {
      if (entity is! File) continue;
      final rel = path.relative(entity.path, from: srcDir);
      final target = path.join(desDir, rel);
      await _FileManager.createDirToDocument(path.dirname(target));
      await entity.copy(target);
    }
  }

  static Future<void> deleteTempCwdPack(String dialName) async {
    final dir = Directory(await tempCwdDir());
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  }

  /// 删除 temp/ 工作区（temp 目录、临时 zip、.watch 等），对齐 Android [deleteTempRootDirectory]
  static Future<void> deleteTempRootDirectory() async {
    try {
      final dir = Directory(await tempCwdBaseDir());
      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
      }
    } catch (e) {
      logger?.e('deleteTempRootDirectory error: $e');
    }
  }

  /// 删除已导入的外壳 zip：zip/{mac}/{dialName}.zip
  static Future<void> deleteCwdPackFile(String dialName) async {
    try {
      final pack = File(await cwdPackFilePath(dialName));
      if (pack.existsSync()) {
        pack.deleteSync();
      }
    } catch (e) {
      logger?.e('deleteCwdPackFile error: $e');
    }
  }

  /// 删除解压目录 watchFileFunction/{dialName}/（含修改过的 images、内层 zip 等）
  static Future<void> deleteDeviceCwdFile(String dialName) async {
    try {
      _FileManager.removeDirectory(await deviceCwdParentDir(dialName));
    } catch (e) {
      logger?.e('deleteDeviceCwdFile error: $e');
    }
  }

  /// 清理指定表盘本地缓存，对齐 Android [WallpaperDialManager.clearCwd]
  static Future<bool> clearCwd(String dialName) async {
    await deleteDeviceCwdFile(dialName);
    await deleteCwdPackFile(dialName);
    return true;
  }

  /// 重新导入表盘包前：清本地解压目录、外壳 zip、temp 工作区及打包产物
  static Future<void> clearLocalDialResources(String dialName) async {
    await clearCwd(dialName);
    await deleteTempRootDirectory();
  }

  static Future<bool> unpackCwdPackage(String dialName) async {
    try {
      final packPath = await cwdPackFilePath(dialName);
      if (!await _isZipFileReadable(packPath)) {
        logger?.e('unpackCwdPackage invalid zip: $packPath');
        return false;
      }
      final baseDir = await deviceCwdBaseDir();
      // 对齐 Android unpackCopyZip：解压到 watchFileFunction，不整目录清空
      await _FileManager.createDirToDocument(baseDir);
      return await _unzipToDir(packPath, baseDir, wipeTarget: false);
    } catch (e) {
      logger?.e('unpackCwdPackage error: $e');
      return false;
    }
  }

  /// 解压后定位表盘包根目录（含 app.json 的目录）
  static Future<String?> resolveDialPackageDir(String dialName) async {
    final expected = await deviceCwdParentDir(dialName);
    if (File(path.join(expected, _cwdAppJson)).existsSync()) {
      return expected;
    }
    return _FileManager.findFileInDirectory(
      await deviceCwdBaseDir(),
      _cwdAppJson,
    );
  }

  /// 解压后定位 app.json；优先 dialName 目录，否则在 watchFileFunction 下递归查找
  static Future<String?> resolveAppJsonPath(String dialName) async {
    final dir = await resolveDialPackageDir(dialName);
    if (dir == null) return null;
    return path.join(dir, _cwdAppJson);
  }

  static Future<bool> unpackTempCwdPackage(String dialName) async {
    try {
      final tempDir = await tempCwdDir();
      final packPath = await deviceCwdPackPath(dialName);
      await _FileManager.createDirToDocument(path.dirname(tempDir));
      final ok = await _unzipToDir(packPath, tempDir);
      if (!ok) return false;
      // 部分包解压后目录名与 dialName 相同，重命名为 temp
      final base = await tempCwdBaseDir();
      final namedDir = Directory('$base$dialName');
      final temp = Directory(tempDir);
      if (namedDir.existsSync() && !temp.existsSync()) {
        namedDir.renameSync(tempDir);
      }
      return true;
    } catch (e) {
      logger?.e('unpackTempCwdPackage error: $e');
      return false;
    }
  }

  static Future<bool> prepareDeviceTempCwdResource(String dialName) async {
    final src = await deviceCwdParentDir(dialName);
    final des = await tempCwdDir();
    await deleteTempCwdPack(dialName);
    await copyDir(src, des);
    return Directory(des).existsSync();
  }

  static Future<bool> packTempCwdPackage(String dialName) async {
    try {
      final zipPath = await tempZipPath();
      await _FileManager.createDirToDocument(path.dirname(zipPath));
      return await _FileManager.zipDirectory(
        zipFilePath: zipPath,
        directoryList: [Directory(await tempCwdDir())],
      );
    } catch (e) {
      logger?.e('packTempCwdPackage error: $e');
      return false;
    }
  }

  static Future<String> packTempCwdPackageBySifli(String dialName) async {
    try {
      final tempDir = await tempCwdDir();
      // C 库在 tempDir 内生成 {dialName}.watch；输出路径须在 tempDir 外，
      // 对齐 example watchDir -> tmp.watch，避免 makeSifliDialFile copy 源/目标同路径
      final watchPath = '${await tempCwdBaseDir()}$dialName.watch';
      if (File(watchPath).existsSync()) {
        File(watchPath).deleteSync();
      }
      final rs = await libManager.tools.makeSifliDialFile(
        inputFilePath: tempDir,
        fileName: dialName,
        outputFilePath: watchPath,
      );
      if (rs != 0) return '';
      final watchFile = File(watchPath);
      if (!watchFile.existsSync() || await watchFile.length() <= 0) {
        logger?.e('packTempCwdPackageBySifli empty watch: $watchPath');
        return '';
      }
      return watchPath;
    } catch (e) {
      logger?.e('packTempCwdPackageBySifli error: $e');
      return '';
    }
  }

  static Future<bool> _unzipToDir(
    String zipPath,
    String targetDir, {
    bool wipeTarget = true,
  }) async {
    if (!await _isZipFileReadable(zipPath)) return false;
    if (wipeTarget) {
      _FileManager.removeDirectory(targetDir);
    }
    await _FileManager.createDirToDocument(targetDir);
    final inputStream = InputFileStream(zipPath);
    final archive = ZipDecoder().decodeBuffer(inputStream);
    await extractArchiveToDisk(archive, targetDir);
    return true;
  }

  /// ZIP 本地文件头 PK\x03\x04，排除 iCloud/FileProvider 占位或未下完的文件
  static Future<bool> _isZipFileReadable(String zipPath) async {
    final file = File(zipPath);
    if (!file.existsSync()) return false;
    if (await file.length() < 4) return false;
    final header = await file.openRead(0, 4).fold(<int>[], (p, e) => p..addAll(e));
    return header.length >= 2 && header[0] == 0x50 && header[1] == 0x4B;
  }

  static String _normalizeJsonText(String raw) {
    var text = raw.trim();
    if (text.startsWith('\uFEFF')) {
      text = text.substring(1);
    }
    return text;
  }

  static List<int>? hex2Rgb(String? hexStr) {
    if (hexStr == null || hexStr.isEmpty || hexStr.length != 7) return null;
    return [
      int.parse(hexStr.substring(1, 3), radix: 16),
      int.parse(hexStr.substring(3, 5), radix: 16),
      int.parse(hexStr.substring(5, 7), radix: 16),
    ];
  }

  static String colorTo16(String color) {
    final raw = color.replaceAll('#', '');
    final hasAlpha = int.tryParse(raw, radix: 16) != null &&
        int.parse(raw, radix: 16) > 0xFFFFFF;
    return hasAlpha ? color.replaceAll('#', '0x') : color.replaceAll('#', '0xFF');
  }

  static List<String> wallpaperColorList() => List.from(IDOPhotoDialWidgetColor.defaults);

  static Future<bool> convertImage2Bmp(String src, String des) async {
    if (!File(src).existsSync()) return false;
    final desFile = File(des);
    await _FileManager.createDirToDocument(path.dirname(des));
    if (desFile.existsSync()) desFile.deleteSync();
    final rs = libManager.tools.png2Bmp(
      inPath: src,
      outPath: des,
      format: ImageFormatType.rgb565,
    );
    return rs == 0;
  }

  static Future<bool> replaceCwrBgImageWithTemp(
    String src,
    String des,
    bool isUseBmpBg,
  ) async {
    try {
      if (isUseBmpBg) {
        return convertImage2Bmp(src, des);
      }
      if (File(src).existsSync()) {
        await _FileManager.createDirToDocument(path.dirname(des));
        await copyFile(src, des);
        return true;
      }
    } catch (e) {
      logger?.e('replaceCwrBgImageWithTemp error: $e');
    }
    return false;
  }

  /// 预览图替换，逻辑同 [replaceCwrBgImageWithTemp]
  static Future<bool> replaceCwrPreviewImageWithTemp(
    String src,
    String des,
    bool isUsePreviewBmp,
  ) =>
      replaceCwrBgImageWithTemp(src, des, isUsePreviewBmp);

  /// 思澈：PNG → ezip bin，对齐 Android FileUtil.savePngByBin
  static Future<bool> savePngByBin(String pngPath, String binPath) async {
    try {
      if (!File(pngPath).existsSync()) return false;
      final pngBytes = await File(pngPath).readAsBytes();
      final bin = await libManager.tools.sifliEBinFromPng(
        pngBytes,
        'rgb888',
        0,
        1,
        SifliSFBoardType.x56,
      );
      if (bin == null || bin.isEmpty) return false;
      await _FileManager.createDirToDocument(path.dirname(binPath));
      await File(binPath).writeAsBytes(bin);
      return true;
    } catch (e) {
      logger?.e('savePngByBin error: $e');
      return false;
    }
  }

  static Future<(int, int)?> getImageSize(String imagePath) async {
    try {
      if (!File(imagePath).existsSync()) return null;
      final bytes = await File(imagePath).readAsBytes();
      final completer = Completer<ui.Image>();
      ui.decodeImageFromList(bytes, completer.complete);
      final image = await completer.future;
      return (image.width, image.height);
    } catch (e) {
      logger?.e('getImageSize error: $e');
      return null;
    }
  }
}
