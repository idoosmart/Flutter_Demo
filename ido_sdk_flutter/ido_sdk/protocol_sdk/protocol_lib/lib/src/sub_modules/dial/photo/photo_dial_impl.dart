/// ============================================================
/// File:           photo_dial_impl
/// Author:         hc
/// Created Date:   2025/3/24 17:39
/// Version:        1.0.0
/// Copyright:      © 2024 by IDO. All Rights Reserved.
/// Description:
///   - 
/// ============================================================

part of dial_manager;

/// 照片表盘实现
class _PhotoDialImpl implements IPhotoDial {

  _PhotoDialImpl._();
  static final _instance = _PhotoDialImpl._();
  factory _PhotoDialImpl() => _instance;

  StreamSubscription<bool>? _subScriptionTrans;
  Completer<bool>? _completer;

  PhotoDialPresetConfig? _appConfig;
  PhotoDialIwfConfig? _iwfConfig;
  PhotoDialConfig? _photoConfig;

  String? _pathRootDial;
  final _defaultBgImgName = "bg.bmp";

  @override
  Future<PhotoDialPresetConfig?> prepare(String? dialPackagePath) async {
    if (dialPackagePath == null) {
      logger?.i('photo watch: 表盘配置包路径为空');
      return null;
    }

    // 获取sdk存储目录
    final rootDir = await DialConstants.dialStoreFolderPath(libManager.deviceInfo.deviceId.toString());
    final targetPath = '$rootDir/custom1_template';

    try {
      _iwfConfig = null;
      _appConfig = null;

      // 解压到目标目录
      final unzipDir = await _JsonHelper.unarchiveToDisk(
          zipPath: dialPackagePath, targetPath: targetPath);
      if (unzipDir == null) {
        logger?.i('photo watch: 解压表盘配置包失败');
        return null;
      }

      // 查找并解析app.json
      final appJsonFile = await _findFile(Directory(unzipDir), "app.json");
      if (appJsonFile == null) {
        logger?.i('photo watch: 未找到app.json文件');
        return null;
      }
      _appConfig = PhotoDialPresetConfig.fromJson(
          jsonDecode(await appJsonFile.readAsString()));

      // 查找并解析iwf.json
      final iwfJsonFile = await _findFile(appJsonFile.parent, "iwf.json");
      if (iwfJsonFile == null) {
        logger?.i('photo watch: 未找到iwf.json文件');
        return null;
      }
      _iwfConfig = PhotoDialIwfConfig.fromJson(
          jsonDecode(await iwfJsonFile.readAsString()));

      // 配置
      _iwfConfig?.jsonFilePath = iwfJsonFile.path;
      _pathRootDial = iwfJsonFile.parent.path;
      _appConfig?.sizePreviewPicture = await _sizePreviewImage();
      final screenInfo = await libManager.deviceInfo.getWatchDialInfo();
      _appConfig?.sizeWatchScreen = ui.Size(screenInfo?.width?.toDouble() ?? 0,
          screenInfo?.height?.toDouble() ?? 0);

      // config PhotoDialConfig
      _initConfigPhotoDial();
    } catch (e) {
      logger?.e(e);
      return null;
    }

    return _appConfig;
  }

  @override
  PhotoDialPresetConfig? prepareSync(String? dialPackagePath) {
    if (dialPackagePath == null) {
      logger?.i('photo watch: 表盘配置包路径为空');
      return null;
    }

    // 解压
    final unzipDir = _JsonHelper.unarchiveFromDiskSync(dialPackagePath, "dial_photo", true);
    if (unzipDir.isEmpty) {
      logger?.i('photo watch: 解压表盘配置包失败');
    }

    // 读取
    final dialJsonStr = _JsonHelper.readJsonContentSync(unzipDir);
    if (dialJsonStr.isEmpty) {
      logger?.i('photo watch: 读取表盘配置失败');
      return null;
    }

    // 解析
    final config = PhotoDialPresetConfig.fromJson(jsonDecode(dialJsonStr));
    //config.dialDirPath = unzipDir;
    //config.dialName = dialName;
    _appConfig = config;
    return config;
  }

  @override
  void install(PhotoDialConfig config, {
    void Function()? onSuccess,
    void Function(int errCode, Object errMsg)? onFailed
  }) async {
    try {

      //_appConfig?.counterTimers

      final locInfo = _appConfig?.locations?.firstWhere((e) => e.type == config.position);
      _iwfConfig?.item?.forEach((e) {
        if (e.type == "time") {
          _updateIwfItemRect(e, locInfo?.time);
        }else if (e.type == "week") {
          _updateIwfItemRect(e, locInfo?.week);
        } else if (e.type == "day") {
          _updateIwfItemRect(e, locInfo?.day);
        }
      });

      if (config.bgPicPath != null) {
        await _replaceBgImage(config.bgPicPath!);
      }

      if (config.previewPicPath != null) {
        await _replacePreviewImage(config.previewPicPath!);
      }

      // 发送到设备
      _sendZipToFirmware("", "", progress: (double v) {},
          onSuccess: onSuccess,
          onFailed: onFailed);
    }catch (e) {
      logger?.e(e);
    }
  }

