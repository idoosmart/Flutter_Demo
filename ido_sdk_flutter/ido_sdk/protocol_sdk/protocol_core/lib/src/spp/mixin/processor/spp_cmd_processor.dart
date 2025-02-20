import 'package:flutter/foundation.dart';
import 'package:protocol_core/src/spp/model/error.dart';

import '../../model/spp_cmd.dart';
import 'spp_base_processor.dart';

///
/// @author tianwei
/// @date 2024/3/22 17:12
/// @desc
///

mixin SppCmdProcessor on BaseSppProcessor {

  @override
  bool initProcessor() {
    return true;
  }

  ///普通指令分流，如B2
  @protected
  @override
  int processReceivedSppCmd(SppCmd data) {
    switch (data.head.cmd) {
      case PROTOCOL_CMD_BT_GET:
        processReceivedSppCmdData(data);
    }
    return SUCCESS;
  }

  ///处理普通指令具体逻辑，如B2 01
  void processReceivedSppCmdData(SppCmd cmd) {
    switch (cmd.head.key) {
      case PROTOCOL_KEY_BT_GET_SPPMTU:
        //获取mtu成功
        parseMtu(cmd.original);
    }
  }
}