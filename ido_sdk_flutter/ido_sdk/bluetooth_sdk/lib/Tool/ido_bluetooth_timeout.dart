
import 'dart:async';

class IDOBluetoothTimeout {
  static Map<String,Timer> timers = {};

   static Timer setTimeout (void Function() callback,{int duration
   = 30,
  String? key}){
     print('setTimeout--$key');
     final timer = Timer(Duration(seconds: duration), callback);
     if (key != null) {
       final lastTimer = timers[key];
       lastTimer?.cancel();
       timers[key] = timer;
     }
     return timer;
   }

   static cancel({Timer? timer,String? key}){
     print('cancelTimeout--$key');
      if (timer != null) {
        timer.cancel();
      }
      if (key != null) {
        final timer = timers[key];
        timer?.cancel();
      }
   }
}