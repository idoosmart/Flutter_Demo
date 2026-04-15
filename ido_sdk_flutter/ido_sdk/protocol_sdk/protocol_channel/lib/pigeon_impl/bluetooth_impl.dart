
import 'dart:typed_data';
import 'package:flutter_bluetooth/ido_bluetooth.dart';
import 'package:flutter_bluetooth/model/ido_bluetooth_dfu_config.dart';
import 'package:protocol_channel/pigeon_generate/bluetooth.g.dart';
import 'package:protocol_channel/pigeon_generate/bridge.g.dart';

import 'bridge_impl.dart';

class BluetoothImpl extends Bluetooth {

  final _bluetoothDelegate = BluetoothDelegate();
  BluetoothDelegate get bluetoothDelegate => _bluetoothDelegate;

  BridgeImpl? bridgeImpl;

  BluetoothImpl() {
    _init();
  }

  _init() {
    ///监听蓝牙返回数据
    bluetoothManager.receiveData().listen((event) {
      final receive = ReceiveData();
      receive.data = event.data;
      receive.uuid = event.uuid;
      receive.macAddress = event.macAddress;
      receive.spp = event.spp;
      receive.platform = event.platform;
      _bluetoothDelegate.receiveData(receive);
    });
    ///监听spp完成写入状态
    bluetoothManager.writeSPPCompleteState().listen((event) {
      _bluetoothDelegate.writeSPPCompleteState(event);
    });
    ///监听ble完成写入状态
    bluetoothManager.writeState().listen((event) {
      final model = WriteStateModel();
      model.macAddress = event.macAddress;
      model.uuid = event.uuid;
      model.state = event.state;
      model.type = WriteType.values[event.type?.index ?? 0];
      _bluetoothDelegate.writeState(model);
    });
    ///监听蓝牙状态
    bluetoothManager.bluetoothState().listen((event) {
      final model = BluetoothStateModel();
      model.type = BluetoothStateType.values[event.state.index];
      model.scanType = BluetoothScanType.values[event.scanType.index];
      _bluetoothDelegate.bluetoothState(model);
    });
    ///监听设备连接状态
    bluetoothManager.deviceState().listen((event) {
      final model = DeviceStateModel();
      model.macAddress = event.macAddress;
      model.uuid = event.uuid;
      model.state = DeviceStateType.values[event.state?.index ?? 0];
      model.errorState = ConnectErrorType.values[event.errorState?.index ?? 0];
      _bluetoothDelegate.deviceState(model);
    });
    ///扫描设备
    bluetoothManager.scanResultNative().listen((event) {
      final devices = getSearchDevices(event);
      _bluetoothDelegate.scanResult(devices);
      // final otaDevices = getSearchOtaDevices(event);
      // if (otaDevices.isNotEmpty) {
      //   bridgeImpl?.bridgeDelegate.listenFoundWaitingOtaDevices(otaDevices);
      // }
    });
    ///监听spp连接状态
    bluetoothManager.stateSPP().listen((event) {
      final model = SPPStateModel();
      model.type = SPPStateType.values[event.index];
      _bluetoothDelegate.stateSPP(model);
    });
    ///监听dfu升级状态及进度
    bluetoothManager.dfuProgress().listen((event) {
      if (event['progress'] != null
          && event['progress'] is int) { /// 进度
        final progress = event['progress'] as int;
        _bluetoothDelegate.dfuProgress(progress);
      } else if (event['state'] != null &&
          event['state'] is String &&
          event['state'] == 'Completed') { /// 升级完成
        _bluetoothDelegate.dfuComplete();
      } else if (event['error'] != null
          && event['error'] is String) { /// 升级错误
        final error = event['error'] as String;
        _bluetoothDelegate.dfuError(error);
      }
    });
    ///监听当前蓝牙设备
    bluetoothManager.listenCurrentDevice().listen((event) {
      if (event.state == null) {
          return;
      }
      print("event.btMacAddress: ${event.btMacAddress}");
      final state = DeviceStateType.values[event.state!.index];
      final device = DeviceModel(rssi: event.rssi,
          name: event.name,
          state: state,
          uuid: event.uuid,
          macAddress: event.macAddress,
          otaMacAddress: event.otaMacAddress,
          btMacAddress: event.btMacAddress,
          deviceId: event.deviceId,
          deviceType: event.deviceType,
          isOta: event.isOta,
          isTlwOta: event.isTlwOta,
          bltVersion: event.bltVersion,
          isPair: event.isPair);
      _bluetoothDelegate.changeCurrentDevice(device);
    });

    /// 监听bt状态
    bluetoothManager.stateBt().listen((event) {
      _bluetoothDelegate.stateBt(event);
    });
  }

  IDOBluetoothDeviceModel? getDartDevice(DeviceModel? device) {
    if (device == null) {
      return null;
    }
    final model = IDOBluetoothDeviceModel();
    model.macAddress = device.macAddress;
    model.uuid = device.uuid;
    model.rssi = device.rssi ?? -1;
    model.name = device.name;
    model.otaMacAddress = device.otaMacAddress;
    model.btMacAddress = device.btMacAddress;
    model.deviceId = device.deviceId;
    model.deviceType = device.deviceType;
    model.isOta = device.isOta ?? false;
    model.bltVersion = device.bltVersion;
    model.isPair = device.isPair ?? false;
    model.state = IDOBluetoothDeviceStateType.values[device.state?.index ?? 0];
    return model;
  }

