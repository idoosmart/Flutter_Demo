part of '../utils_manager.dart';

class _UtilsMakeDial {
  static const int _preview = 0x01;
  static const int _background = 0x02;
  static const int _month = 0x07;
  static const int _day = 0x08;
  static const int _hour = 0x09;
  static const int _minute = 0x0A;
  static const int _amPm = 0x0C;
  static const int _icon = 0x16;
  static const int _week = 0x0D;

  static const String _keyHour = 'KEYHOUR';
  static const String _keyMinute = 'KEYMINUTE';
  static const String _keyTimeDelimiter = 'KEYTIME_DELIMITER';
  static const String _keyDay = 'KEYDAY';
  static const String _keyMonth = 'KEYMONTH';
  static const String _keyDateDelimiter = 'KEYDATE_DELIMITER';
  static const String _keyWeek = 'KEYWEEK';
  static const String _keyAmPm = 'KEYAMPM';

  /// 生成自定义表盘文件
  static Future<bool> toDialFile({
    required String dialFilePath,
    String? bgPath,
    String? previewPath,
    required int color,
    required String baseBinPath,
  }) async {
    try {
      final binFile = File(baseBinPath);
      if (!await binFile.exists()) {
        logger?.d('JieLi - 基础bin文件不存在: $baseBinPath');
        return false;
      }
      final binData = await binFile.readAsBytes();

      if (bgPath == null || bgPath.isEmpty) {
        logger?.d('JieLi - 背景图路径为空');
        return false;
      }
      final bgFile = File(bgPath);
      if (!await bgFile.exists()) {
        logger?.d('JieLi - 背景图文件不存在: $bgPath');
        return false;
      }
      final bgBytes = await bgFile.readAsBytes();
      final bgImage = img.decodeImage(bgBytes);
      if (bgImage == null) {
        logger?.d('JieLi - 背景图解码失败');
        return false;
      }

      img.Image? textImage;
      if (previewPath != null && previewPath.isNotEmpty) {
        final previewFile = File(previewPath);
        if (await previewFile.exists()) {
          final previewBytes = await previewFile.readAsBytes();
          textImage = img.decodeImage(previewBytes);
        }
      }

      final dialData = _getCustomDialData(
        bgImage: bgImage,
        textImage: textImage,
        setColor: color,
        binData: binData,
      );

      if (dialData == null || dialData.isEmpty) {
        logger?.d('JieLi - 表盘数据生成失败');
        return false;
      }

      final tempFile = await _createTempFile(dialFilePath);
      await tempFile.writeAsBytes(dialData);

      final success = await _moveTempToTarget(tempFile, dialFilePath);
      if (!success) {
        await _cleanupTempFile(tempFile);
        return false;
      }

      logger?.d('JieLi - 自定义表盘生成完成，$dialFilePath');
      return true;
    } catch (e, stack) {
      logger?.d('JieLi - 自定义表盘生成失败: $e\n$stack');
      return false;
    }
  }

