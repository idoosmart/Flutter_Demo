import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bluetooth/Tool/ido_bluetooth_tool.dart';

import '../source/ido_bluetooth_enum.dart';
import '../source/ido_bluetooth_source.dart';

class IDOBluetoothDeviceModel {
  //信号量
  int rssi = -1;
  //设备名称;
  String? name;
  //设备状态
  IDOBluetoothDeviceStateType? state;
  //ios macAddress或uuid必传一个
  String? uuid = "";
  //Android必传
  String? macAddress = "";
  //ota
  String? otaMacAddress;
  //bt
  String? btMacAddress;
  //设备id
  int? deviceId;
  /// 设备类型 0:无效 1: 手表 2: 手环
  int? deviceType;
  //是否在ota
  bool isOta = false;
  //是否泰凌微ota
  bool isTlwOta = false;
  //是否xx升级中
  bool isInDfu = false;
  //平台
  int platform = -1;
  //bt版本（不保证准确）
  int? bltVersion;

  // bool isConnect = false;
  //首次绑定获取mac地址 （ios）
  bool isNeedGetMacAddress = true;
  //配对状态（Android）
  bool isPair = false;
  //广播包
  Uint8List? dataManufacturerData;

  IDOBluetoothDeviceModel(
      { // this.distance,
        this.isInDfu = false,
        this.platform = -1,
      this.name,
      this.state,
      this.uuid,
      this.macAddress,
      this.otaMacAddress,
      this.btMacAddress,
      this.bltVersion,
      this.deviceId,
      this.deviceType,
      this.isNeedGetMacAddress = true});

  IDOBluetoothDeviceModel.fromJson(Map json) {
    // print("IDOBluetoothDeviceModel = $json");
    rssi = json["rssi"];
    // distance = json['distance'];
    name = json['name'];
    state = IDOBluetoothDeviceStateType.values[json['state']];
    uuid = json['uuid'];
    macAddress = json['macAddress'];
    if (json.containsKey("serviceUUIDs")) {
      List<String>? sUUIDString = json['serviceUUIDs'] != null
          ? json['serviceUUIDs'].cast<String>()
          : [];
      if (sUUIDString is! List<String>) {
        sUUIDString = [].cast<String>();
      }
      _transformIsOTA(sUUIDString??[]);
    }
    if (json.containsKey("dataManufacturerData")) {
      dataManufacturerData = json['dataManufacturerData'];
      if (dataManufacturerData != null) {
        _transformADData(dataManufacturerData!);
        _transformAnyPlatform(dataManufacturerData!);
      }
    }
    if (isTlwOta) _transformTlwMacAddress();
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['macAddress'] = macAddress;
    return data;
  }

  //兼容xx平台
  _transformAnyPlatform(Uint8List data){
    if (data.length < 16) {
      return;
    }
    platform = data[15];
    int dfuMode = data[14];
    int version = data[8];
    if (version == 3 && dfuMode == 1) {
      isInDfu = true;
    }
  }

  _transformIsOTA(List<String> uuids) {
    isOta = uuids
        .map((uuid) =>
            uuid.toLowerCase() == RX_UPDATE_UUID.toLowerCase() ||
            uuid.toLowerCase() == RX_UPDATE_UUID_0XFE59_ANDROID.toLowerCase() ||
            uuid.toLowerCase() == RX_UPDATE_UUID_0XFE59_IOS.toLowerCase())
        .firstWhere((is_uuid_ota) => is_uuid_ota, orElse: () => false);
    isTlwOta = uuids
        .map(
            (uuid) => uuid.toLowerCase() == RX_UPDATE_UUID_0X0203.toLowerCase())
        .firstWhere((is_uuid_ota) => is_uuid_ota,
            orElse: () =>
                name?.toLowerCase() == RX_UPDATE_NAME_TLW.toLowerCase());

  }

  _transformTlwMacAddress() {
    final macAdr = macAddress?.replaceAll(":", '') ?? '';
    if (macAdr.length < 12) return;
    int num1 = int.tryParse(macAdr.substring(0, 2), radix: 16) ?? 0;
    final num2 = macAdr.substring(2, 4);
    final num3 = macAdr.substring(4, 6);
    final num4 = macAdr.substring(6, 8);
    final num5 = macAdr.substring(8, 10);
    final num6 = macAdr.substring(10, 12);
    final num7 = num1 - 0x01;
    final num8 = IDOBluetoothTool.uint8ToHex(Uint8List.fromList([num7]));
    macAddress = "$num6:$num5:$num4:$num3:$num2:$num8";
  }

  _transformADData(Uint8List data) {
    int length = data.length;
    if (length < 8) {
      return;
    }
    deviceId = data[0] | (data[1] << 8);
    bltVersion = length > 8 ? data[8] : 0;
    final type = length > 9 ? data[9] : 0;
    deviceType = type > 2 ? 0 : type;
    if (Platform.isAndroid) {
      return;
    }
    if (length == 8) {
      macAddress = IDOBluetoothTool.uint8ToHex(data.sublist(2, 8));
    } else {
      final serviceUuid =
          IDOBluetoothTool.uint8ToHex(data.sublist(length - 3, length - 1));
      if (serviceUuid == "0AF0") {
        macAddress =
            IDOBluetoothTool.uint8ToHex(data.sublist(length - 9, length - 3));
      } else {
        if (length >= 29 || length == 10) {
          macAddress = IDOBluetoothTool.uint8ToHex(data.sublist(4, 10));
        } else {
          macAddress = IDOBluetoothTool.uint8ToHex(data.sublist(2, 8));
        }
      }
    }
    macAddress = IDOBluetoothTool.addColon(macAddress!);
  }

  //未找到幂运算
  // Float transformRSSI(int rssi){
  //   int iRssi = rssi.abs();
  //   int power = (iRssi - 59)/(10*2.0);
  //   return rssi.modPow(exponent, modulus)
  // }
}
