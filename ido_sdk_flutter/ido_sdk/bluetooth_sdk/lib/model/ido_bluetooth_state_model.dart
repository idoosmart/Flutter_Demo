import 'package:flutter_bluetooth/source/ido_bluetooth_enum.dart';

class IDOBluetoothStateModel{
  var state = IDOBluetoothStateType.unknown;
  var scanType = IDOBluetoothScanType.stop;

  IDOBluetoothStateModel.fromMap(Map value){
    state = IDOBluetoothStateType.values[value["state"]];
    if (value.containsKey("scanType")){
      scanType = IDOBluetoothScanType.values[value["scanType"]];
    }
  }
}