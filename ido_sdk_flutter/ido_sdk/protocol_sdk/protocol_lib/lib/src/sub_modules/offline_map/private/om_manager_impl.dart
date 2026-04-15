part of '../offline_map_manager.dart';

class _IDOOfflineMapManager implements IDOOfflineMapManager {
  static final _instance = _IDOOfflineMapManager._internal();
  factory _IDOOfflineMapManager() => _instance;
  _IDOOfflineMapManager._internal() {
    // 断开连接时停止任务
    libManager.listenConnectStatusChanged((isConnected) {
      if (!isConnected) {
        stopUploadMap();
        stopUploadTrack();
      }
    });

    // 设备解绑时停止任务
    libManager.deviceBind.listenUnbindNotification((macAddress) async {
      if (macAddress.isNotEmpty) {
        stopUploadMap();
        stopUploadTrack();
      }
    });
  }

  bool _isStopped = false;
  StreamSubscription? _subscriptTrans;

  bool _isStoppedTrack = false;
  StreamSubscription? _subscriptTransTrack;

  // 重试配置
  static const int _maxRetryCount = 1;
  static const Duration _retryDelay = Duration(milliseconds: 100);

  // 记录回调保证只回调一次
  void Function(IDOOfflineMapState state)? _onMapComplete;
  void Function(IDOOfflineMapState state)? _onTrackComplete;

  void _callMapComplete(IDOOfflineMapState state) {
    if (_onMapComplete != null) {
      _onMapComplete!(state);
      _onMapComplete = null;
    }
  }

  void _callTrackComplete(IDOOfflineMapState state) {
    if (_onTrackComplete != null) {
      _onTrackComplete!(state);
      _onTrackComplete = null;
    }
  }

  @override
  Future<List<OMAuthorizationInformation>?> checkAuthorized() async {
    logger?.d("[OfflineMap] checkAuthorized: 开始检查授权状态");
    try {
      final rs = await libManager
          .send(
              evt: CmdEvtType.offlineMap,
              json: jsonEncode(OMOfflineMapInformation(operate: 1).toJson()),
              priority: IDOCmdPriority.high)
          .first;

      if (!rs.isOK || rs.json == null) {
        logger?.d("[OfflineMap] checkAuthorized: 请求失败, code=${rs.code}");
        return null;
      }

      final obj = OMOfflineMapInformationReply.fromJson(jsonDecode(rs.json!));
      if (obj.errorCode == 0 &&
          obj.authorizationItems != null &&
          obj.authorizationItems!.isNotEmpty) {
        logger?.d("[OfflineMap] checkAuthorized: 授权状态查询成功");
        return obj.authorizationItems;
      }
      logger
          ?.d("[OfflineMap] checkAuthorized: 未授权, errorCode=${obj.errorCode}");
      return null;
    } catch (e, stackTrace) {
      logger?.d("[OfflineMap] checkAuthorized: 异常 - $e\n$stackTrace");
      return null;
    }
  }

  @override
  Future<int> configureAuthorization({required String code}) async {
    logger?.d("[OfflineMap] configureAuthorization: 开始设置授权码");
    try {
      // code 需要转为字节数据: 将十六进制字符串转换为字节数组
      final List<int> bytes = [];
      for (var i = 0; i < code.length; i += 2) {
        if (i + 2 <= code.length) {
          final hex = code.substring(i, i + 2);
          final byte = int.parse(hex, radix: 16);
          bytes.add(byte);
        }
      }

      final rs = await libManager
          .send(
              evt: CmdEvtType.offlineMap,
              json: jsonEncode(OMOfflineMapInformation(
                      operate: 2,
                      authorizationCode: bytes,
                      authorizationCodeLen: bytes.length)
                  .toJson()))
          .first;

      if (!rs.isOK || rs.json == null) {
        logger?.d("[OfflineMap] configureAuthorization: 请求失败, code=${rs.code}");
        return rs.code;
      }

      final obj = OMOfflineMapInformationReply.fromJson(jsonDecode(rs.json!));
      logger?.d(
          "[OfflineMap] configureAuthorization: 完成, errorCode=${obj.errorCode}");
      return obj.errorCode;
    } catch (e, stackTrace) {
      logger?.d("[OfflineMap] configureAuthorization: 异常 - $e\n$stackTrace");
      return -1;
    }
  }

