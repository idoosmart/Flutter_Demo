part of dial_manager;

typedef _PhotoDialProgress = void Function(int progress);

/// 照片表盘公共逻辑，对齐 Android [CommonPhotoDialDelegate.kt]
abstract class _CommonPhotoDialDelegate {
  String? dialFaceName;
  String? dialPackagePath;

  List<String>? colorList;
  List<String>? cwdColorList;

  int functionColorIndex = 0;
  int timeColorIndex = 0;
  int timeFuncLocation = 0;
  final List<int> locationValues = [];
  final List<IDOPhotoDialFunctionList> functions = [];
  int selectedFunction = IDOPhotoDialWidgetFunction.weekDate;
  final List<int> widgetTypeList = [];

  IDOPhotoDialConfig? userConfig;
  IDOPhotoDialPresetConfig? cwdAppBean;
  Map<String, dynamic>? rawAppJson;

  StreamSubscription<bool>? _transferSub;
  bool _interceptFailedCallback = false;

  void saveDialLog(String text) {
    logger?.i('【PhotoDial/$dialFaceName】$text');
  }

  /// 同步入口保留兼容；内部依赖已初始化的 SDK 存储路径，完整流程请用 [prepareCwdAppResource]
  IDOPhotoDialUiPreset? prepareCwdAppResourceSync(
    String dialName,
    String packagePath,
  ) {
    saveDialLog('prepareCwdAppResourceSync: 请优先使用 async prepare');
    return null;
  }

  Future<IDOPhotoDialUiPreset?> prepareCwdAppResource(
    String dialName,
    String packagePath,
  ) async {
    if (dialName.isEmpty) return null;
    dialFaceName = dialName;
    dialPackagePath = packagePath;
    _resetPrepareState();
    saveDialLog('prepare: clear local resources for $dialName');
    await _WallpaperDialManager.clearLocalDialResources(dialName);
    await _copyDialPackage(dialName, packagePath);
    final hasPack = await _WallpaperDialManager.isCwdPackFileExistAsync(dialName);
    if (!hasPack) {
      saveDialLog('prepare async: zip not exist');
      return null;
    }
    final ok = await _WallpaperDialManager.unpackCwdPackage(dialName);
    if (!ok) return null;
    cwdAppBean = await _getCwdAppBean(dialName);
    if (cwdAppBean == null) return null;
    _parseFunctionConfig();
    return await _generateUiPreset();
  }

  Future<void> installPhotoDial(
    IDOPhotoDialConfig config, {
    void Function()? onSuccess,
    void Function(int errCode, Object errMsg)? onFailed,
    _PhotoDialProgress? onProgress,
  }) async {
    _initCwdConfig();
    userConfig = config;
    if (config.dialName != null && config.dialName!.isNotEmpty) {
      dialFaceName = config.dialName;
    }
    final colors = _resolveColorList();
    functionColorIndex = colors.indexOf(config.functionColor);
    if (functionColorIndex < 0) functionColorIndex = 0;
    timeColorIndex = colors.indexOf(config.timeColor);
    if (timeColorIndex < 0) timeColorIndex = 0;
    if (!_isSupportWallpaperFunctionColorSetting()) {
      functionColorIndex = timeColorIndex;
    }
    timeFuncLocation = config.position;
    selectedFunction = config.showFunction;
    widgetTypeList.add(selectedFunction);

    try {
      final status = await _prepareAndReplaceTemp();
      if (status == IDOPhotoDialCwdConfigSetStatus.success) {
        await _packAndTransfer(onSuccess: onSuccess, onFailed: onFailed, onProgress: onProgress);
      } else if (status == IDOPhotoDialCwdConfigSetStatus.download) {
        onFailed?.call(IDOPhotoDialInstallStatus.failed, '表盘包不存在，需先下载');
      } else {
        onFailed?.call(IDOPhotoDialInstallStatus.failed, '准备表盘资源失败');
      }
    } catch (e) {
      saveDialLog('install error: $e');
      onFailed?.call(IDOPhotoDialInstallStatus.failed, e);
    }
  }

