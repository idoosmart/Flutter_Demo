part of '../epo_manager.dart';

extension _IDOEpoManagerDownload on _IDOEPOManager {

  bool _isIcoeGpsPlatform() {
    return libManager.deviceInfo.gpsPlatform == 3;
  }

  /// 获取平台名称
  String _gpsPlatformName() {
    return _isIcoeGpsPlatform() ? "icoe" : "normal";
  }

  Future<String?> _epoDirectory({String? subFolders}) async {
    final rootFolder = await storage?.pathOTA();
    if (rootFolder == null) {
      logger?.e('EPO: 获取保存目录失败');
      return null;
    }

    String saveFolder;
    if (subFolders != null && subFolders.isNotEmpty) {
      saveFolder = '$rootFolder/${_gpsPlatformName()}/$subFolders';
    }else {
      saveFolder = '$rootFolder/${_gpsPlatformName()}';
    }

    final dir = Directory(saveFolder);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return saveFolder;
  }

  Future<List<String>> _downLoadAllEpoFilePath(List<_EPOType> epoTypes) async {
    List<String> list = List.empty(growable: true);
    int num = Random().nextInt(10000);
    int index = 0;
    for (_EPOType type in epoTypes) {
      if (!_statusModel.isUpgrading) {
        logger?.i('EPO: ${type.fileName} 下载取消 1');
        break;
      }
      final downPath = await _downEpoItem(type, num, index, epoTypes.length);
      if (downPath.isEmpty) {
        if (_statusModel.isUpgrading) {
          logger?.i('EPO: ${type.fileName} 下载失败');
        }
        return [];
      }
      logger?.i('EPO: ${type.fileName} 下载成功');
      list.add(downPath);
      index++;
    }
    return list;
  }

  Future<String> _downEpoItem(_EPOType type, int num, int index, int totalCount) async {
    final saveFolder = await _epoDirectory(subFolders: _downDirName);
    final savePath = '$saveFolder/${type.fileName}';

    // 文件已存在，直接返回
    if (File(savePath).existsSync()) {
      return savePath;
    }

    // 执行下载
    final downUrl = type.isIcoePlatform ? type.getIcoeEPOUrl() : type.getEPOUrl(num);
    final path = await _downloadFile(type.fileName, downUrl, savePath, index, totalCount);
    return path ?? '';
  }

  /// 下载文件
  Future<String?> _downloadFile(String fileName, String url, String savePath, int index, int totalCount) async {
    if (!_statusModel.isUpgrading) {
      logger?.i('EPO: $fileName 下载取消 2');
      _streamDownloadCtrl?.cancel();
      debugPrint("_streamDownloadCtrl cancel");
      return null;
    }
    logger?.i("EPO: 开始下载: $url");
    var completer = Completer<String?>();
    final HttpClient httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final ioClient = IOClient(httpClient);
    try {
      final http.Client client = ioClient;
      var response = await client.send(http.Request('GET', Uri.parse(url)))
          .timeout(const Duration(seconds: 15));
      var contentLength = response.contentLength;

      if (!_statusModel.isUpgrading) {
        logger?.i('EPO: $fileName 下载取消 3');
        return null;
      }

      if (response.statusCode != 200) {
        logger?.e("EPO: 下载失败: $url ${response.statusCode}");
        _statusModel.epoStatus = EpoUpgradeStatus.failure;
        completer.complete(null);
        return null;
      }

      // 创建一个本地文件保存下载的内容
      final tmpFilePath = '$savePath.tmp'; // 临时文件
      var file = File(tmpFilePath);
      var fileStream = file.openWrite();

      // 将响应流转换为广播流
      var stream = response.stream;//.asBroadcastStream();

      // 计算下载进度
      int totalBytes = 0;

      // 监听进度
      _streamDownloadCtrl = stream.listen(
            (List<int> chunk) async {
          if (!_statusModel.isUpgrading) {
            await fileStream.close(); // 如果已经停止，则关闭文件流
            return;
          }
          fileStream.add(chunk); // 写入数据块
          totalBytes += chunk.length;
          if (contentLength != null) {
            final progress = totalBytes / contentLength;
            // 多个文件时，计算总进度
            final progressTotal = (index + 1) / totalCount * progress;
            _streamCallbackCtrl.add(progressTotal);
            logger?.i("下载进度: ${progress.toStringAsFixed(2)} / ${progressTotal.toStringAsFixed(2)} %");
          }
        },
        onDone: () async {
          await fileStream.flush();
          await fileStream.close();
          logger?.i("下载完成: $fileName size: $contentLength");
          if (file.existsSync() && file.statSync().size > 1*1024) {
            file.renameSync(savePath);
            completer.complete(savePath);
          }
        },
        onError: (error) {
          logger?.e("下载过程中发生错误: $error");
          completer.complete(null);
        },
        cancelOnError: true,
      );
    } on TimeoutException catch (e) {
      logger?.e('请求超时: $e');
      completer.complete(null);
    } catch (e) {
      logger?.e("下载过程中发生错误: $e");
      completer.complete(null);
    }
    return completer.future;
  }

}