  @override
  Future<List<OMMapConfigReply>?> queryMapConfig() async {
    logger?.d("[OfflineMap] queryMapConfig: 开始查询固件地图配置信息");
    try {
      final rs = await libManager
          .send(
              evt: CmdEvtType.offlineMap,
              json: jsonEncode(OMOfflineMapInformation(
                      operate: 3, mapConfigCount: 1, mapConfigItem: null)
                  .toJson()),
              priority: IDOCmdPriority.high)
          .first;

      if (!rs.isOK || rs.json == null) {
        logger?.d("[OfflineMap] queryMapConfig: 请求失败, code=${rs.code}");
        return null;
      }

      final obj = OMOfflineMapInformationReply.fromJson(jsonDecode(rs.json!));
      if (obj.errorCode == 0) {
        logger?.d("[OfflineMap] queryMapConfig: 查询固件地图配置信息成功");
        return obj.mapConfigItems ?? [];
      }
      logger?.d(
          "[OfflineMap] queryMapConfig: 查询固件地图配置信息查询失败, errorCode=${obj.errorCode}");
      return null;
    } catch (e, stackTrace) {
      logger?.d("[OfflineMap] queryMapConfig: 异常 - $e\n$stackTrace");
      return null;
    }
  }

  @override
  void uploadMap(
      String mapName,
      String filePath,
      void Function(double progress)? sendProgress,
      void Function(IDOOfflineMapState state) funcComplete) {
    logger?.d(
        "[OfflineMap] uploadMap: 开始上传地图, mapName=$mapName, filePath=$filePath");

    _onMapComplete = funcComplete;
    // 异步处理zip解压
    _handleZipAndUpload(mapName, filePath, sendProgress, _callMapComplete);
  }

  /// 处理zip文件解压并上传
  Future<void> _handleZipAndUpload(
      String mapName,
      String filePath,
      void Function(double progress)? sendProgress,
      void Function(IDOOfflineMapState state) funcComplete) async {
    String? tempDir;
    try {
      // 1. 检查zip文件是否存在
      final zipFile = File(filePath);
      if (!zipFile.existsSync()) {
        logger?.d("[OfflineMap] _handleZipAndUpload: zip文件不存在 - $filePath");
        funcComplete(IDOOfflineMapState.unzipResourceFailed);
        return;
      }

      // 2. 创建临时目录
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final tempDirPath = p.join(
          Directory.systemTemp.path, 'offline_map_${mapName}_$timestamp');
      tempDir = tempDirPath;
      final dir = Directory(tempDir);
      await dir.create(recursive: true);
      logger?.d("[OfflineMap] _handleZipAndUpload: 创建临时目录 - $tempDir");

      // 3. 解压zip文件到临时目录
      logger?.d("[OfflineMap] _handleZipAndUpload: 开始解压zip文件");
      final inputStream = InputFileStream(filePath);
      final archive = ZipDecoder().decodeBuffer(inputStream);
      await extractArchiveToDisk(archive, tempDir);
      logger?.d("[OfflineMap] _handleZipAndUpload: 解压完成");

      // 4. 验证解压后的目录不为空
      if (dir.listSync().isEmpty) {
        logger?.e("[OfflineMap] _handleZipAndUpload: 解压后目录为空");
        funcComplete(IDOOfflineMapState.unzipResourceFailed);
        return;
      }

      // 5. 包装完成回调，添加清理逻辑
      void wrappedComplete(IDOOfflineMapState state) {
        // 清理临时目录
        if (tempDir != null) {
          try {
            final dir = Directory(tempDir);
            if (dir.existsSync()) {
              dir.deleteSync(recursive: true);
              logger?.d("[OfflineMap] _handleZipAndUpload: 清理临时目录 - $tempDir");
            }
          } catch (e) {
            logger?.e("[OfflineMap] _handleZipAndUpload: 清理临时目录失败 - $e");
          }
        }
        // 调用原始回调
        funcComplete(state);
      }

      // 6. 调用原有的上传任务
      _updateOfflineMapTask(mapName, tempDir, sendProgress, wrappedComplete);
    } catch (e, stackTrace) {
      logger?.e("[OfflineMap] _handleZipAndUpload: 异常 - $e\n$stackTrace");

      // 清理临时目录
      if (tempDir != null) {
        try {
          final dir = Directory(tempDir);
          if (dir.existsSync()) {
            dir.deleteSync(recursive: true);
          }
        } catch (cleanupError) {
          logger
              ?.e("[OfflineMap] _handleZipAndUpload: 清理临时目录失败 - $cleanupError");
        }
      }

      funcComplete(IDOOfflineMapState.failed);
    }
  }

