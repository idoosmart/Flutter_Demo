import 'dart:async';
import 'dart:typed_data';

import 'package:protocol_lib/protocol_lib.dart';
import 'package:ido_logger/ido_logger.dart';

import '../pigeon_generate/bridge.g.dart';

class BridgeImpl extends Bridge {
  final bridgeDelegate = BridgeDelegate();

  @override
  void dispose() {
    libManager.dispose();
  }

  @override
  bool isBinding() {
    return libManager.isBinding;
  }

  @override
  bool isConnected() {
    return libManager.isConnected;
  }

  @override
  bool isConnecting() {
    return libManager.isConnecting;
  }

  @override
  bool isFastSynchronizing() {
    return libManager.isFastSynchronizing;
  }

  @override
  String macAddress() {
    return libManager.macAddress;
  }

  @override
  Future<bool> markConnectedDevice(
      String uniqueId, int otaType, bool isBinded, String? deviceName) {
    return libManager.markConnectedDeviceSafe(
        uniqueId: uniqueId,
        otaType: IDOOtaType.values[otaType],
        isBinded: isBinded,
        deviceName: deviceName);
  }

  @override
  Future<bool> markDisconnectedDevice(String? macAddress, String? uuid) {
    return libManager.markDisconnectedDevice(
        macAddress: macAddress, uuid: uuid);
  }

  @override
  void receiveDataFromBle(Uint8List data, String? macAddress, int type) {
    //print("dart 写数据到蓝牙设备 receiveDataFromBle2");
    libManager.receiveDataFromBle(data, macAddress, type);
  }

  @override
  void stopSyncConfig() {
    libManager.stopSyncConfig();
  }

  @override
  void writeDataComplete() {
    //print("dart writeDataComplete");
    libManager.writeDataComplete();
  }

  @override
  int otaType() {
    return libManager.otaType.index;
  }

  @override
  Future<bool> register(bool outputToConsole, bool outputToConsoleClib,
      bool isReleaseClib) async {
    final rs = await IDOProtocolLibManager.register(
        outputToConsole: outputToConsole,
        outputToConsoleClib: outputToConsoleClib,
        isReleaseClib: isReleaseClib);

    //==============do not edit directly begin==============
    // libManager.registerWriteDataToBle((data) {
    //   bridgeDelegate.registerWriteDataToBle(BleData(
    //       data: data.data, macAddress: data.macAddress, type: data.type));
    // });
    //==============do not edit directly end==============

    libManager.listenStatusNotification((status) {
      bridgeDelegate.listenStatusNotification(StatusNotification.values[status.index]);
    });

    libManager.listenDeviceNotification((model) {
      final obj = DeviceNotificationModel(
          dataType: model.dataType,
          notifyType: model.notifyType,
          msgNotice: model.msgNotice,
          errorIndex: model.errorIndex,
          controlEvt: model.controlEvt,
          controlJson: model.controlJson);
      bridgeDelegate.listenDeviceNotification(obj);
    });

    libManager.listenDeviceRawDataReport((dataType, data) {
      bridgeDelegate.listenDeviceRawDataReport(dataType, data);
    });

    return rs;
  }

  @override
  Future<bool> markOtaMode(String macAddress, String iosUUID, int platform, int deviceId) {
      return libManager.markSiceOtaMode(macAddress: macAddress, iosUUID: iosUUID, platform: platform, deviceId: deviceId);
  }
}