  void cancelInstall() {
    _transferSub?.cancel();
    _transferSub = null;
  }

  Future<int> _prepareAndReplaceTemp() async {
    if (dialFaceName == null || dialFaceName!.isEmpty) {
      return IDOPhotoDialCwdConfigSetStatus.failed;
    }
    final name = dialFaceName!;
    if (await _WallpaperDialManager.isDeviceCwdPackExist(name)) {
      await prepareCwdResource(unpackShell: false);
      await replaceTempCwdImage();
      await replaceTempCwdConfig();
      return IDOPhotoDialCwdConfigSetStatus.success;
    }
    if (await _WallpaperDialManager.isCwdPackFileExistAsync(name)) {
      await prepareCwdResource(unpackShell: true);
      await replaceTempCwdImage();
      await replaceTempCwdConfig();
      return IDOPhotoDialCwdConfigSetStatus.success;
    }
    return IDOPhotoDialCwdConfigSetStatus.download;
  }

  Future<void> prepareCwdResource({required bool unpackShell}) async {
    saveDialLog('prepareCwdResource unpackShell=$unpackShell');
    if (unpackShell) {
      final ok = await _WallpaperDialManager.unpackCwdPackage(dialFaceName!);
      if (!ok) throw Exception('unpackCwdShell Failed');
    }
    await _WallpaperDialManager.deleteTempCwdPack(dialFaceName!);
    final ok = await _WallpaperDialManager.unpackTempCwdPackage(dialFaceName!);
    if (!ok) throw Exception('unpackTempCwd Failed');
  }

  Future<void> replaceTempCwdImage();
  Future<void> replaceTempCwdConfig();
  Future<String> packCwdPackage();
  Future<void> processAfterInstall() async {}

  Future<void> _packAndTransfer({
    void Function()? onSuccess,
    void Function(int errCode, Object errMsg)? onFailed,
    _PhotoDialProgress? onProgress,
  }) async {
    final zipPath = await packCwdPackage();
    if (zipPath.isEmpty) {
      onFailed?.call(IDOPhotoDialInstallStatus.failed, '打包失败');
      return;
    }
    await _startTransfer(
      zipPath,
      onSuccess: onSuccess,
      onFailed: onFailed,
      onProgress: onProgress,
    );
  }

  Future<void> _startTransfer(
    String filePath, {
    void Function()? onSuccess,
    void Function(int errCode, Object errMsg)? onFailed,
    _PhotoDialProgress? onProgress,
  }) async {
    if (!libManager.isConnected) {
      onFailed?.call(IDOPhotoDialInstallStatus.failed, 'device is disconnected');
      return;
    }
    final isSifli = libManager.deviceInfo.isSilfiPlatform();
    final fileType = isSifli ? FileTransType.watch : FileTransType.iwf_lz;
    // Actions 等平台打包产物为固定 temp.zip，传输名必须用 dialFaceName（如 custom1），
    // 否则会变成 temp.zip.iwf.lz。思澈 .watch 包本身已带正确文件名。
    final fileName = isSifli
        ? path.basename(filePath)
        : (dialFaceName?.deleteIWF().isNotEmpty == true
            ? dialFaceName!.deleteIWF()
            : path.basenameWithoutExtension(filePath));
    final watchFile = File(filePath);
    final fileSize =
        watchFile.existsSync() ? await watchFile.length() : 0;
    if (fileSize <= 0) {
      saveDialLog('transfer aborted: watch file empty $filePath');
      onFailed?.call(IDOPhotoDialInstallStatus.failed, '表盘文件为空');
      return;
    }
    saveDialLog('transfer start: type=$fileType name=$fileName path=$filePath');
    final fileItem = NormalFileModel(
      fileType: fileType,
      filePath: filePath,
      fileName: fileName,
      fileSize: fileSize,
    );
    _transferSub?.cancel();
    _transferSub = libManager.transFile
        .transferSingle(
      fileItem: fileItem,
      funcStatus: (s) => saveDialLog('transfer status: ${s.name}'),
      funcProgress: (p) => onProgress?.call((p * 100).round()),
      funError: (index, errorCode, errorCodeFromDevice, finishingTime) {
        if (_interceptFailedCallback) return;
        if (errorCode != 0) {
          onFailed?.call(errorCode, '文件传输失败');
        }
      },
      cancelPrevTranTask: true,
    )
        .listen((ok) async {
      if (ok) {
        await _copyAndReplaceOldCwd(onSuccess: onSuccess, onFailed: onFailed);
      } else if (!_interceptFailedCallback) {
        onFailed?.call(IDOPhotoDialInstallStatus.failed, '传输失败');
      }
    });
  }

