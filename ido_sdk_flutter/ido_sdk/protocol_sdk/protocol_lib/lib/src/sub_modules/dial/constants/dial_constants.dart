import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import '../../../private/local_storage/local_storage.dart';

//表盘类型 内置, 云表盘(通用), 旧自定义, 功能,    照片,  云照片
enum IDODialType {
  local,
  common,
  // customize,
  function,
  photo,
  cloudPhoto;
}

// IDODialType checkTheDialType(String faceType, String customFaceType) {
//   if (customFaceType == 'CUSTOM_PHOTO' ||
//       customFaceType == 'CUSTOM_FIXED_PHOTO') {
//     return IDODialType.cloudPhoto;
//   }
//   if (faceType == 'COMMON') {
//     return IDODialType.common;
//   } else if (customFaceType == 'CUSTOM_FUNCTION') {
//     return IDODialType.function;
//   } else if (customFaceType == 'DEFAULT') {
//     return IDODialType.common;
//   }
//   return IDODialType.common;
// }

///方形 矩形 圆形 手环
enum IDODialShapeType {
  square,
  rectangle,
  circle,
  bracelet;

  String getPhotoDefaultImageName() {
    switch (this) {
      case IDODialShapeType.bracelet:
        return 'photo_default_bracelet.webp';
      case IDODialShapeType.circle:
        return 'photo_default_circle.webp';
      default:
        return 'photo_default_rectangle.webp';
    }
  }
}

//表盘列表 表盘详情 管理管理 设备首页
enum IDODialShapeLoc { faceList, faceDetail, managerDial, deviceHome }

enum IDODialThemeStyle {
  classicWhite, //('classic_white'),
  boundless; //('boundless');

  // const IDODialThemeStyle(this.styleName);
  // final String styleName;

  /// 是否是经典白模式
  bool isClassic() => (this == IDODialThemeStyle.classicWhite);
}


enum IDODialFirmwarePlatform {
  common({0}),
  persimwear({97}), //恒玄
  sifli({98, 99}); //思澈

  const IDODialFirmwarePlatform(this.typeSet);
  final Set<int> typeSet;

  bool isContains(int type) => typeSet.isEmpty || typeSet.contains(type);

  ///获取平台类型
  static IDODialFirmwarePlatform getPlatform(int type) {
    return IDODialFirmwarePlatform.values.firstWhere(
          (element) => element.isContains(type),
      orElse: () => IDODialFirmwarePlatform.common,
    );
  }
}

class IDODialConstants {
  /// 照片表盘在表盘市场上的自定义 id（原 `kPhotoMarketId`）
  static const int photoMarketId = -1000;

  /// 照片表盘 OTA face 名（原 `kPhotoOtaFaceName`）
  static const String photoOtaFaceName = 'wallpaper.z';

  static Future<String> dialStoreFolderPath(String deviceId) async {
    //Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final rootPath = await LocalStorage.pathSDKStatic();
    Directory documentsDirectory = Directory(rootPath);
    //循环创建文件夹
    String path = '${documentsDirectory.path}/dial/$deviceId';
    return path;
  }

  static Future<String> dialStoreFolderPathSync(String deviceId) async {
    //Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final rootPath = await LocalStorage.pathSDKStatic();
    Directory documentsDirectory = Directory(rootPath);
    //循环创建文件夹
    String path = '${documentsDirectory.path}/dial/$deviceId';
    return path;
  }

  ///表盘市场的缓存的key
  static const kFaceStoreCacheKey = 'kFaceStoreCacheKey';

  ///表盘列表的缓存的key
  static const kFaceListCacheKey = 'kFaceListCacheKey';

  ///表盘上的功能的Key
  static const kDefaultCloseFuncKey = 'kDefaultCloseFuncKey';

  ///关闭显示的Key
  static const kDefaultCloseFuncItemKey = 'kDefaultCloseFuncItemKey';

  ///设备当前表盘的缓存key
  static const kDialFacePathKey = 'kDialFacePathKey';

  ///表盘最后一次检测更新时间戳
  static const kFaceLastCheckUpdate = 'kFaceLastCheckUpdate';

  ///设备屏幕大小
  static const kDeviceScreenInfo = 'kDeviceScreenInfo';

  ///照片云表盘 预览图缓存的key
  static const kCloudPhotoCachePreviewKey = 'kCloudPhotoCachePreviewKey';

