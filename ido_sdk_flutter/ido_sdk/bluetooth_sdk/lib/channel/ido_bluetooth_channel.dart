import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth/model/ido_bluetooth_dfu_state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_bluetooth/ido_bluetooth.dart';
import '../model/ido_bluetooth_dfu_config.dart';
import '../model/ido_bluetooth_media_state.dart';
part 'firmware_data_channel.dart';

class IDOBluetoothChannel {
  final MethodChannel _channel = const MethodChannel('flutter_bluetooth_IDO');
  final MethodChannel _firmwareDataChannel = const MethodChannel('firmware_data');
  final EventChannel _stateChannel = const EventChannel('bluetoothState');
  final EventChannel _deviceStateChannel = const EventChannel('deviceState');

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
  final mediaStateSubject = PublishSubject<IDOBluetoothMediaState>();

  //当前搜索的设备，会在开始搜索时清空
  final deviceMap = <String, IDOBluetoothDeviceModel>{};
  //缓存所有搜索到的设备
  final allDeviceMap = <String, IDOBluetoothDeviceModel>{};

  //TODO 占时只维护pair的回调
  final isPairList = <Completer<IDOBluetoothPairType>>[];

  //开始调用connect直到收到设备状态都为true
  bool isConnecting = false;

  register(){
    callHandle();
    bluetoothState();
    if (Platform.isAndroid) {
      callHandleFirmwareData();
      deviceStateChannel();
    }
  }

  callHandle() {
    try {
      _channel.setMethodCallHandler((call) {
        final arguments = call.arguments;
        final method = call.method;
        if (["deviceState","scanResult"].contains(method)) {
          bluetoothManager.addLog(
              {
                '通道消息callHandle': method,
                'arguments': arguments.toString(),
              }.toString(),
              method: method);
        }
        if (call.method == "sendState" && Platform.isIOS) {
          //发送数据状态
          final model = IDOBluetoothWriteState.fromMap(arguments);
          sendStateSubject.add(model);
        } else if (call.method == "receiveData" && Platform.isIOS) {
          final receiveData = IDOBluetoothReceiveData.fromMap(arguments);
          receiveDataSubject.add(receiveData);
        } else if (call.method == "scanResult") {
          _scanResult(arguments);
        } else if (call.method == "deviceState") {
          _deviceState(arguments);
        } else if (call.method == "isOtaWithServices") {
          final uuids = arguments["servicesUUID"];
          bool isOta = isOtaWithServices(uuids);
          bluetoothManager.currentDevice?.isOta = isOta;
        } else if (call.method == "pairState") {
          final value = call.arguments;
          final isPair = value["isPair"];
          if (bluetoothManager.currentDevice != null) {
            bluetoothManager.currentDevice!.isPair = isPair as bool;
          }
          isPairList.forEach((element) => element.complete(isPair));
          isPairList.clear();
        } else if (call.method == "SPPState") {
          sppStateSubject
              .add(IDOBluetoothSPPStateType.values[arguments['state']]);
        } else if (call.method == "writeSPPCompleteState") {
          writeSPPCompleteSubject.add(arguments['btMacAddress']);
        } else if (call.method == "writeLog") {
          logStateSubject.add(arguments);
        } else if (call.method == "dfuState") {
          final dfuState = IDOBluetoothDfuState.fromJson(arguments);
          dfuStateSubject.add(dfuState);
        } else if (call.method == "dfuProgress") {
          dfuProgressSubject.add(arguments);
        } else if (call.method == "mediaState"){
          final state = IDOBluetoothMediaState.fromJson(arguments);
          mediaStateSubject.add(state);
        }
        return Future.value(true);
      });
    } catch (e) {
      final json = {
        'platform': 3, //1 ios  2 android 3 flutter;
        'className': 'IDOBluetoothChannel',
        'method': 'callHandle_error',
        'detail': e.toString(), //日志内容
      };
      logStateSubject.add(json);
    }
  }

  bluetoothState() {
    _stateChannel.receiveBroadcastStream().listen((event) {
      final value = event as Map;
      stateSubject.add(IDOBluetoothStateModel.fromMap(value));
    }, onError: (dynamic error) {}, cancelOnError: true);
  }

  deviceStateChannel(){
    _deviceStateChannel.receiveBroadcastStream().listen((event) {
      final value = event as Map;
      _deviceState(value);;
    }, onError: (dynamic error) {}, cancelOnError: true);
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
}

extension InvokeChannel on IDOBluetoothChannel {
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
    bluetoothManager.addDeviceState(IDOBluetoothDeviceStateModel(
      uuid: device.uuid ?? "",
      macAddress: device.macAddress ?? "",
      state: IDOBluetoothDeviceStateType.connecting,
      errorState: IDOBluetoothDeviceConnectErrorType.none,
    ));
    if (bluetoothManager.currentDevice?.macAddress == device.macAddress) {
      isConnecting = true;
    }
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
        bluetoothManager.addDeviceState(IDOBluetoothDeviceStateModel(
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
    if (Platform.isIOS) {
      _channel.invokeMethod("sendData", data);
    }  else{
      _firmwareDataChannel.invokeMethod("sendData", data);
    }
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

  autoConnect(IDOBluetoothDeviceModel device,
      {bool isDueToPhoneBluetoothSwitch = false}) {
    bluetoothManager.addDeviceState(IDOBluetoothDeviceStateModel(
      uuid: device.uuid ?? "",
      macAddress: device.macAddress ?? "",
      state: IDOBluetoothDeviceStateType.connecting,
      errorState: IDOBluetoothDeviceConnectErrorType.none,
    ));
    if (bluetoothManager.currentDevice?.macAddress == device.macAddress) {
      isConnecting = true;
    }
    _channel.invokeMethod("autoConnect", {
      "uuid": device.uuid,
      "macAddress": device.macAddress,
      "btMacAddress": device.btMacAddress,
      "isDueToPhoneBluetoothSwitch": isDueToPhoneBluetoothSwitch
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
}

extension DeviceStateChannel on IDOBluetoothChannel {
  _deviceState(Map arguments) {
    final model = IDOBluetoothDeviceStateModel.fromJson(arguments);
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
  }

  Future<IDOBluetoothMediaState> getMediaState(String btMac) async{
    final value = await _channel.invokeMethod<Map>("getMediaState",
        {"btMac": btMac})??{};
    return IDOBluetoothMediaState.fromJson(value);
  }
}

extension ScanResultChannel on IDOBluetoothChannel {
  _scanResult(Map json) {
    // print('_scanResult = $json');

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
  }
}
