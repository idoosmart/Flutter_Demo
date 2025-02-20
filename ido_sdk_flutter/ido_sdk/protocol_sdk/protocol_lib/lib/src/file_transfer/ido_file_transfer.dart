import 'dart:async';
import 'dart:math';
import 'dart:convert';

import 'package:protocol_core/protocol_core.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'package:rxdart/rxdart.dart';

import 'module/base_file.dart';
import 'module/music_file.dart';
import 'module/normal_file.dart';
import 'module/watch_file.dart';
import 'module/agps_file.dart';
import 'module/message_file.dart';
import 'module/epo_file.dart';
import 'module/sport_file.dart';
import 'module/contact_file.dart';
import 'module/voice_file.dart';
import '../private/logger/logger.dart';

part 'part/file_transfer_impl.dart';

/// 文件传输
abstract class IDOFileTransfer {
  factory IDOFileTransfer() => _IDOFileTransfer();

  /// 是否在执行传输
  bool get isTransmitting;

  /// 当前传输中的文件类型
  FileTransType? get transFileType;

  /// 监听当前上传的文件类型 (文件开始传输、传输完成及失败都会回调此处)
  ///
  /// fileType 正在上传的文件类型，null表示无文件在上传
  StreamSubscription listenTransFileTypeChanged(
      void Function(FileTransType? fileType) func);

  /// 执行文件传输 (单文件）
  ///
  /// cancelPrevTranTask 取消存在的上传任务 默认为false
  /// ```dart
  /// Example:
  ///
  /// BaseFileModel? fileItem;
  /// // 音乐
  /// fileItem = MusicFileModel(filePath: 'filePath/xx.mp3', fileName: 'xx', musicId: 1);
  ///
  /// // 运动图标
  /// fileItem = SportFileModel(filePath: 'filePath', fileName: 'xx', iconType: 1, sportType: 1, isSports: true);
  ///
  /// // 其他
  /// fileItem = NormalFileModel(fileType: FileTransType.iwf_lz, filePath: 'filePath', fileName: 'xx');
  ///
  /// // 调用传输
  /// libManager.transFile.transferSingle(
  /// fileItem: fileItem,
  /// funcStatus: (FileTransStatus status) {
  ///   print('状态： ${status.name}');
  /// },
  /// funcProgress: (double progress) {
  ///   print('进度：$progress');
  /// });
  /// ```
  Stream<bool> transferSingle(
      {required BaseFileModel fileItem,
      required CallbackFileTransStatusSingle funcStatus,
      required CallbackFileTransProgressSingle funcProgress,
      CallbackFileTransErrorCode? funError,
      bool cancelPrevTranTask});

  /// 执行文件传输（批量）
  ///
  /// cancelPrevTranTask 取消存在的上传任务 默认为false
  ///
  /// ```dart
  ///
  /// Example:
  ///
  /// BaseFileModel? fileItem;
  /// // 音乐
  /// fileItem = MusicFileModel(filePath: 'filePath/xx.mp3', fileName: 'xx', musicId: 1);
  ///
  /// // 运动图标
  /// fileItem = SportFileModel(filePath: 'filePath', fileName: 'xx', iconType: 1, sportType: 1, isSports: true);
  ///
  /// // 其他
  /// fileItem = NormalFileModel(fileType: FileTransType.iwf_lz, filePath: 'filePath', fileName: 'xx');
  ///
  /// // 调用传输
  /// libManager.transFile.transferMultiple(
  /// fileItems: [fileItem!],
  /// funcStatus: (int index, FileTransStatus status) {
  ///   print('状态： ${status.name}');
  /// },
  /// funcProgress: (int index, int totalCount, double currentProgress, double totalProgress) {
  ///   print('进度：${index + 1}/$totalCount $currentProgress $totalProgress');
  /// });
  /// ```
  Stream<List<bool>> transferMultiple(
      {required List<BaseFileModel> fileItems,
      required CallbackFileTransStatusMultiple funcStatus,
      required CallbackFileTransProgressMultiple funcProgress,
      CallbackFileTransErrorCode? funError,
      bool cancelPrevTranTask});

  /// 获取压缩前.iwf文件大小
  ///
  /// ```dart
  /// filePath 表盘文件绝对路径
  /// type 表盘类型 1 云表盘 ，2 壁纸表盘
  /// ```
  Future<int> iwfFileSize({required String filePath, required int type});

  /// 注册 设备文件->app传输 (仅最后一次注册有效）
  ///
  /// ```dart
  /// taskFunc 接收到的文件任务
  /// ```
  void registerDeviceTranFileToApp(void Function(DeviceFileToAppTask task) taskFunc);

  /// 取消设备文件->app传输 注册
  void unregisterDeviceTranFileToApp();
}
