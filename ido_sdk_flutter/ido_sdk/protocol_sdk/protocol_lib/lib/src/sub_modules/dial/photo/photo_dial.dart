import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:image/image.dart' as pkg_img;
import 'package:flutter/foundation.dart';

import 'package:protocol_lib/protocol_lib.dart';
import 'package:protocol_lib/src/private/logger/logger.dart';

import '../utils/dial_extensions.dart';
import '../utils/dial_sdk_helper.dart';
import '../../extension/completer_ext.dart';
import '../../../private/local_storage/ido_storage.dart';
import '../constants/dial_constants.dart';
import '../model/sdk/set_wallpaper_dial_v3.dart';
import '../utils/dial_manager.dart';
import '../utils/ido_file_manager.dart';
import '../utils/json_helper.dart';
import '../../extension/list_ext.dart';
import 'photo_dial_preset_config.dart';
import 'photo_dial_config.dart';

/// 照片表盘相关功能接口
abstract class IPhotoDial {
  /// 同步解析表盘配置包
  /// [dialPackagePath] 表盘配置包路径
  /// 返回表盘支持的一些配置项，如颜色、位置（坐标）、组件功能
  PhotoDialPresetConfig? prepareSync(String? dialPackagePath);

  /// 异步解析表盘配置包
  /// [dialPackagePath] 表盘配置包路径
  /// 返回表盘支持的一些配置项，如颜色、位置（坐标），组件功能
  Future<PhotoDialPresetConfig?> prepare(String? dialPackagePath);

  /// 安装表盘
  /// [config] 表盘配置
  /// [onSuccess] 安装成功时的回调函数
  /// [onFailed] 安装失败时的回调函数，回调错误码和错误信息
  void install(
      PhotoDialConfig config, {
        void Function()? onSuccess,
        void Function(int errCode, Object errMsg)? onFailed,
      });

  /// 取消安装
  void cancelInstall();
}

class PhotoDialImpl implements IPhotoDial {

  PhotoDialImpl._();
  static final _instance = PhotoDialImpl._();
  factory PhotoDialImpl() => _instance;
  StreamSubscription<bool>? _subScriptionTrans;
  Completer<bool>? _completer;
  PhotoDialPresetConfig? _lastDialPresetConfig;

  @override
  Future<PhotoDialPresetConfig?> prepare(String? dialPackagePath) async {
    if (dialPackagePath == null) {
      logger?.i('photo watch: 表盘配置包路径为空');
      return null;
    }

    final rootDir = await DialManager.getDialRootPath(libManager.deviceInfo.deviceId.toString());
    final dialName = dialPackagePath.basenameWithoutExtension();
    final targetPath = '$rootDir/$dialName';
    // 解压
    final unzipDir = await JsonHelper.unarchiveToDisk(zipPath: dialPackagePath, targetPath: targetPath);
    if (unzipDir == null) {
      logger?.i('photo watch: 解压表盘配置包失败');
      return null;
    }
    // 读取
    final dialJsonStr = await JsonHelper.readJsonContent(unzipDir);
    if (dialJsonStr.isEmpty) {
      logger?.i('photo watch: 读取表盘配置失败');
      return null;
    }

    // 解析
    final config = PhotoDialPresetConfig.fromJson(jsonDecode(dialJsonStr));
    config.dialDirPath = unzipDir;
    config.dialName = dialName;
    _lastDialPresetConfig = config;
    return config;
  }

  @override
  PhotoDialPresetConfig? prepareSync(String? dialPackagePath) {
    if (dialPackagePath == null) {
      logger?.i('photo watch: 表盘配置包路径为空');
      return null;
    }

    // 解压
    final dialUnzipPath = JsonHelper.unarchiveFromDiskSync(dialPackagePath, "dial_photo", true);
    if (dialUnzipPath.isEmpty) {
      logger?.i('photo watch: 解压表盘配置包失败');
    }

    // 读取
    final dialJsonStr = JsonHelper.readJsonContentSync(dialUnzipPath);
    if (dialJsonStr.isEmpty) {
      logger?.i('photo watch: 读取表盘配置失败');
      return null;
    }

    // 解析
    final config = PhotoDialPresetConfig.fromJson(jsonDecode(dialJsonStr));
    return config;
  }

