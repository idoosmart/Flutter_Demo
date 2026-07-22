part of dial_manager;

class _ActionsPhotoDial extends _CommonPhotoDialDelegate {
  _ActionsPhotoDial._();
  static final instance = _ActionsPhotoDial._();

  @override
  Future<void> replaceTempCwdImage() async {
    saveDialLog('replaceCwdImage start, userConfig = $userConfig');
    final config = userConfig;
    if (config == null) return;

    final iwf = await _loadTempIwfMap();

    if (config.previewPicPath != null && config.previewPicPath!.isNotEmpty) {
      try {
        await _replaceActionsStylePreview(config.previewPicPath!, iwf);
      } catch (e) {
        saveDialLog('savePreview出错：$e');
        throw Exception('savePreview Failed：$e');
      }
    }

    final imageTempPath = config.bgPicPath ?? '';
    saveDialLog('convertImage2Bmp start imageTempPath = $imageTempPath');
    if (imageTempPath.isEmpty) {
      saveDialLog('the image temp path is empty!');
      throw Exception('the image temp path is empty!');
    }

    if (config.bgPicPath != null && config.bgPicPath!.isNotEmpty) {
      try {
        await _replaceActionsStyleBackground(config.bgPicPath!, iwf);
      } catch (e) {
        saveDialLog('replaceCwrBgImageWithTemp出错：$e');
        throw Exception('replaceCwrBgImageWithTemp failed: $e');
      }
    }
    saveDialLog('replaceCwdImage end');
  }

  @override
  Future<void> replaceTempCwdConfig() async {
    final iwf = await _loadTempIwfMap();
    if (iwf == null) return;
    final items = (iwf['item'] as List?)?.cast<Map>() ?? [];
    if (items.isEmpty) return;

    final location = getTimeFuncLocation();
    final selected = findFunction(selectedFunction);
    final timeColor = _WallpaperDialManager.colorTo16(getColor(timeColorIndex));
    final funcColor =
        _WallpaperDialManager.colorTo16(getColor(functionColorIndex));
    var hasChanged = false;

    if (isCwdSupportFunctionNew()) {
      IDOPhotoDialFunctionCoordinate? functionCoordinate;
      if (location != null && selected != null) {
        for (final fc in location.functionCoordinate ?? <IDOPhotoDialFunctionCoordinate>[]) {
          if (fc.function == selectedFunction) {
            functionCoordinate = fc;
            break;
          }
        }
      }

      items.removeWhere((item) {
        for (final fn in functions) {
          for (final fi in fn.item) {
            if (item['type'] == fi['type'] && item['widget'] == fi['widget']) {
              return true;
            }
          }
        }
        final type = item['type']?.toString() ?? '';
        final widget = item['widget']?.toString() ?? '';
        return cwdAppBean?.findTimeWidgetItem(type, widget) ?? false;
      });

      if (functionCoordinate != null && selected != null) {
        for (final funcItem in selected.item) {
          final type = funcItem['type']?.toString() ?? '';
          final widget = funcItem['widget']?.toString() ?? '';
          IDOPhotoDialFunctionCoordinateItem? coordItem;
          for (final c in functionCoordinate.item) {
            if (c.type == type && c.widget == widget) {
              coordItem = c;
              break;
            }
          }
          if (coordItem == null || coordItem.coordinate.length < 4) continue;
          final c = coordItem.coordinate;
          items.add({
            'bg': funcItem['bg'] ?? '',
            'fgcolor': funcColor,
            'fgrender': '',
            'font': funcItem['font'] ?? '',
            'fontnum': funcItem['fontnum'] ?? 0,
            'h': c[3],
            'type': type,
            'w': c[2],
            'widget': widget,
            'compress': '',
            'x': c[0],
            'y': c[1],
            'align': funcItem['align'],
            'bgcolor': funcColor,
          });
        }
      }

      final timeWidgets = location?.timeWidget ?? [];
      for (final tw in timeWidgets) {
        items.add(_timeWidgetToIwfItem(tw, timeColor, iwf));
      }
      hasChanged = true;
    } else {
      for (final item in items) {
        final type = item['type']?.toString();
        if (type == IDOPhotoDialIwfItemType.time) {
          item['fgcolor'] = timeColor;
          if (iwf['deployFgRender'] == 1) item['fgrender'] = timeColor;
          if (location?.time != null && location!.time!.length >= 2) {
            item['x'] = location.time![0];
            item['y'] = location.time![1];
          }
          hasChanged = true;
        } else if (type == IDOPhotoDialIwfItemType.day) {
          item['fgcolor'] = funcColor;
          if (iwf['deployFgRender'] == 1) item['fgrender'] = funcColor;
          if (location?.day != null && location!.day!.length >= 2) {
            item['x'] = location.day![0];
            item['y'] = location.day![1];
          }
          hasChanged = true;
        } else if (type == IDOPhotoDialIwfItemType.week) {
          item['fgcolor'] = funcColor;
          if (iwf['deployFgRender'] == 1) item['fgrender'] = funcColor;
          if (location?.week != null && location!.week!.length >= 2) {
            item['x'] = location.week![0];
            item['y'] = location.week![1];
          }
          hasChanged = true;
        }
      }
    }

    if (hasChanged) {
      iwf['item'] = items;
      await _saveTempIwf(iwf);
    }
  }

