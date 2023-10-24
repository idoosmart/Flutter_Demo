import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../logger/logger.dart';

/// 网络状态
enum NetworkStatus {
  /// 网络不可用
  notReachable,

  /// WiFi
  reachableViaWiFi,

  /// 移动网络
  reachableViaWWAN
}

/// 网络状态监听
class AlexaReachability {
  NetworkStatus _networkStatus = NetworkStatus.reachableViaWiFi;
  ConnectivityResult _status = ConnectivityResult.none;
  late final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _subscription;
  late StreamController<NetworkStatus> _streamController;

  static final _instance = AlexaReachability._internal();
  factory AlexaReachability() => _instance;
  AlexaReachability._internal() {
    _initConnectivity();
    _streamController = StreamController.broadcast();
    _subscription = _connectivity.onConnectivityChanged.listen((e) {
      _updateConnectionStatus(e);
    });
  }

  /// 是否有网
  bool get hasNetwork => _networkStatus != NetworkStatus.notReachable;

  /// 网络状态类型
  NetworkStatus get networkStatus => _networkStatus;

  /// 网络状态变更
  void listenNetworkStatusChanged(void Function(NetworkStatus status) func) {
    _streamController.stream.listen(func);
  }

  void _dispose() {
    _subscription.cancel();
    _streamController.close();
  }

  Future<void> _initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      logger?.e(e.toString());
      return;
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _status = result;
    _networkStatus = _mappingStatus();
    logger?.d('network changed:${result.name}');
    if (_streamController.hasListener) {
      _streamController.add(_networkStatus);
    }
  }

  NetworkStatus _mappingStatus() {
    NetworkStatus ns = NetworkStatus.reachableViaWiFi;
    switch (_status) {
      case ConnectivityResult.wifi:
        ns = NetworkStatus.reachableViaWiFi;
        break;
      case ConnectivityResult.mobile:
        ns = NetworkStatus.reachableViaWWAN;
        break;
      case ConnectivityResult.none:
        ns = NetworkStatus.notReachable;
        break;
      default:
        break;
    }
    return ns;
  }
}
