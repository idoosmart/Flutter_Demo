import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/ido_bluetooth.dart';
import 'package:protocol_lib/protocol_lib.dart';

/// Demo 连接/协议状态（全局单例，供首页与功能页共用）
enum DemoConnectionPhase {
  bluetoothOff,
  disconnected,
  connecting,
  connected,
  protocolReady,
  fastSyncing,
  fastSyncDone,
  fastSyncFailed,
}

class ConnectionStatusController extends ChangeNotifier {
  ConnectionStatusController._();

  static final ConnectionStatusController instance =
      ConnectionStatusController._();

  StreamSubscription? _deviceStateSub;
  StreamSubscription? _bluetoothStateSub;
  StreamSubscription? _libStatusSub;
  bool _started = false;

  IDOBluetoothStateType _bleAdapterState = IDOBluetoothStateType.unknown;
  IDOBluetoothDeviceStateType _deviceState =
      IDOBluetoothDeviceStateType.disconnected;
  DemoConnectionPhase _phase = DemoConnectionPhase.disconnected;
  String? _macAddress;
  String? _deviceName;
  bool _isBindedHint = false;

  DemoConnectionPhase get phase => _phase;
  String? get macAddress => _macAddress;
  String? get deviceName => _deviceName;
  IDOBluetoothDeviceStateType get deviceState => _deviceState;
  bool get isConnected =>
      _deviceState == IDOBluetoothDeviceStateType.connected ||
      libManager.isConnected;

  String get statusText {
    if (_deviceState == IDOBluetoothDeviceStateType.disconnecting) {
      return '断开中…';
    }
    switch (_phase) {
      case DemoConnectionPhase.bluetoothOff:
        return '蓝牙已关闭';
      case DemoConnectionPhase.disconnected:
        return '未连接';
      case DemoConnectionPhase.connecting:
        return '连接中…';
      case DemoConnectionPhase.connected:
        return '已连接（协议初始化中）';
      case DemoConnectionPhase.protocolReady:
        return '已连接 · 协议就绪';
      case DemoConnectionPhase.fastSyncing:
        return '快速配置中…';
      case DemoConnectionPhase.fastSyncDone:
        return '已连接 · 快速配置完成';
      case DemoConnectionPhase.fastSyncFailed:
        return '已连接 · 快速配置失败';
    }
  }

  Color get statusColor {
    switch (_phase) {
      case DemoConnectionPhase.bluetoothOff:
      case DemoConnectionPhase.fastSyncFailed:
        return Colors.red.shade700;
      case DemoConnectionPhase.disconnected:
        return Colors.grey.shade700;
      case DemoConnectionPhase.connecting:
      case DemoConnectionPhase.fastSyncing:
        return Colors.orange.shade800;
      case DemoConnectionPhase.connected:
        return Colors.blue.shade700;
      case DemoConnectionPhase.protocolReady:
      case DemoConnectionPhase.fastSyncDone:
        return Colors.green.shade700;
    }
  }

  String get detailText {
    final name = _deviceName;
    final mac = _macAddress;
    if (name != null && name.isNotEmpty && mac != null && mac.isNotEmpty) {
      return '$name ($mac)';
    }
    if (mac != null && mac.isNotEmpty) return mac;
    if (name != null && name.isNotEmpty) return name;
    return '无当前设备';
  }

  bool get isBindedHint => _isBindedHint;

  void setBindedHint(bool value) {
    if (_isBindedHint == value) return;
    _isBindedHint = value;
    notifyListeners();
  }