  @override
  Future<String> packCwdPackage() async {
    if (dialFaceName == null) return '';
    final ok = await _WallpaperDialManager.packTempCwdPackage(dialFaceName!);
    return ok ? await _WallpaperDialManager.tempZipPath() : '';
  }

  @override
  Future<void> processAfterInstall() async {
    try {
      final tempZip = await _WallpaperDialManager.tempZipPath();
      final devicePack =
          await _WallpaperDialManager.deviceCwdPackPath(dialFaceName!);
      await _WallpaperDialManager.copyFile(tempZip, devicePack);
    } catch (e) {
      saveDialLog('processAfterInstall error: $e');
    }
  }

  Future<Map<String, dynamic>?> _loadTempIwfMap() async {
    try {
      final p = await _WallpaperDialManager.deviceTempJsonPath();
      if (!File(p).existsSync()) return null;
      return jsonDecode(await File(p).readAsString()) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  Future<bool> _saveTempIwf(Map<String, dynamic> data) async {
    final p = await _WallpaperDialManager.deviceTempJsonPath();
    await File(p).writeAsString(jsonEncode(data));
    return true;
  }

  Map<String, dynamic> _timeWidgetToIwfItem(
    Map tw,
    String color,
    Map<String, dynamic> iwf,
  ) {
    return {
      'bg': tw['bg'] ?? '',
      'fgcolor': color,
      'fgrender': iwf['deployFgRender'] == 1 ? color : '',
      'font': tw['font'] ?? '',
      'fontnum': tw['fontnum'] ?? 0,
      'h': tw['h'] ?? 0,
      'type': tw['type'] ?? '',
      'w': tw['w'] ?? 0,
      'widget': tw['widget'] ?? '',
      'compress': '',
      'x': tw['x'] ?? 0,
      'y': tw['y'] ?? 0,
      'align': tw['align'],
      'bgcolor': color,
    };
  }
}

extension _PhotoDialAppExt on IDOPhotoDialPresetConfig {
  bool findTimeWidgetItem(String type, String widget) {
    for (final loc in locations ?? <IDODialJsonLocations>[]) {
      for (final tw in loc.timeWidget ?? <Map>[]) {
        if (tw['type'] == type && tw['widget'] == widget) return true;
      }
    }
    for (final tw in timeWidgetList ?? <IDOPhotoDialTimeWidgetListItem>[]) {
      if (tw.type == type && tw.widget == widget) return true;
    }
    return false;
  }
}
