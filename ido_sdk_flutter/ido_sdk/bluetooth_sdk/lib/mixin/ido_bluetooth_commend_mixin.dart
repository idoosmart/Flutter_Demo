import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bluetooth/ido_bluetooth.dart';
import 'package:rxdart/rxdart.dart';
import '../Tool/ido_bluetooth_tool.dart';
import 'ido_bluetooth_timeout_mixin.dart';

mixin IDOBluetoothCommendMixin {
  GetMacAddressCommendHandler? _cmdHandler;

  //获取MacAddress
  GetMacAddressCommendHandler getCommendHandler() {
    if (_cmdHandler == null) {
      _cmdHandler = GetMacAddressCommendHandler();
      _cmdHandler!
          .setNext(AnalyticMacAddressCommendHandler())
          .setNext(OpenANCSCommendHandler())
          .setNext(GetPairCommendHandler())
          .setNext(OpenPairCommendHandler())
          .setNext(AnalyticOpenPairCommendHandler())
          .setNext(AnalyticPairCommendHandler());
    }
    return _cmdHandler!;
  }

  bool isOpenPairCommend(Uint8List data) {
    return data.sublist(0, 2).compare(openPairCommend.sublist(0, 2));
  }

  bool isGetPairCommend(Uint8List data) {
    return data.sublist(0, 2).compare(getPairCommend);
  }
}

abstract class CommendHandler
    with IDOBluetoothTimeoutMixin, IDOBluetoothCommendMixin {
  CommendHandler? _handler;

  CommendHandler setNext(CommendHandler next) {
    _handler = next;
    return next;
  }

  CommendHandler? getNext() {
    return _handler;
  }

  handleRequest(Uint8List cmd) => print("handleRequest");
}

//获取mac地址指令
class GetMacAddressCommendHandler extends CommendHandler {
  @override
  handleRequest(Uint8List cmd) {
    if (cmd.compare(getMacAddressCommend)) {
      bluetoothManager.writeData(getMacAddressCommend);
      bluetoothManager.addLog("GetMacAddressCommendHandler",
          className: 'AnalyticMacAdd'
              'ressCommendHandler',
          method: 'handleRequest');
    } else {
      if (getNext() != null) {
        getNext()?.handleRequest(cmd);
      } else {
        print("No one to deal with it");
      }
    }
  }
}

//解析Mac地址
class AnalyticMacAddressCommendHandler extends CommendHandler {
  @override
  handleRequest(Uint8List cmd) {
    if (cmd.sublist(0, 2).compare(getMacAddressCommend)) {
      final device = bluetoothManager.currentDevice;
      device?.macAddress = IDOBluetoothTool.addColon(
          IDOBluetoothTool.uint8ToHex(cmd.sublist(2, 8)));
      device?.btMacAddress = IDOBluetoothTool.addColon(
          IDOBluetoothTool.uint8ToHex(cmd.sublist(8, 14)));
      bluetoothManager.requestMacAddress(device);
      bluetoothManager.currentDevice?.isNeedGetMacAddress = false;
      cancelCommendTimeout();
      if (Platform.isIOS) {
        //获取ANCS（ios）
        getCommendHandler().handleRequest(openANCSCommend);
      }
      bluetoothManager.addLog(
          "getMacAddressCommend ${bluetoothManager.currentDevice?.macAddress}"
          " , btmac = ${device?.btMacAddress}",
          className: 'AnalyticMacAdd'
              'ressCommendHandler',
          method: 'handleRequest');
    } else {
      if (getNext() != null) {
        getNext()?.handleRequest(cmd);
      } else {
        print("No one to deal with it");
      }
    }
  }
}

//打开ANCS
class OpenANCSCommendHandler extends CommendHandler {
  @override
  handleRequest(Uint8List cmd) {
    if (cmd.compare(openANCSCommend)) {
      bluetoothManager.writeData(openANCSCommend);
      final device = bluetoothManager.currentDevice;
      bluetoothManager.addDeviceState(IDOBluetoothDeviceStateModel(
          uuid: device?.uuid,
          macAddress: device?.macAddress,
          state: IDOBluetoothDeviceStateType.connected,
          errorState: IDOBluetoothDeviceConnectErrorType.none,
          platform: 0
      ));
      bluetoothManager.addLog("openANCSCommend",
          className: 'OpenANCSCommendHa'
              'ndler',
          method: 'handleRequest');
    } else {
      if (getNext() != null) {
        getNext()?.handleRequest(cmd);
      } else {
        print("No one to deal with it");
      }
    }
  }
}

//获取配对
class GetPairCommendHandler extends CommendHandler {
  @override
  handleRequest(Uint8List cmd) {
    if (cmd.compare(getPairCommend)) {
      bluetoothManager.writeData(getPairCommend);
      bluetoothManager.addLog("getPairCommend",
          className: 'GetPairCommendHand'
              'ler',
          method: 'handleRequest');
    } else {
      if (getNext() != null) {
        getNext()?.handleRequest(cmd);
      } else {
        print("No one to deal with it");
      }
    }
  }
}

//设置配对
class OpenPairCommendHandler extends CommendHandler {
  @override
  handleRequest(Uint8List cmd) {
    if (cmd.compare(openPairCommend)) {
      bluetoothManager.writeData(openPairCommend);
      bluetoothManager.addLog("openPairCommend",
          className: 'OpenPairCommendHandler',
          method: 'handleRequest');
    } else {
      if (getNext() != null) {
        getNext()?.handleRequest(cmd);
      } else {
        print("No one to deal with it");
      }
    }
  }
}

//解析设置配对
class AnalyticOpenPairCommendHandler extends CommendHandler {
  @override
  handleRequest(Uint8List cmd) {
    if (cmd.sublist(0, 2).compare(openPairCommend.sublist(0, 2))) {
      getCommendHandler().handleRequest(getPairCommend);
      bluetoothManager.addLog("AnalyticOpenPairCommendHandler",
          className: 'An'
              'alyticOpenPairCommendHandler',
          method: 'handleRequest');
    } else {
      if (getNext() != null) {
        getNext()?.handleRequest(cmd);
      } else {
        print("No one to deal with it");
      }
    }
  }
}

//解析配对状态
class AnalyticPairCommendHandler extends CommendHandler {
  @override
  handleRequest(Uint8List cmd) {
    if (cmd.sublist(0, 2).compare(getPairCommend) && cmd.length > 3) {
      bluetoothManager.currentDevice?.isPair = (cmd[2] == 0x55);
      cancelOpenPairTimeOut();
      bluetoothManager.addLog(
          "getPairCommend ${bluetoothManager.currentDevice?.isPair.toString()}",
          className: 'AnalyticPairCommendHandler',
          method: 'handleReq'
              'uest');
    } else {
      if (getNext() != null) {
        getNext()?.handleRequest(cmd);
      } else {
        print("No one to deal with it");
      }
    }
  }
}
