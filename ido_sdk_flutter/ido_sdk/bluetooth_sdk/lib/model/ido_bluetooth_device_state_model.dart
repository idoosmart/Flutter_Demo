

import 'package:flutter_bluetooth/source/ido_bluetooth_enum.dart';

class IDOBluetoothDeviceStateModel {
  String? uuid;
  //ios:Mac地址在没有搜索到设备情况下获取不到
  String? macAddress;
  IDOBluetoothDeviceStateType? state;
  IDOBluetoothDeviceConnectErrorType? errorState;

  IDOBluetoothDeviceStateModel(
      {this.uuid, this.macAddress, this.state, this.errorState});

  IDOBluetoothDeviceStateModel.fromJson(Map json) {
    uuid = json.putIfAbsent('uuid', () => (null));
    macAddress = json.putIfAbsent('macAddress', () => (null));
    state = IDOBluetoothDeviceStateType.values[json['state']];
    errorState = IDOBluetoothDeviceConnectErrorType.values[json['errorState']];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['macAddress'] = macAddress;
    data['state'] = state;
    data['errorState'] = errorState;
    return data;
  }
}
