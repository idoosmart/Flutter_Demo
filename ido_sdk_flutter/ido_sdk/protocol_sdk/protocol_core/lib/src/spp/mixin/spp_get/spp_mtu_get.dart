import 'dart:typed_data';

import '../../../logger/logger.dart';
import '../../model/spp_cmd.dart';

///
/// @author tianwei
/// @date 2024/3/22 17:21
/// @desc
///
mixin SppMtuGet {
  int txMtu = 512;
  int rxMtu = 512;

  setMtu(int txMtu, int rxMtu) {
    if (txMtu < 20 || rxMtu < 20) {
      logger?.e(
          "err:${txMtu < 20 ? "tx spp mtu less than 20byte" : ""} ${rxMtu < 20 ? "rx spp mtu less than 20byte" : ""}");
      return;
    }
    logger?.e("set spp mtu tx:$txMtu rx:$rxMtu");
    this.txMtu = txMtu;
    this.rxMtu = rxMtu;
  }

  parseMtu(Uint8List data) {
    final mtuReply = SppMtuReply(data);
    int mtu = mtuReply.mtu;
    if (mtu != 0) {
      logger?.i("get spp mtu:${mtu}");
      //set mtu
      setMtu(mtu - 4, mtu - 2);
    } else {
      logger?.e("get spp mtu failed, mtu = 0");
    }
  }
}
