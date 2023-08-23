import 'package:flutter_bluetooth/ido_bluetooth.dart';

mixin IDOBluetoothStateMixin {
  //是否授权
  Future<bool> get authorized async {
    final state = await bluetoothManager.getBluetoothState();
    return !(state == IDOBluetoothStateType.unknown ||
        state == IDOBluetoothStateType.unauthorized ||
        state == IDOBluetoothStateType.unsupported);
  }

  //蓝牙是否开打
  Future<bool> get poweredOn async {
    final state = await bluetoothManager.getBluetoothState();
    return state == IDOBluetoothStateType.poweredOn;
  }

  //蓝牙是否关闭
  Future<bool> get poweredOff async {
    final state = await bluetoothManager.getBluetoothState();
    return state == IDOBluetoothStateType.poweredOff;
  }

  //是否连接
  bool get isConnected{
    return bluetoothManager.currentDevice?.state ==
        IDOBluetoothDeviceStateType
            .connected;
  }

  //是否断链
  // bool get isDisconnected{
  //   return bluetoothManager.currentDevice?.state !=
  //       IDOBluetoothDeviceStateType
  //           .connected;
  // }

  bool get isOTA{
    return  (bluetoothManager.currentDevice?.isOta ?? false) || (bluetoothManager
        .currentDevice?.isTlwOta ?? false);
  }

  bool get isPair{
    return bluetoothManager.currentDevice?.isPair ?? false;
  }
}
