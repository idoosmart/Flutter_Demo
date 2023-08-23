import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:protocol_core/protocol_core.dart';
import 'package:archive/archive_io.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'package:protocol_lib/src/private/logger/logger.dart';

import '../device_info/model/device_info_ext_model.dart';
import '../function_table/model/function_table_model.dart';
import '../function_table/ido_function_table.dart';
import '../type_define/image_type.dart';
import '../private/local_storage/local_storage.dart';

/// c库工具
class IDOTool {
  late final _coreMgr = IDOProtocolCoreManager();

  /// 图片转换格式 png->bmp
  /// ```dart
  /// inPath 用于转换的png路径(包含文件名及后缀)
  /// outPath 转换完的bmp路径(包含文件名及后缀)
  /// format 转换成bmp的文件格式
  /// 返回 0 成功
  /// ```dart
  int png2Bmp(
      {required String inPath,
        required String outPath,
        required ImageFormatType format}) {
    return _coreMgr.png2Bmp(
        inPath: inPath, outPath: outPath, format: format.realValue);
  }

  /// 压缩png图片质量
  /// ```dart
  /// inputFilePath   输入文件路径
  /// outputFilePath 输出文件路径
  /// 返回 0 成功
  /// ```
  int compressToPNG(
      {required String inputFilePath, required String outputFilePath}) {
    return _coreMgr.compressToPNG(
        inputFilePath: inputFilePath, outputFilePath: outputFilePath);
  }

  /// 创建EPO.DAT文件
  /// ```dart
  /// dirPath 存放要制作epo文件的目录
  /// epoFilePath 制作的epo文件存放路径
  /// ```
  Future<bool> makeEpoFile({
    required String dirPath,
    required String epoFilePath,
  }) async {
    // 目标文件不该在相同目录内
    if (epoFilePath.startsWith(dirPath)) {
      throw UnsupportedError(
          'The target files should not be in the same directory');
    }

    const fileName = '0.epo';
    if (!dirPath.endsWith('/')) {
      dirPath += '/'; // c库需要目录最后以 / 结尾
    }

    final tmpFile = File('$dirPath$fileName');
    if (tmpFile.existsSync()) {
      await tmpFile.delete(); // 清理临时文件
    }

    // 制作epo文件
    int rs = _coreMgr.makeEpoFile(filePath: dirPath, saveFileName: fileName);
    if (rs == 0 && await tmpFile.exists()) {
      await tmpFile.rename(epoFilePath); // rename
      if (await File(epoFilePath).exists()) {
        return Future(() => true);
      }
      logger?.e('file rename failed');
      return Future(() => false);
    }
    logger?.e('failed to create epo file rs:$rs');
    return Future(() => false);
  }

  /// 设置流数据是否输出开关
  ///
  /// iswrite 控制写入流数据开关公开 0不写入 1写入 默认不写入流数据
  /// 0 成功
  bool setWriteStreamByte(bool isWrite) {
    return _coreMgr.setWriteStreamByte(isWrite ? 1 : 0) == 0;
  }

  // ------------------------------ GPS轨迹工具 ------------------------------

  /// gsp运动后优化轨迹,根据运动类型初始化速度阈值，若输入其他运动类型，会导致无运动轨迹
  ///
  /// [motionTypeIn] 运动类型：
  /// ```dart
  /// 1、户外走路 = 52, 走路 = 1, 徒步 = 4, 运动类型设为0
  /// 2、户外跑步 = 48, 跑步 = 2, 运动类型设为1
  /// 3、户外骑行 = 50, 骑行 = 3, 运动型性设为2
  /// ```dart
  int gpsInitType(int motionTypeIn) {
    return _coreMgr.initType(motionTypeIn);
  }

  /// gps数据实时处理入口,需要对输出的数据进行判断，若纬度为-180则为错误值，不应该输出
  /// ```dart
  /// { lon,经度,数据类型double
  ///  lat,纬度,数据类型double
  ///  timestamp,时间戳,数据类型int
  ///  accuracy,定位精度,数据类型double
  ///  gpsaccuracystatus,定位等级，0 = 定位未知, 1 = 定位好, 2 = 定位差,数据类型int }
  /// ```dart
  String gpsAlgProcessRealtime({required String json}) {
    return _coreMgr.appGpsAlgProcessRealtime(json: json);
  }

  /// 平滑数据，结果保存在数组lat和lon中
  /// ```dart
  /// {lat,纬度数组,长度为len,数据类型double
  ///  lon,经度数组,长度为len,数据类型double len,数据长度}
  /// ```dart
  String gpsSmoothData({required String json}) {
    return _coreMgr.smoothData(json: json);
  }
}

/// 来电提醒 、消息提醒
class IDOCallNotice {
  late final _coreMgr = IDOProtocolCoreManager();

  ///  v2发送来电提醒以及来电电话号码和来电联系人(部分设备实现)
  /// ```dart
  /// contactText：联系人名称
  /// phoneNumber：号码
  /// 返回 0 成功
  /// ```
  int setV2CallEvt({
    required String contactText,
    required String phoneNumber,
  }) {
    return _coreMgr.setV2CallEvt(
        contactText: contactText, phoneNumber: phoneNumber);
  }

  /// v2发送信息提醒以及信息内容(部分设备实现)
  ///
  /// ```dart
  /// type 信息类型
  /// contactText 通知内容
  /// phoneNumber 号码
  /// dataText 消息内容
  /// 返回 0 成功
  /// ```
  int setV2NoticeEvt({
    required int type,
    required String contactText,
    required String phoneNumber,
    required String dataText,
  }) {
    return _coreMgr.setV2NoticeEvt(
        type: type,
        contactText: contactText,
        phoneNumber: phoneNumber,
        dataText: dataText);
  }

