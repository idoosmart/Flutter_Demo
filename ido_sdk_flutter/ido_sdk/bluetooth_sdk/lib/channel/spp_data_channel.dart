part of 'ido_bluetooth_channel.dart';

extension SppDataChannel on IDOBluetoothChannel {
  callHandleSppData() {
    try {
      //接收spp写完成
      _sppDataSendStateChannel.setMessageHandler((message) {
        writeSPPCompleteSubject.add(message['btMacAddress']);
        return Future.value(true);
      });
    } catch (e) {
      final json = {
        'platform': 3, //1 ios  2 android 3 flutter;
        'className': 'IDOBluetoothChannel',
        'method': 'callHandleSppData_error',
        'detail': e.toString(), //日志内容
      };
      logStateSubject.add(json);
    }
    try {
      //接收spp回复数据
      _sppReceiveChannel.setMessageHandler((message) {
        final receiveData = IDOBluetoothReceiveData.fromMap(message);
        receiveDataSubject.add(receiveData);
        return Future.value(true);
      });
    } catch (e) {
      final json = {
        'platform': 3, //1 ios  2 android 3 flutter;
        'className': 'IDOBluetoothChannel',
        'method': 'callHandleSppData_error',
        'detail': e.toString(), //日志内容
      };
      logStateSubject.add(json);
    }
  }

  ///发送Spp数据
  ///data: 整包数据
  writeSppData(Map data) {
    _sppSendChannel.send(data);
  }
}
