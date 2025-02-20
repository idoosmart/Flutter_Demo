

import 'package:flutter_bluetooth/source/ido_bluetooth_enum.dart';

class IDOBluetoothDeviceStateModel {
  String? uuid;
  //ios:Mac地址在没有搜索到设备情况下获取不到
  String? macAddress;
  IDOBluetoothDeviceStateType? state;
  IDOBluetoothDeviceConnectErrorType? errorState;
  // 0 爱都, 1 恒玄, 2 VC
  int? platform;

  IDOBluetoothDeviceStateModel(
      {this.uuid, this.macAddress, this.state, this.errorState, this.platform});

  IDOBluetoothDeviceStateModel.fromJson(Map json) {
    uuid = json.putIfAbsent('uuid', () => (null));
    macAddress = json.putIfAbsent('macAddress', () => (null));
    platform = json.putIfAbsent('platform', () => (0));
    state = IDOBluetoothDeviceStateType.values[json['state']];
    errorState = IDOBluetoothDeviceConnectErrorType.values[json['errorState']];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['macAddress'] = macAddress;
    data['state'] = state;
    data['errorState'] = errorState;
    data['platform'] = platform;
    return data;
  }
}
