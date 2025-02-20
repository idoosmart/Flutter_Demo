import 'dart:typed_data';
import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as pkg_ffi;

import '../ido_protocol_fii.dart';
import 'extension/uint8list.dart';
import '../logger/logger.dart';

// 数据传输
extension IDOProtocolAPIExtTran on IDOProtocolAPI {
  /// 设置持久化路径, 用于保存数据(分段同步), 初始化时调用即可，无顺序要求，最后不要加斜杠 /
  int setFilePath({required String filePath}) {
    final path = filePath.toNativeUtf8();
    return bindings.setFilePath(path.cast());
  }

  /// 开始传输数据
  int tranDataStart() {
    return bindings.tranDataStart();
  }

  /// 开始传输数据, 且设置续传次数
  ///
  /// time 续传次数
  int tranDataStartWithTryTime({required int times}) {
    return bindings.tranDataStartWithTryTime(times);
  }

  // /// 断点续传, 用于发送过程中杀死app情况,app发起续传,
  // /// 传输过程(status = 2)中失败或者超时时,会自动续传,续传次数累加
  // int tranDataContinue() {
  //   return bindings.tranDataContinue();
  // }

  /// 停止传输数据
  // int tranDataStop() {
  //   return bindings.tranDataStop();
  // }

  /// 手动暂停传输数据
  int tranDataManualStop() {
    return bindings.tranDataManualStop();
  }

  /// 传输是否开启
  bool isTranDataStart() {
    return bindings.tranDataisStart() != 0;
  }

  /// 设置传输buff
  /// ```dart
  /// data: 文件的字节流
  /// dataType: 文件类型 0 无效 1 分区表 2 apgs文件 3 gps固件}
  /// fileName: 文件名(包括完整路径和后缀)
  /// compressionType: 压缩类型 0 为不适用压缩 1 为zlib压缩 2 为fastlz压缩}
  /// oriSize: 压缩前文件大小， 目前对表盘文件有效，表示没有压缩前的文件大小，即iwf文件大小
  /// 如果需要传递文件名 ，dataType需要使用0xff,如果是传递agps，两个分部填""和0就可以了
  /// ```
  int tranDataSetBuff(
      {required Uint8List data,
        required int dataType,
        required String fileName,
        required int compressionType,
        required int oriSize}) {
    final name = fileName.toNativeUtf8();
    final buffData = data.allocatePointer();
    final dataLen = data.length;
    // logger?.d('buffData len: ${buffData.asTypedList(data.length).length}');
    final rs = bindings.tranDataSetBuff(
        buffData.cast(), dataType, dataLen, name.cast(), compressionType, oriSize);
    pkg_ffi.calloc.free(buffData);
    pkg_ffi.calloc.free(name);
    return rs;
  }
  /// ```dart
  /// dataType 文件类型{0 无效 1 分区表 2 apgs文件 3 gps固件}
  /// srcPath 素材文件路径   最大4096字节
  /// dstName 目标文件名+后缀, 注:文件名可以是空但是后缀不能为空(排除掉某些固定名称的文件例如:EPO.DAT) 最大256字节
  /// compressionType 压缩类型{0 为不适用压缩 1 为zlib压缩 2 为fastlz压缩}
  /// oriSize 压缩前文件大小
  /// {目前对表盘文件有效，表示没有压缩前的文件大小，即iwf文件大小}
  /// 如果需要传递文件名 ，dataType需要使用0xff,如果是传递agps，两个分部填""和0就可以了
  /// @return SUCCESS(0) 成功
  /// ```
  int tranDataSetBuffByPath(
      {required int dataType,
        required String srcPath,
        required String fileName,
        required int compressionType,
        required int oriSize}) {
    final name = fileName.toNativeUtf8();
    final path = srcPath.toNativeUtf8();
    // logger?.d('buffData len: ${buffData.asTypedList(data.length).length}');
    final rs = bindings.tranDataSetBuffByPath(
        dataType, path.cast(), name.cast(), compressionType, oriSize);
    pkg_ffi.calloc.free(path);
    pkg_ffi.calloc.free(name);
    return rs;
  }

  /// 设置PRN
  ///
  /// 接收num包通知一次, 用来调节速度和可靠性之间的平衡
  /// app每发[num]包, 固件回应一次
  int tranDataSetPRN(int num) {
    return bindings.tranDataSetPRN(num);
  }

  /// 蓝牙数据发送完成
  int tranDataSendComplete() {
    return bindings.tranDataSendComplete();
  }