  @override
  void stopUploadMap() {
    _isStopped = true;
    if (_subscriptTrans != null) {
      logger
          ?.d("[OfflineMap] stopUploadMap: 停止上传地图 ${_subscriptTrans != null}");
      _subscriptTrans?.cancel();
      _subscriptTrans = null;
      _callMapComplete(IDOOfflineMapState.canceled);
    }
  }

  @override
  void uploadTrack(
      String trackName,
      String filePath,
      int distance,
      int duration,
      int type,
      void Function(double progress)? sendProgress,
      void Function(IDOOfflineMapState state) funcComplete) {
    logger?.d(
        "[OfflineMap] uploadTrack: 开始上传轨迹, trackName=$trackName, filePath=$filePath, distance=$distance, duration=$duration, type=$type");
    _onTrackComplete = funcComplete;
    _updateTrackTask(trackName, filePath, distance, duration, type,
        sendProgress, _callTrackComplete);
  }

  @override
  void stopUploadTrack() {
    _isStoppedTrack = true;
    if (_subscriptTransTrack != null) {
      logger?.d(
          "[OfflineMap] stopUploadTrack: 停止上传轨迹 ${_subscriptTransTrack != null}");
      _subscriptTransTrack?.cancel();
      _subscriptTransTrack = null;
      _callTrackComplete(IDOOfflineMapState.canceled);
    }
  }

  @override
  Future<IDOOfflineMapState> deleteMap(List<OMOfflineMapFileInfo> mapFiles) async {
    return _mapErrorCode(await _deleteMap(mapFiles));
  }
}

extension _IDOOfflineMapManagerExt on _IDOOfflineMapManager {
  /// 通用重试方法
  Future<T> _retryOperation<T>({
    required String operationName,
    required Future<T> Function() operation,
    int maxRetries = _IDOOfflineMapManager._maxRetryCount,
    Duration delay = _IDOOfflineMapManager._retryDelay,
    bool Function(dynamic error)? shouldRetry,
  }) async {
    int attempts = 0;
    dynamic lastError;

    while (attempts < maxRetries) {
      try {
        attempts++;
        logger?.d("[OfflineMap] $operationName: 第 $attempts 次尝试");
        return await operation();
      } catch (e, stackTrace) {
        lastError = e;
        logger?.d("[OfflineMap] $operationName: 第 $attempts 次尝试失败 - $e");

        // 检查是否应该重试
        if (shouldRetry != null && !shouldRetry(e)) {
          logger?.d("[OfflineMap] $operationName: 错误不可重试，直接抛出");
          rethrow;
        }

        if (attempts >= maxRetries) {
          logger?.d("[OfflineMap] $operationName: 已达最大重试次数 $maxRetries，放弃重试");
          rethrow;
        }

        // 指数退避延迟
        final backoffDelay = delay * attempts;
        logger?.d(
            "[OfflineMap] $operationName: 等待 ${backoffDelay.inMilliseconds}ms 后重试");
        await Future.delayed(backoffDelay);
      }
    }

    throw lastError ?? Exception("$operationName 重试失败");
  }

