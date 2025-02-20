import 'dart:convert';
import 'dart:typed_data';
import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as pkg_ffi;

import '../logger/logger.dart';
import '../ido_protocol_fii.dart';
import 'extension/uint8list.dart';

// 基础功能
extension IDOProtocolAPIExtBase on IDOProtocolAPI {
  /// 初始化c库
  int initCLib(CallbackWriteDataHandle func) {
    _writeDataHandle = func;
    final rs = bindings
        .callBackEnable(ffi.Pointer.fromFunction(_callWriteDataHandle));
    logger?.d('call clib - callBackEnable rs:$rs');
    return rs;
  }

  /// 配置log
  int enableLog(
      {bool isPrintConsole = true,
      bool isWriteFile = false,
      String? filePath}) {
    if (isWriteFile && filePath == null) {
      isWriteFile = false;
    }
    final path = (filePath ?? '').toNativeUtf8();
    final rs = bindings.EnableLog(
        isPrintConsole ? 1 : 0, isWriteFile ? 1 : 0, path.cast());
    logger?.d('call clib - EnableLog rs:$rs');
    return rs;
  }

  /// 设置log保存天数
  ///
  /// saveDay 保存日志天数 最少两天
  /// return SUCCESS(0) 成功
  int setSaveLogDay(int saveDay) {
    return bindings.SetSaveLogDay(saveDay);
  }

  /// 设置运行环境 release / debug
  /// mode 0:debug 1:relese
  int setRunMode(int mode) {
    return bindings.setRunMode(mode);
  }

  /// 设置持久化路径, 用于保存功能表数据, 初始化时调用即可，无顺序要求，最后不要加斜杠 /
  /// filePath 持久化目录路径
  /// 返回 SUCCESS(0) 成功
  int setFunctionTableFilePath({required String filePath}) {
    final path = filePath.toNativeUtf8();
    return bindings.setFunctionTableFilePath(
      path.cast(),
    );
  }

  /// 调用事件号发送内容给固件
  int writeJsonData(
      {required String json, required int evtType, required int evtBase}) {
    ffi.Pointer<ffi.Char> jsonData = json.toNativeUtf8().cast();
    final utf8List = utf8.encode(json); // 处理非unicode字符长度问题
    // logger?.d(
    //     'writeJsonData evtType:$evtType json:$json len:${utf8List.length}');
    int rs =
        bindings.WriteJsonData(jsonData, utf8List.length, evtType, evtBase);
    pkg_ffi.calloc.free(jsonData);
    //logger?.d('call clib - WriteJsonData rs:$rs');
    return rs;
  }

  /// 接收到数据,通过这个函数转发到c库（用于转发收到后的命令）
  ///
  /// data 蓝牙接收到的二进制数据
  /// type 数据类型 0:ble 1:SPP
  int receiveDataFromBle({required Uint8List data, required int type}) {
    final recData = data.allocatePointer();
    //logger?.d('receiveDataFromBle() data:$data, len:${data.length}');
    final rs = bindings.ReceiveDatafromBle(recData.cast(), data.length, type);
    pkg_ffi.calloc.free(recData);
    //logger?.d('call clib - ReceiveDatafromBle rs:$rs');
    return rs;
  }

  /// 直接下发原始数据给固件
  int writeRawData({required Uint8List data}) {
    final recData = data.allocatePointer();
    final rs = bindings.WriteRawData(recData.cast(), data.length);
    pkg_ffi.calloc.free(recData);
    return rs;
  }

  /// 设置当前绑定状态
  /// 0 没有绑定, 1 已经绑定, 2 升级模式
  int setBindMode({required int mode}) {
    return bindings.SetMode(mode);
  }

  /// 获取当前绑定状态
  /// 0 没有绑定, 1 已经绑定, 2 升级模式
  int getBindMode() {
    final rs = bindings.GetMode();
    logger?.d("ffi getBindMode: $rs");
    return rs;
  }

  /// 手动停止快速同步配置
  int stopSyncConfig() {
    return bindings.ProtocolSyncConfigStop();
  }

  /// 队列清除
  /// 0 成功
  int cleanProtocolQueue() {
    return bindings.ProtocolQueueClean();
  }

  /// 获取Clib版本信息
  ///
  /// release_string clib版本号 三位表示release版本 四位表是develop版本
  /// 0 成功
  String? getClibVersion() {
    String? ver;
    final recData = pkg_ffi.calloc.allocate(24).cast<pkg_ffi.Utf8>();
    try {
      final rs = bindings.getClibVersion(recData.cast());
      if (rs == 0) {
        final rsStr = recData.toDartString();
        ver = rsStr;
      }
    }catch(e){
      logger?.e(e);
    }finally {
      pkg_ffi.calloc.free(recData);
    }
    //logger?.d('clib version::$ver');
    return ver;
  }

  /// 设置流数据是否输出开关
  /// 
  /// iswrite 控制写入流数据开关公开 0不写入 1写入 默认不写入流数据
  /// 0 成功
  int setWriteStreamByte(int isWrite) {
    return bindings.setWriteStreamByte(isWrite);
  }

  static void _callWriteDataHandle(
      ffi.Pointer<ffi.Int> data, int len, int type) {
    if (_writeDataHandle != null) {
      final dataUint8Ptr = data.cast<ffi.Uint8>();
      final dataUint8 = dataUint8Ptr.asTypedList(len);
      // !!! 此处需做copy操作，否则数据会被随机修改导致出现异
      final dataUint8Copy = Uint8List.fromList(dataUint8.toList());
      //logger?.d('ffi _callWriteDataHandle dataUint8Copy:$dataUint8Copy hashCode:${dataUint8Copy.hashCode}');
      _writeDataHandle!(dataUint8Copy, len, type);
    } else {
      logger?.d('error: _writeDataHandle is null');
    }
  }

  static CallbackWriteDataHandle? _writeDataHandle;
}
