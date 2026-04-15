import 'dart:async';

import 'package:protocol_lib/protocol_lib.dart';

import '../pigeon_generate/file_transfer.g.dart';

class FileTransferImpl extends FileTransfer {
  final _fileTransferDelegate = FileTransferDelegate();
  final _cmdTask = <String, StreamSubscription<dynamic>>{};
  DeviceFileToAppTask? _deviceFileToAppTask;

  @override
  bool isTransmitting() {
    return libManager.transFile.isTransmitting;
  }

  @override
  Future<int> iwfFileSize(String filePath, int type) async {
    return libManager.transFile.iwfFileSize(filePath: filePath, type: type);
  }

  @override
  ApiTransType? transFileType() {
    ApiTransType? rs;
    if (libManager.transFile.transFileType != null) {
      rs = ApiTransType.values[libManager.transFile.transFileType!.index];
    }
    return rs;
  }

  @override
  void cancelTransfer(CancelTransferToken cancelToken) {
    _cancelToken(cancelToken);
  }

  @override
  Future<List<bool?>> transferMultiple(
      List<BaseFile?> fileItems, bool cancelPrevTranTask, CancelTransferToken? cancelToken) async {
    final completer = Completer<List<bool?>>();
    final subscript = libManager.transFile
        .transferMultiple(
        fileItems: fileItems.map((e) => _convertFileModel(e!)).toList(),
        cancelPrevTranTask: cancelPrevTranTask,
        funcStatus: (int index, FileTransStatus status) {
          _fileTransferDelegate.fileTransStatusMultiple(index,
              ApiTransStatus.values[status.index]);
        },
        funcProgress: (int currentIndex, int totalCount,
            double currentProgress, double totalProgress) {
          _fileTransferDelegate.fileTransProgressMultiple(
              currentIndex, totalCount, currentProgress, totalProgress);
        },
        funError: (int index, int errorCode, int errorCodeFromDevice,
            int finishingTime) {
          _fileTransferDelegate.fileTransErrorCode(
              index, errorCode, errorCodeFromDevice, finishingTime);
        }).listen((event) {
      if (!completer.isCompleted) {
        completer.complete(event);
      }
      _cleanToken(cancelToken);
    });
    if (cancelToken != null) {
      _cmdTask[cancelToken.token!] = subscript;
    }
    return completer.future;
  }

  BaseFileModel _convertFileModel(BaseFile fileItem) {
    final type = fileItem.fileType!;
    BaseFileModel? bf;
    switch (type) {
      case ApiTransType.mp3:
        bf = MusicFileModel(
            filePath: fileItem.filePath!,
            fileName: fileItem.fileName!,
            musicId: fileItem.musicId!);
        break;
      case ApiTransType.msg:
        bf = MessageFileModel(
            filePath: fileItem.filePath!,
            fileName: fileItem.fileName!,
            evtType: fileItem.evtType!,
            packName: fileItem.packName!);
        break;
      case ApiTransType.sport:
      case ApiTransType.sports:
        bf = SportFileModel(
            filePath: fileItem.filePath!,
            fileName: fileItem.fileName!,
            iconType: fileItem.iconType!,
            sportType: fileItem.sportType!,
            isSports: fileItem.isSports!);
        break;
      default:
        bf = NormalFileModel(
            fileType: FileTransType.values[type.index],
            filePath: fileItem.filePath!,
            fileName: fileItem.fileName!);
        break;
    }
    return bf;
  }

  void _cancelToken(CancelTransferToken? cancelToken) {
    if (cancelToken != null && cancelToken.token != null) {
      _cmdTask[cancelToken.token]?.cancel();
      _cmdTask.remove(cancelToken.token!);
    }
  }

  void _cleanToken(CancelTransferToken? cancelToken) {
    if (cancelToken != null && cancelToken.token != null) {
      _cmdTask.remove(cancelToken.token!);
    }
  }

  @override
  void registerDeviceTranFileToApp() {
    libManager.transFile.registerDeviceTranFileToApp((task) {
        _deviceFileToAppTask = task;
        final item = ApiDeviceTransItem(
            fileType: task.item.fileType,
            fileSize: task.item.fileSize,
            fileCompressionType: task.item.fileCompressionType,
            fileName: task.item.fileName,
            filePath: task.item.filePath);
        _fileTransferDelegate.deviceToAppTransItem(item);
    });
  }

  @override
  Future<bool> acceptReceiveFile() async {
    final rs = _deviceFileToAppTask?.acceptReceiveFile(
        onProgress:(progress) => _fileTransferDelegate.deviceToAppTransProgress(progress),
        onComplete: (isCompleted, receiveFilePath) =>
            _fileTransferDelegate.deviceToAppTransStatus(isCompleted, receiveFilePath));
    return rs ?? false;
  }

  @override
  Future<bool> rejectReceiveFile() async {
    final rs = _deviceFileToAppTask?.rejectReceiveFile();
    return rs ?? false;
  }

  @override
  Future<bool> stopReceiveFile() async {
    final rs = _deviceFileToAppTask?.stopReceiveFile();
    return rs ?? false;
  }

  @override
  void unregisterDeviceTranFileToApp() {
    libManager.transFile.unregisterDeviceTranFileToApp();
  }
}