  static Uint8List? _getCustomDialData({
    required img.Image bgImage,
    img.Image? textImage,
    required int setColor,
    required Uint8List binData,
  }) {
    try {
      final stream = BytesBuilder();
      final dataMap = _parseBaseBin(binData, setColor);

      int imageTotalCount = 2;
      for (final element in dataMap.values) {
        imageTotalCount += element.imageCount;
      }
      final int elementCount = dataMap.length + 2;

      // 头部（小端模式）
      final header = Uint8List(4);
      header[0] = imageTotalCount & 0xFF;
      header[1] = (imageTotalCount >> 8) & 0xFF;
      header[2] = elementCount;
      header[3] = 2;
      stream.add(header);

      int tIndex = 0;
      final sizeList = <int>[];
      int imageDataBeforeSize = 4 + 20 * elementCount + imageTotalCount * 4;

      // 预览图
      final thumbBean = _getPreviewDataBean(bgImage, textImage, setColor);
      thumbBean.type = _preview;
      thumbBean.offset = imageDataBeforeSize;
      thumbBean.index = tIndex;
      thumbBean.anchor = 0;
      thumbBean.compression = 0;
      sizeList.add(thumbBean.size);
      stream.add(_writeElement(thumbBean));
      tIndex += thumbBean.imageCount;
      imageDataBeforeSize += thumbBean.size * thumbBean.imageCount;

      // 背景图
      final backgroundBean = _getDataBean(bgImage);
      backgroundBean.type = _background;
      backgroundBean.offset = imageDataBeforeSize;
      backgroundBean.index = tIndex;
      backgroundBean.compression = 0;
      sizeList.add(backgroundBean.size);
      stream.add(_writeElement(backgroundBean));
      tIndex += backgroundBean.imageCount;
      imageDataBeforeSize += backgroundBean.size * backgroundBean.imageCount;

      // 按顺序处理各元素
      final elementOrder = [
        _keyHour,
        _keyMinute,
        _keyWeek,
        _keyDay,
        _keyDateDelimiter,
        _keyMonth,
        _keyTimeDelimiter,
        _keyAmPm,
      ];

      for (final key in elementOrder) {
        final bean = dataMap[key];
        if (bean != null) {
          bean.offset = imageDataBeforeSize;
          bean.index = tIndex;
          bean.compression = 0;
          for (int i = 0; i < bean.imageCount; i++) {
            sizeList.add(bean.size);
          }
          stream.add(_writeElement(bean));
          tIndex += bean.imageCount;
          imageDataBeforeSize += bean.size * bean.imageCount;
        }
      }

      // 写入图片大小列表（小端模式）
      stream.add(_writeImageSize(sizeList));

      // 写入图片数据
      stream.add(thumbBean.dataList[0]);
      stream.add(backgroundBean.dataList[0]);

      for (final key in elementOrder) {
        final bean = dataMap[key];
        if (bean != null) {
          for (int n = 0; n < bean.imageCount; n++) {
            stream.add(bean.dataList[n]);
          }
        }
      }

      return stream.toBytes();
    } catch (e, stack) {
      logger?.d('JieLi - 生成表盘数据失败: $e\n$stack');
      return null;
    }
  }

