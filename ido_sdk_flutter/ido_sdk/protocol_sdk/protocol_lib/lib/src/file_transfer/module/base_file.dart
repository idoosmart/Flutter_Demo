import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:protocol_lib/protocol_lib.dart';
import 'package:protocol_core/protocol_core.dart';
import 'package:image/image.dart' as pkg_img;

import 'interface.dart';
import '../../private/logger/logger.dart';
import '../model/tran_config_reply.dart';
import '../../private/local_storage/local_storage.dart';

class BaseFile extends AbstractFileOperate {
  late final _coreMgr = IDOProtocolCoreManager();
  late final _libMgr = IDOProtocolLibManager();
  bool _isCanceled = false;
  CancelableOperation<CmdResponse>? _transCancelOpt;
  Completer<bool>? _completer;

  bool get isCanceled => _isCanceled;

  IDOProtocolCoreManager get coreMgr => _coreMgr;
  IDOProtocolLibManager get libMgr => _libMgr;

  /// 使用缓存（相同文件hash不再走制作及压缩文件流程）
  bool get useCache => kDebugMode ? true : true;

  /// 清理临时文件（制作及压缩文件产生的临时文件）
  bool get hasCleanTampFile => kDebugMode ? false : true; // TODO 测试阶段暂时保留

  int index = 0; // 当前文件在列表中的索引

  //final _keyTranConfigReply = 'TranConfigReply';

  // 进度、状态及结果回调
  void Function(int error, int errorVal, int index)? _funcStatus;
  void Function(double progress, int index)? _funcProgress;

  BaseFile(super.type, super.fileItem);

  @override
  Future<bool> verifyFileType() {
    return Future(() =>
        fileItem.fileType.isContainsExt(path.extension(fileItem.filePath)));
  }

  @override
  Future<bool> checkExists() async {
    final aFile = File(fileItem.filePath);
    final isExists = await aFile.exists();
    if (!isExists) {
      logger?.e('file：$aFile not exist');
      return Future(() => false);
    }
    if (fileItem.fileSize == null || fileItem.fileSize == 0) {
      fileItem.fileSize = await aFile.length();
    }
    return Future(() => true);
  }

  @override
  Future<BaseFileModel> makeFileIfNeed() async {
    newFileItem = fileItem;
    return Future(() => newFileItem!);
  }

  @override
  Future<bool> configParamIfNeed() {
    if (fileItem.fileType == FileTransType.msg ||
        fileItem.fileType == FileTransType.sport ||
        fileItem.fileType == FileTransType.sports) {
      logger?.d("call base configParamIfNeed ${fileItem.fileType}");
    }
    return Future(() => true);
  }

  @override
  Future<bool> tranFile() async {
    _isCanceled = false;
    _completer = Completer();
    try {
      logger?.v("tranFile - begin makeFileIfNeed");
      // 制作压缩制作
      await makeFileIfNeed();
      logger?.v("tranFile - end makeFileIfNeed");
      if (newFileItem == null) {
        throw 'newFileItem is null, has check makeFileIfNeed() function fileType:$type';
      }

      logger?.v("tranFile - begin configParamIfNeed");
      // 配置参数
      if (!await configParamIfNeed()) {
        logger?.d("configParamIfNeed false");
        return false;
      }
      logger?.v("tranFile - end configParamIfNeed");

      logger?.v("tranFile - begin coreMgr.trans");
      var startTime = DateTime.now();
      // 传输
      final fileTranItem = _createTranItem(newFileItem!, index);
      logger?.v("exec tran 原始文件:${fileItem.toString()}");
      logger?.v("exec tran 转换文件:${newFileItem!.toString()}");
      // 屏蔽思澈平台ota中的所有指令发送
      if (libManager.deviceInfo.isSilfiPlatform() && libManager.transFile.transFileType == FileTransType.fw) {
        logger?.v('Silfi platform ota mode, clean cmd queue');
        _coreMgr.dispose(needKeepTransFileTask: true);
      }
      _transCancelOpt = coreMgr.trans(
          fileTranItem: fileTranItem,
          statusCallback: (error, errorVal) =>
              _funcStatus!(error, errorVal, index),
          progressCallback: (progress) => _funcProgress!(progress, index));
      _transCancelOpt?.then((res) async {
        logger?.v("tranFile - end coreMgr.trans");
        if (!res.isOK) {
          if (_completer != null && !_completer!.isCompleted) {
            logger?.d('res = false');
            _completer?.complete(false);
            _completer = null;
          } else {
            logger?.d('tranFile _completer not work1');
          }
          return;
        }
        if (fileTranItem.fileSize > 0) {
          final endTime = DateTime.now();
          final useTime = endTime.difference(startTime);
          final kb = (fileTranItem.fileSize/1024.0);
          logger?.v('tranFile - useTime ${(useTime.inMilliseconds/1000.0).toStringAsFixed(2)}s'
              ' ${kb.toStringAsFixed(2)}KB '
              ' ${((kb/useTime.inMilliseconds)*1000).toStringAsFixed(2)}KB/s');
        }
        final rs = await writeFileIfNeed();
        if (_completer != null && !_completer!.isCompleted) {
          logger?.d('res = true, w = $rs');
          _completer?.complete(rs);
          _completer = null;
        } else {
          logger?.d('tranFile _completer not work2');
        }
        _transCancelOpt = null;
      });
    } catch (e) {
      logger?.e(e.toString());
      return false;
    }
    logger?.v("tranFile - _completer!.future");
    return _completer!.future;
  }