  @override
  void install(PhotoDialConfig config, {void Function()? onSuccess, void Function(int errCode, Object errMsg)? onFailed}) async {
    // 修改表盘配置
    // _updatePhoneDial(config).then((wallpaperInfo) {
    //   if (wallpaperInfo == null) {
    //     logger?.i('photo watch: 修改表盘配置失败');
    //     onFailed?.call(0, '修改表盘配置失败');
    //     return;
    //   }
    //
    //
    //
    //   _sendZipToFirmware("", "", progress: (double v) {}, onSuccess: onSuccess, onFailed: onFailed);
    // });

    _lastDialPresetConfig?.zipName;

    _sendZipToFirmware("", "", progress: (double v) {}, onSuccess: onSuccess, onFailed: onFailed);
  }

  // 壁纸表盘 废弃
  // @override
  // void install(PhotoDialConfig config, {void Function()? onSuccess, void Function(int errCode, Object errMsg)? onFailed}) async {
  //   // 修改表盘配置
  //   _updateWallpaper(config).then((wallpaperInfo) {
  //     if (wallpaperInfo == null) {
  //       logger?.i('photo watch: 修改表盘配置失败');
  //       onFailed?.call(0, '修改表盘配置失败');
  //       return;
  //     }
  //
  //     // 传图
  //     if (config.bgPicPath == null) {
  //       logger?.i('photo watch: bgPicPath为空，不需要传图到设备');
  //       onSuccess?.call();
  //       return;
  //     }
  //     _sendWallpaperToFirmware(config.bgPicPath!, progress: (double v) {}, onSuccess: onSuccess, onFailed: onFailed);
  //   });
  // }

  @override
  void cancelInstall() {
    _subScriptionTrans?.cancel();
    _subScriptionTrans = null;
  }
}

// 照片云表盘
extension _PhotoDialImpl on PhotoDialImpl {

  ///功能表盘需要的zip包名比较特殊，需要根据json指定的zip包
  String getShouldUpdateZipName(PhotoDialPresetConfig jsonObj) {
    //0：style为zip名， 1：以功能表为zip名 2:以dialZipName字段名打包
    int? zipNameInt = jsonObj.zipName;
    if (zipNameInt == null) {
      return "";//jsonObj.iwfName ?? "";
    }
    String folderName;
    switch (zipNameInt) {
      case 0:
        int styleIndex = jsonObj.select?.styleIndex ?? 0;
        String styleName = jsonObj.styles?[styleIndex].name ?? '';
        folderName = styleName;
        break;
      case 1:
        String funcName = jsonObj.select?.function?.first ?? '';
        folderName = funcName;
        break;
    // case 3:
    //   folderName = state.jsonObj.zipName.toString();
      default:
        folderName = "";//jsonObj.dialZipName?.otaFaceName ?? '';
    }
    return folderName;
  }

  //新照片云表盘的动态配置，优先把iwf.json文件中 无关的对象删除，然后重新添加进来
  Map cleanupIwfJson(PhotoDialPresetConfig jsonObj, Map iwfObj) {
    //如果是新功能
    if (jsonObj.functionSupportNew == 0) {
      return iwfObj;
    }
    Map<String, dynamic> newMap = Map.from(iwfObj);
    if (!newMap.containsKey('item')) {
      return iwfObj;
    }

    List<Map> iwfItems = List.from(newMap['item']);
    List<Map> deleteItems = [];

    //需要删除时间的相关Map
    for (TimeWidgetListItem item in jsonObj.timeWidgetList ?? []) {
      final map =
      iwfItems.firstWhereOrNull((element) => element['widget'] == item.widget && element['type'] == item.type);
      if (map != null) {
        deleteItems.add(map);
      }
    }

    //删除所有 功能Map
    for (var functionListItem in jsonObj.functionList ?? []) {
      for (Map item in functionListItem?.item ?? []) {
        final map = iwfItems
            .firstWhereOrNull((element) => element['widget'] == item['widget'] && element['type'] == item['type']);
        if (map != null) {
          deleteItems.add(map);
        }
      }
    }

    //先删除item下的map，
    for (var item in deleteItems) {
      iwfItems.remove(item);
    }

    //重新添加item下的功能Map
    final tmpSelectFuncType = jsonObj.select?.function?.first;
    String selectFuncType = WallpaperWidgetType.date.sdkName;
    if (tmpSelectFuncType != null && tmpSelectFuncType is String && tmpSelectFuncType.isNotEmpty) {
      selectFuncType = tmpSelectFuncType;
    }

    final functionListItem = jsonObj.functionListForFuncation(selectFuncType);
    for (Map item in functionListItem?.item ?? []) {
      iwfItems.add(item);
    }

    final selectLoction = jsonObj.locationsForType(jsonObj.select?.timeFuncLocation ?? 3);
    //重新添加 时间Map
    for (Map item in selectLoction?.timeWidget ?? []) {
      iwfItems.add(item);
    }
    final selectFuncIndex = WallpaperWidgetTypeExtension.formSdkName(selectFuncType).sdkIndex;
    for (FunctionCoordinate item in selectLoction?.functionCoordinate ?? []) {
      if (item.function == selectFuncIndex) {
        for (var subItem in item.item) {
          final map = iwfItems
              .firstWhereOrNull((element) => element['widget'] == subItem.widget && element['type'] == subItem.type);
          if (map != null) {
            updateIwfItemRect(map, subItem.coordinate);
          }
        }
        break;
      }
      // iwfItems.add(item);
    }
    newMap['item'] = iwfItems;
    return newMap;
  }