  ///照片云表盘 背景图缓存的key
  static const kCloudPhotoCacheBgKey = 'kCloudPhotoCacheBgKey';

  ///本地照片云表盘 背景图缓存的key
  static const kWallpaperPhotoCacheKey = 'kWallpaperPhotoCacheKey';

  ///上一次请求的的时间戳
  static const kGetByNamesRequestTimestampKey = 'kGetByNamesRequestTimestampKey';

  ///上一次请求的的时间戳
  static const kFaceListTop3RequestTimestampKey = 'kFaceListTop3RequestTimestampKey';
}

///照片表盘支持的小组件，不能改名字、顺序
enum IDOWallpaperWidgetType {
  date,
  step,
  distance,
  calorie,
  heartrate,
  battery,
}

extension IDOWallpaperWidgetTypeExtension on IDOWallpaperWidgetType {
  String get sdkName {
    return toString().split('.').last;
  }

  int get sdkIndex {
    return index + 1;
  }

  static IDOWallpaperWidgetType formSdkName(String name) {
    return IDOWallpaperWidgetType.values.firstWhere(
      (element) => element.sdkName == name,
      orElse: () => IDOWallpaperWidgetType.date,
    );
  }
}

// 表盘底部操作区的状态
enum IDODialOperationStatus {
  uninstall, //未安装
  installed, //已安装
  current, //已安装，第一表盘
}

// 表盘Header上的安装状态
enum IDODialInstallStatus {
  uninstall,
  downloading,
  installing,
  installed,
  installSuccess,
  installFailure,
  spaceOrganize, // 空间整理
}

enum IDODialFuncType {
  describe, //描述
  background, //背景
  style, //样式
  timeColor, //时间颜色
  funColor, //功能颜色
  countTimer, //计时器
  worldClock, //世界时钟
  commond, //功能
  selectPhoto, // 选择照片
  location, //位置
}

//对应sdk的位置
//*0:无效 1:表盘（上左）参考九宫格 2:表盘（上中）3:表盘（上右) 4:表盘（中左）
//*5:表盘（中中）6:表盘（中右）7:表盘（下左）8:表盘（下中）9:表盘（下右) 55:表盘（居中竖排)
enum IDODialLocType {
  unknown(0),
  topLeft(1),
  topCenter(2),
  topRight(3),
  centerLeft(4),
  center(5),
  centerRight(6),
  bottomLeft(7),
  bottomCenter(8),
  bottomRight(9),
  centerVertical(55);

  const IDODialLocType(this.type);
  final int type;

  static IDODialLocType getLocTypeForValue(int type) {
    return IDODialLocType.values.firstWhere((element) => element.type == type, orElse: () => IDODialLocType.unknown);
  }
}

//表盘SDK的位置、转换为Alignment对应的值
extension IDODialLocTypeExtension on IDODialLocType {
  // Alignment bottomLeft
  AlignmentGeometry get toAlignment {
    switch (this) {
      case IDODialLocType.topLeft:
        return Alignment.topLeft;
      case IDODialLocType.topCenter:
        return Alignment.topCenter;
      case IDODialLocType.topRight:
        return Alignment.topRight;
      case IDODialLocType.centerLeft:
        return Alignment.centerLeft;
      case IDODialLocType.center:
      case IDODialLocType.centerVertical:
        return Alignment.center;
      case IDODialLocType.centerRight:
        return Alignment.centerRight;
      case IDODialLocType.bottomLeft:
        return Alignment.bottomLeft;
      case IDODialLocType.bottomCenter:
        return Alignment.bottomCenter;
      case IDODialLocType.bottomRight:
        return Alignment.bottomRight;
      default:
        return Alignment.topLeft;
    }
  }
}

extension IDODialNameExtension on String {
  String deleteIWF() {
    //lz为兼容
    return replaceAll('.iwf', '').replaceAll('.lz', '');
  }

  String addIWF() {
    if (endsWith('.iwf')) {
      return this;
    }
    return '$this.iwf';
  }

  /// 获取文件名 /a/b/d.txt -> d.txt
  String basename() {
    return path.basename(this);
  }

  /// 获取文件名 /a/b/d.txt -> d
  String basenameWithoutExtension() {
    return path.basenameWithoutExtension(this);
  }
}