  /// 文件传输后，执行文件写入
  Future<bool> writeFileIfNeed() {
    return Future(() => true);
  }

  @override
  void cancel() {
    logger?.d('call cancel');
    if (!_isCanceled) {
      _isCanceled = true;
    }
    _transCancelOpt?.cancel();
    _transCancelOpt = null;

    // 取消后，缓存数据清理， 如：压缩的文件等
    //cleanAllDataIfNeed();
  }

  setCallbackFunc(void Function(int error, int errorVal, int index) funcStatus,
      void Function(double progress, int index) funcProgress) {
    _funcStatus = funcStatus;
    _funcProgress = funcProgress;
  }

  /// 获取文件传输临时目录
  ///
  /// 返回 根据文件类型生成的目录绝对路径
  Future<String> createTransferDirIfNeed({String subPath = ''}) async {
    if (storage == null) {
      return Future.error('storage不能为空，检查IDOProtocolLibManager macAddress是否为空');
    }
    final rootPath = await storage!.pathRoot();
    final dir =
        Directory('$rootPath/tran_cache/${type.name.toLowerCase()}/$subPath');
    final path = (await dir.create(recursive: true)).path;
    return Future(() => path);
  }

  /// 用官方的crypto库同步获取文件hash
  ///
  /// 耗时情况：206MB 1.3s / 39MB 0.3s / 1.3MB 10 ms
  Future<String> getFileChecksum(File file) async {
    if (!await file.exists()) {
      return Future.error('file not exists: ${file.path}');
    }
    final stream = file.openRead();
    final hash = await md5.bind(stream).first;
    return hash.toString();
  }

