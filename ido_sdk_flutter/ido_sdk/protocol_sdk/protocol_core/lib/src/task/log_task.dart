import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as libpath;
import 'package:protocol_ffi/protocol_ffi.dart';
import 'package:protocol_core/protocol_core.dart';
import 'package:native_channel/native_channel.dart';

import '../logger/logger.dart';

import 'base_task.dart';

class LogTask extends BaseTask {
  TaskStatus _status = TaskStatus.waiting;
  final LogType logType;
  final String dirPath;
  final LogProgressCallback? progressCallback;
  Completer<CmdResponse>? _completer;
  Timer? _rebootTimer;
  File? _file;
  final int _durationDay = 7*24*60*60;

  LogTask.create(this.logType,this.dirPath,this.progressCallback) : super.create();

  @override
  Future<CmdResponse> call() async {
    return _exec();
  }

  @override
  cancel() {
    _status = TaskStatus.canceled;
    if (_completer != null && !_completer!.isCompleted) {
      final res = LogResponse(code: ErrorCode.canceled, logType: logType);
      _completer!.complete(res);
      _completer = null;
    }
    _stopFlashLog();
  }

  @override
  TaskStatus get status => _status;

}

extension _CommandTask on LogTask {

  static int changeType(dynamic num) {
    if (num is double) {
      final newNum = num.toInt();
      return newNum;
    }else if (num is int){
      return num;
    }else {
      return 0;
    }
  }

  /// 删除过期文件
  Future<bool>_deleteFileExpiration(String path) async {
    final directory = Directory(path);
    if (directory.existsSync()) {
      try {
        for (FileSystemEntity fileSystemEntity in directory.listSync(recursive: true)) {
          if (fileSystemEntity is File) {
            if (libpath.basename(fileSystemEntity.path).endsWith("_history.log")) {
              continue;
            }
            if (fileSystemEntity.existsSync() && FileSystemEntity.isFileSync(fileSystemEntity.path)) {
              /// 文件存在才操作
              final value = await GetFileInfo().readFileInfo(fileSystemEntity.path);
              final create = changeType(value?["createSeconds"]);
              int timestamp = DateTime.now().millisecondsSinceEpoch~/1000;
              logger?.d("flashLog - device log name create time == $create file path == ${fileSystemEntity.path}");
              if (timestamp - create >= _durationDay) {
                logger?.d("flashLog - the log file exceeds 7 days, need to delete it file path == ${fileSystemEntity.path}");
                final historyFilePath = "${directory.path}/${libpath.basename(fileSystemEntity.path).split('.').first}_history.log";
                fileSystemEntity.absolute.copySync(historyFilePath); // 先备份
                /// 超过7天的文件删除
                fileSystemEntity.deleteSync();
              }
            }
          }
        }
        return Future(() => true);
      } catch (e) {
        logger?.e("flashLog - delete file error == $e");
        return Future(() => false);
      }
    } else {
      return Future(() => false);
    }
  }

  Future<String> _logDirInit(String dirName) async {
    final dirLog = Directory('${dirPath}/${dirName}/');
    if (dirLog.existsSync()) {
      return dirLog.path;
    }else {
      final pathLog = (await dirLog.create(recursive: true)).path;
      return pathLog;
    }
  }

  Future<File> _flashFileInit(String fileName) async {
    final path = await _logDirInit('flash');
    await _deleteFileExpiration(path);
    File file = File('$path${fileName}.log');
    if (await file.exists() == false) {
      file = await file.create();
    }
    return file;
  }

  Future<File> _batteryFileInit() async {
    final path = await _logDirInit('battery');
    await _deleteFileExpiration(path);
    final time = DateTime.now().millisecondsSinceEpoch;
    File file = File('$path/$time.log');
    if (await file.exists() == false) {
      file = await file.create();
    }
    return file;
  }