  @override
  void cancelInstall() {
    _subScriptionTrans?.cancel();
    _subScriptionTrans = null;
  }
}

// 照片云表盘
extension _PhotoDialImplExt on _PhotoDialImpl {

  Future<bool> parseDialZip(String zipFilePath) async {
    try {
      const zipFileName = "custom1";
      const templateDirName = "custom1_template";
      final tempDir = Directory.systemTemp;
      final templateDir = Directory(path.join(tempDir.path, templateDirName));

      // 1. Clean and recreate template directory
      if (await templateDir.exists()) await templateDir.delete(recursive: true);
      await templateDir.create(recursive: true);

      // Unzip main file
      await _unzipFile(File(zipFilePath), templateDir);

      // 2. Find and unzip inner zip
      final innerZip = await _findFile(templateDir, "$zipFileName.zip");
      if (innerZip == null) return false;

      final innerZipDir = Directory(path.dirname(innerZip.path));
      final extractDir = Directory(path.join(innerZipDir.path, zipFileName));
      if (await extractDir.exists()) await extractDir.delete(recursive: true);
      await extractDir.create(recursive: true);

      await _unzipFile(innerZip, extractDir);
      _pathRootDial = extractDir.path;
      await innerZip.delete();

      // 3. Parse app.json
      final appJsonFile = await _findFile(templateDir, "app.json");
      if (appJsonFile == null) return false;
      _appConfig = PhotoDialPresetConfig.fromJson(
          jsonDecode(await appJsonFile.readAsString()));

      // 4. Parse iwf.json
      final iwfJsonFile = await _findFile(extractDir, "iwf.json");
      if (iwfJsonFile == null) return false;
      _iwfConfig = PhotoDialIwfConfig.fromJson(
          jsonDecode(await iwfJsonFile.readAsString()));
      _iwfConfig?.jsonFilePath = iwfJsonFile.path;

      // 5. config PhotoDialConfig
      _initConfigPhotoDial();

      // // Find background image
      // _bgImgPath = (await _findFile(extractDir, _defaultBgImgName))?.path;

      return true;
    } catch (e) {
      print("Error in parseDialZip: $e");
      return false;
    }
  }

  void _updateIwfItemRect(IWFItem iwfItem, List<int>? list) {
    iwfItem.x = list?[0];
    iwfItem.y = list?[1];
    iwfItem.w = list?[2];
    iwfItem.h = list?[3];
  }

  // 传输表盘到固件
  Future<bool> _sendZipToFirmware(
      String zipFilePath, String fileName, {
        required Function(double) progress,
        void Function()? onSuccess,
        void Function(int errCode, Object errMsg)? onFailed
      }) async {
    _completer = Completer<bool>();
    if (libManager.deviceLog.getLogIng) {
      logger?.i("Watch: 文件传输 传输壁纸图片关闭flash日志传输");
      libManager.deviceLog.cancel();
    }
    final isSifli = libManager.deviceInfo.isSilfiPlatform();
    final fileType = isSifli ? FileTransType.watch : FileTransType.iwf_lz;
    final tmpFileName = fileName + (isSifli ? ".watch" : "");
    final fileItem = NormalFileModel(fileType: fileType, filePath: zipFilePath, fileName: tmpFileName);
    _subScriptionTrans = libManager.transFile
        .transferSingle(
        fileItem: fileItem,
        funcStatus: (status) {
          logger?.i('Watch: 文件传输 状态: ${status.name}');
        },
        funcProgress: progress,
        funError: (index, errorCode, errorCodeFromDevice, finishingTime) {
          logger?.i('Watch: 文件传输 错误码: $errorCode $errorCodeFromDevice $finishingTime');
          onFailed?.call(errorCode, '文件传输失败');
          _completer?.completeSafe(false);
          _completer = null;
        },
        cancelPrevTranTask: true)
        .listen((rs) {
      logger?.i('Watch: 文件传输 状态 result: $rs');
      _completer?.completeSafe(rs);
      _completer = null;
    });

    return _completer!.future;
  }


