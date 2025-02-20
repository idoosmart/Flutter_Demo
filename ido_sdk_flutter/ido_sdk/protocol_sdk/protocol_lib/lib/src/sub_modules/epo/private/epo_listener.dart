part of '../epo_manager.dart';

class _EpoStatusListener {
  final void Function(EpoUpgradeStatus status) onStatusChanged;
  final void Function(double progress)? onDownloadProgress;
  final void Function(double progress)? onSendProgress;
  final void Function(int errorCode) onComplete;

  _EpoStatusListener({
    required this.onStatusChanged,
    this.onDownloadProgress,
    this.onSendProgress,
    required this.onComplete,
  });
}

extension _IDOEPOManagerListener on _IDOEPOManager {
  _registerListener() {
    _statusModel.addListener(() {
      if (_statusModel.isStopped) {
        return;
      }
      _streamCallbackCtrl.add(_statusModel.epoStatus);
      if (_statusModel.epoStatus == EpoUpgradeStatus.failure
          || _statusModel.epoStatus == EpoUpgradeStatus.success) {
        final curStatus = _statusModel.epoStatus;
        // 升级结束，重置状态
        _statusModel.resetAll();
        _needAutoUpdateOnIdle = true;
        logger?.i('EPO: 本次任务结束: $curStatus，重置状态');
      }
    });

    // 设备epo升级结果通知
    libManager.listenDeviceNotification((value) {
      if (_isIcoeGpsPlatform()) {
        //logger?.e("EPO: 该平台无 43、44的成功通知（有也不处理）");
        return;
      }
      final dataType = value.dataType;
      switch (dataType) {
        case 43: // 固件升级EPO.dat文件失败，通知app再次下发一次该文件
          _tryUpgradeIfNeed(EpoUpgradeStatus.installing);
          break;
        case 44: // 固件升级EPO.dat文件成功
          _retryCountMap.clear();
          _updateResult(true);
          _updateGpsHotStartParam();
          logger?.i('EPO: dataType:$dataType  固件升级EPO.dat文件成功');
          break;
      }
    });

    // 文件传输状态变更
    libManager.transFile.listenTransFileTypeChanged((fileType) {
      if (fileType == null) {
        // 空闲状态
        _statusModel.isTransBusy = false;
      } else if (fileType != FileTransType.epo) {
        // 不是EPO文件
        _statusModel.isTransBusy = true;
      }
    });

    // 连接状态变更，切换设备
    libManager.listenConnectStatusChanged((isConnected) {
      _statusModel.isConnected = isConnected;
      if (isConnected) {
        if (_statusModel.lastMacAddress != libManager.macAddress) {
          stop(); // 切换设备，停止epo升级（如果有）
        }
        _statusModel.lastMacAddress = libManager.macAddress;
      } else {
        _statusModel.lastMacAddress = '';
      }
    });

    // 快速配置
    libManager.listenStatusNotification((status) {
      if (status == IDOStatusNotification.fastSyncCompleted) {
        // 快速配置完成, 延迟1分钟执行epo升级
        _startAutoUpgradeTimer();
        // 请求更新热启动参数
        _updateGpsHotStartParam();
      }
    });

    // 数据同步
    libManager.syncData.listenSyncStatus().listen((event) {
      if (event == SyncStatus.syncing && _statusModel.isUpgrading) {
        //stop(); // 可并行执行epo升级，先不停止
      } else if (event == SyncStatus.finished && !_statusModel.isUpgrading) {
        _startAutoUpgradeTimer();
      }
    });

    // 设备解绑
    libManager.deviceBind.listenUnbindNotification((macAddress) async {
      if (macAddress.isNotEmpty) {
        await storage?.removeOtaInfo(macAddress);
      }
    });
  }
}