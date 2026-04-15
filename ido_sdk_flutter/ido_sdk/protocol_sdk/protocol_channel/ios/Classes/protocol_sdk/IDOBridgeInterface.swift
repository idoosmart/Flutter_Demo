//
//  IDOBridgeInterface.swift
//  alexa_channel
//
//  Created by hc on 2023/11/2.
//

import Foundation
import CoreBluetooth

/// 桥接接口
@objc
public protocol IDOBridgeInterface {

    /// 注册,程序开始运行调用（全局只调用一次即可）
    /// - Parameters:
    ///   - delegate: 代理
    ///   - logType: log等级
    func setupBridge(delegate: IDOBridgeDelegate, logType: IDOLogType)

    
    /// 标记为OTA模式
    /// - Parameters:
    ///   - macAddress: 设备macAddress
    ///   - iosUUID: uuid
    ///   - platform: 设备平台 0:nordic, 10:realtek 8762x, 20:cypress psoc6,
    ///          30:Apollo3, 40:汇顶, 50:nordic+泰凌微,
    ///          60:泰凌微+5340+no nand flash, 70:汇顶+富瑞坤,
    ///          80:5340, 90: 炬芯, 97: 恒玄, 98: 思澈1,
    ///          99: 思澈2 （注意：目前只支持98）
    ///   - deviceId: 设备id
    @objc optional func markOtaMode(macAddress: String, iosUUID: String, platform: Int , deviceId: Int , completion: @escaping (Bool) -> Void);
}


// MARK: - 代理

@objc
public protocol IDOBridgeDelegate: NSObjectProtocol {
    /// 监听状态通知（SDK)
    func listenStatusNotification(status: IDOStatusNotification)
    
    /// 监听设备主动通知/控制事件 (设备)
    func listenDeviceNotification(model: IDODeviceNotificationModel)
    
    /// 根据设备macAddress查询绑定状态（由APP端提供） true: 已绑定，false：未绑定
    func checkDeviceBindState(macAddress: String) -> Bool
    
    /// 监听已扫描列表中处于ota模式的设备 ，需要业务端执行ota
    func listenWaitingOtaDevice(otaDevice: IDOOtaDeviceModel)
}



// MARK: - 桥接方法（内部蓝牙库无需使用）
@objc
private protocol IDOBridgePipeInterface {
    
    // 暂不对外公开
//    var protocolState: IDOProtocolState { get }
    
    /// 标记设备已连接 （蓝牙连接时调用）
    /// - Parameters:
    ///   - uniqueId: 当前连接设备的mac地址或uuid
    ///   - otaType: 设置ota模式
    ///   - isBinded: 绑定状态
    ///   - deviceName: 设备名称
    func markConnectedDevice(uniqueId: String, otaType: IDOOtaType, isBinded: Bool, deviceName: String?, completion: @escaping (Bool) -> Void)

    /// 标记设备已断开（蓝牙断开时调用）
    func markDisconnectedDevice(macAddress: String?, uuid: String?, completion: @escaping (Bool) -> Void)

    /// 收到蓝牙数据
    ///
    /// type 数据类型 0:ble 1:SPP
    func receiveDataFromBle(data: Data, macAddress: String?)

    /// 发送蓝牙数据完成
    func writeDataComplete()
      
    /// 检查ota类型
    func checkOtaType(peripheral: CBPeripheral, advertisementData: [String: Any]) -> IDOOtaType
}

@objc
private protocol IDOBridgePipeDelegate {
    ///  写数据到蓝牙设备
    func writeDataToBle(bleData: IDOBleData)
}
