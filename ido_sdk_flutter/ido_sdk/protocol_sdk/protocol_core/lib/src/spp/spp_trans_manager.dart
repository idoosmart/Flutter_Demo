import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:protocol_core/src/spp/extension/data.dart';

import '../logger/logger.dart';
import 'mixin/processor/spp_cmd_processor.dart';
import 'mixin/processor/spp_trans_processor.dart';
import 'mixin/processor/spp_base_processor.dart';
import 'model/spp_cmd.dart';
import 'model/type_def.dart';

part 'spp_trans_manager_imp.dart';

///
/// @author tianwei
/// @date 2024/3/22 11:00
/// @desc spp文件传输管理
///
///


abstract class SppTransManager {
  factory SppTransManager() => SppTransManagerImp();

  bool initSpp();

  void registerCoreBridge(
      {BoolCallback? inOtaMode,
      BoolCallback? supportContinueTrans,
      BleDataWriter? writer});

  /// 文件传输进度事件回调注册
  int registerSppDataTranProgressCallbackReg(
      {required CallbackDataTranProgressCbHandle func});

  /// 文件传输完成事件回调注册
  int registerSppDataTranCompleteCallback(
      {required CallbackDataTranCompleteCbHandle func});

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
      required int oriSize});

  /// 设置PRN
  ///
  /// 接收num包通知一次, 用来调节速度和可靠性之间的平衡
  /// app每发[num]包, 固件回应一次
  int sppTranDataSetPRN(int num);

  /// 开始传输数据 返回：0 成功
  int sppTranDataStart();

  /// 手动暂停传输数据 返回：0 成功
  int sppTranDataManualStop();

  /// 开始传输数据, 且设置续传次数 返回：0 成功
  int sppTranDataStartWithTryTime(int times);

  ///是否开始spp文件传输
  bool isSppTranStart();

  ///断链事件
  int onDisconnect();

  ///spp数据写完成
  int sppDataTransComplete();

  ///接收spp的数据
  bool receivedData(Uint8List data);

  ///拦截指令
  bool interceptCmd(Uint8List data);
}
