import 'dart:io';

import 'package:flutter_bluetooth/Tool/ido_bluetooth_tool.dart';
import 'package:flutter_bluetooth/ido_bluetooth_manager.dart';
import 'package:flutter/foundation.dart';

import '../source/ido_bluetooth_enum.dart';
import '../source/ido_bluetooth_source.dart';

class IDOBluetoothDeviceModel extends ChangeNotifier {
  // 信号量
  int _rssi = -1;

  /// 获取信号量
  int get rssi => _rssi;

  /// 设置信号量
  set rssi(int value) {
    _rssi = value;
    notifyListeners();
  }

  // 设备名称
  String? _name;

  /// 获取设备名称
  String? get name => _name;

  /// 设置设备名称
  set name(String? value) {
    _name = value;
    notifyListeners();
  }

  // 设备状态
  IDOBluetoothDeviceStateType? _state;

  /// 获取设备状态
  IDOBluetoothDeviceStateType? get state => _state;

  /// 设置设备状态
  set state(IDOBluetoothDeviceStateType? value) {
    _state = value;
    notifyListeners();
  }

  // iOS macAddress 或 uuid 必传一个
  String? _uuid = "";

  /// 获取 iOS macAddress 或 uuid
  String? get uuid => _uuid;

  /// 设置 iOS macAddress 或 uuid
  set uuid(String? value) {
    _uuid = value;
    notifyListeners();
  }

  // Android 必传
  String? _macAddress = "";

  /// 获取 Android macAddress
  String? get macAddress => _macAddress;

  /// 设置 Android macAddress
  set macAddress(String? value) {
    if (value?.isEmpty ?? false) {
      bluetoothManager.addLog('set macAddress = ${value} ${StackTrace.current}', method: 'set macAddress');
    }
    _macAddress = value;
    notifyListeners();
  }

  // OTA
  String? _otaMacAddress;

  /// 获取 OTA macAddress
  String? get otaMacAddress => _otaMacAddress;

  /// 设置 OTA macAddress
  set otaMacAddress(String? value) {
    _otaMacAddress = value;
    notifyListeners();
  }

  // BT
  String? _btMacAddress;

  /// 获取 BT macAddress
  String? get btMacAddress => _btMacAddress;

  /// 设置 BT macAddress
  set btMacAddress(String? value) {
    _btMacAddress = value;
    notifyListeners();
  }

  // 设备 ID
  int? _deviceId;

  /// 获取设备 ID
  int? get deviceId => _deviceId;

  /// 设置设备 ID
  set deviceId(int? value) {
    _deviceId = value;
    notifyListeners();
  }

  // 设备类型 0: 无效 1: 手表 2: 手环
  int? _deviceType;

  /// 获取设备类型
  int? get deviceType => _deviceType;

  /// 设置设备类型
  set deviceType(int? value) {
    _deviceType = value;
    notifyListeners();
  }

  // 是否在 OTA
  bool _isOta = false;

  /// 获取是否在 OTA
  bool get isOta => _isOta;

  /// 设置是否在 OTA
  set isOta(bool value) {
    _isOta = value;
    notifyListeners();
  }

  // 是否泰凌微 OTA
  bool _isTlwOta = false;

  /// 获取是否泰凌微 OTA
  bool get isTlwOta => _isTlwOta;

  /// 设置是否泰凌微 OTA
  set isTlwOta(bool value) {
    _isTlwOta = value;
    notifyListeners();
  }

  // 是否 XX 升级中
  bool _isInDfu = false;

  /// 获取是否 XX 升级中
  bool get isInDfu => _isInDfu;

  /// 设置是否 XX 升级中
  set isInDfu(bool value) {
    _isInDfu = value;
    notifyListeners();
  }

  // 平台
  int _platform = -1;

  /// 获取平台
  int get platform => _platform;

  /// 设置平台
  set platform(int value) {
    _platform = value;
    notifyListeners();
  }

  // BT 版本（不保证准确）
  int? _bltVersion;

  /// 获取 BT 版本
  int? get bltVersion => _bltVersion;

  /// 设置 BT 版本
  set bltVersion(int? value) {
    _bltVersion = value;
    notifyListeners();
  }

  // 首次绑定获取 mac 地址（iOS）
  bool _isNeedGetMacAddress = true;

  /// 获取首次绑定获取 mac 地址（iOS）
  bool get isNeedGetMacAddress => _isNeedGetMacAddress;

