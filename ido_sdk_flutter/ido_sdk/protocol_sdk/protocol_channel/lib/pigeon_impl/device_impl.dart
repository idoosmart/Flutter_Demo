import 'package:protocol_lib/protocol_lib.dart';

import '../pigeon_generate/device.g.dart';

class DeviceImpl extends Device {

  @override
  Future<bool> refreshDeviceExtInfo() async {
    await libManager.deviceInfo.refreshDeviceExtInfo();
    return true;
  }

  @override
  Future<bool> refreshDeviceInfo(bool forced) async {
    final rs = await libManager.deviceInfo.refreshDeviceInfo(forced: forced);
    return rs != null;
  }

  @override
  Future<bool> refreshDeviceInfoBeforeBind(bool forced) async {
    final rs = await libManager.deviceInfo.refreshDeviceInfoBeforeBind(forced: forced);
    return rs != null;
  }

  @override
  Future<bool> refreshFirmwareVersion(bool forced) async {
    final rs = await libManager.deviceInfo.refreshFirmwareVersion(forced: forced);
    return rs != null;
  }

  @override
  void setDeviceBtMacAddress(String macAddressBt) {
    libManager.deviceInfo.setDeviceBtMacAddress(macAddressBt);
  }

  @override
  void cleanDataOnMemory() {
    libManager.deviceInfo.cleanDataOnMemory();
  }

}

extension IDODeviceInfoExt on IDODeviceInfo {
  DeviceInfo toDeviceInfo() {
    return DeviceInfo(
      deviceMode: deviceMode,
      battStatus: battStatus,
      battLevel: battLevel,
      rebootFlag: rebootFlag,
      bindState: bindState,
      bindType: bindType,
      bindTimeout: bindTimeout,
      platform: platform,
      deviceShapeType: deviceShapeType,
      deviceType: deviceType,
      dialMainVersion: dialMainVersion,
      showBindChoiceUi: showBindChoiceUi,
      deviceId: deviceId,
      firmwareVersion: firmwareVersion,
      gpsPlatform: gpsPlatform,
      macAddress: macAddress,
      macAddressFull: macAddressFull,
      deviceName: deviceName,
      otaMode: otaMode,
      uuid: uuid,
      macAddressBt: macAddressBt,
      fwVersion1: fwVersion1,
      fwVersion2: fwVersion2,
      fwVersion3: fwVersion3,
      fwBtFlag: fwBtFlag,
      fwBtVersion1: fwBtVersion1,
      fwBtVersion2: fwBtVersion2,
      fwBtVersion3: fwBtVersion3,
      fwBtMatchVersion1: fwBtMatchVersion1,
      fwBtMatchVersion2: fwBtMatchVersion2,
      fwBtMatchVersion3: fwBtMatchVersion3,
    );
  }
}