  Future<void> _copyAndReplaceOldCwd({
    void Function()? onSuccess,
    void Function(int errCode, Object errMsg)? onFailed,
  }) async {
    try {
      final local = await _getCwdAppBean(dialFaceName!);
      if (local != null) cwdAppBean = local;
      cwdAppBean?.select?.timeColorIndex = timeColorIndex;
      cwdAppBean?.select?.funcColorIndex = functionColorIndex;
      cwdAppBean?.select?.timeFuncLocation = timeFuncLocation;
      cwdAppBean?.select?.function = widgetTypeList.isEmpty
          ? [IDOPhotoDialWidgetFunction.weekDate]
          : widgetTypeList;
      if (cwdAppBean != null) {
        await _saveCwdAppBean(cwdAppBean!);
      }
      await processAfterInstall();
      await _persistImagesAfterInstall();
      onSuccess?.call();
    } catch (e) {
      saveDialLog('copyAndReplaceOldCwd failed: $e');
      onFailed?.call(IDOPhotoDialInstallStatus.failed, e);
    }
  }

  Future<IDOPhotoDialUiPreset?> _generateUiPreset() async {
    if (dialFaceName == null || cwdAppBean == null) return null;
    final colors = _resolveColorList();
    return IDOPhotoDialUiPreset(
      dialName: dialFaceName!,
      bg: await _WallpaperDialManager.deviceBackgroundImagePath(dialFaceName!),
      preview: await _WallpaperDialManager.devicePreviewImagePath(dialFaceName!),
      position: timeFuncLocation,
      supportPositions: List.from(locationValues),
      timeColor: _colorAt(colors, timeColorIndex),
      timeColorList: colors,
      supportFunctionType: _isSupportWallpaperFunction(),
      defaultFunctionType: selectedFunction,
      defaultFunctionWidgetColor: _colorAt(colors, functionColorIndex),
      supportFunctionTypeList: _functionValuesFromBean(),
      functionWidgetColorList: colors,
      supportFunctionColorSetting: _isSupportWallpaperFunctionColorSetting(),
      supportLocation: _isSupportWallpaperLocation(),
      supportColorSetting: _isSupportWallpaperSetting(),
      previewRadius: (rawAppJson?['previewRadius'] as num?)?.toDouble() ?? 16,
      screenCorner: (rawAppJson?['screen_corner'] as num?)?.toDouble() ?? 0,
      supportPreviewBorder: rawAppJson?['previewIsNeedBorder'] == true,
      previewBorderRadius:
          (rawAppJson?['previewBorderRadius'] as num?)?.toDouble() ?? 16,
      previewBorderWidth:
          (rawAppJson?['previewBorderWidth'] as num?)?.toDouble() ?? 16,
      previewBorderColor:
          rawAppJson?['previewBorderColor'] as String? ?? '#7F7F7F',
    );
  }

  void _parseFunctionConfig() {
    if (cwdAppBean == null) return;
    // 对齐 Android：只要有 app.json 就解析 locations，与 function_support 无关
    _parseLocationConfig();
    if (cwdAppBean!.functionSupportNew != 1 &&
        !_isSupportWallpaperFunction()) {
      return;
    }
    cwdColorList = cwdAppBean!.colors;
    if (cwdColorList == null || cwdColorList!.isEmpty) {
      cwdColorList = _readColorsFromRaw();
    }
    if (cwdColorList == null || cwdColorList!.isEmpty) {
      cwdColorList = _WallpaperDialManager.wallpaperColorList();
    }
    colorList = List.from(cwdColorList!);
    timeColorIndex = cwdAppBean!.select?.timeColorIndex ?? 0;
    functions.clear();
    if (cwdAppBean!.functionList != null) {
      functions.addAll(cwdAppBean!.functionList!);
      selectedFunction = _resolveSelectedFunction();
      functionColorIndex = cwdAppBean!.select?.funcColorIndex ?? 0;
    }
  }

