part of dial_manager;

class _SifliPhotoDial extends _CommonPhotoDialDelegate {
  _SifliPhotoDial._();
  static final instance = _SifliPhotoDial._();

  static const _defaultSifliFontSize = 70;
  static const _defaultSifliShowType = 2;

  @override
  Future<void> replaceTempCwdImage() async {
    saveDialLog('replaceCwdImage start, userConfig = $userConfig');
    final config = userConfig;
    if (config == null) return;

    if (config.previewPicPath != null && config.previewPicPath!.isNotEmpty) {
      try {
        await _replaceSifliStylePreview(config.previewPicPath!);
      } catch (e) {
        saveDialLog('savePreview出错：$e');
        throw Exception('savePreview Failed：$e');
      }
    }

    if (config.bgPicPath != null && config.bgPicPath!.isNotEmpty) {
      try {
        await _replaceSifliStyleBackground(config.bgPicPath!);
      } catch (e) {
        saveDialLog('replaceCwrBgImageWithTemp出错：$e');
        throw Exception('replaceCwrBgImageWithTemp failed: $e');
      }
    }
    saveDialLog('replaceCwdImage end');
  }

  @override
  Future<void> replaceTempCwdConfig() async {
    var hasChanged = false;
    final bean = await _loadTempDialConfig();
    if (bean == null || bean.dialData.isEmpty) return;

    if (isCwdSupportFunctionNew()) {
      final location = getTimeFuncLocation();
      final selected = findFunction(selectedFunction);
      saveDialLog('replaceCwdConfig 支持功能编辑（思澈）');
      IDOPhotoDialFunctionCoordinate? functionCoordinate;
      if (location != null && selected != null) {
        for (final fc in location.functionCoordinate ?? <IDOPhotoDialFunctionCoordinate>[]) {
          if (fc.function == selectedFunction) {
            functionCoordinate = fc;
            break;
          }
        }
      }
      bean.posType = timeFuncLocation;
      if (location != null && selected != null) {
        _rebuildSifliDialDataForNewFunction(
          bean,
          location,
          selected,
          functionCoordinate,
        );
        hasChanged = true;
      }
    } else {
      final rgb = _WallpaperDialManager.hex2Rgb(getColor(timeColorIndex));
      if (bean.dialData.length > 2) {
        final item = bean.dialData[2];
        _applyRgbToDialRow(item, rgb);
        final loc = getTimeFuncLocation();
        if (loc?.week != null && loc!.week!.length >= 2) {
          item.x = loc.week![0];
          item.y = loc.week![1];
        }
        hasChanged = true;
      }
      if (bean.dialData.length > 3) {
        final item = bean.dialData[3];
        _applyRgbToDialRow(item, rgb);
        final loc = getTimeFuncLocation();
        if (loc?.time != null && loc!.time!.length >= 2) {
          item.x = loc.time![0];
          item.y = loc.time![1];
        }
        hasChanged = true;
      }
    }

    if (hasChanged) {
      await _saveTempDialConfig(bean);
    }
  }

  @override
  Future<String> packCwdPackage() async {
    if (dialFaceName == null) return '';
    return _WallpaperDialManager.packTempCwdPackageBySifli(dialFaceName!);
  }

  Future<IDOCwdDialConfigBean?> _loadTempDialConfig() async {
    try {
      final p = await _WallpaperDialManager.deviceTempConfigJsonPath();
      if (!File(p).existsSync()) return null;
      final text = await File(p).readAsString();
      return IDOCwdDialConfigBean.fromJson(jsonDecode(text) as Map<String, dynamic>);
    } catch (e) {
      saveDialLog('loadTempDialConfig error: $e');
      return null;
    }
  }

  Future<bool> _saveTempDialConfig(IDOCwdDialConfigBean data) async {
    final p = await _WallpaperDialManager.deviceTempConfigJsonPath();
    await File(p).writeAsString(jsonEncode(data.toJson()));
    return true;
  }

  bool _isSifliDialAssetRow(IDODialDataBean row) {
    if (row.wtype == 1 || row.wtype == 2 || row.wtype == 10) return true;
    final f = (row.file ?? '').toLowerCase();
    if (row.dtype == 0 && f.isNotEmpty) {
      return f == 'preview.bin' || f == 'background.bin' || f == 'video.h264';
    }
    return false;
  }