  Future<void> _updateOfflineMapTask(
      String mapName,
      String filePath,
      void Function(double progress)? sendProgress,
      void Function(IDOOfflineMapState state) funcComplete) async {
    _isStopped = false;
    logger?.d("[OfflineMap] _updateOfflineMapTask: 开始处理地图上传任务");

    try {
      // 0. 检查本地文件
      final dir = Directory(filePath);
      if (!dir.existsSync()) {
        logger?.d("[OfflineMap] _updateOfflineMapTask: 本地目录不存在 - $filePath");
        funcComplete(IDOOfflineMapState.invalidResource);
        return;
      }

      if (mapName.isEmpty) {
        logger?.d("[OfflineMap] _updateOfflineMapTask: 地图名称为空");
        funcComplete(IDOOfflineMapState.invalidMapName);
        return;
      }

      if (_isStopped) {
        logger?.d("[OfflineMap] _updateOfflineMapTask: 任务已停止");
        funcComplete(IDOOfflineMapState.canceled);
        return;
      }

      // 1. Operate 5: 查询单个地图详细信息
      logger?.d("[OfflineMap] _updateOfflineMapTask: 查询地图详细信息");
      final queryRes = await _retryOperation(
        operationName: "queryMapInfo",
        operation: () => libManager
            .send(
                evt: CmdEvtType.offlineMap,
                json: jsonEncode(OMOfflineMapInformation(
                        operate: 5,
                        mapNameCount: 1,
                        mapNameItems: [OMOfflineMapName(name: mapName)],
                        filePath: filePath,
                        mapName: mapName)
                    .toJson()),
                priority: IDOCmdPriority.high)
            .first,
      );

      if (_isStopped) {
        logger?.d("[OfflineMap] _updateOfflineMapTask: 任务已停止");
        funcComplete(IDOOfflineMapState.canceled);
        return;
      }

      if (!queryRes.isOK || queryRes.json == null) {
        logger?.d(
            "[OfflineMap] _updateOfflineMapTask: 查询失败, code=${queryRes.code}");
        funcComplete(IDOOfflineMapState.queryMapInfoFailed);
        return;
      }

      final queryObj =
          OMOfflineMapInformationReply.fromJson(jsonDecode(queryRes.json!));
      logger?.d(
          "[OfflineMap] _updateOfflineMapTask: 查询结果, errorCode=${queryObj.errorCode}");

      bool needDelete = false;
      bool needAdd = false;
      final mapItem =
          (queryObj.mapItems != null && queryObj.mapItems!.isNotEmpty)
              ? queryObj.mapItems!.first
              : null;
      final deviceFiles = mapItem?.downloadFiles;

      // 如果没有文件列表，认为不需要更新
      if (deviceFiles == null) {
        logger?.d("[OfflineMap] _updateOfflineMapTask: 无文件列表，无需更新");
        funcComplete(IDOOfflineMapState.successful);
        return;
      }

      List<NormalFileModel> transItems = deviceFiles.map((f) {
        final fPath = p.join(filePath, f.name);
        logger?.d(
            "[OfflineMap] _transferFiles: 准备文件 - name=${f.name} path=$fPath");
        return NormalFileModel(
            fileType: FileTransType.map, filePath: fPath, fileName: f.name);
      }).toList();

      logger?.d(
          "[OfflineMap] _updateOfflineMapTask: 设备文件数量=${deviceFiles.length}");

      if (queryObj.errorCode == 0) {
        // 判断是否续传：如果文件列表小于7个，认为是续传
        if (deviceFiles.length < 7) {
          logger?.d("[OfflineMap] _updateOfflineMapTask: 续传模式，直接传输文件");
          _subscriptTrans =
              _transferFiles(transItems, sendProgress, funcComplete);
          return;
        } else {
          logger?.d("[OfflineMap] _updateOfflineMapTask: 需要添加地图后传输");
          needAdd = true;
        }
      } else if (queryObj.errorCode == 5) {
        logger?.d("[OfflineMap] _updateOfflineMapTask: 固件无该地图，需要添加");
        needAdd = true;
      } else if ([201, 202, 203].contains(queryObj.errorCode)) {
        logger?.d("[OfflineMap] _updateOfflineMapTask: 地图文件不一致，需要删除后重新添加");
        needDelete = true;
        needAdd = true;
      } else {
        logger?.d(
            "[OfflineMap] _updateOfflineMapTask: 其他错误, errorCode=${queryObj.errorCode}");
        funcComplete(_mapErrorCode(queryObj.errorCode));
        return;
      }

      if (_isStopped) {
        logger?.d("[OfflineMap] _updateOfflineMapTask: 任务已停止");
        funcComplete(IDOOfflineMapState.canceled);
        return;
      }

      // 2. 需要删除 (Operate 4)
      if (needDelete) {
        logger?.d("[OfflineMap] _updateOfflineMapTask: 开始删除旧地图");
        final delRes = await _deleteMap(deviceFiles);

        if (_isStopped) {
          logger?.d("[OfflineMap] _updateOfflineMapTask: 任务已停止");
          funcComplete(IDOOfflineMapState.canceled);
          return;
        }

        if (delRes != 0) {
          logger?.d(
              "[OfflineMap] _updateOfflineMapTask: 删除地图失败 errCode: $delRes");
          funcComplete(IDOOfflineMapState.deleteMapFailed);
          return;
        }
        logger?.d("[OfflineMap] _updateOfflineMapTask: 删除地图成功");
      }

      // 3. 需要添加 (Operate 6)
      if (needAdd) {
        logger?.d("[OfflineMap] _updateOfflineMapTask: 开始添加地图");
        final addRes = await _addMap(mapName, deviceFiles, filePath);

        if (_isStopped) {
          logger?.d("[OfflineMap] _updateOfflineMapTask: 任务已停止");
          funcComplete(IDOOfflineMapState.canceled);
          return;
        }

        if (addRes != 0) {
          logger?.d(
              "[OfflineMap] _updateOfflineMapTask: 添加地图失败 errCode: $addRes");
          funcComplete(IDOOfflineMapState.addMapFailed);
          return;
        }
        logger?.d("[OfflineMap] _updateOfflineMapTask: 添加地图成功");
      }

      // 4. 文件传输
      if (_isStopped) {
        logger?.d("[OfflineMap] _updateOfflineMapTask: 任务已停止");
        funcComplete(IDOOfflineMapState.canceled);
        return;
      }

      logger?.d("[OfflineMap] _updateOfflineMapTask: 开始传输文件");
      _subscriptTrans = _transferFiles(transItems, sendProgress, funcComplete);
    } catch (e, stackTrace) {
      logger?.d("[OfflineMap] _updateOfflineMapTask: 异常 - $e\n$stackTrace");
      funcComplete(IDOOfflineMapState.failed);
    }
  }

