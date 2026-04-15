import 'dart:async';

import 'package:protocol_lib/protocol_lib.dart';

import '../pigeon_generate/epo.g.dart';

class EpoImpl extends ApiEPOManager implements IDOEPOManagerDelegate {

  late final _epoManager = IDOEPOManager();
  final _delegate = ApiEpoManagerDelegate();

  EpoImpl() {
    _epoManager.delegateGetGps = this;
    _epoManager.listenEPOStatusChanged((status) {
      try {
        _delegate.onEpoStatusChanged(ApiEpoUpgradeStatus.values[status.index]);
      }catch (e) {
        libManager.cache.writeLog("epo status error: $e");
      }
    }, (progress) {
      _delegate.onEpoDownloadProgress(progress);
    }, (progress) {
      _delegate.onEpoSendProgress(progress);
    }, (errorCode) {
      _delegate.onEpoComplete(errorCode);
    });
  }

  @override
  Future<int> lastUpdateTimestamp() async {
    return _epoManager.lastUpdateTimestamp();
  }

  @override
  Future<bool> shouldUpdateForEPO(bool isForce) {
    return _epoManager.shouldUpdateForEPO(isForce: isForce);
  }

  @override
  void stop() {
    _epoManager.stop();
  }

  @override
  void willStartInstall(bool isForce, int retryCount) {
    _epoManager.willStartInstall(isForce: isForce, retryCount: retryCount);
  }

  @override
  Future<OTAGpsInfo?> getAppGpsInfo() async {
    final gpsInfo = await _delegate.onGetGps();
    if (gpsInfo != null) {
      return OTAGpsInfo(
        latitude: gpsInfo.latitude ?? 0.0,
        longitude: gpsInfo.longitude ?? 0.0,
        altitude: gpsInfo.altitude ?? 0.0,
        tcxoOffset: gpsInfo.tcxoOffset ?? 0,
      );
    }
    return null;
  }

  @override
  bool enableAutoUpgrade() {
    return _epoManager.enableAutoUpgrade;
  }

  @override
  void setEnableAutoUpgrade(bool value) {
    _epoManager.enableAutoUpgrade = value;
  }
  
}