  /// v2发送来电提醒状态为来电已接, 告诉设备停止提醒用户(部分设备实现)
  ///
  /// 返回 0 成功
  int stopV2CallEvt() {
    return _coreMgr.stopV2CallEvt();
  }

  /// v2发送来电提醒状态为来电已拒, 告诉设备停止提醒用户(部分设备实现)
  ///
  /// 返回 0 成功
  int missedV2MissedCallEvt() {
    return _coreMgr.missedV2MissedCallEvt();
  }
}

/// 协议库缓存
class IDOCache {
  /// 获取log根路径
  Future<String> logPath() async {
    final pathSDK = await LocalStorage.pathSDKStatic();
    return Future.value('$pathSDK/logs');
  }

  /// 获取alexa根路径
  Future<String> alexaPath() async {
    final pathSDK = await LocalStorage.pathSDKStatic();
    return Future.value('$pathSDK/alexa');
  }

  /// 获取alexa测试目录
  Future<String> alexaTestPath() async {
    final dirDocument = await getApplicationDocumentsDirectory();
    return Future.value('${dirDocument.path}/alexa_test_pkg');
  }

  /// 获取当前设备缓存根路径
  Future<String?> currentDevicePath() async {
    return storage?.pathRoot();
  }

  /// 导出日志 返回压缩后日志zip文件绝对路径
  Future<String?> exportLog() async {
    final pathSDK = await LocalStorage.pathSDKStatic();
    //return await compute(_doZip, "$pathSDK/logs");
    final info = _ExportInfo("$pathSDK/logs", "$pathSDK/protocol_logs.zip");
    return await compute(_doZip, info);
  }

  /// 导出flash日志 返回压缩后日志zip文件绝对路径
  Future<String?> exportLogFlash() async {
    final path =  await storage?.pathDeviceLog();
    if (path == null) {
      logger?.e("get pathDeviceLog is null");
      return null;
    }

    final inoutDir = "$path/flash";
    final outputFile = "$path/flash_logs.zip";
    // 删除缓存
    final dir = Directory(inoutDir);
    if (dir.existsSync()) {
      dir.listSync().forEach((entity) {
        if (entity is File) {
          entity.deleteSync();
        }
      });
    }
    final zipFile = File(outputFile);
    if (zipFile.existsSync()) {
      zipFile.deleteSync();
    }

    final rs = await libManager.deviceLog.startGet([
      IDOLogType.general,
      IDOLogType.reset,
      IDOLogType.hardware,
      IDOLogType.algorithm,
      IDOLogType.restart
    ]).first;
    if (rs) {
      final logPath = await libManager.deviceLog.logDirPath;
      final info = _ExportInfo("$logPath/flash", outputFile);
      return await compute(_doZip, info);
    }
    return null;
  }

  /// 加载指定设备功能表
  @Deprecated('Use loadFuncTableByDisk(...)')
  Future<FunctionTableModel?> loadFuncTable(
      {required String macAddress}) async {
    final macAddr = macAddress.replaceAll(':', '').toUpperCase();
    return storage?.loadFunctionTableWith(macAddress: macAddr);
  }

  /// 加载指定设备功能表
  Future<BaseFunctionTable?> loadFuncTableByDisk(
      {required String macAddress}) async {
    final macAddr = macAddress.replaceAll(':', '').toUpperCase();
    final ft = await storage?.loadFunctionTableWith(macAddress: macAddr);
    logger?.d('loadFuncTableByDisk rs:$ft');
    if (ft == null) return null;
    return BaseFunctionTable()..initFunTableModel(ft);
  }

  /// 加载指定设备功能表
  Future<String?> loadFuncTableJsonByDisk(
      {required String macAddress}) async {
    final macAddr = macAddress.replaceAll(':', '').toUpperCase();
    final ft = await storage?.loadFunctionTableWith(macAddress: macAddr);
    logger?.d('loadFuncTableByDisk rs:$ft');
    if (ft == null) return null;
    return jsonEncode(ft.toJson());
  }

  /// 加载指定设备绑定状态
  Future<bool> loadBindStatus({required String macAddress}) async {
    final macAddr = macAddress.replaceAll(':', '').toUpperCase();
    final rs = await storage?.loadBindStatus(macAddress: macAddr);
    return Future(() => rs ?? false);
  }

  /// 获取最后连接的设备
  Future<DeviceInfoExtModel?> lastConnectDevice() async {
    final list = await storage?.loadDeviceExtListByDisk();
    return Future(() => list?.first);
  }

  /// 获取连接过的设备列表
  Future<List<DeviceInfoExtModel>?> loadDeviceExtListByDisk(
      {bool sortDesc = true}) async {
    return storage?.loadDeviceExtListByDisk(sortDesc: sortDesc);
  }

  static Future<String?> _doZip(_ExportInfo info) async {
    try {
      final pathLog = info.inputPath;
      final dir = Directory(pathLog);
      if (await dir.exists()) {
        final zipPath = info.outputFilePath;
        final zipFile = File(zipPath);
        if (await zipFile.exists()) {
          await File(zipPath).delete();
        }
        zipFile.createSync();
        final encoder = ZipFileEncoder();
        encoder.create(zipPath);
        encoder.addDirectory(dir);
        encoder.close();
        return zipFile.existsSync() ? zipPath : null;
      }
      return null;
    } catch (e) {
      logger?.e(e.toString());
      return null;
    }
  }
}

class _ExportInfo {
  final String inputPath;
  final String outputFilePath;

  _ExportInfo(this.inputPath, this.outputFilePath);
}