  /// 删除指定文件
  removeFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// 删除指定目录
  removeDir(String dirPath) async {
    final dir = Directory(dirPath);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  /// 文件复制，覆盖已存在文件
  copyFile(String orgFilePath, String newFilePage) async {
    final file = await File(orgFilePath).copy(newFilePage);
    if (!await file.exists()) {
      logger?.d('copy file fail $orgFilePath to $newFilePage');
      throw UnsupportedError('copy file fail');
    }
  }

  /// 文件复制，已存在文件时不复制
  copyFileIfNeed(String orgFilePath, String newFilePath) async {
    await copyFile(orgFilePath, newFilePath);
    // if (!await File(newFilePath).exists()) {
    //   logger?.d('\ncopy $orgFilePath\n  to $newFilePath');
    //   await copyFile(orgFilePath, newFilePath);
    // } else {
    //   logger?.d('\n exists $newFilePath ignore copy');
    // }
  }

  /// 解压缩文件
  Future<void> unzipFileIfNeed(String zipFilePath, String targetDir) async {
    final dir = Directory(targetDir);
    await removeDir(targetDir);
    await dir.create(recursive: true);
    final inputStream = InputFileStream(zipFilePath);
    final archive = ZipDecoder().decodeBuffer(inputStream);
    logger?.d('unzip $zipFilePath \n\t to $targetDir');
    extractArchiveToDisk(archive, targetDir);
    // 目标目录为空，记录日志
    if (dir.listSync().isEmpty) {
      logger?.e(
          'error: The file is too small, and an exception may exist.');
    }
  }

  /// 获取传输配置信息
  Future<TranConfigReply> getTranConfigReply(String jsonString) async {
    // final key =
    //     '${_keyTranConfigReply}_${md5.convert(utf8.encode(jsonString)).toString()}';
    // final json = await storage?.getString(key: key);
    // if (json != null && useCache) {
    //   logger?.d('getTranConfigReply use cache key:$key json:$json');
    //   return Future(() => TranConfigReply.fromJson(jsonDecode(json)));
    // }
    final s = await _libMgr
        .send(evt: CmdEvtType.getDataTranConfig, json: jsonString)
        .first;
    if (s.code == 0 && s.json is String) {
      // await storage?.setString(key: key, value: s.json!);
      final rs = TranConfigReply.fromJson(jsonDecode(s.json!));
      return Future(() => rs);
    }
    throw AssertionError(
        'Failed to obtain transmission configuration information.');
  }

  Future<bool> cropImage(CropImageConfig config) async {
    return await compute(_cropImage, config);
  }

  /// 开新线程处理
  static Future<bool> _cropImage(CropImageConfig config) async {
    try {
      var image = pkg_img.decodeImage(File(config.srcPath).readAsBytesSync());
      if (image == null) {
        logger?.e('Image processing failed');
        throw AssertionError('Image processing failed');
      }
      logger?.d('call _cropImage config:${config.toString()}');
      var newImage =
          pkg_img.copyResize(image, width: config.width, height: config.height);
      if (config.isCircle) {
        newImage = pkg_img.copyCropCircle(newImage);
      }
      await File(config.targetPath).writeAsBytes(pkg_img.encodePng(newImage));
      if (!await File(config.targetPath).exists()) {
        throw AssertionError('Image processing failed');
      }
      return Future(() => true);
    } catch (e) {
      logger?.e('Image processing failed ${e.toString()}');
      throw AssertionError('Image processing failed');
    }
  }
}

extension BaseFileExt on BaseFile {
  /// 创建FileTranItem传输项
  FileTranItem _createTranItem(BaseFileModel item, int idx) {
    final fileItem = FileTranItem(
        filePath: item.filePath,
        fileName: _fileNameAddExtIfNeed(item.fileType, item.fileName),
        dataType: _tranFileDataType(item.fileType),
        compressionType: _compressionType(item.fileType),
        fileSize: item.fileSize ?? 0,
        originalFileSize: item.originalFileSize ?? 0,
        platform: _libMgr.deviceInfo.platform,
        macAddress: Platform.isAndroid ? _libMgr.deviceInfo.macAddressFull : _libMgr.deviceInfo.uuid,
    );
    if (item.fileType == FileTransType.mp3 && item is MusicFileModel) {
      fileItem.useSpp = item.useSpp;
    }
    if (Platform.isIOS && _libMgr.deviceInfo.uuid == null) {
      logger?.e("_libMgr.deviceInfo.uuid is null");
    }
    fileItem.index = idx;
    return fileItem;
  }

  /// C库接口所需的压缩类型
  ///
  /// 根据文件类型FileTransType映射c库传输接口所需的压缩类型 FileTranCompressionType
  FileTranCompressionType _compressionType(FileTransType type) {
    var rs = FileTranCompressionType.fastlz;
    switch (type) {
      case FileTransType.fw:
      case FileTransType.fzbin:
      case FileTransType.bin:
      case FileTransType.watch:
        rs = FileTranCompressionType.fastlz;
        break;
      case FileTransType.lang:
        rs = FileTranCompressionType.fastlz;
        break;
      case FileTransType.bt:
      case FileTransType.ton:
        rs = FileTranCompressionType.fastlz;
        break;
      case FileTransType.iwf_lz:
      case FileTransType.wallpaper_z:
        rs = FileTranCompressionType.fastlz;
        break;
      case FileTransType.ml:
        rs = FileTranCompressionType.fastlz;
        break;
      case FileTransType.online_ubx:
      case FileTransType.offline_ubx:
        rs = FileTranCompressionType.none;
        break;
      case FileTransType.mp3:
        rs = FileTranCompressionType.fastlz;
        break;
      case FileTransType.msg:
        rs = FileTranCompressionType.fastlz;
        break;
      case FileTransType.sport:
      case FileTransType.sports:
        rs = FileTranCompressionType.fastlz;
        break;
      case FileTransType.epo:
        rs = FileTranCompressionType.none;
        break;
      case FileTransType.bpbin:
        rs = FileTranCompressionType.fastlz;
        break;
      case FileTransType.gps:
        rs = FileTranCompressionType.fastlz;
        break;
      case FileTransType.voice:
        rs = FileTranCompressionType.fastlz;
        break;
      case FileTransType.other:
        break;
      case FileTransType.app:
        rs = FileTranCompressionType.none;
        break;
    }
    return rs;
  }

