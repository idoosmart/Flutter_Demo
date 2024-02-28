import 'dart:async';

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
  // ConnectivityResult _status = ConnectivityResult.none;
  // late final Connectivity _connectivity = Connectivity();
  // late StreamSubscription<ConnectivityResult> _subscription;
  late StreamController<NetworkStatus> _streamController;

  static final _instance = AlexaReachability._internal();
  factory AlexaReachability() => _instance;
  AlexaReachability._internal() {
    //_initConnectivity();
    _streamController = StreamController.broadcast();
    // _subscription = _connectivity.onConnectivityChanged.listen((e) {
    //   _updateConnectionStatus(e);
    // });
  }

  /// 是否有网
  bool get hasNetwork => _networkStatus != NetworkStatus.notReachable;

  /// 网络状态类型
  NetworkStatus get networkStatus => _networkStatus;


  // 判断网络可达，需要用到connectivity_plus这个库，该引用编译后会产生：
  // connectivity_plus.xcframework \ Reachability.xcframework，
  // 使用纯dart代码暂未找到解决办法，此处去除网络变化获取，改由外部传入
  void setNetworkState(bool hasNetwork) {
    _networkStatus = hasNetwork ? NetworkStatus.reachableViaWiFi : NetworkStatus.notReachable;
    _streamController.add(_networkStatus);
  }

  /// 网络状态变更
  void listenNetworkStatusChanged(void Function(NetworkStatus status) func) {
    _streamController.stream.listen(func);
  }

}
