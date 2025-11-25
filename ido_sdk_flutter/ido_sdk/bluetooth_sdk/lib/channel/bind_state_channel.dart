part of 'ido_bluetooth_channel.dart';

///
/// @author davy
/// @date 2025/6/19 15:53
/// @description:
///

extension BindStateChannel on IDOBluetoothChannel {
  callCheckDeviceBindState() {
    try {
      //接收spp写完成
      _bindStateChannel.setMessageHandler((message) async {
        try {
          print("callCheckDeviceBindState: $message");
          String deviceAddress = message['mac'];
          final json = {
            'platform': 3, //1 ios  2 android 3 flutter;
            'className': 'IDOBluetoothChannel',
            'method': 'callCheckDeviceBindState',
            'detail': "checkBindState: $deviceAddress, _bindStateDelegate = $_bindStateDelegate, _bindStateAsyncDelegate = $_bindStateAsyncDelegate", //日志内容
          };
          logStateSubject.add(json);
          if(deviceAddress.isEmpty){
            return false;
          } else if (_bindStateDelegate != null) {
            return _bindStateDelegate!(deviceAddress);
          } else if (_bindStateAsyncDelegate != null) {
            return await _bindStateAsyncDelegate!(deviceAddress);
          }
        } catch (e) {
          final json = {
            'platform': 3, //1 ios  2 android 3 flutter;
            'className': 'IDOBluetoothChannel',
            'method': 'callCheckDeviceBindState',
            'detail': "checkBindState err: $e", //日志内容
          };
          logStateSubject.add(json);
        }
        return false;
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
