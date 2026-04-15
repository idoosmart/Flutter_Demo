//
//  BridgeImpl.swift
//  protocol_channel
//
//  Created by hc on 2023/7/18.
//

import Foundation
import CoreBluetooth

private var _flagSetupBridge = false
private var _flagErrTips = true
private var _bridge: Bridge? {
    if SwiftProtocolChannelPlugin.shared.bridge == nil, _flagErrTips {
        _flagErrTips = false
        let msg = """
        \n————————————————————————————————————————————————————————————————————————
        注意：SDK使用方式（不正确配置将无法使用）
        在AppDelegate中添加以下代码：
        1. 导入依赖
        import Flutter
        import protocol_channel
        
        2. 启用Flutter引擎并注册
        let flutterEngine = FlutterEngine(name: "io.flutter", project: nil)
        flutterEngine?.run(withEntrypoint: nil)
        if let engine = flutterEngine {
        GeneratedPluginRegistrant.register(with: engine)
            print("flutterEngine finished")
        } else {
            print("engine is null")
            assert(false, "engine is null")
        }
        ————————————————————————————————————————————————————————————————————————\n
        """
        assertionFailure(msg)
        print(msg)
    }
    return SwiftProtocolChannelPlugin.shared.bridge
}

class BridgeImpl: IDOBridgeInterface {
    func setupBridge(delegate: IDOBridgeDelegate, logType: IDOLogType) {
        if(_flagSetupBridge) {
            BridgeDelegateImpl.shared.delegate = delegate
            _logNative("重复调用setupBridge(...)")
            return
        }
        _flagSetupBridge = true
        BridgeDelegateImpl.shared.delegate = delegate
        _runOnMainThread {
            _bridge?.register(outputToConsole: logType != .none,
                              outputToConsoleClib: logType == .debug,
                              isReleaseClib: logType != .debug,
                              completion: { _ in })
            _logNative("ios native sdk: \(IDOSDK.shared.info.versionSdk) updateTime: \(IDOSDK.shared.info.updateTime)")
        }
    }
    
    func markOtaMode(macAddress: String, iosUUID: String, platform: Int , deviceId: Int , completion: @escaping (Bool) -> Void) {
        _runOnMainThread {
            _bridge?.markOtaMode(macAddress: macAddress, iosUUID: iosUUID, platform: Int64(platform), deviceId: Int64(deviceId), completion: completion)
        }
    }
    
    func markConnectedDevice(uniqueId: String, otaType: IDOOtaType, isBinded: Bool, deviceName: String?, completion: @escaping (Bool) -> Void) {
        _runOnMainThread {
            _bridge?.markConnectedDevice(uniqueId: uniqueId, otaType: Int64(otaType.rawValue), isBinded: isBinded, deviceName: deviceName, completion: completion)
        }
    }
    
    func markDisconnectedDevice(macAddress: String?, uuid: String?, completion: @escaping (Bool) -> Void) {
        _runOnMainThread {
            _bridge?.markDisconnectedDevice(macAddress: macAddress, uuid: uuid) { rs in
                BridgeDelegateImpl.shared.protocolState.resetAll()
                completion(rs)
            }
        }
    }
    
    func receiveDataFromBle(data: Data, macAddress: String?) {
        _runOnMainThread {
            _bridge?.receiveDataFromBle(data: FlutterStandardTypedData(bytes: data), macAddress: macAddress, type: 0) {}
        }
    }
    