  ///修改照片表盘的时间相关颜色
  List<String> changeCloudPhotoColorLocation(PhotoDialPresetConfig jsonObj, Map iwfObj) {
    if (jsonObj.select == null ||
        jsonObj.select?.paletteIndex == null ||
        (jsonObj.palettes?.length ?? 0) <= 0 ||
        jsonObj.select!.paletteIndex! >= jsonObj.palettes!.length ||
        (iwfObj['paletteindex'] == null)) {
      return [];
    }

    DialJsonSelect selectObj = jsonObj.select!;

    DialJsonPalettes timePalettes = jsonObj.palettes![selectObj.timeColorIndex!];
    DialJsonPalettes funcPalettes = jsonObj.palettes![selectObj.funcColorIndex!];

    DialJsonLocations? locationItem;
    for (DialJsonLocations element in jsonObj.locations ?? []) {
      if (element.type == selectObj.timeFuncLocation) {
        locationItem = element;
        break;
      }
    }

    List<String> colorHexList = [timePalettes.colors!, funcPalettes.colors!];
    //思澈平台的处理
    if (libManager.deviceInfo.isSilfiPlatform()) {
      updateForSifliColorAndRect(iwfObj['dial_data']![2], timePalettes.colors!, locationItem?.week);
      updateForSifliColorAndRect(iwfObj['dial_data']![3], timePalettes.colors!, locationItem?.time);
      return colorHexList;
    }

    //颜色可以会有多个，匹配iwf.json里 也要按顺序匹配，如果两个一样 就填写同一个值
    for (var i = 0; i < (iwfObj['item']?.length ?? 0); i++) {
      Map iwfItem = iwfObj['item']![i];

      ///修改照片云表盘的颜色
      if (iwfItem['type'] == 'day' ||
          iwfItem['type'] == 'week' ||
          iwfItem['type'] == 'time' ||
          iwfItem['type'] == 'hour' ||
          iwfItem['type'] == 'min') {
        if (colorHexList.length > 1 && (iwfItem['type'] == 'day' || iwfItem['type'] == 'week')) {
          iwfItem['fgcolor'] = colorHexList[1].converToARGB();
          iwfItem['fgrender'] = colorHexList[1].converToARGB();
        } else {
          iwfItem['fgcolor'] = colorHexList[0].converToARGB();
          iwfItem['fgrender'] = colorHexList[0].converToARGB();
        }

        //只有旧版本，才修改这个位置的值
        // if ((jsonObj.functionSupportNew ?? 0) == 0) {
        if (locationItem != null) {
          if (iwfItem['type'] == 'day') {
            updateIwfItemRect(iwfItem, locationItem.day);
          } else if (iwfItem['type'] == 'week') {
            updateIwfItemRect(iwfItem, locationItem.week);
          } else if (iwfItem['type'] == 'time') {
            updateIwfItemRect(iwfItem, locationItem.time);
          }
        }
        // }
      }
    }
    return colorHexList;
  }

  //转换成RGB  （思澈GTX12专用）
  updateForSifliColorAndRect(Map iwfItem, String hexColorStr, List<int>? rect) {
    if (hexColorStr.isNotEmpty) {
      Color color = hexColorStr.parseColor();

      iwfItem["r"] = color.red;
      iwfItem["g"] = color.green;
      iwfItem["b"] = color.blue;
    }

    if (!(rect?.isEmpty ?? true)) {
      iwfItem["x"] = rect![0];
      iwfItem["y"] = rect[1];
    }
  }