  static Map<String, _Element> _parseBaseBin(Uint8List binData, int hexColor) {
    int tOffset = 100;

    // 时间数字图片
    final hourModel = _Element()..type = _hour;
    final minuteModel = _Element()..type = _minute;

    hourModel.width = _readUInt16LE(binData, tOffset);
    minuteModel.width = hourModel.width;
    tOffset += 2;

    hourModel.height = _readUInt16LE(binData, tOffset);
    minuteModel.height = hourModel.height;
    tOffset += 2;

    hourModel.dataList = [];
    minuteModel.dataList = [];
    hourModel.imageCount = 10;
    minuteModel.imageCount = 10;

    for (int n = 0; n < 10; n++) {
      final fourBytes = _readUInt32LE(binData, tOffset);
      tOffset += 4;

      final rawData = binData.sublist(tOffset, tOffset + fourBytes);
      tOffset += fourBytes;

      final bitmap = img.decodeImage(rawData);
      if (bitmap != null) {
        final dest = _replaceColorPix(hexColor, bitmap);
        final data = _getBitmapAlphaPix(dest);
        hourModel.size = data.length;
        minuteModel.size = data.length;
        hourModel.dataList.add(data);
        minuteModel.dataList.add(data);
      }
    }

    // 时间分隔符图片
    final timeSeparatorModel = _Element()..type = _icon;
    timeSeparatorModel.width = _readUInt16LE(binData, tOffset);
    tOffset += 2;
    timeSeparatorModel.height = _readUInt16LE(binData, tOffset);
    tOffset += 2;
    timeSeparatorModel.dataList = [];
    timeSeparatorModel.imageCount = 1;

    int fourBytes = _readUInt32LE(binData, tOffset);
    tOffset += 4;
    var rawData = binData.sublist(tOffset, tOffset + fourBytes);
    tOffset += fourBytes;

    var bitmap = img.decodeImage(rawData);
    if (bitmap != null) {
      final dest = _replaceColorPix(hexColor, bitmap);
      final data = _getBitmapAlphaPix(dest);
      timeSeparatorModel.size = data.length;
      timeSeparatorModel.dataList.add(data);
    }

    // 日期数字图片
    final dayModel = _Element()..type = _day;
    final monthModel = _Element()..type = _month;

    dayModel.width = _readUInt16LE(binData, tOffset);
    monthModel.width = dayModel.width;
    tOffset += 2;

    dayModel.height = _readUInt16LE(binData, tOffset);
    monthModel.height = dayModel.height;
    tOffset += 2;

    dayModel.dataList = [];
    monthModel.dataList = [];
    dayModel.imageCount = 10;
    monthModel.imageCount = 10;

    for (int n = 0; n < 10; n++) {
      fourBytes = _readUInt32LE(binData, tOffset);
      tOffset += 4;

      final dayRawData = binData.sublist(tOffset, tOffset + fourBytes);
      tOffset += fourBytes;

      final dayBitmap = img.decodeImage(dayRawData);
      if (dayBitmap != null) {
        final dest = _replaceColorPix(hexColor, dayBitmap);
        final dayData = _getBitmapAlphaPix(dest);
        dayModel.size = dayData.length;
        monthModel.size = dayData.length;
        dayModel.dataList.add(dayData);
        monthModel.dataList.add(dayData);
      }
    }

    // 日期分隔符图片
    final dateSeparatorModel = _Element()..type = _icon;
    dateSeparatorModel.width = _readUInt16LE(binData, tOffset);
    tOffset += 2;
    dateSeparatorModel.height = _readUInt16LE(binData, tOffset);
    tOffset += 2;
    dateSeparatorModel.dataList = [];
    dateSeparatorModel.imageCount = 1;

    fourBytes = _readUInt32LE(binData, tOffset);
    tOffset += 4;
    final dateSeparatorData = binData.sublist(tOffset, tOffset + fourBytes);
    tOffset += fourBytes;

    final dateBitmap = img.decodeImage(dateSeparatorData);
    if (dateBitmap != null) {
      final dateDest = _replaceColorPix(hexColor, dateBitmap);
      final dateData = _getBitmapAlphaPix(dateDest);
      dateSeparatorModel.size = dateData.length;
      dateSeparatorModel.dataList.add(dateData);
    }

    // 星期图片
    final weekModel = _Element()..type = _week;
    weekModel.width = _readUInt16LE(binData, tOffset);
    tOffset += 2;
    weekModel.height = _readUInt16LE(binData, tOffset);
    tOffset += 2;
    weekModel.dataList = [];
    weekModel.imageCount = 7;

    for (int n = 0; n < 7; n++) {
      fourBytes = _readUInt32LE(binData, tOffset);
      tOffset += 4;

      final weekRawData = binData.sublist(tOffset, tOffset + fourBytes);
      tOffset += fourBytes;

      final weekBitmap = img.decodeImage(weekRawData);
      if (weekBitmap != null) {
        final weekDest = _replaceColorPix(hexColor, weekBitmap);
        final weekData = _getBitmapAlphaPix(weekDest);
        weekModel.size = weekData.length;
        weekModel.dataList.add(weekData);
      }
    }

    // 上/下午图片
    final halfDayModel = _Element()..type = _amPm;
    halfDayModel.width = _readUInt16LE(binData, tOffset);
    tOffset += 2;
    halfDayModel.height = _readUInt16LE(binData, tOffset);
    tOffset += 2;
    halfDayModel.dataList = [];
    halfDayModel.imageCount = 2;

    for (int n = 0; n < 2; n++) {
      fourBytes = _readUInt32LE(binData, tOffset);
      tOffset += 4;

      final halfDayRawData = binData.sublist(tOffset, tOffset + fourBytes);
      tOffset += fourBytes;

      final halfDayBitmap = img.decodeImage(halfDayRawData);
      if (halfDayBitmap != null) {
        final halfDayDest = _replaceColorPix(hexColor, halfDayBitmap);
        final halfDayData = _getBitmapAlphaPix(halfDayDest);
        halfDayModel.size = halfDayData.length;
        halfDayModel.dataList.add(halfDayData);
      }
    }

    // 读取位置信息（iOS 读取为 UInt16，但判断时用 != -1）
    // 所以我们读取为 UInt16，然后判断 != 0xFFFF
    hourModel.x = _readUInt16LE(binData, tOffset);
    tOffset += 2;
    hourModel.y = _readUInt16LE(binData, tOffset);
    tOffset += 2;

    timeSeparatorModel.x = _readUInt16LE(binData, tOffset);
    tOffset += 2;
    timeSeparatorModel.y = _readUInt16LE(binData, tOffset);
    tOffset += 2;

    minuteModel.x = _readUInt16LE(binData, tOffset);
    tOffset += 2;
    minuteModel.y = _readUInt16LE(binData, tOffset);
    tOffset += 2;

    monthModel.x = _readUInt16LE(binData, tOffset);
    tOffset += 2;
    monthModel.y = _readUInt16LE(binData, tOffset);
    tOffset += 2;

    dateSeparatorModel.x = _readUInt16LE(binData, tOffset);
    tOffset += 2;
    dateSeparatorModel.y = _readUInt16LE(binData, tOffset);
    tOffset += 2;

    dayModel.x = _readUInt16LE(binData, tOffset);
    tOffset += 2;
    dayModel.y = _readUInt16LE(binData, tOffset);
    tOffset += 2;

    weekModel.x = _readUInt16LE(binData, tOffset);
    tOffset += 2;
    weekModel.y = _readUInt16LE(binData, tOffset);
    tOffset += 2;

    halfDayModel.x = _readUInt16LE(binData, tOffset);
    tOffset += 2;
    halfDayModel.y = _readUInt16LE(binData, tOffset);
    tOffset += 2;

    // 构建结果 Map
    // iOS 判断是 != -1，但由于读取的是 UInt16，只有 0xFFFF 转为 int 后仍是 65535
    // 实际上 iOS 的判断可能是历史遗留，我们按 0xFFFF 判断更准确
    final dataMap = <String, _Element>{};

    // 注意：iOS 中 -1 作为 int 是 0xFFFFFFFF，UInt16 的 0xFFFF 是 65535
    // 由于 iOS 从 UInt16 读取后赋值给可能是 int 的属性，65535 != -1 总是 true
    // 所以实际上所有读取到的坐标都会被使用
    // 但为了安全起见，我们仍然检查 0xFFFF
    if (_isValidCoord(hourModel.x) && _isValidCoord(hourModel.y)) {
      dataMap[_keyHour] = hourModel;
    }
    if (_isValidCoord(minuteModel.x) && _isValidCoord(minuteModel.y)) {
      dataMap[_keyMinute] = minuteModel;
    }
    if (_isValidCoord(timeSeparatorModel.x) && _isValidCoord(timeSeparatorModel.y)) {
      dataMap[_keyTimeDelimiter] = timeSeparatorModel;
    }
    if (_isValidCoord(dayModel.x) && _isValidCoord(dayModel.y)) {
      dataMap[_keyDay] = dayModel;
    }
    if (_isValidCoord(monthModel.x) && _isValidCoord(monthModel.y)) {
      dataMap[_keyMonth] = monthModel;
    }
    if (_isValidCoord(dateSeparatorModel.x) && _isValidCoord(dateSeparatorModel.y)) {
      dataMap[_keyDateDelimiter] = dateSeparatorModel;
    }
    if (_isValidCoord(weekModel.x) && _isValidCoord(weekModel.y)) {
      dataMap[_keyWeek] = weekModel;
    }
    if (_isValidCoord(halfDayModel.x) && _isValidCoord(halfDayModel.y)) {
      dataMap[_keyAmPm] = halfDayModel;
    }

    return dataMap;
  }