  Future<File> _heatFileInit() async {
    final path =  await _logDirInit('heat');
    await _deleteFileExpiration(path);
    final time = DateTime.now().millisecondsSinceEpoch;
    File file = File('$path/$time.log');
    if (await file.exists() == false) {
      file = await file.create();
    }
    return file;
  }

  Future<File> _rebootFileInit() async {
    final path = await _logDirInit('reboot');
    await _deleteFileExpiration(path);
    final time = DateTime.now().millisecondsSinceEpoch;
    File file = File('$path/$time.log');
    if (await file.exists() == false) {
      file = await file.create();
    }
    return file;
  }

  _writeFileLog(String log) async {
    var sink = await _file?.openWrite(mode: FileMode.append);
    sink?.write('${log}\n');
    await sink?.flush();
    await sink?.close();
  }

  _rebootLogComplete(int errorCode) {
    final res = LogResponse(code: errorCode, logType: LogType.reboot, logPath: _file?.path);
    _completer?.complete(res);
    _completer = null;
    _rebootTimer?.cancel();
    _rebootTimer = null;
    logger?.d('flashLog - get reboot log complete error code: $errorCode');
  }

  _startRebootLog() {
    Uint8List data = Uint8List.fromList([0x21,0x06]);
    coreManager.cLib.writeRawData(data: data);
    _rebootTimer?.cancel();
    _rebootTimer = Timer.periodic(Duration(seconds: 15), (timer) {
      _status = TaskStatus.timeout;
      _rebootLogComplete(13);
    });
  }

  _clearRebootLog() {
    Uint8List data = Uint8List.fromList([0x21,0x07]);
    coreManager.cLib.writeRawData(data: data);
    _status = TaskStatus.finished;
    _rebootTimer?.cancel();
    _rebootLogComplete(0);
  }

  _openRebootLog() {
    Uint8List data = Uint8List.fromList([0xf2,0xf6]);
    coreManager.cLib.writeRawData(data: data);

  }