  Future<void> _updateTrackTask(
      String trackName,
      String filePath,
      int distance,
      int duration,
      int type,
      void Function(double progress)? sendProgress,
      void Function(IDOOfflineMapState state) funcComplete) async {
    _isStoppedTrack = false;
    logger?.d("[OfflineMap] _updateTrackTask: 开始处理轨迹上传任务");

    try {
      // 0. 检查本地文件
      final file = File(filePath);
      if (!file.existsSync()) {
        logger?.d("[OfflineMap] _updateTrackTask: 本地文件不存在 - $filePath");
        funcComplete(IDOOfflineMapState.invalidResource);
        return;
      }

      if (_isStoppedTrack) {
        logger?.d("[OfflineMap] _updateTrackTask: 任务已停止");
        funcComplete(IDOOfflineMapState.canceled);
        return;
      }

      // 1. Operate 7: 添加单个轨迹文件
      final size = await file.length();
      logger?.d("[OfflineMap] _updateTrackTask: 文件大小=$size");

      final trackInfo = OMTrackInformation(
          name: trackName,
          size: size,
          distance: distance,
          duration: duration,
          type: type);

      logger?.d("[OfflineMap] _updateTrackTask: 发送添加轨迹请求");
      final rs = await _retryOperation(
        operationName: "addTrack",
        operation: () => libManager
            .send(
                evt: CmdEvtType.offlineMap,
                json: jsonEncode(OMOfflineMapInformation(
                        operate: 7,
                        trackItemCount: 1,
                        trackItem: [trackInfo],
                        filePath: filePath)
                    .toJson()),
                priority: IDOCmdPriority.high)
            .first,
      );

      if (_isStoppedTrack) {
        logger?.d("[OfflineMap] _updateTrackTask: 任务已停止");
        funcComplete(IDOOfflineMapState.canceled);
        return;
      }

      if (!rs.isOK || rs.json == null) {
        logger?.d("[OfflineMap] _updateTrackTask: 添加轨迹请求失败, code=${rs.code}");
        funcComplete(IDOOfflineMapState.addTrackFailed);
        return;
      }

      final obj = OMOfflineMapInformationReply.fromJson(jsonDecode(rs.json!));
      if (obj.errorCode == 15) {
        // 15: 表示设备端已有相同路线
        logger?.d("[OfflineMap] _updateTrackTask: 设备端已有相同路线");
        funcComplete(IDOOfflineMapState.trackExists);
        return;
      } else if (obj.errorCode != 0) {
        logger?.d(
            "[OfflineMap] _updateTrackTask: 添加轨迹失败, errorCode=${obj.errorCode}");
        funcComplete(_mapErrorCode(obj.errorCode));
        return;
      }

      logger?.d("[OfflineMap] _updateTrackTask: 添加轨迹成功，开始传输文件");

      // 2. 文件传输
      final fileItem = NormalFileModel(
          fileType: FileTransType.gpx, filePath: filePath, fileName: trackName);
      _subscriptTransTrack =
          _transferFiles([fileItem], sendProgress, funcComplete);
    } catch (e, stackTrace) {
      logger?.d("[OfflineMap] _updateTrackTask: 异常 - $e\n$stackTrace");
      funcComplete(IDOOfflineMapState.failed);
    }
  }
}

