import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:protocol_core/protocol_core.dart';
import 'package:archive/archive_io.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'package:protocol_lib/src/private/logger/logger.dart';
import 'package:native_channel/native_channel.dart';
import 'package:image/image.dart';

import '../device_info/model/device_info_ext_model.dart';
import '../private/local_storage/local_storage.dart';
import '../private/isolate/isolate_manager.dart';
import 'package:image/image.dart' as img;

enum SifliSFBoardType {
  x55,
  x56,
  x52,
}

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

  /// PNG图片32位转24位
  /// ```dart
  /// inputFilePath 用于转换的png路径(包含文件名及后缀)
  /// outputFilePath 转换完的png路径(包含文件名及后缀)
  /// 返回 0 成功
  /// ```
  Future<int> pngTo24bit({required String inputFilePath, required String outputFilePath}) async {
    if (!File(inputFilePath).existsSync()) {
      logger?.e("pngTo24bit inputFilePath:$inputFilePath 文件不存在");
      return -1;
    }

    int execute(dynamic i)  {
      int result = _convertPngTo24Bit(inputFilePath,outputFilePath);
      return result;
    }
    return await IsolateManager.instance.handleFunctionInIsolate(execute,1);
  }

  /// 创建EPO.DAT文件
  /// ```dart
  /// dirPath 存放要制作epo文件的目录
  /// epoFilePath 制作的epo文件存放路径（epoFilePath不该在dirPath目录内）
  /// fileCount 制作epo所需的文件数量
  /// ```
  Future<bool> makeEpoFile({
    required String dirPath,
    required String epoFilePath,
    required int fileCount
  }) async {
    if (epoFilePath.startsWith(dirPath)) {
      throw UnsupportedError(
          'epoFilePath不该在dirPath目录内, 请修改');
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
    int rs = _coreMgr.makeEpoFile(filePath: dirPath, saveFileName: fileName, fileCount: fileCount);
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

  /// 制作思澈表盘文件
  /// ```dart
  /// dirPath 存放制作素材文件的目录
  /// fileName 表盘名称（注：需要和dial_config.json中的name的值一致，无需后缀）
  /// outputFilePath 制作的watch文件存放路径（注：需要绝对路径，如：/xx/*/{name}.watch)
  /// 返回 0成功 非0失败 -1: 没有控件 -2: json文件加载失败 -3: 文件制作失败
  /// ```
  Future<int> makeSifliDialFile({
    required String inputFilePath,
    required String fileName,
    required  String outputFilePath}) async {
    if (inputFilePath.startsWith(outputFilePath)) {
      throw UnsupportedError(
          'outputFilePath不该在inputFilePath目录内，请修改');
    }
    final tmpFile = File('$inputFilePath/$fileName.watch');
    // if (tmpFile.existsSync()) {
    //   await tmpFile.delete(); // 清理临时文件
    // }
    final rs = _coreMgr.mkSifliDialFile(filePath: inputFilePath);
    if (rs == 0 && tmpFile.existsSync()) {
      await tmpFile.copy(outputFilePath); // rename
      if (await File(outputFilePath).exists()) {
        return rs;
      }
      logger?.e('mkSifliDialFile file rename failed, rs: -3');
      return -3;
    }
    final code = rs != 0 ? rs : -3;
    logger?.e('mkSifliDialFile file rename failed, rs: $code');
    return code;
  }

  /// 获取思澈表盘(.watch)文件占用空间大小，计算规则：
  /// ```dart
  /// nor方案：对表盘所有文件以4096向上取整  -98平台对应的项目，IDW27,205G Pro,IDW28,IDS05，DR03等
  /// nand方案：对表盘所有文件以2048向上取整 -99平台对应的项目，GTX12,GTX13,GTR1,TIT21
  /// filePath .watch文件路径，包含文件名
  /// platform 平台类型，目前支持：98(nor)，99(nand)平台
  /// @return size 文件占用磁盘的实际大小(字节)，-1:失败，文件路径访问失败，-2:失败，申请内存失败，-3:失败，读取文件失败，-4:失败，输入平台类型不支持
  /// ```
  int getSifliDialSize({required String filePath, required int platform}) {
    if ([98, 99].contains(platform)) {
      return _coreMgr.getSifliDialSize(filePath: filePath, platform: platform);
    }
    logger?.e("getSifliDialSize 不支持的平台类型:$platform");
    return -1;
  }


  /// 将png格式文件序列转为ezipBin类型。转换失败返回nil。V2.2
  /// ```dart
  /// pngDatas png文件数据序列数组 （如果数组是多张图片，则会几张图片组合拼接成一张图片）
  /// eColor 颜色字符串 color type as below: rgb565, rgb565A, rbg888, rgb888A
  /// eType eizp类型 0 keep original alpha channel;1 no alpha chanel
  /// binType bin类型 0 to support rotation; 1 for no rotation
  /// boardType 主板芯片类型 @See SFBoardType 0:55x 1:56x  2:52x
  /// @return ezip or apng result, nil for fail
  /// ```
  Future<Uint8List?> sifliEBinFromPng(Uint8List pngDatas, String eColor, int type, int binType, SifliSFBoardType boardType) async {
    return SifliChannelImpl().sifliHost.sifliEBinFromPng(pngDatas, eColor, type, binType, IDOSFBoardType.values[boardType.index]);
  }


  /// 设置流数据是否输出开关
  ///
  /// iswrite 控制写入流数据开关公开 0不写入 1写入 默认不写入流数据
  /// 0 成功
  bool setWriteStreamByte(bool isWrite) {
    return _coreMgr.setWriteStreamByte(isWrite ? 1 : 0) == 0;
  }

  // ------------------------------ GPS轨迹工具 ------------------------------

  /// 初始化算法内部参数
  void initParameter() {
    _coreMgr.initParameter();
  }

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

  /// 字符串按最大字节截取
  /// input：字符串
  /// maxByteLen：最大字节长度
  @Deprecated("有bug，废弃")
  String truncateString2(String input,int maxByteLen) {
    if (input == null || input.isEmpty) {
      return '';
    }
    int byteLength = 0;
    int charIndex = 0;
    while (byteLength < maxByteLen && charIndex < input.length) {
      int charCode = input.codeUnitAt(charIndex);
      int bytesPerChar = 0;
      if (charCode <= 0x7F) {
        bytesPerChar = 1;
      } else if (charCode <= 0x7FF) {
        bytesPerChar = 2;
      } else if (charCode <= 0xFFFF) {
        bytesPerChar = 3;
      } else {
        bytesPerChar = 4;
      }
      if (byteLength + bytesPerChar > maxByteLen) {
        break;
      }
      byteLength += bytesPerChar;
      charIndex++;
    }
    return input.substring(0, charIndex);
  }

  /// 字符串按最大字节截取
  /// input：字符串
  /// maxByteLen：最大字节长度
  String truncateString(String s, int maxBytes) {
    var bytes = utf8.encode(s);
    if (bytes.length <= maxBytes) return s;

    int charLength = 0;
    int byteLength = 0;

    while (byteLength < maxBytes) {
      int charBytes = utf8.encode(s[charLength]).length;
      if (byteLength + charBytes > maxBytes) break;
      byteLength += charBytes;
      charLength++;
    }

    return s.substring(0, charLength);
  }


  /// 图片格式转换 png 添加透明背景色
  /// src: 原图片
  Future<Image?> imageCompressToPng(String imagePath) async {
    final targetImagePath = "$imagePath.tmp";
    final targetFile = File(targetImagePath);
    Image? pngImage;

    if (!File(imagePath).existsSync()) {
      logger?.e("imageCompressToPng imagePath:$imagePath 文件不存在");
      return null;
    }

    try {
      // 转换
      final rs = _coreMgr.jpgToPNG(
          inputFilePath: imagePath, outputFilePath: targetImagePath);

      // 0 成功, 1 已经是png，其它失败
      if (rs == 0) {
        if (await targetFile.exists()) {
          final pngBytes = targetFile.readAsBytesSync();
          pngImage = decodeImage(pngBytes);
        }
      } else if (rs == 1) {
        final srcFile = File(imagePath);
        if (await srcFile.exists()) {
          final pngBytes = srcFile.readAsBytesSync();
          pngImage = decodeImage(pngBytes);
        }
      }

      // 删除临时文件
      if (targetFile.existsSync()) {
        targetFile.deleteSync();
      }
    } catch(e) {
      final msgPath = await storage?.pathMessageIcon();
      final dirMessageIconExists = msgPath != null ? Directory(msgPath).existsSync() : false;
      final srcFileExists = File(imagePath).existsSync();
      final outFileExists = targetFile.existsSync();
      logger?.e("imageCompressToPng error:$e "
          "dirMessageIconExists:$dirMessageIconExists "
          "srcFileExists:$srcFileExists "
          "outFileExists:$outFileExists");
    }
    return pngImage;
  }

  /// 获取mp3音频采样率
  /// ```dart
  /// mp3FilePath 输入带路径MP3文件名
  /// return int 输入的MP3文件的采样率如：441000， 异常返回-1
  /// ```
  int mp3SamplingRate({required String mp3FilePath}) {
    if (!File(mp3FilePath).existsSync()) {
      logger?.e("audioGetMp3SamplingRate mp3FilePath:$mp3FilePath 文件不存在");
      return -1;
    }
    return _coreMgr.audioGetMp3SamplingRate(mp3FilePath: mp3FilePath);
  }

  /// 音频采样率转化
  /// ```dart
  /// audioRate 音频采样率 (目前只支持44.1khz)
  /// inPath   音频输入文件绝对路径
  /// outPath  音频输出文件绝对路径
  /// progressFunc    进度回调
  /// return   0 成功
  /// ```
  Future<int> audioSamplingRateConversion({
    IDOAudioRate audioRate = IDOAudioRate.rate44_1kHz,
        required String inPath,
        required outPath,
        void Function(double progress)? progressFunc}) async {
    final inputFile = File(inPath);
    if (!inputFile.existsSync()) {
      logger?.e("audioSamplingRateConversion inPath:$inPath 文件不存在");
      return -1;
    }
    final fileSize = await inputFile.length();
    if(progressFunc != null) {
      _coreMgr.registerAudioSRConversionProgress((progress) {
        progressFunc(progress / 100.0);
      });
    }
    return Future(() => _coreMgr.audioSamplingRateConversion(inPath: inPath, outPath: outPath, fileSize: fileSize));
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

  CancellerFlashLog? _cancellerFlashLog;
  /// 协议库log配置 （重启生效）
  ///
  /// fileSize 单日志文件大小（接近该值），单位字节，默认为5MB, 取值范围 1MB ~ 30MB
  /// numberOfLogFiles 日志文件个数（不超过该值），默认3个, 取值范围 1 ~ 50
  logConfigProtocol({
    required int fileSize,
    required int numberOfLogFiles}) async {
    fileSize = min(max(fileSize, 1 * 1024 * 1024), 30 * 1024 * 1024);
    numberOfLogFiles = min(max(numberOfLogFiles, 1), 50);
    await storage?.saveLogConfigProtocol(fileSize, numberOfLogFiles);
  }

  /// c库log配置（重启生效）
  ///
  /// saveDay 保存日志天数 最少两天
  logConfigClib({required int saveDay}) async {
    await storage?.saveLogConfigClib(saveDay);
  }

  void writeLog(String log) {
    logger?.d("writeLog: $log");
  }

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
    final dirDocument = await ToolsImpl().getDocumentPath();
    return Future.value('${dirDocument!}/alexa_test_pkg');
  }

  /// 获取当前设备缓存根路径
  Future<String?> currentDevicePath() async {
    return storage?.pathRoot();
  }

  /// 导出日志 返回压缩后日志zip文件绝对路径
  Future<String?> exportLog() async {
    final pathSDK = await LocalStorage.pathSDKStatic();
    final info = _ExportInfo("$pathSDK/logs", "$pathSDK/protocol_logs.zip");

    /// 打包zip文件
    Future<String?> execute(dynamic obj) async {
      String? path = await _innerDoZip(obj);
      return path;
    }
    return await IsolateManager.instance.handleFunctionInIsolate(execute, info);
  }

  /// 导出消息图标 返回压缩后日志zip文件绝对路径
  Future<String?> exportMsgIconCache() async {
    final pathSDK = await LocalStorage.pathSDKStatic();
    final msgIconPath = await storage?.pathMessageIcon();
    if (msgIconPath == null) {
      logger?.e("get pathMessageIcon is null");
      return null;
    }
    final info = _ExportInfo(msgIconPath, "$pathSDK/message_icon.zip");

    /// 打包zip文件
    Future<String?> execute(dynamic obj) async {
      String? path = await _innerDoZip(obj);
      return path;
    }
    return await IsolateManager.instance.handleFunctionInIsolate(execute, info);
  }

  /// 导出flash日志 返回压缩后日志zip文件绝对路径
  ///
  /// timeOut 最大获取日志时长 (单位秒，默认60秒)
  Future<String?> exportLogFlash({int timeOut = 60,
    void Function(int progress)? progressCallback,
    CancellerFlashLog? canceller}) async {
    logger?.d("call exportLogFlash");
    final path =  await storage?.pathDeviceLog();
    if (path == null) {
      logger?.e("get pathDeviceLog is null");
      return null;
    }

    _cancellerFlashLog = canceller;
    final outputFile = "$path/flash_logs.zip";

    /// 删除原来的压缩文件
    final zipFile = File(outputFile);
    if (zipFile.existsSync()) {
      zipFile.deleteSync();
    }

    /// flash 日志只获取通用日志
    final rs = await libManager.deviceLog.startGet(types:[IDOLogType.general],
        timeOut: timeOut,
        progressCallback: progressCallback).first;
    _cancellerFlashLog?._isCancelled = true;
    if (rs) {
      final logPath = await libManager.deviceLog.logDirPath;
      final info = _ExportInfo("$logPath/flash", outputFile);

      /// 打包zip文件
      Future<String?> execute(dynamic obj) async {
        String? path = await _innerDoZip(obj);
        return path;
      }
      return await IsolateManager.instance.handleFunctionInIsolate(execute, info);
    }
    return null;
  }

  /// 压缩flash日志 返回压缩后日志zip文件绝对路径
  Future<String?> zipLogFlash() async {
    final path =  await storage?.pathDeviceLog();
    if (path == null) {
      logger?.e("get pathDeviceLog is null");
      return null;
    }

    final outputFile = "$path/flash_logs2.zip";

    /// 删除原来的压缩文件
    final zipFile = File(outputFile);
    if (zipFile.existsSync()) {
      zipFile.deleteSync();
    }

    final logPath = await libManager.deviceLog.logDirPath;
    if (Directory(logPath).listSync().isNotEmpty) {
      final info = _ExportInfo("$logPath/flash", outputFile);

      /// 打包zip文件
      Future<String?> execute(dynamic obj) async {
        String? path = await _innerDoZip(obj);
        return path;
      }
      return await IsolateManager.instance.handleFunctionInIsolate(execute, info);
    }
    return null;
  }

  /// 加载指定设备功能表
  Future<BaseFunctionTable?> loadFuncTableByDisk(
      {required String macAddress}) async {
    final macAddr = macAddress.replaceAll(':', '').toUpperCase();
    final ft = await storage?.loadFunctionTableWith(macAddress: macAddr);
    logger?.d('loadFuncTableByDisk $macAddress rs:$ft');
    if (ft == null) return null;
    return BaseFunctionTable()..initFunTableModel(ft);
  }

  /// 加载指定设备功能表
  Future<String?> loadFuncTableJsonByDisk(
      {required String macAddress}) async {
    final macAddr = macAddress.replaceAll(':', '').toUpperCase();
    final ft = await storage?.loadFunctionTableWith(macAddress: macAddr);
    logger?.d('loadFuncTableJsonByDisk $macAddress rs:$ft');
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
    if (list != null && list.isNotEmpty) {
      return list.first;
    }
    return null;
  }

  /// 获取连接过的设备列表
  Future<List<DeviceInfoExtModel>?> loadDeviceExtListByDisk(
      {bool sortDesc = true}) async {
    return storage?.loadDeviceExtListByDisk(sortDesc: sortDesc);
  }

  /// 获取连接过的设备信息列表
  Future<List<DeviceInfoModel>?> loadDeviceInfoListByDisk(
      {bool sortDesc = true}) async {
    return storage?.loadDeviceInfoListByDisk(sortDesc: sortDesc);
  }


  /// 记录原生层log（内部使用）
  void recordNativeLog(String msg) {
      logger?.v(msg);
  }

  // 存在卡住问题（待优化）
  // static Future<String?> _doZip(_ExportInfo info) async {
  //   try {
  //     logger?.d('_doZip input: ${info.inputPath} output:${info.outputFilePath}');
  //     final pathLog = info.inputPath;
  //     final dir = Directory(pathLog);
  //     if (await dir.exists()) {
  //       final zipPath = info.outputFilePath;
  //       final zipFile = File(zipPath);
  //       if (await zipFile.exists()) {
  //         logger?.d('_doZip delete:$zipPath');
  //         await File(zipPath).delete();
  //       }
  //       zipFile.createSync();
  //       final encoder = ZipFileEncoder();
  //       encoder.create(zipPath);
  //       await encoder.addDirectory(dir);
  //       encoder.close();
  //       logger?.d('_doZip done');
  //       return zipFile.existsSync() ? zipPath : null;
  //     }
  //     return null;
  //   } catch (e) {
  //     logger?.d('_doZip fail');
  //     logger?.e(e.toString());
  //     return null;
  //   }
  // }
}

extension _IDOCacheExt on IDOCache {
  Future<String?> _innerDoZip(_ExportInfo info) async {
    try {
      logger?.d('_innerDoZip input: ${info.inputPath} output:${info.outputFilePath}');
      final pathLog = info.inputPath;
      final dir = Directory(pathLog);
      if (await dir.exists()) {
        final zipPath = info.outputFilePath;
        final zipFile = File(zipPath);
        if (await zipFile.exists()) {
          logger?.d('_innerDoZip delete:$zipPath');
          await File(zipPath).delete();
        }
        zipFile.createSync();
        final encoder = ZipFileEncoder();
        encoder.create(zipPath);
        await encoder.addDirectory(dir);
        encoder.close();
        logger?.d('_innerDoZip done');
        return zipFile.existsSync() ? zipPath : null;
      }
      return null;
    } catch (e) {
      logger?.d('_innerDoZip fail');
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

class CancellerFlashLog {
   var _isCancelled = false;

  void cancel() async {
    if (_isCancelled || this != libManager.cache._cancellerFlashLog) {
        return;
    }
    
    _isCancelled = true;
    await libManager.send(evt: CmdEvtType.getFlashLogStop).timeout(const Duration(seconds: 2)).first;
    libManager.deviceLog.cancel();
  }
}

int _convertPngTo24Bit(String inputPath, String outputPath) {
  // 读取 32 位 PNG 图像
  final bytes = File(inputPath).readAsBytesSync();
  img.Image? image = img.decodeImage(bytes);

  if (image == null) {
    logger?.e("err:failed to decode image");
    return ErrorCode.failed;
  }

  // 创建新的图像，使用 RGB565 格式
  img.Image newImage = img.Image(width:image.width, height:image.height);
  // 将 32 位颜色转换为 16 位
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      final pixel = image.getPixel(x, y);
      // 提取 RGB 组件
      int r = pixel.r.toInt();  // 8 bits
      int g = pixel.g.toInt();  // 8 bits
      int b = pixel.b.toInt();  // 8 bits

      // // 转换为 16 位 RGB565
      // int r16 = r & 0xF8;    // 5 bits
      // int g16 = g & 0xFC;    // 6 bits
      // int b16 = b & 0xF8;    // 5 bits

      newImage.setPixelRgb(x, y, r, g, b);
    }
  }

  // 编码为 PNG 并保存
  final pngBytes = img.encodePng(newImage);
  File(outputPath).writeAsBytesSync(pngBytes);

  return ErrorCode.success;
}