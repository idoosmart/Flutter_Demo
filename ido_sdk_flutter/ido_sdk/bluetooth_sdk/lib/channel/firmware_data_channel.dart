

part of 'ido_bluetooth_channel.dart';

extension FirmwareDataChannel on IDOBluetoothChannel{
  callHandleFirmwareData(){
    try {
      _firmwareDataChannel.setMethodCallHandler((call) {
        final arguments = call.arguments;
        final method = call.method;
        if (call.method == "sendState") {
          //发送数据状态
          final model = IDOBluetoothWriteState.fromMap(arguments);
          sendStateSubject.add(model);
        }else if (method == "receiveData") {
          final receiveData = IDOBluetoothReceiveData.fromMap(arguments);
          receiveDataSubject.add(receiveData);
        }
        return Future.value(true);
      });
    } catch (e) {
      final json = {
        'platform': 3, //1 ios  2 android 3 flutter;
        'className': 'IDOBluetoothChannel',
        'method': 'callHandle_error',
        'detail': e.toString(), //日志内容
      };
      logStateSubject.add(json);
    }
  }
}