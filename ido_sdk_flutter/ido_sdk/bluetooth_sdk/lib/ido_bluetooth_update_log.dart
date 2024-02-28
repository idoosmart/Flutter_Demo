

class IDOBluetoothUpdateLog{
  String getSdkVersion() {
    return "4.1.2";
  }
}

/// 4.1.2
/// 解析广播包兼容思恻平台
///4.1.1
///1.android的deviceState通过新的EventChannel发送
///2.增加服务发现超时拦截，修复超时后再回调成功后导致流程错乱的问题，bug#151179
/// 4.1.0
/// android添加获取和监听媒体状态
/// 4.0.3：
/// 修复iOS原生getPeripheral空字典导致的崩溃，
/// 关闭蓝牙，主动断开连接，iOS直接发送断开连接通知
/// 4.0.4
/// 修复iOS didUpdateValueFor data为空时return
/// 4.0.5
/// 安卓添加channel用于收发固件数据
/// 4.0.6
/// ios 修复characteristic?.uuid为nil时候导致的崩溃
/// 4.0.7
/// android channel数据丢失的 加了日志
/// 调用connect手动添加connecting到deviceState里
/// 4.0.8
/// 添加后台心跳包发送控制开关
/// 4.0.9
/// ios发送无响应数据添加20ms延迟