    func writeDataComplete() {
        _runOnMainThread {
            _bridge?.writeDataComplete {}
        }
    }
    
    
    func checkOtaType(peripheral: CBPeripheral, advertisementData: [String: Any]) -> IDOOtaType {
        let manufacturerData = advertisementData["kCBAdvDataManufacturerData"] as? Data
        guard let data = manufacturerData, data.count >= 16 else {
            return .none
        }
        
        let name = peripheral.name
        let platform = Int(data[15])
        let dfuMode = Int(data[14])
        let version = Int(data[8])
        let deviceId = Int(data[0]) | Int(data[1]) << 8
        if (version == 3 && dfuMode == 1 && (platform == 98 || platform == 99)) {
            // 思澈平台
            _runOnMainThread {
                _bridge?.markOtaMode(macAddress: "",
                                     iosUUID: peripheral.identifier.uuidString,
                                     platform: platform.int64,
                                     deviceId: deviceId.int64) { _ in }
            }
            return .nordic
        }else if let cbuuids = advertisementData["kCBAdvDataServiceUUIDs"] as? [CBUUID] {
            // 其它平台
            let uuids = cbuuids.map({ $0.uuidString })
            let RX_UPDATE_UUID = "00001530-1212-efde-1523-785feabcd123"
            let RX_UPDATE_UUID_0XFE59_ANDROID = "0000fe59-0000-1000-8000-00805f9b34fb"
            let RX_UPDATE_UUID_0XFE59_IOS = "fe59"
            let RX_UPDATE_UUID_0X0203 = "00010203-0405-0607-0809-0a0b0c0d1912"
            let RX_UPDATE_NAME_TLW = "tlwota"
            
            for uuid in uuids {
                let lowUuid = uuid.lowercased()
                if (lowUuid == RX_UPDATE_UUID_0X0203 && name?.lowercased() == RX_UPDATE_NAME_TLW) {
                    //modeInfo.isTlwOta = true
                    return .telink
                }else if [RX_UPDATE_UUID, RX_UPDATE_UUID_0XFE59_ANDROID, RX_UPDATE_UUID_0XFE59_IOS].contains(lowUuid) {
                    //modeInfo.isOta = true
                    return .nordic
                }
            }
        }
        return .none
    }
}

@objcMembers
public class IDOProtocolState: NSObject {
    
    /// 设备已连接
    public internal(set) var isConnected: Bool
    
    /// 连接中（切换设备会受限制）
    /*public*/ internal(set) var isConnecting: Bool

    /// 绑定中 (切换设备会受到限制）
    public internal(set) var isBinding: Bool

    /// 执行快速配置 (执行快速配置期间，外部指令将直接返回失败）
    public internal(set) var isFastSynchronizing: Bool

    /// ota类型
    ///
    /// otaType 0 无升级, 1 泰凌微设备OTA, 2 nordic设备OTA
    public internal(set) var otaType: IDOOtaType

    /// 当前连接的设备MAC地址
    ///
    /// 注意：未标记为已连接时，将固定返回"UNKNOWN"
    public internal(set) var macAddress: String = "UNKNOWN"

    init(isConnected: Bool, isConnecting: Bool, isBinding: Bool, isFastSynchronizing: Bool, otaType: IDOOtaType, macAddress: String) {
        self.isConnected = isConnected
        self.isConnecting = isConnecting
        self.isBinding = isBinding
        self.isFastSynchronizing = isFastSynchronizing
        self.otaType = otaType
        self.macAddress = macAddress
    }
    
    func resetAll() {
        isConnected = false
        isConnecting = false
        isBinding = false
        isFastSynchronizing = false
        otaType = .none
        macAddress = "UNKNOWN"
    }
}

// MARK: -

/// 日志类型 （只针对控制台）
@objc
public enum IDOLogType: Int {
    /// 不打印
    case none = 0
    
    /// 详细
    case debug
    
    /// 重要
    case release
}

/// OTA类型
@objc
public enum IDOOtaType: Int {
    /// 无升级
    case none = 0
    
    /// 泰凌微设备OTA
    case telink
    
    /// nordic设备OTA
    case nordic
}

/// 绑定状态
@objc
public enum IDOBindStatus: Int {
    /// 绑定失败
    case failed = 0
    
    /// 绑定成功
    case successful
    
    /// 已经绑定
    case binded
    
    /// 需要授权码绑定
    case needAuth
    
    /// 拒绝绑定
    case refusedBind
    
    /// 绑定错误设备
    case wrongDevice
    
    /// 授权码校验失败
    case authCodeCheckFailed
    
    /// 取消绑定
    case canceled
    
    /// 绑定失败（获取功能表失败)
    case failedOnGetFunctionTable
    
    /// 绑定失败（获取设备信息失败)
    case failedOnGetDeviceInfo
    
    /// 绑定超时（支持该功能的设备专用）
    case timeout

