
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/Tool/ido_bluetooth_tool.dart';
import 'package:flutter_bluetooth/ido_bluetooth.dart';
import 'package:rxdart/rxdart.dart';

class IDOBluetoothHeartPing with WidgetsBindingObserver, IDOBluetoothStateMixin {
  //最近是否发送过数据
  bool _isSendRecently = false;
  bool openBully = false;
  Stream? _stream;
  late StreamSubscription _heartPingTimer;

  startHeartPing({int heartPingSecond = 20}) {
    // print('_sendHeartPingCommand startHeartPing');
    _stream ??= Stream.periodic(Duration(seconds: heartPingSecond)).take
      (3600*1000);
    WidgetsBinding.instance.addObserver(this);
    _heartPingTimer = _stream!.listen((event) => _sendHeartPingCommand());
    _heartPingTimer.pause();
  }

  pauseHeartPing(Uint8List? data) {
    if (data != null && data.length >= 2 && !data.sublist(0, 2).compare
      (heartPingCommend)) {
      _isSendRecently = true;
    }else{
      // print("pauseHeartPing writeData or receive heartPingCommend");
    }
  }

  _sendHeartPingCommand() {
    // print('_sendHeartPingCommand 1 isConnected = $isConnected,isOTA = $isOTA,'
    //     '_isSendRecently = $_isSendRecently,time = ${DateTime.now()}');
    if (!isConnected || isOTA || !openBully) {
      return;
    }
    if (_isSendRecently) {
      _isSendRecently = false;
      return;
    }
    // print('_sendHeartPingCommand 2 isConnected = $isConnected,isOTA = $isOTA,'
    //     '_isSendRecently = $_isSendRecently,time = ${DateTime.now()}');
    bluetoothManager.addLog("_sendHeartPingCommand",
        className: 'IDOBluetoothHeartPing',
        method: '_sendHeartPingCommand');
    bluetoothManager.writeData(heartPingCommend);
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
          _isSendRecently = false;
          _heartPingTimer.resume();
        }
        break;
      case AppLifecycleState.detached:
        if (isConnected) {
          bluetoothManager.cancelConnect();
        }
        break;
      default:
    }
  }
}