  /// 对齐 Android [CwdAppBean.getLocationValues]：仅 app.json locations[].type
  void _parseLocationConfig() {
    if (cwdAppBean == null) return;
    locationValues
      ..clear()
      ..addAll(_locationValuesFromBean(cwdAppBean!));
    timeFuncLocation = cwdAppBean!.select?.timeFuncLocation ?? 0;
    if (timeFuncLocation == IDOPhotoDialWidgetPosition.invalid) {
      timeFuncLocation = locationValues.isNotEmpty
          ? locationValues.first
          : IDOPhotoDialWidgetPosition.rightTop;
    } else if (locationValues.isNotEmpty &&
        !locationValues.contains(timeFuncLocation)) {
      // select 指向包外位置时不追加进列表，回退到首个合法位置
      timeFuncLocation = locationValues.first;
    }
  }

  List<int> _locationValuesFromBean(IDOPhotoDialPresetConfig bean) {
    final values = <int>[];
    for (final loc in bean.locations ?? <IDODialJsonLocations>[]) {
      final type = loc.type ?? 0;
      if (type <= 0 || type == IDOPhotoDialWidgetPosition.invalid) continue;
      if (!values.contains(type)) values.add(type);
    }
    return values;
  }

  List<int> _functionValuesFromBean() {
    final values = <int>[];
    for (final func in cwdAppBean?.functionList ?? <IDOPhotoDialFunctionList>[]) {
      final id = func.function ?? 0;
      if (id <= 0 || !IDOPhotoDialWidgetFunction.all.contains(id)) continue;
      if (!values.contains(id)) values.add(id);
    }
    if (values.isNotEmpty) return values;
    return List.from(IDOPhotoDialWidgetFunction.all);
  }

  int _resolveSelectedFunction() {
    final sel = cwdAppBean!.select?.function;
    if (sel != null && sel.isNotEmpty) {
      final v = sel.first;
      if (v is int) return v;
      if (v is num) return v.toInt();
    }
    return IDOPhotoDialWidgetFunction.weekDate;
  }

  List<String> _resolveColorList() {
    if (isCwdSupportFunctionNew() &&
        cwdColorList != null &&
        cwdColorList!.isNotEmpty) {
      return cwdColorList!;
    }
    return _WallpaperDialManager.wallpaperColorList();
  }

  List<String>? _readColorsFromRaw() {
    final raw = rawAppJson?['colors'];
    if (raw is List) {
      return raw.map((e) => e.toString()).toList();
    }
    return null;
  }

  String _colorAt(List<String> list, int index) {
    if (index >= 0 && index < list.length) return list[index];
    return list.isNotEmpty ? list.first : '#FFFFFF';
  }

  IDODialJsonCloudWallpaper _cloudWallpaper() {
    final cw = cwdAppBean?.cloudWallpaper;
    if (cw != null) return cw;
    return IDODialJsonCloudWallpaper(0, 0, 0);
  }

  bool isCwdSupportFunctionNew() => cwdAppBean?.functionSupportNew == 1;

  /// 对齐 CommonPhotoDialDelegate.isSupportWallpaperFunction()
  bool _isSupportWallpaperFunction() =>
      (_cloudWallpaper().functionSupport ?? 0) == 1 ||
      isCwdSupportFunctionNew();

  /// 对齐 CommonPhotoDialDelegate.isSupportWallpaperFunctionColorSetting()
  bool _isSupportWallpaperFunctionColorSetting() =>
      _isSupportWallpaperFunction();

  /// 对齐 CommonPhotoDialDelegate.isSupportWallpaperLocation()
  bool _isSupportWallpaperLocation() =>
      (_cloudWallpaper().noSupportLocation ?? 0) == 0;