  // ------------------------------ SPP文件传输功能 ------------------------------


  /// 开始传输数据 返回：0 成功
  int sppTranDataStart() {
    return bindings.sppTranDataStart();
  }

  /// 开始传输数据, 且设置续传次数 返回：0 成功
  int sppTranDataStartWithTryTime(int times) {
    return bindings.sppTranDataStartWithTryTime(times);
  }

  /// 停止传输数据 返回：0 成功
  // int sppTranDataStop() {
  //   return bindings.sppTranDataStop();
  // }

  /// 手动暂停传输数据 返回：0 成功
  int sppTranDataManualStop() {
    return bindings.sppTranDataManualStop();
  }

  /// 获取传输状态 返回：1 传输已开启， 0 传输未开启
  int sppTranDataisStart() {
    return bindings.sppTranDataisStart();
  }


  /// 设置传输buff
  /// ```dart
  /// data: 文件的字节流
  /// dataType: 文件类型 0 无效 1 分区表 2 apgs文件 3 gps固件}
  /// fileName: 文件名(包括完整路径和后缀)
  /// compressionType: 压缩类型 0 为不适用压缩 1 为zlib压缩 2 为fastlz压缩}
  /// oriSize: 压缩前文件大小， 目前对表盘文件有效，表示没有压缩前的文件大小，即iwf文件大小
  /// 如果需要传递文件名 ，dataType需要使用0xff,如果是传递agps，两个分部填""和0就可以了
  /// ```
  int sppTranDataSetBuff(
      {required Uint8List data,
        required int dataType,
        required String fileName,
        required int compressionType,
        required int oriSize}) {
    final name = fileName.toNativeUtf8();
    final buffData = data.allocatePointer();
    final dataLen = data.length;
    // logger?.d('buffData2 len: ${buffData.asTypedList(data.length).length}');
    final rs = bindings.sppTranDataSetBuff(
        buffData.cast(), dataType, dataLen, name.cast(), compressionType, oriSize);
    pkg_ffi.calloc.free(buffData);
    pkg_ffi.calloc.free(name);
    return rs;
  }

  /// ```dart
  /// dataType 文件类型{0 无效 1 分区表 2 apgs文件 3 gps固件}
  /// srcPath 素材文件路径   最大4096字节
  /// dstName 目标文件名+后缀, 注:文件名可以是空但是后缀不能为空(排除掉某些固定名称的文件例如:EPO.DAT) 最大256字节
  /// compressionType 压缩类型{0 为不适用压缩 1 为zlib压缩 2 为fastlz压缩}
  /// oriSize 压缩前文件大小
  /// {目前对表盘文件有效，表示没有压缩前的文件大小，即iwf文件大小}
  /// 如果需要传递文件名 ，dataType需要使用0xff,如果是传递agps，两个分部填""和0就可以了
  /// @return SUCCESS(0) 成功
  /// ```
  int sppTranDataSetBuffByPath(
      {required int dataType,
        required String srcPath,
        required String fileName,
        required int compressionType,
        required int oriSize}) {
    final name = fileName.toNativeUtf8();
    final path = srcPath.toNativeUtf8();
    // logger?.d('buffData len: ${buffData.asTypedList(data.length).length}');
    final rs = bindings.sppTranDataSetBuffByPath(
        dataType, path.cast(), name.cast(), compressionType, oriSize);
    pkg_ffi.calloc.free(path);
    pkg_ffi.calloc.free(name);
    return rs;
  }

  /// 设置PRN
  ///
  /// 接收num包通知一次, 用来调节速度和可靠性之间的平衡
  /// app每发[num]包, 固件回应一次
  int sppTranDataSetPRN(int num) {
    return bindings.sppTranDataSetPRN(num);
  }

  /// 获取是否支持断点续传的功能表
  bool getIsSupportTranContinue() {
    return bindings.getIsSupportTranContinue() == 1;
  }

// ------------------------------ 设备传输文件到APP ------------------------------


  /// APP回复设备传输文件到APP的请求
  /// ```dart
  /// errorCode 0回复握手成功 非0失败，拒绝传输
  /// @return:SUCCESS(0)成功
  /// ```
  int device2AppDataTranRequestReply(int errorCode) {
    return bindings.Device2AppDataTranRequestReply(errorCode);
  }

  /// APP主动停止设备传输文件到APP
  ///
  /// @return:SUCCESS(0)成功
  int device2AppDataTranManualStop() {
    return bindings.Device2AppDataTranManualStop();
  }

}

