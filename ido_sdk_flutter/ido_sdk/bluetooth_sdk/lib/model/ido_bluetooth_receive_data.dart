import 'dart:typed_data';

class IDOBluetoothReceiveData {
  Uint8List? data;
  String? uuid;
  String? macAddress;
  bool? spp = false;

  IDOBluetoothReceiveData({this.data, this.uuid, this.macAddress});

  IDOBluetoothReceiveData.fromMap(Map json) {
    data = json['data'];
    uuid = json['uuid'];
    macAddress = json['macAddress'];
    spp = json['spp'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = data;
    data['uuid'] = uuid;
    data['macAddress'] = macAddress;
    data['spp'] = spp;
    return data;
  }
}
