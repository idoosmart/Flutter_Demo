import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bluetooth/model/ido_bluetooth_dfu_state.dart';

import 'package:rxdart/rxdart.dart';
import 'package:flutter_bluetooth/ido_bluetooth.dart';

import '../model/ido_bluetooth_dfu_config.dart';

class IDOBluetoothChannel {
  final MethodChannel _channel = const MethodChannel('flutter_bluetooth_IDO');
  final EventChannel _stateChannel = const EventChannel('bluetoothState');

  final stateSubject = PublishSubject<IDOBluetoothStateModel>();
  final scanSubject = PublishSubject<List<IDOBluetoothDeviceModel>>();
  final deviceStateSubject = PublishSubject<IDOBluetoothDeviceStateModel>();
  final sendStateSubject = PublishSubject<IDOBluetoothWriteState>();
  final receiveDataSubject = PublishSubject<IDOBluetoothReceiveData>();
  final sppStateSubject = PublishSubject<IDOBluetoothSPPStateType>();
  final writeSPPCompleteSubject = PublishSubject<String>();
  final logStateSubject = PublishSubject<Map>();
  final dfuStateSubject = PublishSubject<IDOBluetoothDfuState>();
  final dfuProgressSubject = PublishSubject<Map>();
  final EventChannel _dfuProgress = const EventChannel('dfuProgress');

  //当前搜索的设备，会在开始搜索时清空
  final deviceMap = <String, IDOBluetoothDeviceModel>{};
  //缓存所有搜索到的设备
  final allDeviceMap = <String, IDOBluetoothDeviceModel>{};

  //TODO 占时只维护pair的回调
  final isPairList = <Completer<IDOBluetoothPairType>>[];

  callHandle() {
    try{
      _channel.setMethodCallHandler((call) {
        if (call.method == "sendState") {
          //发送数据状态
          final sendState = call.arguments;
          final model = IDOBluetoothWriteState.fromMap(sendState);
          sendStateSubject.add(model);
        } else if (call.method == "receiveData") {
          final data = call.arguments;
          final receiveData = IDOBluetoothReceiveData.fromMap(data);
          receiveDataSubject.add(receiveData);
        } else if (call.method == "scanResult") {
          Map json = call.arguments;
          final device = IDOBluetoothDeviceModel.fromJson(json);
          final key = json[deviceMapKey];
          final storeDevice = allDeviceMap[key];
          if (Platform.isIOS &&
              (device.macAddress == null || device.macAddress!.isEmpty) &&
              storeDevice != null) {
            //收缩到Mac地址可能为空，会覆盖有Mac地址的设备，这时候不进行覆盖
            device.macAddress = storeDevice.macAddress;
          } else {
            allDeviceMap[key] = device;
          }
          deviceMap[key] = device;
          scanSubject.add(deviceMap.values.toList());
        } else if (call.method == "deviceState") {
          Map value = call.arguments;
          final model = IDOBluetoothDeviceStateModel.fromJson(value);
          if (Platform.isIOS) {
            final device = allDeviceMap[model.uuid];
            //搜索后没有Mac地址的
            if (device != null &&
                device.macAddress != null &&
                device.macAddress!.isNotEmpty) {
              model.macAddress = device.macAddress;
            }
            //  如果没有搜索直接连
            if (model.macAddress == null &&
                model.uuid == bluetoothManager.currentDevice?.uuid) {
              model.macAddress = bluetoothManager.currentDevice?.macAddress;
            }
          }
          deviceStateSubject.add(model);
        } else if (call.method == "isOtaWithServices") {
          final value = call.arguments;
          final key = value[deviceMapKey];
          final uuids = value["servicesUUID"];
          bool isOta = isOtaWithServices(uuids);
          bluetoothManager.currentDevice?.isOta = isOta;
        } else if (call.method == "pairState") {
          final value = call.arguments;
          final isPair = value["isPair "];
          if (bluetoothManager.currentDevice != null) {
            bluetoothManager.currentDevice!.isPair = isPair as bool;
          }
          isPairList.forEach((element) => element.complete(isPair));
          isPairList.clear();
        } else if (call.method == "SPPState") {
          final value = call.arguments;
          sppStateSubject.add(IDOBluetoothSPPStateType.values[value['state']]);
        } else if (call.method == "writeSPPCompleteState") {
          final value = call.arguments;
          writeSPPCompleteSubject.add(value['btMacAddress']);
        } else if (call.method == "writeLog") {
          final value = call.arguments;
          logStateSubject.add(value);
        } else if (call.method == "dfuState") {
          final value = call.arguments;
          final dfuState = IDOBluetoothDfuState.fromJson(value);
          dfuStateSubject.add(dfuState);
        } else if (call.method == "dfuProgress") {
          final data = call.arguments;
          dfuProgressSubject.add(data);
        }
        return Future.value(Null);
      });
    }catch(e){
      final json = {
        'platform': 3, //1 ios  2 android 3 flutter;
        'className': 'IDOBluetoothChannel',
        'method': 'callHandle',
        'detail': e.toString(), //日志内容
      };
      logStateSubject.add(json);
    }
  }

