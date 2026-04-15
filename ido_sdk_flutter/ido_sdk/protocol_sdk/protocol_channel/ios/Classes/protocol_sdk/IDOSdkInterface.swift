//
//  IDOSdkInterface.swift
//  alexa_channel
//
//  Created by hc on 2023/11/2.
//

import Foundation

/// SDK接口
@objc
public protocol IDOSdkInterface {
    /// 设备信息
    var device: IDODeviceInterface { get }
    
    /// 功能表
    var funcTable: IDOFuncTableInterface { get }
    
    /// 指令
    var cmd: IDOCmdInterface { get }
    
    /// 桥接
    var bridge: IDOBridgeInterface { get }
    
    /// 蓝牙
    var ble: IDOBleInterface { get }
    
    /// Alexa
    var alexa: IDOAlexaInterface { get }
    
    /// 文件传输
    var transfer: IDOFileTransferInterface { get }
    
    /// 消息图标
    var messageIcon: IDOMessageIconInterface { get }
    
    /// 数据同步
    var syncData: IDOSyncDataInterface { get }
    
    /// 数据交换
    var dataExchange: IDODataExchangeOCInterface  { get }
    
    /// 设备日志
    var deviceLog: IDODeviceLogInterface { get }

    /// 常用工具、缓存
    var tool: IDOToolsInterface { get }
    
    /// sdk info
    var info: IDOSdkInfo { get }
    
    /// sdk state
    var state: IDOProtocolState { get }
    
}

@objc
public protocol IDOCancellable {
    var isCancelled: Bool { get }

    func cancel()
}
