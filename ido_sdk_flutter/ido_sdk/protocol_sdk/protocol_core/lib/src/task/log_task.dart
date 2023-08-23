import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:protocol_ffi/protocol_ffi.dart';
import 'package:protocol_core/protocol_core.dart';


import '../logger/logger.dart';

import 'base_task.dart';

class LogTask extends BaseTask {
  TaskStatus _status = TaskStatus.waiting;
  final LogType logType;
  final String dirPath;
  Completer<CmdResponse>? _completer;
  Timer? _rebootTimer;
  File? _file;

  LogTask.create(this.logType,this.dirPath) : super.create();

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
    final time = DateTime.now().millisecondsSinceEpoch;
    File file = File('$path${fileName}_${time}.log');
    if (await file.exists() == false) {
      file = await file.create();
    }
    return file;
  }

  Future<File> _batteryFileInit() async {
    final path = await _logDirInit('battery');
    final time = DateTime.now().millisecondsSinceEpoch;
    File file = File('$path/$time.log');
    if (await file.exists() == false) {
      file = await file.create();
    }
    return file;
  }

  Future<File> _heatFileInit() async {
    final path =  await _logDirInit('heat');
    final time = DateTime.now().millisecondsSinceEpoch;
    File file = File('$path/$time.log');
    if (await file.exists() == false) {
      file = await file.create();
    }
    return file;
  }

  Future<File> _rebootFileInit() async {
    final path = await _logDirInit('reboot');
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
    logger?.d('get reboot log complete error code: $errorCode');
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
    switch(logType) {
      case LogType.reboot:
        {
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
        }
        break;
      case LogType.general:
        {
          _file = await _flashFileInit('general') as File;
          coreManager.cLib.registerFlashLogTranCompleteCbHandle(func:(int errorCode){
            _status = TaskStatus.finished;
            final res = LogResponse(code: errorCode, logType: LogType.general, logPath: _file?.path);
            _completer?.complete(res);
            _completer = null;
            logger?.d('get flash general log complete');
          });
          coreManager.cLib.startGetFlashLog(type:0, fileName: _file?.path ?? '');
        }
        break;
      case LogType.reset:
        {
          _file = await _flashFileInit('reset') as File;
          coreManager.cLib.registerFlashLogTranCompleteCbHandle(func:(int errorCode){
            _status = TaskStatus.finished;
            final res = LogResponse(code: errorCode, logType: LogType.reset, logPath: _file?.path);
            _completer?.complete(res);
            _completer = null;
            logger?.d('get flash reset log complete');
          });
          coreManager.cLib.startGetFlashLog(type:1, fileName: _file?.path ?? '');
        }
        break;
      case LogType.hardware:
        {
          _file = await _flashFileInit('hardware') as File;
          coreManager.cLib.registerFlashLogTranCompleteCbHandle(func:(int errorCode){
            _status = TaskStatus.finished;
            final res = LogResponse(code: errorCode, logType: LogType.hardware, logPath: _file?.path);
            _completer?.complete(res);
            _completer = null;
            logger?.d('get flash hardware log complete');
          });
          coreManager.cLib.startGetFlashLog(type:3, fileName: _file?.path ?? '');
        }
        break;
      case LogType.algorithm:
        {
          _file =  await _flashFileInit('algorithm') as File;
          coreManager.cLib.registerFlashLogTranCompleteCbHandle(func:(int errorCode){
            _status = TaskStatus.finished;
            final res = LogResponse(code: errorCode, logType: LogType.algorithm, logPath: _file?.path);
            _completer?.complete(res);
            _completer = null;
            logger?.d('get flash algorithm log complete');
          });
          coreManager.cLib.startGetFlashLog(type:2, fileName: _file?.path ?? '');
        }
        break;
      case LogType.restart:
        {
          _file = await _flashFileInit('restart') as File;
          coreManager.cLib.registerFlashLogTranCompleteCbHandle(func:(int errorCode){
            _status = TaskStatus.finished;
            final res = LogResponse(code: errorCode, logType: LogType.restart, logPath: _file?.path);
            _completer?.complete(res);
            _completer = null;
            logger?.d('get flash restart log complete');
          });
          coreManager.cLib.startGetFlashLog(type:4, fileName: _file?.path ?? '');
        }
        break;
      case LogType.battery:
        {
          _file = await _batteryFileInit() as File;
          coreManager.cLib.registerBatteryLogGetCompletedCallbackReg(func:(String json, int errorCode) {
            if (errorCode == 0) {
              _writeFileLog(json);
            }
            final res = LogResponse(code: errorCode, logType: LogType.battery, logPath: _file?.path, json: json);
            _completer?.complete(res);
            _completer = null;
            logger?.d('get battery log complete error code:$errorCode');
          });
          coreManager.cLib.getBatteryLogInfo();
        }
        break;
      case LogType.heat:
        {
          _file = await _heatFileInit() as File;
          coreManager.cLib.registerHeatLogGetCompletCallbackReg(func: (String json, int errorCode) {
            if (errorCode == 0) {
              _writeFileLog(json);
            }
            final res = LogResponse(code: errorCode, logType: LogType.heat, logPath: _file?.path, json: json);
            _completer?.complete(res);
            _completer = null;
            logger?.d('get heat log complete error code:$errorCode');
          });
          coreManager.cLib.getHeatLogInfo();
        }
        break;
      default:
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