  //开始搜索，
  //macAddress（Android）:根据Mac地址搜索
  ///UUID:iOS为实现
  startScan([String? macAddress]) {
    _channel.invokeMethod(
        "startScan", {"UUID": servicesUUID, "macAddress": macAddress});
  }

  stopScan() {
    _channel.invokeMethod("stopScan");
  }

  connect(IDOBluetoothDeviceModel device) {
    // print('channel connect  ${device.macAddress}');
    _channel.invokeMethod("connect", {
      "uuid": device.uuid,
      "macAddress": device.macAddress,
      "CharacteristicsUUID": characteristicUUID
    });
  }

  cancelConnect(String macAddress) {
    if (Platform.isAndroid) {
      _channel.invokeMethod(
          "cancelConnect", {'macAddress': macAddress, 'uuid': null});
    } else {
      final deviceMap = findDevice(macAddress)?.toMap();
      if (deviceMap == null) {
        //找不到设备直接返回断链状态
        deviceStateSubject.add(IDOBluetoothDeviceStateModel(
          macAddress: macAddress,
            state: IDOBluetoothDeviceStateType.disconnected,
            errorState: IDOBluetoothDeviceConnectErrorType.none));
        return;
      }
      _channel.invokeMethod("cancelConnect", deviceMap);
    }
  }

  requestMacAddress(IDOBluetoothDeviceModel device) {
    _channel.invokeMethod("requestMacAddress", device.toMap());
  }

  Future<Map?> state() async {
    final value = await _channel.invokeMethod<Map>("state");
    return value;
  }

  Future<Map?> deviceState(IDOBluetoothDeviceModel device) async {
    final value = await _channel.invokeMethod("getDeviceState", device.toMap());
    return value;
  }

  writeData(Map data) {
    _channel.invokeMethod("sendData", data);
  }

  bluetoothState() {
    _stateChannel.receiveBroadcastStream().listen((event) {
      final value = event as Map;
      stateSubject.add(IDOBluetoothStateModel.fromMap(value));
    }, onError: (dynamic error) {
      print('received error: ${error.message}');
    }, cancelOnError: true);
  }

  bool isOtaWithServices(List<String> uuids) {
    bool isOta = false;
    for (String element in uuids) {
      if (isOtaUUID.contains(element)) {
        isOta = true;
        break;
      }
    }
    return isOta;
  }

  setPair(IDOBluetoothDeviceModel device) {
    // print('startPair btMacAddress = ${device.btMacAddress}');
    _channel.invokeMethod("startPair", {
      "uuid": device.uuid,
      "macAddress": device.macAddress,
      "btMacAddress": device.btMacAddress
    });
  }

  cancelPair(IDOBluetoothDeviceModel device) {
    _channel.invokeMethod("cancelPair", {
      "uuid": device.uuid,
      "macAddress": device.macAddress,
      "btMacAddress": device.btMacAddress
    });
  }

  autoConnect(IDOBluetoothDeviceModel device,{bool
  isDueToPhoneBluetoothSwitch = false}) {
    _channel.invokeMethod("autoConnect", {
      "uuid": device.uuid,
      "macAddress": device.macAddress,
      "btMacAddress": device.btMacAddress,
      "isDueToPhoneBluetoothSwitch":isDueToPhoneBluetoothSwitch
    });
  }

  connectSPP(String btMacAddress) {
    _channel.invokeMethod('connectSPP', {'btMacAddress': btMacAddress});
  }

  disconnectSPP(String btMacAddress) {
    _channel.invokeMethod('disconnectSPP', {'btMacAddress': btMacAddress});
  }

  startNordicDFU(IDOBluetoothDfuConfig config) {
    _channel.invokeMethod("startNordicDFU", config.toJson());
  }

  IDOBluetoothDeviceModel? findDevice(String macAddress) {
    IDOBluetoothDeviceModel? device;
    if (Platform.isAndroid) {
      device = allDeviceMap[macAddress];
    } else {
      final i = allDeviceMap.values
          .where((element) => element.macAddress == macAddress)
          .toList();
      if (i.isNotEmpty) {
        device = i.first;
      }
    }
    return device;
  }
}
