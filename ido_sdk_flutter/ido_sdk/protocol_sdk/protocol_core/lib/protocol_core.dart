///
/// 依赖protocol_ffi库，该层会弱化蓝牙协议具体指令，使用json传输各个指令
/// 主要功能包括：
/// - 定时器管理
/// - 指令调度队列
/// - 文件传输队列
///
/// 支持指令透传，对外暴露纯Dart接口
///
/// http://10.1.0.17/SDK/protocol_sdk/blob/develop/README.md.
///
library protocol_core;

export 'src/ido_protocol_core.dart';

export 'src/extension/tools.dart';
export 'src/extension/sport.dart';
export 'src/extension/alexa.dart';
export 'src/extension/device2app.dart';
export 'src/extension/sync_data.dart';

export 'src/manager/response.dart';
export 'src/manager/request.dart';
export 'src/manager/type_define.dart';

export 'src/model/file_item.dart';
