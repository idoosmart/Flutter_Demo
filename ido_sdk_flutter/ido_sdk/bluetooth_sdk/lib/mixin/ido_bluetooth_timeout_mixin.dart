import 'package:flutter_bluetooth/Tool/ido_bluetooth_timeout.dart';
import 'package:flutter_bluetooth/ido_bluetooth.dart';


mixin IDOBluetoothTimeoutMixin {
  cancelAllTimeout(){
    IDOBluetoothTimeout.timers.forEach((key, value) {value.cancel();});
    IDOBluetoothTimeout.timers.clear();
  }

  addOpenPairTimeOut(void Function() callback){
    IDOBluetoothTimeout.setTimeout(callback,
        key: IDOBluetoothTimeoutType.pair.toString(), duration: 1);
  }

  cancelOpenPairTimeOut(){
    IDOBluetoothTimeout.cancel(key: IDOBluetoothTimeoutType.pair.toString());
  }

  addScanIntervalTimeOut(void Function() callback){
    IDOBluetoothTimeout.setTimeout(callback,
        key: IDOBluetoothTimeoutType.scan.toString(), duration: 10);
  }

  cancelScanIntervalTimeOut(){
    bluetoothManager.addLog('deleteScanIntervalTimeOut',className: 'IDOBlueto'
        'othTimeoutMixin',method: 'cancelScanIntervalTimeOut');
    IDOBluetoothTimeout.cancel(key: IDOBluetoothTimeoutType.scan.toString());
  }

  addConnectTimeout() {
    bluetoothManager.addLog('addConnectTimeout',className: 'IDOBlueto'
        'othTimeoutMixin',method: 'addConnectTimeout');
    IDOBluetoothTimeout.setTimeout(_connectTimeout,
        key: IDOBluetoothTimeoutType.connect.toString());
  }

  cancelConnectTimeout() {
    bluetoothManager.addLog('deleteConnectTimeout',className: 'IDOBlueto'
        'othTimeoutMixin',method: 'cancelConnectTimeout');
    IDOBluetoothTimeout.cancel(key: IDOBluetoothTimeoutType.connect.toString());
  }

  _connectTimeout() {
    _timeout();
    bluetoothManager.addLog('_connectTimeout',className: 'IDOBlueto'
        'othTimeoutMixin',method: '_connectTimeout');
  }

  addCommendTimeout() {
    IDOBluetoothTimeout.setTimeout(_getCommendTimeout,
        key: IDOBluetoothTimeoutType.commend.toString());
  }

  cancelCommendTimeout() {
    IDOBluetoothTimeout.cancel(
        key: IDOBluetoothTimeoutType.commend.toString());
  }

  _getCommendTimeout() {
    _timeout();
    bluetoothManager.addLog('_getCommendTimeout',className: 'IDOBluetoothTimeoutMixin',method: '_getCommendTimeout');
  }

  _timeout() async{
    final currentDevice = bluetoothManager.currentDevice;
    final deviceState = await bluetoothManager.getDeviceState();
    if (deviceState == IDOBluetoothDeviceStateType.disconnected) {
      bluetoothManager.addDeviceState(IDOBluetoothDeviceStateModel(
          uuid: currentDevice?.uuid,
          macAddress: currentDevice?.macAddress,
          state: IDOBluetoothDeviceStateType.disconnected,
          errorState: IDOBluetoothDeviceConnectErrorType.timeOut,
          platform: 0
      ));
    }//这里会再次触发设备状态回调
    bluetoothManager.channelCancelConnect(currentDevice?.macAddress);
  }
}
