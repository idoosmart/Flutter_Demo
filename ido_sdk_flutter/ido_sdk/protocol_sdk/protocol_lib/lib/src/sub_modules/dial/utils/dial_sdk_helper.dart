import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:image/image.dart' as pkg_img;

import '../../../../protocol_lib.dart';
import '../../../private/logger/logger.dart';
import '../../../private/local_storage/ido_storage.dart';

import '../constants/dial_constants.dart';
import '../model/sdk/dial_list_v2_obj.dart';
import '../model/sdk/dial_list_v3_obj.dart';
import '../model/sdk/screen_info_obj.dart';
import '../model/sdk/set_wallpaper_dial_v3.dart';
import 'dial_manager.dart';

enum SetDialOperate { checkUsing, setFirst, delete }

typedef ErrorCallback = void Function(int index, int errorCode, int errorCodeFromDevice, int finishingTime);

class DialSDKHelper {

  static Future<void> resizeImage(File file, int width, int height) async {
    final bytes = await file.readAsBytes();
    final image = pkg_img.decodeImage(bytes);
    if (image?.width == width && image?.height == height) {
      return Future.value();
    }
    final resizedImage = pkg_img.copyResize(image!, width: width, height: height);

    final resizedFile = File(file.path);
    await resizedFile.writeAsBytes(pkg_img.encodePng(resizedImage));
    return Future.value();
  }

  /// v3 获取表盘列表
  static getV3DialList() async {
    final resp = await libManager
        .send(evt: CmdEvtType.getWatchListV3)
        .timeout(const Duration(seconds: 3), onTimeout: (_) {})
        .first;

    logger?.i("Watch: 表盘列表V3 code:${resp.code}; json:${resp.json}");

    if (resp.code == 0) {
      DialListV3Obj infoObj = DialListV3Obj.fromJson(json.decode(resp.json ?? ''));
      await didGetDialList(infoObj);
    }
  }

  static getV2DialList() async {
    final resp = await libManager
        .send(evt: CmdEvtType.getWatchFaceList)
        .timeout(const Duration(seconds: 3), onTimeout: (_) {})
        .first;
    logger?.i("Watch: 表盘列表V2 code:${resp.code}; json:${resp.json}");

    if (resp.code == 0) {
      DialListV2Obj infoObj = DialListV2Obj.fromJson(json.decode(resp.json ?? ''));
      DialListV3Obj v3Obj = infoObj.convertToV3Obj();
      await didGetDialList(v3Obj);
    }
  }

  static didGetDialList(DialListV3Obj infoObj) async {
    if (libManager.funTable.setWatchCapacitySizeDisplay &&
        infoObj.userWatchCapacitySize > 0 &&
        infoObj.watchCapacitySize > 0) {
      int useSize = infoObj.userWatchCapacitySize ~/ 1024;
      int totalSize = infoObj.watchCapacitySize ~/ 1024;

      DialManager().dialMemberOrCount = '${useSize}kb/${totalSize}kb';
      DialManager().myDialListMemberOrCount = '${useSize}kb/${totalSize}kb';
    } else if (infoObj.userCloudWatchNum > 0 && infoObj.cloudWatchNum > 0) {
      int useNum = infoObj.userCloudWatchNum + infoObj.localWatchNum + infoObj.userWallpaperWatchNum;
      int totalNum = infoObj.localWatchNum + infoObj.cloudWatchNum + infoObj.wallpaperWatchNum;
      DialManager().dialMemberOrCount = '$useNum/$totalNum';
      DialManager().myDialListMemberOrCount = '${infoObj.userCloudWatchNum}/${infoObj.cloudWatchNum}';
    } else {
      DialManager().dialMemberOrCount = '--';
      DialManager().myDialListMemberOrCount = '--';
    }
    if (infoObj.dialListV3Item?.isNotEmpty ?? false) {
      var sortList = infoObj.dialListV3Item!..sort((a, b) => a.sortNumber.compareTo(b.sortNumber));
      DialManager().otaFaceNames = sortList
          .map(
            (e) => e.name == kPhotoOtaFaceName ? e.name : e.name.split('.').first,
          )
          .toList();
    }

    DialManager().dialListV3Obj = infoObj;
    if (infoObj.nowShowWatchName.isEmpty) {
      final currentName = await getCurrentWatchFace();
      DialManager().currentDialName = currentName?.deleteIWF() ?? DialManager().otaFaceNames.first;
    } else {
      DialManager().currentDialName = infoObj.nowShowWatchName.deleteIWF();
    }

    ///发送获取表盘市场的eventBus
    //EventBus.getDefault().fire(DialStatusEvent(status: DialEventStatus.didGetDialListFromFirmware));
  }

  static Future<String?> getCurrentWatchFace() async {
    Map<String, dynamic> map = {
      'operate': 0,
    };
    final resp = await libManager
        .send(evt: CmdEvtType.setWatchFaceData, json: json.encode(map))
        .timeout(const Duration(seconds: 3), onTimeout: (_) {})
        .first;

    logger?.i("Watch: 获取当前表盘 code:${resp.code}; json:${resp.json}");
    if (resp.code == 0 && resp.json != null) {
      Map map = json.decode(resp.json!);
      return map['file_name'].first;
    }
    return null;
  }