  /// 在 SDK 注册完成后调用一次
  Future<void> start() async {
    if (_started) return;
    _started = true;

    try {
      _bleAdapterState = await bluetoothManager.getBluetoothState();
    } catch (_) {}

    try {
      _deviceState = await bluetoothManager.getDeviceState();
    } catch (_) {}

    _macAddress = bluetoothManager.currentDevice?.macAddress;
    _deviceName = bluetoothManager.currentDevice?.name;
    _recomputePhase();
    notifyListeners();

    _bluetoothStateSub =
        bluetoothManager.bluetoothState().listen((event) async {
      _bleAdapterState = event.state;
      if (_bleAdapterState == IDOBluetoothStateType.poweredOff) {
        _deviceState = IDOBluetoothDeviceStateType.disconnected;
      }
      _recomputePhase();
      notifyListeners();
    });

    _deviceStateSub = bluetoothManager.deviceState().listen((event) {
      _deviceState =
          event.state ?? IDOBluetoothDeviceStateType.disconnected;
      if (event.macAddress != null && event.macAddress!.isNotEmpty) {
        _macAddress = event.macAddress;
      } else {
        _macAddress = bluetoothManager.currentDevice?.macAddress;
      }
      _deviceName = bluetoothManager.currentDevice?.name ?? _deviceName;

      if (_deviceState == IDOBluetoothDeviceStateType.disconnected) {
        // 断连后保留上次设备信息用于展示，但状态回到未连接
      }
      _recomputePhase();
      notifyListeners();
    });

    _libStatusSub = libManager.listenStatusNotification((status) {
      switch (status) {
        case IDOStatusNotification.protocolConnectCompleted:
          if (_deviceState == IDOBluetoothDeviceStateType.connected) {
            _phase = DemoConnectionPhase.protocolReady;
            notifyListeners();
          }
          break;
        case IDOStatusNotification.fastSyncStarting:
          _phase = DemoConnectionPhase.fastSyncing;
          notifyListeners();
          break;
        case IDOStatusNotification.fastSyncCompleted:
          _phase = DemoConnectionPhase.fastSyncDone;
          _macAddress = bluetoothManager.currentDevice?.macAddress ?? _macAddress;
          _deviceName = bluetoothManager.currentDevice?.name ?? _deviceName;
          notifyListeners();
          break;
        case IDOStatusNotification.fastSyncFailed:
          _phase = DemoConnectionPhase.fastSyncFailed;
          notifyListeners();
          break;
        default:
          break;
      }
    });
  }

  void _recomputePhase() {
    if (_bleAdapterState == IDOBluetoothStateType.poweredOff) {
      _phase = DemoConnectionPhase.bluetoothOff;
      return;
    }
    switch (_deviceState) {
      case IDOBluetoothDeviceStateType.connecting:
      case IDOBluetoothDeviceStateType.disconnecting:
        _phase = DemoConnectionPhase.connecting;
        break;
      case IDOBluetoothDeviceStateType.connected:
        // 保留 fastSync / protocol 细分态，避免被 BLE connected 冲掉
        if (_phase == DemoConnectionPhase.fastSyncing ||
            _phase == DemoConnectionPhase.fastSyncDone ||
            _phase == DemoConnectionPhase.fastSyncFailed ||
            _phase == DemoConnectionPhase.protocolReady) {
          return;
        }
        if (libManager.isConnected) {
          _phase = DemoConnectionPhase.protocolReady;
        } else {
          _phase = DemoConnectionPhase.connected;
        }
        break;
      case IDOBluetoothDeviceStateType.disconnected:
      default:
        _phase = DemoConnectionPhase.disconnected;
        break;
    }
  }

  @override
  void dispose() {
    _deviceStateSub?.cancel();
    _bluetoothStateSub?.cancel();
    _libStatusSub?.cancel();
    _started = false;
    super.dispose();
  }
}

/// 顶部实时连接状态条
class ConnectionStatusBanner extends StatelessWidget {
  const ConnectionStatusBanner({super.key, this.showBindChip = false});

  final bool showBindChip;

  @override
  Widget build(BuildContext context) {
    final ctrl = ConnectionStatusController.instance;
    return AnimatedBuilder(
      animation: ctrl,
      builder: (context, _) {
        return Material(
          color: ctrl.statusColor.withOpacity(0.12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.circle, size: 10, color: ctrl.statusColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ctrl.statusText,
                        style: TextStyle(
                          color: ctrl.statusColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ctrl.detailText,
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showBindChip) ...[
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(
                      ctrl.isBindedHint ? '已绑定' : '未绑定',
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: ctrl.isBindedHint
                        ? Colors.green.shade100
                        : Colors.grey.shade200,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
