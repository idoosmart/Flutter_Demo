

class IDOBluetoothUpdateLog{
  String getSdkVersion() {
    return "4.2.1";
  }
}
/// 4.2.0
/// 屏蔽gatt 错误回调，避免自动重连的过程中app触发重连（Android ）
/// 4.1.9
/// 优化获取系统设备列表(ios)
/// 4.1.8
/// 添加关闭蓝牙通知功能(ios)
/// 4.1.7
/// 修复android btMacAddress字段为空问题
/// 添加IDOBluetoothDeviceModel字段值变更通知（原生对外SDK需要用到）
///4.1.6
///移除path_provider库
///iOS添加PrivacyInfo.xcprivacy隐私说明（苹果要求）
///4.1.5
///增加spp状态获取
///4.1.4
///增加恒玄平台 2024-03-28 何东阳
///4.1.3
///spp使用独立通道
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

