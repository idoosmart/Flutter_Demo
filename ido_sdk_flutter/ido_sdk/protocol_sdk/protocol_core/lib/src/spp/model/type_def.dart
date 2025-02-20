import 'dart:typed_data';

/// 回调处理函数,传输文件进度回调
typedef CallbackDataTranProgressCbHandle = void Function(int);

/// 回调处理函数,传输文件完成回调
typedef CallbackDataTranCompleteCbHandle = void Function(int, int);

///写数据
typedef BleDataWriter = void Function(Uint8List);

typedef BoolCallback = bool Function();
