//
//  IDOSDK.swift
//  protocol_channel
//
//  Created by hc on 2023/8/15.
//

import Foundation

/// SDK入口类
@objcMembers
public class IDOSDK: NSObject, IDOSdkInterface {
    public static let shared = IDOSDK()
    override private init() {}

    public private(set) lazy var device: IDODeviceInterface = DeviceImpl()

    public private(set) lazy var funcTable: IDOFuncTableInterface = FuncTableImpl()

    public private(set) lazy var cmd: IDOCmdInterface = CmdImpl()

    public private(set) lazy var bridge: IDOBridgeInterface = BridgeImpl()

    public private(set) lazy var ble: IDOBleInterface = BleImpl()

    public private(set) lazy var alexa: IDOAlexaInterface = AlexaImpl()

    public private(set) lazy var transfer: IDOFileTransferInterface = FileTransferImpl()

    public private(set) lazy var messageIcon: IDOMessageIconInterface = MessageIconImpl()

    public private(set) lazy var syncData: IDOSyncDataInterface = SyncDataImpl()
    
    public private(set) lazy var dataExchange: IDODataExchangeOCInterface = ExchangeDataOCImpl()

    public private(set) lazy var deviceLog: IDODeviceLogInterface = DeviceLogImpl()

    public private(set) lazy var tool: IDOToolsInterface = ToolImpl()
    
    public private(set) lazy var state: IDOProtocolState = BridgeDelegateImpl.shared.protocolState
    
    private let _sdkInfo = IDOSdkInfo()
    public var info: IDOSdkInfo {
        get {
            guard let verInfo = SwiftProtocolChannelPlugin.shared.verInfo else {
                return _sdkInfo
            }
            _sdkInfo.versionLib = verInfo.verMain!
            _sdkInfo.versionAlexa = verInfo.verAlexa!
            _sdkInfo.versionClib = verInfo.verClib!
            return _sdkInfo
        }
    }
}


@objcMembers
public class IDOSdkInfo: NSObject {
    /// SDK版本
    public let versionSdk = "4.5.1"
    
    /// SDK更新时间
    public let updateTime = "2026-03-26 11:37:52"
    
    /// Lib库版本
    public internal(set) var versionLib: String = "4.0.16"
    
    /// Alexa库版本
    public internal(set) var versionAlexa: String = "2.0.9"
    
    /// c库版本
    public internal(set) var versionClib: String = "3.7.12"
}

func _runOnMainThread(_ closure: @escaping () -> Void) {
    if Thread.isMainThread {
        closure()
    } else {
        DispatchQueue.main.async {
            _logNative("其它线程，切主线程后调用")
            closure()
        }
    }
}