  Future<String?> create24BitPNG(ui.Size size, ui.Image image) async {
    // try {
    //   final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    //   final tempDir = Directory.systemTemp;
    //   final file = File(path.join(tempDir.path, "${Uuid().v4()}.png"));
    //   await file.writeAsBytes(byteData!.buffer.asUint8List());
    //   return file.path;
    // } catch (e) {
    //   print("Error creating PNG: $e");
    //   return null;
    // }
    return null;
  }

  // 修改sizePreviewImage为异步方法
  Future<ui.Size> _sizePreviewImage() async {
    if (_pathRootDial == null || _iwfConfig?.preview == null) return ui.Size.zero;
    final previewFile = File(path.join(_pathRootDial!, _iwfConfig!.preview!));
    if (!await previewFile.exists()) return ui.Size.zero;
    try {
      final bytes = await previewFile.readAsBytes();
      final completer = Completer<ui.Image>();
      ui.decodeImageFromList(bytes, (image) => completer.complete(image));
      final image = await completer.future;
      return ui.Size(image.width.toDouble(), image.height.toDouble());
    } catch (e) {
      logger?.e("Error decoding preview image: $e");
      return ui.Size.zero;
    }
  }

  Future<bool> _replacePreviewImage(String newImagePath) async {
    return _iwfConfig?.preview != null
        ? await _replace24BitImage(newImagePath, _iwfConfig!.preview!)
        : false;
  }

  Future<bool> _replaceBgImage(String newImagePath) async {
    return await _replace24BitImage(newImagePath, _defaultBgImgName);
  }

  Future<String?> _packDialToZip() async {
    if (_pathRootDial == null) return null;

    final dialDir = Directory(_pathRootDial!);
    final templateDir = dialDir.parent;
    final zipFile = File(path.join(templateDir.path, "custom1.zip"));

    try {
      if (await zipFile.exists()) await zipFile.delete();

      final encoder = ZipFileEncoder();
      encoder.create(zipFile.path);

      await for (final file in dialDir.list(recursive: true)) {
        if (file is File && !path.basename(file.path).startsWith('.')) {
          encoder.addFile(file);
        }
      }
      encoder.close();
      return zipFile.path;
    } catch (e) {
      logger?.e("Error packing dial to zip: $e");
      return null;
    }
  }

  void _initConfigPhotoDial() {
    final photoDialConfig = PhotoDialConfig(timeColor: 0, functionColor: 0, position: 0);
    //_appConfig
    // 时间
    if (_appConfig?.select?.timeColorIndex != null) {
      photoDialConfig.timeColor = _appConfig?.select?.timeColorIndex ?? 0;
    }
    if (_appConfig?.select?.funcColorIndex != null) {
      photoDialConfig.functionColor = _appConfig?.select?.funcColorIndex ?? 0;
    }
    if (_appConfig?.select?.timeFuncLocation != null) {
      photoDialConfig.position = _appConfig?.select?.timeFuncLocation ?? 0;
    }
    _appConfig?.photoDialConfig = photoDialConfig;
    _photoConfig = _photoConfig;
  }

  // MARK: - Private Methods
  Future<bool> _replace24BitImage(String newPath, String imgName) async {
    if (_pathRootDial == null) return false;

    final targetFile = await _findFile(Directory(_pathRootDial!), imgName);
    if (targetFile == null) return false;

    try {
      if (await targetFile.exists()) await targetFile.delete();
      await File(newPath).copy(targetFile.path);
      return true;
    } catch (e) {
      logger?.e("Error replacing image: $e");
      return false;
    }
  }

  Future<File?> _findFile(Directory dir, String fileName) async {
    try {
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File && path.basename(entity.path) == fileName) {
          return entity;
        }
      }
    } catch (e) {
      logger?.e("Error searching file: $e");
    }
    return null;
  }

  Future<void> _unzipFile(File zipFile, Directory targetDir) async {
    final bytes = await zipFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    for (final file in archive) {
      final filename = path.join(targetDir.path, file.name);
      if (file.isFile) {
        await File(filename).create(recursive: true);
        await File(filename).writeAsBytes(file.content);
      }
    }
  }
}

// MARK: - Helper Extensions
extension ImageUtils on ui.Image {
  static Future<ui.Image> scale(ui.Image image, ui.Size size) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();

    final aspect = image.width / image.height;
    final src = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    Rect dst;

    if (size.width / size.height > aspect) {
      final width = size.height * aspect;
      dst = Rect.fromLTWH(
          (size.width - width) / 2, 0, width, size.height
      );
    } else {
      final height = size.width / aspect;
      dst = Rect.fromLTWH(
          0, (size.height - height) / 2, size.width, height
      );
    }

    canvas.drawImageRect(image, src, dst, paint);
    final picture = recorder.endRecording();
    return await picture.toImage(size.width.toInt(), size.height.toInt());
  }
}