/// 辅助方法：删除地图 0:成功，其它失败
Future<int> _deleteMap(List<OMOfflineMapFileInfo> mapFiles) async {
  logger?.d("[OfflineMap] _deleteMap: 开始删除地图, 文件数量=${mapFiles.length}");

  try {
    final items = mapFiles.map((e) => OMOfflineMapName(name: e.name)).toList();
    final rs = await libManager
        .send(
            evt: CmdEvtType.offlineMap,
            json: jsonEncode(OMOfflineMapInformation(
                    operate: 4,
                    mapNameCount: mapFiles.length,
                    mapNameItems: items)
                .toJson()),
            priority: IDOCmdPriority.high)
        .first;

    if (rs.isOK && rs.json != null) {
      final obj = OMOfflineMapInformationReply.fromJson(jsonDecode(rs.json!));
      if (obj.errorCode == 0) {
        logger?.d("[OfflineMap] _deleteMap: 删除成功");
        return 0;
      }
      logger?.d("[OfflineMap] _deleteMap: 删除失败, errorCode=${obj.errorCode}");
      return obj.errorCode;
    } else {
      logger?.d("[OfflineMap] _deleteMap: 请求失败, isOK=${rs.isOK}");
      return rs.code;
    }
  } catch (e, stackTrace) {
    logger?.d("[OfflineMap] _deleteMap: 异常 - $e\n$stackTrace");
  }
  return -1;
}

/// 辅助方法：添加地图
Future<int> _addMap(
    String mapName, List<OMOfflineMapFileInfo> files, String rootPath) async {
  logger?.d(
      "[OfflineMap] _addMap: 开始添加地图, mapName=$mapName, 文件数量=${files.length}");
  try {
    // 构建文件列表信息
    List<OMOfflineMapFileInfo> fileInfos = [];
    int totalSize = 0;

    for (var f in files) {
      final size = f.size;
      totalSize += size;
      fileInfos.add(OMOfflineMapFileInfo(
          name: f.name, size: size, crc16: f.crc16, path: f.path));
    }

    logger?.d("[OfflineMap] _addMap: 总大小=$totalSize");

    final rs = await libManager
        .send(
            evt: CmdEvtType.offlineMap,
            json: jsonEncode(OMOfflineMapInformation(
                    operate: 6,
                    mapInformationCount: 1,
                    mapItems: [
                      OMMapInformation(
                          name: mapName,
                          size: totalSize,
                          fileCount: files.length,
                          files: fileInfos)
                    ],
                    filePath: rootPath)
                .toJson()),
            priority: IDOCmdPriority.high)
        .first;

    if (rs.isOK && rs.json != null) {
      final obj = OMOfflineMapInformationReply.fromJson(jsonDecode(rs.json!));
      if (obj.errorCode == 0) {
        logger?.d("[OfflineMap] _addMap: 添加成功");
        return 0;
      }
      logger?.d("[OfflineMap] _addMap: 添加失败, errorCode=${obj.errorCode}");
      return obj.errorCode;
    } else {
      logger?.d("[OfflineMap] _addMap: 请求失败, isOK=${rs.isOK}");
      return rs.code;
    }
  } catch (e, stackTrace) {
    logger?.d("[OfflineMap] _addMap: 异常 - $e\n$stackTrace");
  }

  logger?.d("[OfflineMap] _addMap: 添加失败");
  return -1;
}