  DeviceModel? getNativeDevice(IDOBluetoothDeviceModel? device) {
    if (device == null) {
      return null;
    }
    final model = DeviceModel();
    model.macAddress = device.macAddress;
    model.uuid = device.uuid;
    model.rssi = device.rssi;
    model.name = device.name;
    model.otaMacAddress = device.otaMacAddress;
    model.btMacAddress = device.btMacAddress;
    model.deviceId = device.deviceId;
    model.deviceType = device.deviceType;
    model.isOta = device.isOta;
    model.bltVersion = device.bltVersion;
    model.isPair = device.isPair;
    model.state = DeviceStateType.values[device.state?.index ?? 0];
    model.platform = device.platform;
    return model;
  }

  List<DeviceModel> getSearchDevices(List<IDOBluetoothDeviceModel> devices) {
    final deviceList = <DeviceModel>[];
    for (var element in devices) {
      var model = getNativeDevice(element);
      model ??= DeviceModel();
      deviceList.add(model);
    }
    return deviceList;
  }

  // 思澈ota中的设备
  List<OtaDeviceModel> getSearchOtaDevices(List<IDOBluetoothDeviceModel> devices) {
    final otaDeviceList = <OtaDeviceModel>[];
    for (var element in devices) {
      if ([99].contains(element.platform) && element.isOta) {
        otaDeviceList.add(OtaDeviceModel(
            rssi: element.rssi,
            name: element.name,
            uuid: element.uuid,
            macAddress: element.macAddress,
            otaMacAddress: element.otaMacAddress,
            btMacAddress: element.btMacAddress,
            deviceId: element.deviceId,
            deviceType: element.deviceType,
            isOta: element.isOta,
            isTlwOta: element.isTlwOta,
            platform: element.platform));
      }
    }
    return otaDeviceList;
  }

  @override
  void autoConnect(DeviceModel? device) {
    final model = getDartDevice(device);
    bluetoothManager.autoConnect(device: model);
  }

  @override
  Future<bool> cancelConnect(String? macAddress) {
    return bluetoothManager.cancelConnect(macAddress: macAddress);
  }

  @override
  void cancelPair(DeviceModel? device) {
    final model = getDartDevice(device);
    bluetoothManager.cancelPair(device: model);
  }

  @override
  void connect(DeviceModel? device) {
    final model = getDartDevice(device);
    bluetoothManager.connect(model);
  }

  @override
  void connectSPP(String btMacAddress) {
    bluetoothManager.connectSPP(btMacAddress);
  }

  @override
  void disconnectSPP(String btMacAddress) {
    bluetoothManager.disconnectSPP(btMacAddress);
  }

  @override
  Future<BluetoothStateModel> getBluetoothState() async{
    final type = await bluetoothManager.getBluetoothState();
    final model = BluetoothStateModel();
    model.type = BluetoothStateType.values[type.index];
    return model;
  }

  @override
  Future<DeviceStateModel> getDeviceState(DeviceModel? device) async{
    final model = getDartDevice(device);
    final type = await bluetoothManager.getDeviceState(model);
    final stateModel = DeviceStateModel();
    stateModel.state = DeviceStateType.values[type.index];
    stateModel.macAddress = model?.macAddress;
    stateModel.uuid = model?.uuid;
    return stateModel;
  }

  @override
  void register(int heartPingSecond, bool outputToConsole) {
    bluetoothManager.register(heartPingSecond: heartPingSecond, outputToConsole: outputToConsole);
  }

  @override
  void scanFilter(List<String?>? deviceName, List<int?>? deviceID, List<String?>? macAddress, List<String?>? uuid) {
    List<String>? nameList = deviceName?.cast<String>();
    List<int>? idList = deviceID?.cast<int>();
    List<String>? macList = macAddress?.cast<String>();
    List<String>? uuidList = uuid?.cast<String>();
    bluetoothManager.scanFilter(deviceNames: nameList,deviceIDs: idList,macAddresss: macList,uuids: uuidList);
  }

  @override
  void setBtPair(DeviceModel device) {
    var model = getDartDevice(device);
    model ??= IDOBluetoothDeviceModel();
    bluetoothManager.setBtPair(model);
  }

  @override
  void startNordicDFU(DfuConfig config) {
    final filePath = config.filePath ?? '';
    final uuid = config.uuid ?? '';
    final macAddress = config.macAddress ?? '';
    final dfuConfig = IDOBluetoothDfuConfig(filePath:filePath , uuid: uuid, macAddress: macAddress);
    bluetoothManager.startNordicDFU(dfuConfig);
  }

  @override
  Future<List<DeviceModel?>?> startScan(String? macAddress) {
    bluetoothManager.startScan(macAddress);
    return Future(() => []);
  }

  @override
  void stopScan() {
    bluetoothManager.stopScan();
  }

  @override
  Future<WriteStateModel> writeData(Uint8List data, DeviceModel? device, int type, int platform) async{
    final model = getDartDevice(device);
    final writeType = await bluetoothManager.writeData(data,device: model,type: type, platform: platform);
    final writeModel = WriteStateModel();
    writeModel.uuid = device?.uuid;
    writeModel.macAddress = device?.macAddress;
    writeModel.type = WriteType.values[writeType.index];
    writeModel.state = true;
    return writeModel;
  }

  @override
  DeviceModel? currentDevice() {
    final obj =  bluetoothManager.currentDevice;
    if (obj != null) {
      final state = DeviceStateType.values[obj.state!.index];
      return DeviceModel(rssi: obj.rssi,
          name: obj.name,
          state: state,
          uuid: obj.uuid,
          macAddress: obj.macAddress,
          otaMacAddress: obj.otaMacAddress,
          btMacAddress: obj.btMacAddress,
          deviceId: obj.deviceId,
          deviceType: obj.deviceType,
          isOta: obj.isOta,
          isTlwOta: obj.isTlwOta,
          bltVersion: obj.bltVersion,
          isPair: obj.isPair,
          platform: obj.platform);
    }
    return null;
  }

  @override
  Future<String?> logPath() {
    return bluetoothManager.logPath();
  }

}