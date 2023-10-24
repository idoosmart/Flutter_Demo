
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/Tool/ido_bluetooth_tool.dart';
import 'package:flutter_bluetooth/ido_bluetooth.dart';

class IDOBluetoothHeartPing with WidgetsBindingObserver, IDOBluetoothStateMixin {
  //最近是否发送过数据
  bool _isSendRecently = false;
  Stream? _stream;
  late StreamSubscription _heartPingTimer;

  startHeartPing({int heartPingSecond = 25}) {
    // print('startHeartPing');
    _stream ??= Stream.periodic(Duration(seconds: heartPingSecond));
    WidgetsBinding.instance.addObserver(this);
    _heartPingTimer = _stream!.listen((event) => _sendHeartPingCommand());
    _heartPingTimer.pause();
  }

  pauseHeartPing(Uint8List? data) {
    if (data != null && data.length >= 2 && !data.sublist(0, 2).compare
      (heartPingCommend)) {
      _isSendRecently = true;
    }
  }

  _sendHeartPingCommand() {
    if (isConnected &&
        // isBind ||
        !isOTA &&
        _isSendRecently) {
      _isSendRecently = false;
      return;
    }
    bluetoothManager.addLog("_sendHeartPingCommand",className: 'IDOBluetoothHe'
        'artPing',method: '_sendHeartPingCommand');
    bluetoothManager.writeData(getMacAddressCommend);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    bluetoothManager.addLog("didChangeAppLifecycleState $state",className: 'IDOBluetoothHe'
        'artPing',method: 'didChangeAppLifecycleState');
    switch (state) {
      case AppLifecycleState.resumed:
        if (!_heartPingTimer.isPaused){
          _heartPingTimer.pause();
        }
        break;
      case AppLifecycleState.paused:
        if (isConnected && _heartPingTimer.isPaused) {
          _heartPingTimer.resume();
        }
        break;
      default:
    }
  }
}