  /// 对齐 CommonPhotoDialDelegate.isSupportWallpaperSetting()
  bool _isSupportWallpaperSetting() =>
      (_cloudWallpaper().noSupportColors ?? 0) == 0;

  IDODialJsonLocations? getTimeFuncLocation() {
    final locs = cwdAppBean?.locations;
    if (locs == null) return null;
    for (final loc in locs) {
      if (loc.type == timeFuncLocation) return loc;
    }
    return null;
  }

  String getColor(int index) => _colorAt(_resolveColorList(), index);

  IDOPhotoDialFunctionList? findFunction(int func) {
    for (final f in functions) {
      if (f.function == func) return f;
    }
    return null;
  }

  void _initCwdConfig() {
    userConfig = null;
    functionColorIndex = -1;
    timeColorIndex = -1;
    timeFuncLocation = -1;
    widgetTypeList.clear();
    _interceptFailedCallback = false;
  }

  void _resetPrepareState() {
    cwdAppBean = null;
    rawAppJson = null;
    colorList = null;
    cwdColorList = null;
    locationValues.clear();
    functions.clear();
    functionColorIndex = 0;
    timeColorIndex = 0;
    timeFuncLocation = 0;
    selectedFunction = IDOPhotoDialWidgetFunction.weekDate;
    widgetTypeList.clear();
    _interceptFailedCallback = false;
  }

  Future<void> clearLocalDialResources(String dialName) async {
    if (dialName.isEmpty) return;
    saveDialLog('clearLocalDialResources: $dialName');
    await _WallpaperDialManager.clearLocalDialResources(dialName);
    if (dialFaceName == dialName) {
      _resetPrepareState();
    }
  }

  Future<void> _copyDialPackage(String dialName, String packagePath) async {
    final des = await _WallpaperDialManager.cwdPackFilePath(dialName);
    await _FileManager.createDirToDocument(path.dirname(des));
    await File(packagePath).copy(des);
  }

  Future<IDOPhotoDialPresetConfig?> _getCwdAppBean(String dialName) async {
    try {
      final jsonPath = await _WallpaperDialManager.resolveAppJsonPath(dialName);
      if (jsonPath == null || !File(jsonPath).existsSync()) {
        saveDialLog('getCwdAppBean: app.json not found for $dialName');
        return null;
      }
      final text = _WallpaperDialManager._normalizeJsonText(
        await File(jsonPath).readAsString(),
      );
      if (!text.startsWith('{') && !text.startsWith('[')) {
        final preview = text.length > 48 ? text.substring(0, 48) : text;
        saveDialLog('getCwdAppBean invalid json head at $jsonPath: $preview');
        return null;
      }
      rawAppJson = jsonDecode(text) as Map<String, dynamic>;
      return IDOPhotoDialPresetConfig.fromJson(rawAppJson!);
    } catch (e) {
      saveDialLog('getCwdAppBean error: $e');
      return null;
    }
  }

  Future<bool> _saveCwdAppBean(IDOPhotoDialPresetConfig bean) async {
    try {
      if (dialFaceName == null) return false;
      final jsonPath = await _WallpaperDialManager.appJsonPath(dialFaceName!);
      final map = rawAppJson ?? bean.toJson();
      map['select'] = bean.select?.toJson();
      await File(jsonPath).writeAsString(jsonEncode(map));
      return true;
    } catch (e) {
      saveDialLog('saveCwdAppBean error: $e');
      return false;
    }
  }

  Future<ui.Image?> _loadAndScaleImage(String src, int w, int h) async {
    final bytes = await File(src).readAsBytes();
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, completer.complete);
    final image = await completer.future;
    return IDOPhotoDialImageUtils.scale(image, ui.Size(w.toDouble(), h.toDouble()));
  }

  Future<String?> _saveScaledPng(ui.Image image, String outPath) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;
    await _FileManager.createDirToDocument(path.dirname(outPath));
    await File(outPath).writeAsBytes(byteData.buffer.asUint8List());
    return outPath;
  }
}