  /// 判断坐标是否有效（模拟 iOS 的 != -1 判断）
  static bool _isValidCoord(int coord) {
    // iOS 读取 UInt16 后判断 != -1
    // 由于 UInt16 范围是 0-65535，所以这个判断在 iOS 中总是 true
    // 除非属性的默认值是 -1 且没有被赋值
    // 但在我们的实现中，坐标总是会被赋值的
    // 为了兼容性，我们检查 0xFFFF (65535)
    return coord != 0xFFFF && coord != 65535;
  }

  static _Element _getPreviewDataBean(
      img.Image bgImage, img.Image? textImage, int color) {
    final element = _Element();
    element.imageCount = 1;
    element.dataList = [];

    final composedImage = _composeImage(bgImage, textImage, color);
    final scaledImage = _scaleImage(
      composedImage,
      _Constants.previewWidth,
      _Constants.previewHeight,
    );

    element.width = scaledImage.width;
    element.height = scaledImage.height;

    final data = _getBitmapAlphaPix(scaledImage);
    element.size = data.length;
    element.dataList.add(data);

    return element;
  }

  static _Element _getDataBean(img.Image bgImage) {
    final element = _Element();
    element.imageCount = 1;
    element.dataList = [];

    element.width = bgImage.width;
    element.height = bgImage.height;

    final data = _getBitmapAlphaPix(bgImage);
    element.size = data.length;
    element.dataList.add(data);

    return element;
  }