/// 辅助方法：传输文件
StreamSubscription _transferFiles(
    List<NormalFileModel> files,
    void Function(double progress)? sendProgress,
    void Function(IDOOfflineMapState state) funcComplete) {
  logger?.d("[OfflineMap] _transferFiles: 开始传输文件, 文件数量=${files.length}");
  var errorCodes = [];
  return libManager.transFile
      .transferMultiple(
          fileItems: files,
          funcStatus: (int index, FileTransStatus status) {
            logger?.d("[OfflineMap] _transferFiles: 文件[$index] 状态变更 - $status");
          },
          funcProgress: (int currentIndex, int totalCount,
              double currentProgress, double totalProgress) {
            logger?.d(
                "[OfflineMap] _transferFiles: 进度 - 当前文件[${currentIndex + 1}/$totalCount]: ${(currentProgress * 100).toStringAsFixed(1)}%, 总进度: ${(totalProgress * 100).toStringAsFixed(1)}%");
            if (sendProgress != null) {
              sendProgress(totalProgress);
            }
          },
          funError: (idx, err, errVal, time) {
            logger?.d(
                "[OfflineMap] _transferFiles: 错误 - idx=$idx, err=$err, errVal=$errVal, time=$time");
            errorCodes.add(errVal);
            // 添加路线文件复制到日志目录，用于定位问题
            if (errVal == 0 && files[idx].fileType == FileTransType.gpx) {
              _backupTrackFile(files[idx].filePath);
            }
          }, cancelPrevTranTask: true)
      .listen(
    (transResult) {
      logger?.d("[OfflineMap] _transferFiles: 传输完成, 结果=$transResult");
      if (transResult.isNotEmpty && transResult.every((e) => e)) {
        logger?.d("[OfflineMap] _transferFiles: 所有文件传输成功");
        funcComplete(IDOOfflineMapState.successful);
      } else {
        logger?.d("[OfflineMap] _transferFiles: 部分文件传输失败");
        // 解析错误码并映射到IDOOfflineMapState
        final firstErrCode = errorCodes.firstWhere((val) => val != 0);
        funcComplete(_mapErrorCode(firstErrCode));
      }
    },
    onError: (error, stackTrace) {
      logger?.d("[OfflineMap] _transferFiles: 传输异常 - $error\n$stackTrace");
      funcComplete(IDOOfflineMapState.failed);
    },
  );
}

void _backupTrackFile(String trackFilePath) async {
  logger?.d("[OfflineMap] _backupTrackFile: 开始备份轨迹文件");
  try {
    // 1. 获取文件名和路径
    final fileName = p.basename(trackFilePath);
    //final timestamp = DateTime.now().millisecondsSinceEpoch;
    final now = DateTime.now();
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    final h = now.hour.toString().padLeft(2, '0');
    final min = now.minute.toString().padLeft(2, '0');
    final s = now.second.toString().padLeft(2, '0');
    
    final timestamp = "$m$d$h$min$s";
    final newFileName = "${timestamp}_$fileName";

    final rootPath = await storage?.pathSDK();
    if (rootPath == null) {
      throw Exception("无法获取存储路径");
    }

    // 2. 定义目标文件夹路径
    final directoryPath = p.join(rootPath, "logs", "_gpx_");
    final newFilePath = p.join(directoryPath, newFileName);

    // 3. 核心修复：确保目标目录存在
    // recursive: true 会自动创建所有不存在的父目录
    final directory = Directory(directoryPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
      logger?.d("[OfflineMap] _backupTrackFile: 文件夹不存在，已创建目录: $directoryPath");
    }

    // 4. 执行拷贝
    final sourceFile = File(trackFilePath);
    if (await sourceFile.exists()) {
      await sourceFile.copy(newFilePath);
      logger?.d("[OfflineMap] _backupTrackFile: 备份成功 - $newFilePath");
    } else {
      logger?.e("[OfflineMap] _backupTrackFile: 备份失败 - 源文件不存在: $trackFilePath");
    }

  } catch (e, stackTrace) {
    logger?.e("[OfflineMap] _backupTrackFile: 备份过程中出现异常 - $e\n$stackTrace");
  }
}

/// 错误码映射
IDOOfflineMapState _mapErrorCode(int errorCode) {
  switch (errorCode) {
    case 0:
      return IDOOfflineMapState.successful;
    case -1:
      return IDOOfflineMapState.canceled;
    case -2:
      return IDOOfflineMapState.failed;
    case 26:
      return IDOOfflineMapState.devicePowerSaving;
    case 27:
      return IDOOfflineMapState.deviceIsSporting;
    case 28:
      return IDOOfflineMapState.deviceIsCalling;
    case 29:
      return IDOOfflineMapState.deviceInCharging;
    case 30:
      return IDOOfflineMapState.deviceFullNumber;
    default:
      return IDOOfflineMapState.failed;
  }
}