  ///保存本地表盘的照片
  Future<String> savePhotoBg(filePath) async {
    if (filePath == null) {
      return '';
    }
    String mac = DialManager().info.mac.replaceAll(':', '');
    final wallpaperImgNameKey = "${DialConstants.kWallpaperPhotoCacheKey}-${libManager.deviceInfo.macAddress}";
    String wallpaperImgName = IDOKvEngine.withDefault().getString(wallpaperImgNameKey);
    final lastCacheFilePath = '${DialManager().dialRootPath}/$wallpaperImgName';

    wallpaperImgName = "$mac-wallpaper-${DateTime.now().millisecondsSinceEpoch}.webp";
    String savePath = '${DialManager().dialRootPath}/$wallpaperImgName';
    if (filePath.contains('http')) {
      // TODO: 下载图片
      //await Dio().download(filePath, savePath);
      final dtc = pkg_img.decodeImage(File(savePath).readAsBytesSync())!;
      final src = pkg_img.copyResize(dtc,
          width: DialManager().info.size.width.toInt(),
          height: DialManager().info.size.height.toInt());
      //libManager.tools.compressToPNG(inputFilePath: inputFilePath, outputFilePath: savePath);
      //final imagePath = await File(savePath).create();
      //await imagePath.writeAsBytes(result!);
    } else {
      //await XFile(filePath).saveTo(savePath);
      File(savePath).writeAsBytesSync(File(filePath).readAsBytesSync());
    }

    //删除上次的照片
    final aFile = File(lastCacheFilePath);
    if (aFile.existsSync()) {
      aFile.deleteSync();
    }
    IDOKvEngine.withDefault().putString(wallpaperImgNameKey, wallpaperImgName);
    return savePath;
  }

  ///照片云表盘的背景
  Future<String> saveCloudPhotoBg(String filePath, String otaFaceName, int width, int height) async {
    logger?.i('Watch: 保存照片云表盘的背景 $filePath $otaFaceName ${width.toString()} ${height.toString()} ');
    final bgImgNameKey = "${DialConstants.kCloudPhotoCacheBgKey}-${libManager.deviceInfo.macAddress}-$otaFaceName";
    String bgImgName = IDOKvEngine.withDefault().getString(bgImgNameKey);

    //上次设置的背景图
    if (bgImgName.isNotEmpty && filePath.contains(bgImgName)) {
      return filePath;
    }

    String savePath = '${DialManager().dialRootPath}/$otaFaceName/images/$bgImgName';

    if (IDOFileManager.existFile(savePath)) {
      IDOFileManager.deleteFile(savePath);
    }
    bgImgName = "bgSet${DateTime.now().millisecondsSinceEpoch}.png";
    savePath = '${DialManager().dialRootPath}/$otaFaceName/images/$bgImgName';
    if (filePath.contains('http')) {
      // savePath += '_original.webp';
      //await Dio().download(filePath, savePath);
      // var result = await FlutterImageCompress.compressWithFile(savePath,
      //     minWidth: width, minHeight: height, quality: 90, format: CompressFormat.png);

      // var newPath = '${DialManager().dialRootPath}/${state.detailObj?.otaFaceName}/images/$bgImgName';
      // final imagePath = await File(newPath).create();
      // await imagePath.writeAsBytes(result!);
      // await resizeImage(File(newPath), width, height);
      IDOKvEngine.withDefault().putString(bgImgNameKey, bgImgName);
    } else {
      //await XFile(filePath).saveTo(savePath);
      await DialSDKHelper.resizeImage(File(savePath), width, height);
      IDOKvEngine.withDefault().putString(bgImgNameKey, bgImgName);
    }
    return savePath;
  }

  saveImageToPath(savePath, Uint8List image) async {
    final imagePath = await File(savePath).create();
    await imagePath.writeAsBytes(image);
  }

  void updateIwfItemRect(Map iwfItem, List<int>? list) {
    iwfItem['x'] = list?[0];
    iwfItem['y'] = list?[1];
    iwfItem['w'] = list?[2];
    iwfItem['h'] = list?[3];
  }