  void _applyRgbToDialRow(IDODialDataBean row, List<int>? rgb) {
    if (rgb == null || rgb.length < 3) return;
    row.r = rgb[0];
    row.g = rgb[1];
    row.b = rgb[2];
  }

  void _rebuildSifliDialDataForNewFunction(
    IDOCwdDialConfigBean bean,
    IDODialJsonLocations location,
    IDOPhotoDialFunctionList selectedFunction,
    IDOPhotoDialFunctionCoordinate? functionCoordinate,
  ) {
    final assets =
        bean.dialData.where(_isSifliDialAssetRow).toList(growable: true);
    final timeRgb = _WallpaperDialManager.hex2Rgb(getColor(timeColorIndex));
    final funcRgb = _WallpaperDialManager.hex2Rgb(getColor(functionColorIndex));
    final widgets =
        bean.dialData.where((e) => !_isSifliDialAssetRow(e)).toList();
    var wtype = 9;
    var user = 1;
    if (widgets.isNotEmpty) {
      wtype = widgets.first.wtype;
      user = widgets.first.user;
    }

    final dynamic = <IDODialDataBean>[];
    for (final tw in location.timeWidget ?? <Map>[]) {
      final type = tw['type']?.toString() ?? '';
      final widget = tw['widget']?.toString() ?? '';
      final dtype = _mapAppComponentToDialDtype(type, widget);
      if (dtype == null) continue;
      dynamic.add(_mkDialDataRow(
        user,
        wtype,
        dtype,
        (tw['x'] as num?)?.toInt() ?? 0,
        (tw['y'] as num?)?.toInt() ?? 0,
        (tw['w'] as num?)?.toInt() ?? 0,
        (tw['h'] as num?)?.toInt() ?? 0,
        (tw['font_size'] as num?)?.toInt() ?? _defaultSifliFontSize,
        (tw['show_type'] as num?)?.toInt() ?? _defaultSifliShowType,
        timeRgb,
      ));
    }

    for (final funcItem in selectedFunction.item) {
      final type = funcItem['type']?.toString() ?? '';
      final widget = funcItem['widget']?.toString() ?? '';
      if (type.toLowerCase() == 'small_icon') continue;
      IDOPhotoDialFunctionCoordinateItem? coordItem;
      for (final item in functionCoordinate?.item ?? <IDOPhotoDialFunctionCoordinateItem>[]) {
        if (item.type == type && item.widget == widget) {
          coordItem = item;
          break;
        }
      }
      final c = coordItem?.coordinate;
      if (c == null || c.length < 4) continue;
      final dtype = _mapAppComponentToDialDtype(type, widget);
      if (dtype == null) continue;
      dynamic.add(_mkDialDataRow(
        user,
        wtype,
        dtype,
        c[0],
        c[1],
        c[2],
        c[3],
        _defaultSifliFontSize,
        _defaultSifliShowType,
        funcRgb,
      ));
    }

    bean.dialData
      ..clear()
      ..addAll(assets)
      ..addAll(dynamic);
  }

  IDODialDataBean _mkDialDataRow(
    int user,
    int wtype,
    int dtype,
    int x,
    int y,
    int w,
    int h,
    int font,
    int showType,
    List<int>? rgb,
  ) {
    return IDODialDataBean(
      user: user,
      wtype: wtype,
      dtype: dtype,
      x: x,
      y: y,
      w: w,
      h: h,
      fontSize: font,
      showType: showType,
      r: rgb?.elementAtOrNull(0) ?? 255,
      g: rgb?.elementAtOrNull(1) ?? 255,
      b: rgb?.elementAtOrNull(2) ?? 255,
    );
  }

  int? _mapAppComponentToDialDtype(String type, String widget) {
    final t = type.toLowerCase();
    switch (t) {
      case 'hour':
        return IDODialDataType.hour;
      case 'min':
        return IDODialDataType.minute;
      case 'time':
        return IDODialDataType.hm;
      case 'week':
        return IDODialDataType.week;
      case 'day':
        return IDODialDataType.day;
      case 'step':
        return IDODialDataType.dayStep;
      case 'distance':
        return IDODialDataType.dayDistance;
      case 'calorie':
        return IDODialDataType.dayKcal;
      case 'heartrate':
        return IDODialDataType.hrvalLast;
      case 'battery':
        return IDODialDataType.batteryWithBar;
      default:
        return null;
    }
  }
}

extension _ListExtOrNull<T> on List<T> {
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }
}
