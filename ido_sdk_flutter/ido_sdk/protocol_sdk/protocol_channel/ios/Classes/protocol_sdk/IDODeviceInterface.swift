//
//  IDODeviceInterface.swift
//  alexa_channel
//
//  Created by hc on 2023/11/2.
//

import Foundation

/// 设备信息
@objc
public protocol IDODeviceInterface {
    /// 设备模式 0：运动模式，1：睡眠模式
    var deviceMode: Int { get }
    /// 电量状态 0:正常, 1:正在充电, 2:充满, 3:电量低
    var battStatus: Int { get }
    /// 电量级别 0～100
    var battLevel: Int { get }
    /// 是否重启 0:未重启 1:重启
    var rebootFlag: Int { get }
    /// 绑定状态 0:未绑定 1:已绑定
    var bindState: Int { get }
    /// 绑定类型 0:默认 1:单击 2:长按 3:屏幕点击 横向确认和取消,确认在左边 4:屏幕点击 横向确认和取消,确认在右边
    /// 5:屏幕点击 竖向确认和取消,确认在上边 6:屏幕点击 竖向确认和取消,确认在下边 7:点击(右边一个按键)
    var bindType: Int { get }
    /// 绑定超时 最长为15秒,0表示不超时
    var bindTimeout: Int { get }
    /// 设备平台 0:nordic, 10:realtek 8762x, 20:cypress psoc6, 30:Apollo3, 40:汇顶, 50:nordic+泰凌微,
    /// 60:泰凌微+5340+no nand flash, 70:汇顶+富瑞坤, 80:5340
    var platform: Int { get }
    /// 设备形状类型 0：无效；1：圆形；2：方形的； 3：椭圆
    var deviceShapeType: Int { get }
    /// 设备类型 0：无效；1：手环；2：手表
    var deviceType: Int { get }
    /// 自定义表盘主版本 从1开始 0:不支持对应的自定义表盘功能
    var dialMainVersion: Int { get }
    /// 固件绑定时候显示勾ui界面 0:不需要 1:需要
    var showBindChoiceUi: Int { get }
    /// 设备id
    var deviceId: Int { get }
    /// 设备固件主版本号
    var firmwareVersion: Int { get }
    /// 当前设备mac地址 - 无冒号
    var macAddress: String { get }
    /// 当前设备mac地址 - 带冒号
    var macAddressFull: String { get }
    /// 注意：该名称是由调用 markConnectedDevice(...)传入，sdk不会主动去刷新该值
    /// 需要获取最新值可以使用 Cmds.getDeviceName().send(..) 方法
    var deviceName: String { get }
    /// OTA模式
    var otaMode: Bool { get }
    /// UUID ios专用
    var uuid: String { get }
    /// BT macAddress - 带冒号
    var macAddressBt: String { get }
    
    /// 设备SN
    var sn: String? { get }

    /// BtName
    var btName: String? { get }

    /// GPS芯片平台 0：无效 1：索尼 sony 2：洛达 Airoh 3：芯与物 icoe
    var gpsPlatform: Int { get }
    
    /// 固件版本version1
    var fwVersion1: Int { get }
    /// 固件版本version2
    var fwVersion2: Int { get }
    /// 固件版本version3
    var fwVersion3: Int { get }
    /// BT版本生效标志位 0：无效 1：说明固件有对应的BT固件
    var fwBtFlag: Int { get }
    /// BT的版本version1
    var fwBtVersion1: Int { get }
    /// BT的版本version2
    var fwBtVersion2: Int { get }
    /// BT的版本version3
    var fwBtVersion3: Int { get }
    /// BT的所需要匹配的版本version1
    var fwBtMatchVersion1: Int { get }
    /// BT的所需要匹配的版本version2
    var fwBtMatchVersion2: Int { get }
    /// BT的所需要匹配的版本version3
    var fwBtMatchVersion3: Int { get }
    
    func printProperties() -> String?
    
    /// 刷新设备信息
    func refreshDeviceInfo(forced: Bool, completion: @escaping (Bool) -> Void)

    /// 刷新设备三级版本
    func refreshFirmwareVersion(forced: Bool, completion: @escaping (Bool) -> Void)
}
