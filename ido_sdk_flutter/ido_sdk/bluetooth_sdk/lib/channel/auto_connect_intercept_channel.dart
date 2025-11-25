part of 'ido_bluetooth_channel.dart';

///
/// @author davy
/// @date 2025/6/19 15:53
/// @description:
///

extension AutoConnectInterceptChannel on IDOBluetoothChannel {
  callCheckAutoConnectIntercept() {
    try {
      //接收spp写完成
      _autoConnectInterceptChannel.setMessageHandler((message) {
        try {
          print("callCheckAutoConnectIntercept: $message");
          String deviceAddress = message['mac'];
          final json = {
            'platform': 3, //1 ios  2 android 3 flutter;
            'className': 'IDOBluetoothChannel',
            'method': 'callCheckAutoConnectIntercept',
            'detail': "autoConnectInterceptor: $deviceAddress, _autoConnectInterceptor = $_autoConnectInterceptor}", //日志内容
          };
          print(json);
          logStateSubject.add(json);
          return Future.value((deviceAddress.isEmpty)
              ? false
              : _autoConnectInterceptor != null
                  ? _autoConnectInterceptor!(deviceAddress)
                  : false);
        } catch (e) {
          final json = {
            'platform': 3, //1 ios  2 android 3 flutter;
            'className': 'IDOBluetoothChannel',
            'method': 'callCheckAutoConnectIntercept',
            'detail': "autoConnectInterceptor err: $e", //日志内容
          };
          logStateSubject.add(json);
          return Future.value(false);
        }
      });
    } catch (e) {
      final json = {
        'platform': 3, //1 ios  2 android 3 flutter;
        'className': 'IDOBluetoothChannel',
        'method': 'callCheckDeviceBindState',
        'detail': e.toString(), //日志内容
      };
      logStateSubject.add(json);
    }
  }
}
