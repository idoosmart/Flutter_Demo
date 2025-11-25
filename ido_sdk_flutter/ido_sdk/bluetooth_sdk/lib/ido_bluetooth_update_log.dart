

class IDOBluetoothUpdateLog{
  String getSdkVersion() {
    return "4.3.7";
  }
}

///4.3.7
/// 1.【优化】iOS补全连接日志记录
///4.3.6
/// 1.【优化】延长链接超时时间30秒改为 60秒
/// 2.【优化】内部 channel 的连接方法增加绑定状态参数，方便原生插件同步调用
/// 4.3.5
/// 1.增加自动重连拦截处理
/// 2.增加绑定状态异步设置代理方法，方便异步获取设备绑定状态
/// 4.3.4
/// 修复 iOS 绑定支持配对设备时，如果设备不支持重复绑定连接定时器取消失败问题
/// 4.3.3
/// 优化蓝牙解除配对，当传入的 bt mac 是无效的时，用有效的 ble mac 地址去解除配对
/// 4.3.2
/// 修复0af8使能通知比固件协议通知早回来，导致重复使能
/// 4.3.1
/// 优化 ble 配对
/// 4.3.0
/// 支持 ble 配对
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

