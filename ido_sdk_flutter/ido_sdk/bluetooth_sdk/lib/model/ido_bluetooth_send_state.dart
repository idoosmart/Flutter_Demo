
import '../ido_bluetooth.dart';

class IDOBluetoothWriteState {
  bool? state;
  String? uuid;
  String? macAddress;
  IDOBluetoothWriteType? type;

  IDOBluetoothWriteState({this.state, this.uuid, this.macAddress,this.type
  });

  IDOBluetoothWriteState.fromMap(Map json) {
    state = json['state'];
    uuid = json['uuid'];
    macAddress = json['macAddress'];
  }

  // Map<String, dynamic> toMap() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['state'] = state;
  //   data['uuid'] = uuid;
  //   data['macAddress'] = macAddress;
  //   return data;
  // }

}