  /// C库接口所需的文件名（此处确保扩展名正确）
  ///
  /// 根据文件类型FileTransType返回c库传输接口所需的完整文件名
  String _fileNameAddExtIfNeed(FileTransType fileType, String fileName) {
    var fileExt = '.zip';
    switch (fileType) {
      case FileTransType.fw:
        if (libMgr.deviceInfo.isSilfiOta()) {
          return '.zip';
        }
        // 名称固定
        return '.fw';
      case FileTransType.fzbin:
      case FileTransType.bin:
      case FileTransType.watch:
        fileExt = '.${fileType.name}';
        break;
      case FileTransType.lang:
        fileExt = '.lang';
        break;
      case FileTransType.bt:
        fileExt = '.bt';
        break;
      case FileTransType.ton:
        fileExt = '.ton';
        break;
      case FileTransType.iwf_lz:
        fileExt = '.iwf.lz';
        break;
      case FileTransType.wallpaper_z:
        // 名称固定
        return 'wallpaper.z';
      case FileTransType.ml:
        fileExt = '.ml';
        break;
      case FileTransType.online_ubx:
      case FileTransType.offline_ubx:
        // 名称固定
        return 'agps.ubx';
      case FileTransType.mp3:
        fileExt = '.mp3';
        break;
      case FileTransType.msg:
        fileExt = '.msg';
        break;
      case FileTransType.sport:
        fileExt = '.sport';
        break;
      case FileTransType.sports:
        fileExt = '.sports';
        break;
      case FileTransType.epo:
        // 名称固定
        return 'EPO.DAT';
      case FileTransType.gps:
        // 名称固定
        return 'GPS_FW.gps';
      case FileTransType.bpbin:
        fileExt = '.bpbin';
        break;
      case FileTransType.voice:
        fileExt = '.pcm';
        break;
      case FileTransType.other:
        fileExt = ''; // 不指定后缀
        break;
      case FileTransType.app:
        fileExt = '.app';
        break;
    }
    return fileName.endsWith(fileExt) ? fileName : '$fileName$fileExt';
  }

  /// C库接口所需的数据类型
  FileTranDataType _tranFileDataType(FileTransType type) {
    var dataType = FileTranDataType.photo;
    switch (type) {
      case FileTransType.fw:
        dataType = FileTranDataType.fw;
        break;
      case FileTransType.wallpaper_z:
        dataType = FileTranDataType.photo;
        break;
      case FileTransType.fzbin:
      case FileTransType.bin:
        dataType = FileTranDataType.photo;
        break;
      case FileTransType.offline_ubx:
      case FileTransType.online_ubx:
        dataType = FileTranDataType.agps;
        break;
      case FileTransType.sport:
      case FileTransType.sports:
        //case FileTransType.msg:
        dataType = FileTranDataType.photo;
        break;
      case FileTransType.voice:
        dataType = FileTranDataType.voice_alexa;
        break;
      default:
        break;
    }
    return dataType;
  }
}

class CropImageConfig {
  final String srcPath;
  final String targetPath;
  final int width;
  final int height;
  final bool isCircle;

  CropImageConfig(
      this.srcPath, this.targetPath, this.width, this.height, this.isCircle);

  @override
  String toString() {
    //return 'CropImageConfig{srcPath: $srcPath, targetPath: $targetPath, width: $width, height: $height, isCircle: $isCircle}';
    return 'CropImageConfig{width: $width, height: $height, isCircle: $isCircle}';
  }
}

extension _DirectorySize on Directory {
  int totalSizeSync() {
    int totalSize = 0;
    if (existsSync()) {
      // 遍历目录下的所有实体（文件和子目录）
      listSync(recursive: true).forEach((entity) {
        if (entity is File) {
          totalSize += entity.lengthSync();
        }
      });
    }
    return totalSize;
  }
}