  // 更新照片表盘
  Future<SetWallpaperDialV3?> _updatePhoneDial(PhotoDialConfig config) async {
    //选中的颜色
    int timeColor = config.timeColor;
    int funcColor = config.functionColor;
    int widgetType = config.showFunction;
    logger?.i('Watch: 3.1更新本地照片表盘');

    SetWallpaperDialV3 item = SetWallpaperDialV3(
        1, 0, config.position, timeColor, funcColor, funcColor, widgetType);
    var result = await DialSDKHelper.wallpaperV3Operate(
      item,
    );

    logger?.i('Watch: 3.2更新本地照片表盘结果 $result');

    if (result != null) {
      return SetWallpaperDialV3.fromJson(json.decode(result));
    }
    return null;
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

  // 传输图片表盘到固件
  Future<bool> _sendPhotoDialToFirmware(
      String filePath, {
        required Function(double) progress,
        void Function()? onSuccess,
        void Function(int errCode, Object errMsg)? onFailed
      }) async {
    _completer = Completer<bool>();
    if (libManager.deviceLog.getLogIng) {
      logger?.i("Watch: 文件传输 传输壁纸图片关闭flash日志传输");
      libManager.deviceLog.cancel();
    }
    final fileItem =
    NormalFileModel(fileType: FileTransType.wallpaper_z, filePath: filePath, fileName: kPhotoOtaFaceName);
    _subScriptionTrans = libManager.transFile
        .transferSingle(
        fileItem: fileItem,
        funcStatus: (status) {
          logger?.i('Watch: 壁纸图片文件传输 状态: ${status.name}');
        },
        funcProgress: progress,
        funError: (index, errorCode, errorCodeFromDevice, finishingTime) {
          logger?.i('Watch: 壁纸图片文件传输 错误码: $errorCode $errorCodeFromDevice $finishingTime');
          onFailed?.call(errorCode, '壁纸图片文件传输');
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

}

// 壁纸表盘 废弃
// extension _WallpaperDialImpl on PhotoDialImpl {
//
//   //更新表盘
//   Future<SetWallpaperDialV3?> _updateWallpaper(PhotoDialConfig config) async {
//     //选中的颜色
//     int timeColor = config.timeColor;
//     int funcColor = config.functionColor;
//     int widgetType = config.showFunction;
//     logger?.i('Watch: 3.1更新本地照片表盘');
//
//     SetWallpaperDialV3 item = SetWallpaperDialV3(
//         1, 0, config.position, timeColor, funcColor, funcColor, widgetType);
//     var result = await DialSDKHelper.wallpaperV3Operate(
//       item,
//     );
//
//     logger?.i('Watch: 3.2更新本地照片表盘结果 $result');
//
//     if (result != null) {
//       return SetWallpaperDialV3.fromJson(json.decode(result));
//     }
//     return null;
//   }
//
//   // 传输壁纸图片到固件
//   Future<bool> _sendWallpaperToFirmware(
//       String filePath, {
//         required Function(double) progress,
//         void Function()? onSuccess,
//         void Function(int errCode, Object errMsg)? onFailed
//       }) async {
//     _completer = Completer<bool>();
//     if (libManager.deviceLog.getLogIng) {
//       logger?.i("Watch: 文件传输 传输壁纸图片关闭flash日志传输");
//       libManager.deviceLog.cancel();
//     }
//     final fileItem =
//     NormalFileModel(fileType: FileTransType.wallpaper_z, filePath: filePath, fileName: kPhotoOtaFaceName);
//     _subScriptionTrans = libManager.transFile
//         .transferSingle(
//         fileItem: fileItem,
//         funcStatus: (status) {
//           logger?.i('Watch: 壁纸图片文件传输 状态: ${status.name}');
//         },
//         funcProgress: progress,
//         funError: (index, errorCode, errorCodeFromDevice, finishingTime) {
//           logger?.i('Watch: 壁纸图片文件传输 错误码: $errorCode $errorCodeFromDevice $finishingTime');
//           onFailed?.call(errorCode, '壁纸图片文件传输');
//           _completer?.completeSafe(false);
//           _completer = null;
//         },
//         cancelPrevTranTask: true)
//         .listen((rs) {
//       logger?.i('Watch: 文件传输 状态 result: $rs');
//       _completer?.completeSafe(rs);
//       _completer = null;
//     });
//
//     return _completer!.future;
//   }
//
//
// }