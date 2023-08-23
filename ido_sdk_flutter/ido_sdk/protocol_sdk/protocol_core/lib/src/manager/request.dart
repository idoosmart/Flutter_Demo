import 'dart:typed_data';

/// 指令请求发送
class CmdRequest {
  /// 响应数据
  final Uint8List data;

  /// 设备Mac地址
  String? macAddress;

  /// 0 BLE数据, 1 SPP数据
  final int type;

  CmdRequest({required this.data, required this.type, this.macAddress});
}