  /// 设置首次绑定获取 mac 地址（iOS）
  set isNeedGetMacAddress(bool value) {
    _isNeedGetMacAddress = value;
    notifyListeners();
  }

  // 配对状态（Android）
  bool _isPair = false;

  /// 获取配对状态（Android）
  bool get isPair => _isPair;

  /// 设置配对状态（Android）
  set isPair(bool value) {
    _isPair = value;
    notifyListeners();
  }

  // 广播包
  Uint8List? _dataManufacturerData;

  /// 获取广播包
  Uint8List? get dataManufacturerData => _dataManufacturerData;

  /// 设置广播包
  set dataManufacturerData(Uint8List? value) {
    _dataManufacturerData = value;
    notifyListeners();
  }

  // Constructor
  IDOBluetoothDeviceModel({
    int? rssi, // Required parameter
    String? name, // Required parameter
    IDOBluetoothDeviceStateType? state, // Required parameter
    String? uuid, // Optional parameter
    String? macAddress, // Optional parameter
    String? otaMacAddress, // Optional parameter
    String? btMacAddress, // Optional parameter
    int? bltVersion, // Optional parameter
    int? deviceId, // Optional parameter
    int? deviceType, // Optional parameter
    bool isOta = false, // Optional parameter with default value
    bool isTlwOta = false, // Optional parameter with default value
    bool isInDfu = false, // Optional parameter with default value
    int platform = -1, // Optional parameter with default value
    bool isNeedGetMacAddress = true, // Optional parameter with default value
    bool isPair = false, // Optional parameter with default value
    Uint8List? dataManufacturerData, // Optional parameter
  })  : _rssi = rssi ?? -1,
        _name = name,
        _state = state ?? IDOBluetoothDeviceStateType.disconnected,
        _uuid = uuid ?? "",
        _macAddress = macAddress ?? "",
        _otaMacAddress = otaMacAddress,
        _btMacAddress = btMacAddress,
        _bltVersion = bltVersion,
        _deviceId = deviceId,
        _deviceType = deviceType,
        _isOta = isOta,
        _isTlwOta = isTlwOta,
        _isInDfu = isInDfu,
        _platform = platform,
        _isNeedGetMacAddress = isNeedGetMacAddress,
        _isPair = isPair,
        _dataManufacturerData = dataManufacturerData;

  IDOBluetoothDeviceModel.fromJson(Map json) {
    // print("IDOBluetoothDeviceModel = $json");
    rssi = json["rssi"];
    // distance = json['distance'];
    name = json['name'];
    state = IDOBluetoothDeviceStateType.values[json['state']];
    uuid = json['uuid'];
    macAddress = json['macAddress'];
    if (json.containsKey("serviceUUIDs")) {
      List<String>? sUUIDString = json['serviceUUIDs'] != null ? json['serviceUUIDs'].cast<String>() : [];
      if (sUUIDString is! List<String>) {
        sUUIDString = [].cast<String>();
      }
      _transformIsOTA(sUUIDString ?? []);
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
  _transformAnyPlatform(Uint8List data) {
    if (data.length < 16) {
      return;
    }
    platform = data[15];
    int dfuMode = data[14];
    int version = data[8];
    if (version == 3 && dfuMode == 1 && (platform == 98 || platform == 99)) {
      /// 思澈ota
      isInDfu = true;
      isOta = true;
    }
  }

  _transformIsOTA(List<String> uuids) {
    isOta = uuids
        .map((uuid) =>
            uuid.toLowerCase() == RX_UPDATE_UUID.toLowerCase() ||
            uuid.toLowerCase() == RX_UPDATE_UUID_0XFE59_ANDROID.toLowerCase() ||
            uuid.toLowerCase() == RX_UPDATE_UUID_0XFE59_IOS.toLowerCase())
        .firstWhere((is_uuid_ota) => is_uuid_ota, orElse: () => false);
    isTlwOta = uuids.map((uuid) => uuid.toLowerCase() == RX_UPDATE_UUID_0X0203.toLowerCase()).firstWhere(
        (is_uuid_ota) => is_uuid_ota,
        orElse: () => name?.toLowerCase() == RX_UPDATE_NAME_TLW.toLowerCase());
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
      final serviceUuid = IDOBluetoothTool.uint8ToHex(data.sublist(length - 3, length - 1));
      if (serviceUuid == "0AF0") {
        macAddress = IDOBluetoothTool.uint8ToHex(data.sublist(length - 9, length - 3));
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