    /// 新账户绑定，用户确定删除设备数据（支持该功能的设备专用）
    case agreeDeleteDeviceData

    /// 新账户绑定，用户不删除设备数据，绑定失败（支持该功能的设备专用）
    case denyDeleteDeviceData
    
    /// 新账户绑定，用户不选择，设备超时（支持该功能的设备专用）
    case timeoutOnNewAccount
    
    /// 设备同意配对(绑定)请求，等待APP下发配对结果（支持该功能的设备专用）
    case needConfirmByApp

}

@objcMembers
public class IDOOtaDeviceModel: NSObject {
    /// rssi
    public private(set) var rssi: Int
    /// 设备名称
    public private(set) var name: String?
    /// uuid
    public private(set) var uuid: String?
    /// mac address
    public private(set) var macAddress: String?
    /// ota mac address
    public private(set) var otaMacAddress: String?
    /// bt mac address
    public private(set) var btMacAddress: String?
    /// 设备ID
    public private(set) var deviceId: Int
    /// 设备类型 0:无效 1: 手表 2: 手环
    public private(set) var deviceType: Int
    /// 是否ota模式
    public private(set) var isOta: Bool
    /// 是否泰凌微ota
    public private(set) var isTlwOta: Bool
    /// bt版本号
    public private(set) var bltVersion: Int
    /// 配对状态（Android）
    public private(set) var isPair: Bool
    /// 平台 98, 99
    public private(set) var platform: Int

    public init(rssi: Int, name: String?, uuid: String?, macAddress: String?, otaMacAddress: String?, btMacAddress: String?, deviceId: Int, deviceType: Int, isOta: Bool, isTlwOta: Bool, bltVersion: Int, isPair: Bool, platform: Int) {
        self.rssi = rssi
        self.name = name
        self.uuid = uuid
        self.macAddress = macAddress
        self.otaMacAddress = otaMacAddress
        self.btMacAddress = btMacAddress
        self.deviceId = deviceId
        self.deviceType = deviceType
        self.isOta = isOta
        self.isTlwOta = isTlwOta
        self.bltVersion = bltVersion
        self.isPair = isPair
        self.platform = platform
    }
    
//    func updateValues(newDevice: OtaDeviceModel) {
//        guard macAddress != nil && macAddress == newDevice.macAddress else {
//            //print("swift 收到bleModel属性变更，macAddress不相同 return")
//            return
//        }
//        //print("swift 收到bleModel属性变更，对外实体属性更新")
//        rssi = newDevice.rssi?.int ?? -1
//        name = newDevice.name
//        uuid = newDevice.uuid
//        macAddress = newDevice.macAddress
//        otaMacAddress = newDevice.otaMacAddress
//        btMacAddress = newDevice.btMacAddress
//        deviceId = newDevice.deviceId?.int ?? 0
//        deviceType = newDevice.deviceType?.int ?? 0
//        isOta = newDevice.isOta ?? false
//        isTlwOta = newDevice.isTlwOta ?? false
//        bltVersion = newDevice.bltVersion?.int ?? 0
//        isPair = newDevice.isPair ?? false
//    }
    
    public override var description: String {
        return "IDOOtaDeviceModel(macAddress: \(macAddress ?? ""), isPair: \(isPair), isTlwOta: \(isTlwOta), isOta: \(isOta), name: \(name ?? ""), rssi: \(rssi), uuid: \(uuid ?? "") deviceId: \(deviceId), deviceType: \(deviceType), bltVersion: \(bltVersion))"
    }
    
    //==============do not edit directly begin==============
    public func toDeviceModel() -> IDODeviceModel {
        return IDODeviceModel(rssi: rssi, 
                              name: name,
                              state: .disconnected,
                              uuid: uuid, 
                              macAddress: macAddress,
                              otaMacAddress: otaMacAddress,
                              btMacAddress: btMacAddress,
                              deviceId: deviceId, 
                              deviceType: deviceType,
                              isOta: isOta, 
                              isTlwOta: isTlwOta,
                              bltVersion: bltVersion,
                              isPair: isPair,
                              platform: platform)
    }
    //==============do not edit directly end==============
}