  /// RGB24 转 RGB16（与 iOS 完全一致）
  static int _rgb24ToRgb16(int r, int g, int b) {
    return (((r >> 3) << 11) | ((g >> 2) << 5) | (b >> 3));
  }

  /// 获取带 alpha 的 RGB565 图片数据（与 iOS 完全一致）
  static Uint8List _getBitmapAlphaPix(img.Image image) {
    // 确保是 RGBA8 格式
    final src = _ensureRGBA8(image);

    final width = src.width;
    final height = src.height;

    // 计算行字节数并对齐到 4 字节
    int lineSize = width * 3;
    lineSize = ((lineSize + 3) ~/ 4) * 4;

    final resultData = Uint8List(lineSize * height);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = src.getPixel(x, y);

        // 获取 RGBA 分量
        final int red = pixel.r.toInt() & 0xFF;
        final int green = pixel.g.toInt() & 0xFF;
        final int blue = pixel.b.toInt() & 0xFF;
        final int alpha = pixel.a.toInt() & 0xFF;

        // RGB565 转换
        final int color = _rgb24ToRgb16(red, green, blue);

        // 写入：Alpha, RGB565高字节, RGB565低字节
        final int resultIndex = y * lineSize + x * 3;
        resultData[resultIndex] = alpha;
        resultData[resultIndex + 1] = (color >> 8) & 0xFF;
        resultData[resultIndex + 2] = color & 0xFF;
      }
    }

    return resultData;
  }

  /// 颜色替换（与 iOS 完全一致）
  static img.Image _replaceColorPix(int hexColor, img.Image src) {
    final normalizedSrc = _ensureRGBA8(src);

    final width = normalizedSrc.width;
    final height = normalizedSrc.height;

    final result = img.Image(
      width: width,
      height: height,
      format: img.Format.uint8,
      numChannels: 4,
    );

    final int red = (hexColor >> 16) & 0xFF;
    final int green = (hexColor >> 8) & 0xFF;
    final int blue = hexColor & 0xFF;

    // iOS 的循环顺序是 for y ... for x
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = normalizedSrc.getPixel(x, y);
        final int pixelAlpha = pixel.a.toInt() & 0xFF;

        if (pixelAlpha > 0) {
          result.setPixelRgba(x, y, red, green, blue, pixelAlpha);
        } else {
          result.setPixelRgba(x, y, 0, 0, 0, 0);
        }
      }
    }

    return result;
  }

  /// 合成图片
  static img.Image _composeImage(
      img.Image bgImage, img.Image? textImage, int color) {
    final normalizedBg = _ensureRGBA8(bgImage);

    final width = normalizedBg.width;
    final height = normalizedBg.height;

    final result = img.Image(
      width: width,
      height: height,
      format: img.Format.uint8,
      numChannels: 4,
    );

    // 复制背景
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = normalizedBg.getPixel(x, y);
        result.setPixelRgba(
          x, y,
          pixel.r.toInt() & 0xFF,
          pixel.g.toInt() & 0xFF,
          pixel.b.toInt() & 0xFF,
          pixel.a.toInt() & 0xFF,
        );
      }
    }

    // 叠加文字图
    if (textImage != null) {
      final coloredText = _replaceColorPix(color, textImage);

      final minW = coloredText.width < width ? coloredText.width : width;
      final minH = coloredText.height < height ? coloredText.height : height;

      for (int y = 0; y < minH; y++) {
        for (int x = 0; x < minW; x++) {
          final srcPixel = coloredText.getPixel(x, y);
          final int srcA = srcPixel.a.toInt() & 0xFF;

          if (srcA == 0) continue;

          final int srcR = srcPixel.r.toInt() & 0xFF;
          final int srcG = srcPixel.g.toInt() & 0xFF;
          final int srcB = srcPixel.b.toInt() & 0xFF;

          if (srcA == 255) {
            result.setPixelRgba(x, y, srcR, srcG, srcB, 255);
          } else {
            final dstPixel = result.getPixel(x, y);
            final int dstR = dstPixel.r.toInt() & 0xFF;
            final int dstG = dstPixel.g.toInt() & 0xFF;
            final int dstB = dstPixel.b.toInt() & 0xFF;
            final int dstA = dstPixel.a.toInt() & 0xFF;

            final int outA = srcA + ((dstA * (255 - srcA)) ~/ 255);
            if (outA == 0) {
              result.setPixelRgba(x, y, 0, 0, 0, 0);
            } else {
              final int outR = ((srcR * srcA) + (dstR * dstA * (255 - srcA) ~/ 255)) ~/ outA;
              final int outG = ((srcG * srcA) + (dstG * dstA * (255 - srcA) ~/ 255)) ~/ outA;
              final int outB = ((srcB * srcA) + (dstB * dstA * (255 - srcA) ~/ 255)) ~/ outA;

              result.setPixelRgba(
                x, y,
                outR.clamp(0, 255),
                outG.clamp(0, 255),
                outB.clamp(0, 255),
                outA.clamp(0, 255),
              );
            }
          }
        }
      }
    }

    return result;
  }

  static img.Image _scaleImage(img.Image image, int widthSize, int heightSize) {
    final scaled = img.copyResize(
      image,
      width: widthSize,
      height: heightSize,
      interpolation: img.Interpolation.linear,
    );
    return _ensureRGBA8(scaled);
  }

  static img.Image _ensureRGBA8(img.Image src) {
    if (src.numChannels == 4 && src.format == img.Format.uint8) {
      return src;
    }
    return src.convert(format: img.Format.uint8, numChannels: 4);
  }

  /// 写入图片大小列表（小端模式）
  static Uint8List _writeImageSize(List<int> list) {
    final sizeList = Uint8List(list.length * 4);
    int i = 0;
    for (final value in list) {
      sizeList[i++] = value & 0xFF;
      sizeList[i++] = (value >> 8) & 0xFF;
      sizeList[i++] = (value >> 16) & 0xFF;
      sizeList[i++] = (value >> 24) & 0xFF;
    }
    return sizeList;
  }

  /// 写入元素数据（小端模式）
  static Uint8List _writeElement(_Element bean) {
    final data = Uint8List(20);

    // offset (4 bytes, little-endian)
    data[0] = bean.offset & 0xFF;
    data[1] = (bean.offset >> 8) & 0xFF;
    data[2] = (bean.offset >> 16) & 0xFF;
    data[3] = (bean.offset >> 24) & 0xFF;

    // index (2 bytes, little-endian)
    data[4] = bean.index & 0xFF;
    data[5] = (bean.index >> 8) & 0xFF;

    // width (2 bytes, little-endian)
    data[6] = bean.width & 0xFF;
    data[7] = (bean.width >> 8) & 0xFF;

    // height (2 bytes, little-endian)
    data[8] = bean.height & 0xFF;
    data[9] = (bean.height >> 8) & 0xFF;

    // x (2 bytes, little-endian)
    data[10] = bean.x & 0xFF;
    data[11] = (bean.x >> 8) & 0xFF;

    // y (2 bytes, little-endian)
    data[12] = bean.y & 0xFF;
    data[13] = (bean.y >> 8) & 0xFF;

    data[14] = bean.imageCount;
    data[15] = bean.type | (bean.hasAlpha << 7);
    data[16] = bean.anchor;
    data[17] = bean.blackTransparent;
    data[18] = bean.compression << 1;
    data[19] = bean.leftOffset;

    return data;
  }

  /// 读取 2 字节小端无符号整数
  static int _readUInt16LE(Uint8List data, int offset) {
    return (data[offset] & 0xFF) | ((data[offset + 1] & 0xFF) << 8);
  }

  /// 读取 4 字节小端无符号整数
  static int _readUInt32LE(Uint8List data, int offset) {
    return (data[offset] & 0xFF) |
    ((data[offset + 1] & 0xFF) << 8) |
    ((data[offset + 2] & 0xFF) << 16) |
    ((data[offset + 3] & 0xFF) << 24);
  }

  static Future<File> _createTempFile(String targetPath) async {
    final dir = path.dirname(targetPath);
    final baseName = path.basenameWithoutExtension(targetPath);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecond;
    final tempFileName = '${baseName}_${timestamp}_$random.tmp';
    final tempPath = path.join(dir, tempFileName);

    final directory = Directory(dir);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return File(tempPath);
  }

  static Future<bool> _moveTempToTarget(File tempFile, String targetPath) async {
    try {
      if (!await tempFile.exists()) return false;

      final tempFileSize = await tempFile.length();
      final targetFile = File(targetPath);

      if (await targetFile.exists()) {
        await targetFile.delete();
      }

      try {
        await tempFile.rename(targetPath);
      } catch (e) {
        await tempFile.copy(targetPath);
        await tempFile.delete();
      }

      if (!await targetFile.exists()) return false;

      final targetFileSize = await targetFile.length();
      if (targetFileSize != tempFileSize) {
        await targetFile.delete();
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> _cleanupTempFile(File tempFile) async {
    try {
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    } catch (e) {
      // 忽略
    }
  }
}

class _Element {
  int type = 0;
  int offset = 0;
  int index = 0;
  int width = 0;
  int height = 0;
  int x = 0xFFFF;
  int y = 0xFFFF;
  int imageCount = 0;
  int size = 0;
  int anchor = 0;
  int hasAlpha = 0;
  int blackTransparent = 0;
  int compression = 0;
  int leftOffset = 0;
  List<Uint8List> dataList = [];
}

class _Constants {
  static const int previewWidth = 194;
  static const int previewHeight = 194;
}