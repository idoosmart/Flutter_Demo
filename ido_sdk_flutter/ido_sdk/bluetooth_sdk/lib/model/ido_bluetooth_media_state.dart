
import '../source/ido_bluetooth_enum.dart';

class IDOBluetoothMediaState{
  String? btMac;
  IDOBluetoothSwitchType type = IDOBluetoothSwitchType.off;

  IDOBluetoothMediaState({this.btMac,this.type = IDOBluetoothSwitchType.off});

  IDOBluetoothMediaState.fromJson(Map json){
    btMac = json["btMac"];
    type = IDOBluetoothSwitchType.values[json["type"]??0];
  }
}