  Future<CmdResponse> _exec() async {
    _status = TaskStatus.running;
    _completer = Completer<CmdResponse>();
    if (logType == LogType.reboot) {
      logger?.d("flashLog - start get old reboot log");
      _file = await _rebootFileInit() as File;
      coreManager.cLib.registerResponseRawData(func: (Uint8List data, int len) {
        if (_status != TaskStatus.running) {
          return;
        }
        if(data[0] == 0x21 && data[1] == 0x06) {
          if(data[2] == 0x55) { //开始获取
            var logStr = '';
            for (var i = 0; i < len; i++) { ///转16进制的字符
              logStr = logStr + (i > 0 ?  ' ' : '') + data[i].toRadixString(16);
            }
            _writeFileLog(logStr);
            _startRebootLog();
          }else if (data[2] == 0xaa) { //结束获取
            _clearRebootLog();
          }
        }else if (data[0] == 0x21 && data[1] == 0x07) { //清除日志后打开日志记录
          _openRebootLog();
        }
      });
      _startRebootLog();
    }else if (  logType == LogType.general
             || logType == LogType.restart
             || logType == LogType.reset
             || logType == LogType.hardware
             || logType == LogType.algorithm ) {
      /// falsh 日志全放在一起
      logger?.d("flashLog - start get flash general log");
      _file = await _flashFileInit('general') as File;
      /// flash获取完成回调
      coreManager.cLib.registerFlashLogTranCompleteCbHandle(func:(int errorCode){
        _status = TaskStatus.finished;
        final res = LogResponse(code: errorCode, logType: LogType.general, logPath: _file?.path);
        _completer?.complete(res);
        _completer = null;
        logger?.d('flashLog - get flash general log complete');
      });
      /// flash获取进度回调
      coreManager.cLib.registerFlashLogTranProgressCallbackReg(func: (int progress) {
          logger?.d('flashLog - flash log progress == $progress');
          if (progressCallback != null) {
              progressCallback!(progress > 100 ? 100 : progress);
          }
      });
      coreManager.cLib.startGetFlashLog(type:0, fileName: _file?.path ?? '');
    }
    /*else if (logType == LogType.reset) {
      logger?.d("start get flash reset log");
      _file = await _flashFileInit('reset') as File;
      coreManager.cLib.registerFlashLogTranCompleteCbHandle(func:(int errorCode){
        _status = TaskStatus.finished;
        final res = LogResponse(code: errorCode, logType: LogType.reset, logPath: _file?.path);
        _completer?.complete(res);
        _completer = null;
        logger?.d('get flash reset log complete');
      });
      coreManager.cLib.startGetFlashLog(type:1, fileName: _file?.path ?? '');
    }else if (logType == LogType.hardware) {
      logger?.d("start get flash hardware log");
      _file = await _flashFileInit('hardware') as File;
      coreManager.cLib.registerFlashLogTranCompleteCbHandle(func:(int errorCode){
        _status = TaskStatus.finished;
        final res = LogResponse(code: errorCode, logType: LogType.hardware, logPath: _file?.path);
        _completer?.complete(res);
        _completer = null;
        logger?.d('get flash hardware log complete');
      });
      coreManager.cLib.startGetFlashLog(type:3, fileName: _file?.path ?? '');
    }else if (logType == LogType.algorithm) {
      logger?.d("start get flash algorithm log");
      _file =  await _flashFileInit('algorithm') as File;
      coreManager.cLib.registerFlashLogTranCompleteCbHandle(func:(int errorCode){
        _status = TaskStatus.finished;
        final res = LogResponse(code: errorCode, logType: LogType.algorithm, logPath: _file?.path);
        _completer?.complete(res);
        _completer = null;
        logger?.d('get flash algorithm log complete');
      });
      coreManager.cLib.startGetFlashLog(type:2, fileName: _file?.path ?? '');
    }else if (logType == LogType.restart) {
      logger?.d("start get flash restart log");
      _file = await _flashFileInit('restart') as File;
      coreManager.cLib.registerFlashLogTranCompleteCbHandle(func:(int errorCode){
        _status = TaskStatus.finished;
        final res = LogResponse(code: errorCode, logType: LogType.restart, logPath: _file?.path);
        _completer?.complete(res);
        _completer = null;
        logger?.d('get flash restart log complete');
      });
      coreManager.cLib.startGetFlashLog(type:4, fileName: _file?.path ?? '');
    }*/
    else if (logType == LogType.battery) {
      logger?.d("flashLog - start get device battery log");
      _file = await _batteryFileInit() as File;
      coreManager.cLib.registerBatteryLogGetCompletedCallbackReg(func:(String json, int errorCode) {
        if (errorCode == 0) {
          _writeFileLog(json);
        }
        final res = LogResponse(code: errorCode, logType: LogType.battery, logPath: _file?.path, json: json);
        _completer?.complete(res);
        _completer = null;
        logger?.d('flashLog - get battery log complete error code:$errorCode');
      });
      coreManager.cLib.getBatteryLogInfo();
    }else if (logType == LogType.heat) {
      logger?.d("flashLog - start get device heat log");
      _file = await _heatFileInit() as File;
      coreManager.cLib.registerHeatLogGetCompletCallbackReg(func: (String json, int errorCode) {
        if (errorCode == 0) {
          _writeFileLog(json);
        }
        final res = LogResponse(code: errorCode, logType: LogType.heat, logPath: _file?.path, json: json);
        _completer?.complete(res);
        _completer = null;
        logger?.d('flashLog - get heat log complete error code:$errorCode');
      });
      coreManager.cLib.getHeatLogInfo();
    }
    return _completer!.future;
  }

  _stopFlashLog() {
    if (   logType == LogType.general
        || logType == LogType.reset
        || logType == LogType.hardware
        || logType == LogType.algorithm
        || logType == LogType.restart) {
      coreManager.cLib.stopGetFlashLog();
    }
  }

}

