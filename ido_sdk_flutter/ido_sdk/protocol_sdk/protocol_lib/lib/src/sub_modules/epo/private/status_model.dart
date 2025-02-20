part of '../epo_manager.dart';

class _EpoStatusModel extends ChangeNotifier  {

  /// 强制更新
  var isForceUpdate = false;

  /// 其它文件传输中
  late var isTransBusy = libManager.transFile.isTransmitting;

  /// 当前设备连接状态
  late var isConnected = libManager.isConnected;

  /// 最后连接的设备mac地址
  var lastMacAddress = '';

  /// EPO停止
  var isStopped = false;

  bool get isUpgrading {
    if (isStopped || !isConnected) {
      return false;
    }
    return [EpoUpgradeStatus.idle,
      EpoUpgradeStatus.success,
      EpoUpgradeStatus.failure
    ].contains(_epoStatus) == false;
  }

  /// EPO升级状态
  EpoUpgradeStatus _epoStatus = EpoUpgradeStatus.idle;
  EpoUpgradeStatus get epoStatus => _epoStatus;
  set epoStatus(EpoUpgradeStatus value) {
    if (_epoStatus != value) {
      _epoStatus = value;
      notifyListeners();
    }
  }

  resetAll() {
    isForceUpdate = false;
    isTransBusy = libManager.transFile.isTransmitting;
    isConnected = libManager.isConnected;
    lastMacAddress = '';
    epoStatus = EpoUpgradeStatus.idle;
  }
}