  /// 获取屏幕信息
  static getScreenInfo() async {
    const key = 'dial_info';
    final screenInfoJson = IDOKvEngine.withDefault().getString(key);
    if (screenInfoJson.isNotEmpty) {
      ScreenInfoObj obj = ScreenInfoObj.fromJson(json.decode(screenInfoJson));
      DialManager().screenInfoObj = obj;
      DialManager().info.size = Size(obj.width * 1.0, obj.height * 1.0);
      logger?.i("Watch: 屏幕信息缓存 ${obj.toJson()}");
      return;
    }
    final resp = await libManager
        .send(evt: CmdEvtType.getWatchDialInfo)
        .timeout(const Duration(seconds: 3), onTimeout: (_) {})
        .first;
    logger?.i("Watch: 屏幕信息 code:${resp.code}; json:${resp.json}");
    if (resp.code == 0) {
      if (resp.json?.isNotEmpty ?? false) {
        IDOKvEngine.withDefault().putString(key, resp.json!);

        ScreenInfoObj obj = ScreenInfoObj.fromJson(json.decode(resp.json!));
        DialManager().screenInfoObj = obj;
        DialManager().info.size = Size(obj.width * 1.0, obj.height * 1.0);

        logger?.i("Watch: 屏幕信息 ${obj.toJson()}");
      }
    }
  }

  /// 设置表盘 addIwfSuffix:是否追加iwf的后缀
  static Future<bool> setWatchFace(
    SetDialOperate operate, {
    String fileName = '',
    int watchFileSize = 0,
    bool addIwfSuffix = true,
  }) async {
    Map<String, dynamic> map = {
      'operate': operate.index,
      'file_name': addIwfSuffix ? fileName.addIWF() : fileName,
      'watch_file_size': watchFileSize,
    };
    final resp = await libManager
        .send(evt: CmdEvtType.setWatchFaceData, json: json.encode(map))
        // .timeout(const Duration(seconds: 3), onTimeout: (_) {})
        .first;

    logger?.i("Watch: 设置表盘 code:${resp.code}; json:${resp.json}");

    if (resp.code == 0 && jsonDecode(resp.json ?? "")["err_code"] == 0) {
      return true;
    }
    return false;
  }

  /// V3 设置表盘顺序
  static Future<String?> setWatchDialSort(
    int sortItemNumb,
    List pSortItem,
  ) async {
    Map<String, dynamic> map = {
      'sort_item_numb': sortItemNumb,
      'p_sort_item': pSortItem,
    };
    final resp = await libManager
        .send(evt: CmdEvtType.setWatchDialSort, json: json.encode(map))
        .timeout(const Duration(seconds: 3), onTimeout: (_) {})
        .first;

    logger?.i("Watch: V3 设置表盘顺序 code:${resp.code}; json:${resp.json}");

    if (resp.code == 0) {
      return resp.json;
    }
    return null;
  }

  static png2Bmp(String inPath, String outPath) {
    libManager.tools.png2Bmp(inPath: inPath, outPath: outPath, format: ImageFormatType.rgb565);
  }

  // **
  // *operate 操作  0x00 : 查询, 0x01: 设置, 0x02: 删除壁纸表盘
  // *location 设置的位置信息 参考九宫格
  // **/
  static Future<String?> wallpaperV3Operate(SetWallpaperDialV3 v3item) async {
    var jsonStr = json.encode(v3item.toJson());
    logger?.i("Watch: 设置 获取壁纸表盘 颜色和位置 code:$jsonStr");

    final resp = await libManager
        .send(evt: CmdEvtType.setWallpaperDialReplyV3, json: jsonStr)
        .timeout(const Duration(seconds: 3), onTimeout: (_) {})
        .first;
    logger?.i("Watch: 设置壁纸表盘 颜色和位置 code:${resp.code}; json:${resp.json}");

    if (resp.code == 0) {
      return resp.json;
    }
    return null;
  }

  // 传输表盘包到固件
  static Future<bool> sendZipToFirmware(
      String zipFilePath, String fileName, Function(double) progress, ErrorCallback funError) async {
    if (libManager.deviceLog.getLogIng) {
      logger?.i("Watch: 文件传输 传输表盘关闭flash日志传输");
      libManager.deviceLog.cancel();
    }
    final isSifli = libManager.deviceInfo.isSilfiPlatform();
    final fileType = isSifli ? FileTransType.watch : FileTransType.iwf_lz;
    final tmpFileName = fileName + (isSifli ? ".watch" : "");
    final fileItem = NormalFileModel(fileType: fileType, filePath: zipFilePath, fileName: tmpFileName);
    final result = await _transferFile(fileItem, progress, (status) {
      logger?.i('Watch: 文件传输 状态: ${status.name}');
    }, funError);
    logger?.i('Watch: 文件传输 状态 result: $result');
    return result;
  }

  // 传输壁纸图片到固件
  static Future<bool> sendWallpaperToFirmware(
    String filePath, {
    required Function(double) progress,
  }) async {
    if (libManager.deviceLog.getLogIng) {
      logger?.i("Watch: 文件传输 传输壁纸图片关闭flash日志传输");
      libManager.deviceLog.cancel();
    }
    final fileItem =
        NormalFileModel(fileType: FileTransType.wallpaper_z, filePath: filePath, fileName: kPhotoOtaFaceName);
    final result = await _transferFile(fileItem, progress, (status) {
      logger?.i('Watch: 壁纸图片文件传输 状态: ${status.name}');
    }, (index, errorCode, errorCodeFromDevice, finishingTime) {
      logger?.i('Watch: 壁纸图片文件传输 错误码: $errorCode $errorCodeFromDevice $finishingTime');
    });

    logger?.i('Watch: 文件传输 状态 result: $result');

    return result;
  }

  //文件传输的基础方法
  static Future<bool> _transferFile(BaseFileModel item, Function(double) progress,
      Function(FileTransStatus status) funcStatus, ErrorCallback funError) {
    return libManager.transFile
        .transferSingle(
            fileItem: item,
            funcStatus: funcStatus,
            funcProgress: progress,
            funError: funError,
            cancelPrevTranTask: true)
        .first;
  }
}
