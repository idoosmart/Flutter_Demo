/// 照片表盘常量，对齐 Android [IDOPhotoDialConstants.kt]
class IDOPhotoDialConstants {
  IDOPhotoDialConstants._();
}

/// 壁纸表盘功能类型：1星期/日期 2步数 3距离 4卡路里 5心率 6电量
class IDOPhotoDialWidgetFunction {
  IDOPhotoDialWidgetFunction._();

  static const int weekDate = 1;
  static const int step = 2;
  static const int distance = 3;
  static const int calorie = 4;
  static const int heartRate = 5;
  static const int battery = 6;

  static const List<int> all = [
    weekDate,
    step,
    distance,
    calorie,
    heartRate,
    battery,
  ];

  /// 功能显示名，对齐 Android `wallpaper_dial_functions.xml`
  static String labelOf(int function) {
    switch (function) {
      case weekDate:
        return '星期/日期';
      case step:
        return '步数';
      case distance:
        return '距离';
      case calorie:
        return '卡路里';
      case heartRate:
        return '心率';
      case battery:
        return '电量';
      default:
        return '功能 $function';
    }
  }
}

/// 组件九宫格位置
class IDOPhotoDialWidgetPosition {
  IDOPhotoDialWidgetPosition._();

  static const int invalid = 0;
  static const int leftTop = 1;
  static const int centerTop = 2;
  static const int rightTop = 3;
  static const int leftCenter = 4;
  static const int center = 5;
  static const int rightCenter = 6;
  static const int leftBottom = 7;
  static const int centerBottom = 8;
  static const int rightBottom = 9;
  static const int center55 = 55;
}

class IDOPhotoDialWidgetStatus {
  IDOPhotoDialWidgetStatus._();

  static const int show = 0;
  static const int hide = 1;
}

/// 预设颜色表
class IDOPhotoDialWidgetColor {
  IDOPhotoDialWidgetColor._();

  static const List<String> defaults = [
    '#FFFFFF',
    '#BFA8FF',
    '#FF3333',
    '#826F60',
    '#FF8542',
    '#5CA4AC',
    '#7DC498',
    '#4694FF',
    '#4C68BE',
    '#718B83',
    '#B4C21D',
    '#CC8A89',
    '#FFD508',
    '#FDF19F',
    '#FFE0BF',
    '#C4DAE9',
  ];
}

class IDOPhotoDialInstallStatus {
  IDOPhotoDialInstallStatus._();

  static const int defaultStatus = -1;
  static const int success = 0;
  static const int failed = 1;
  static const int spaceNotEnough = 2;
  static const int diskDefragStart = 3;
  static const int diskDefragIng = 4;
}

class IDOPhotoDialCwdConfigSetStatus {
  IDOPhotoDialCwdConfigSetStatus._();

  static const int success = 1;
  static const int download = 2;
  static const int failed = 3;
}

class IDOPhotoDialIwfItemType {
  IDOPhotoDialIwfItemType._();

  static const String time = 'time';
  static const String week = 'week';
  static const String day = 'day';
  static const String icon = 'icon';
}
