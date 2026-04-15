//
//  BleImpl.swift
//  protocol_channel
//
//  Created by hc on 2023/7/18.
//

import Foundation

private var _ble: Bluetooth? {
    return SwiftProtocolChannelPlugin.shared.ble
}

class BleImpl: IDOBleInterface {
    
    var lastSelectDevice: IDODeviceModel?
    
    init() {
        BluetoothDelegateImpl.shared.callbackDeviceBleModel = { [weak self] val in
            self?.lastSelectDevice?.updateValues(newDevice: val)
        }
    }
    
    func addBleDelegate(api: IDOBleDelegate?) {
        BluetoothDelegateImpl.shared.delegate = api
    }

    func addDfuDelegate(api: IDODfuDelegate?) {
        BluetoothDelegateImpl.shared.delegateDfu = api
    }

    func bluetoothRegister(heartPingSecond: Int, outputToConsole: Bool) {
        _runOnMainThread {
            _ble?.register(heartPingSecond: Int64(heartPingSecond), outputToConsole: outputToConsole) {}
        }
    }

    func startScan(macAddress: String?, completion: @escaping ([IDODeviceModel]?) -> Void) {
        _runOnMainThread {
            _ble?.startScan(macAddress: macAddress) { items in
                guard let _items = items else {
                    completion(nil)
                    return
                }
                
                var list = [IDODeviceModel]()
                for obj in _items {
                    guard let o = obj else { continue }
                    list.append(o.toIDODeviceModel())
                }
                completion(list)
            }
        }
    }

    func scanFilter(deviceName: [String]?,
                    deviceID: [Int]?,
                    macAddress: [String]?,
                    uuid: [String]?)
    {
        _runOnMainThread {
            _ble?.scanFilter(deviceName: deviceName,
                             deviceID: deviceID?.map { Int64($0) },
                             macAddress: macAddress,
                             uuid: uuid) {}
        }
    }

    func stopScan() {
        _runOnMainThread {
            _ble?.stopScan {}
        }
    }

    func connect(device: IDODeviceModel?) {
        lastSelectDevice = device
        _runOnMainThread {
            _ble?.connect(device: device?.toDeviceModel()) {}
        }
    }

    func autoConnect(device: IDODeviceModel?) {
        lastSelectDevice = device
        _runOnMainThread {
            _ble?.autoConnect(device: device?.toDeviceModel()) {}
        }
    }

    func cancelConnect(macAddress: String?, completion: @escaping (Bool) -> Void) {
        _runOnMainThread {
            _ble?.cancelConnect(macAddress: macAddress, completion: completion)
        }
    }

    func getBluetoothState(completion: @escaping (IDOBluetoothStateModel) -> Void) {
        _runOnMainThread {
            _ble?.getBluetoothState { rs in
                completion(rs.toIDOBluetoothStateModel())
            }
        }
    }

    func getDeviceState(device: IDODeviceModel?, completion: @escaping (IDODeviceStateModel) -> Void) {
        _runOnMainThread {
            _ble?.getDeviceState(device: device?.toDeviceModel()) { rs in
                completion(rs.toDeviceStateModel())
            }
        }
    }

    func writeData(data: Data, device: IDODeviceModel, type: Int, platform: Int, completion: @escaping (IDOWriteStateModel) -> Void) {
        _runOnMainThread {
            _ble?.writeData(data: FlutterStandardTypedData(bytes: data),
                            device: device.toDeviceModel(),
                            type: type.int64,
                            platform: platform.int64)
            {
                completion($0.toWriteStateModel())
            }
        }
    }

//    func setBtPair(device: IDODeviceModel) {
//        _ble?.setBtPair(device: device.toDeviceModel()) {}
//    }
//
//    func cancelPair(device: IDODeviceModel?) {
//        _ble?.cancelPair(device: device?.toDeviceModel()) {}
//    }
//
//    func connectSPP(btMacAddress: String) {
//        _ble?.connectSPP(btMacAddress: btMacAddress) {}
//    }
//
//    func disconnectSPP(btMacAddress: String) {
//        _ble?.disconnectSPP(btMacAddress: btMacAddress) {}
//    }

    func startNordicDFU(config: IDODfuConfig) {
        _runOnMainThread {
            _ble?.startNordicDFU(config: config.toDfuConfig()) {}
        }
    }
    
    func exportLog(completion: @escaping (String?) -> Void) {
        _runOnMainThread {
            _ble?.logPath(completion: completion)
        }
    }
}

// MARK: -

/// 连接状态
@objc
public enum IDODeviceStateType: Int {
    /// 断开连接
    case disconnected = 0
    /// 连接中
    case connecting
    /// 已连接
    case connected
    /// 断开连接中
    case disconnecting
}

/// 蓝牙状态
@objc
public enum IDOBluetoothStateType: Int {
    /// 未知
    case unknown = 0
    /// 系统服务重启中
    case resetting
    /// 不支持
    case unsupported
    /// 未授权
    case unauthorized
    /// 蓝牙关闭
    case poweredOff
    /// 蓝牙打开
    case poweredOn
}

/// 扫描状态
@objc
public enum IDOBluetoothScanType: Int {
    /// 扫描中
    case scanning = 0
    /// 扫描结束
    case stop
    /// 找到设备（android）
    case find
}

/// 连接错误
@objc
public enum IDOConnectErrorType: Int {
    /// 无状态
    case none = 0
    /// UUID或Mac地址异常
    case abnormalUUIDMacAddress
    /// 蓝牙关闭
    case bluetoothOff
    /// 主动断开连接
    case connectCancel
    /// 连接失败
    case fail
    /// 连接超时
    case timeOut
    /// 发现服务失败
    case serviceFail
    /// 发现特征失败
    case characteristicsFail
    /// 配对异常
    case pairFail
    /// 获取基本信息失败
    case informationFail
    /// app主动断开
    case cancelByUser
    /// 设备已绑定并且不支持重复绑定
    case deviceAlreadyBindAndNotSupportRebind
    /// app 绑定的设备被重置了
    case deviceHasBeenReset
    /// 连接被终止，比如在 ota 中，不需要执行重连了
    case connectTerminated
}

/// 写数据状态
@objc
public enum IDOWriteType: Int {
    /// 有响应
    case withResponse = 0
    /// 无响应
    case withoutResponse
    /// 错误
    case error
}

/// spp
@objc
public enum IDOSppStateType: Int {
    /// 开始连接
    case onStart = 0
    /// 连接成功
    case onSuccess
    /// 连接失败
    case onFail
    /// 断链
    case onBreak
}

@objcMembers
public class IDODeviceModel: NSObject {
    /// rssi
    public private(set) var rssi: Int
    /// 设备名称
    public private(set) var name: String?
    /// 设备状态
    public private(set) var state: IDODeviceStateType
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
    
    public private(set) var platform: Int = 0

    public init(rssi: Int, name: String?, state: IDODeviceStateType, uuid: String?, macAddress: String?, otaMacAddress: String?, btMacAddress: String?, deviceId: Int, deviceType: Int, isOta: Bool, isTlwOta: Bool, bltVersion: Int, isPair: Bool) {
        self.rssi = rssi
        self.name = name
        self.state = state
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
    }
    
    public init(rssi: Int, name: String?, state: IDODeviceStateType, uuid: String?, macAddress: String?, otaMacAddress: String?, btMacAddress: String?, deviceId: Int, deviceType: Int, isOta: Bool, isTlwOta: Bool, bltVersion: Int, isPair: Bool, platform: Int) {
        self.rssi = rssi
        self.name = name
        self.state = state
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
    
    func updateValues(newDevice: DeviceModel) {
        guard macAddress != nil && macAddress == newDevice.macAddress else {
            //print("swift 收到bleModel属性变更，macAddress不相同 return")
            return
        }
        //print("swift 收到bleModel属性变更，对外实体属性更新")
        let _state = IDODeviceStateType(rawValue: newDevice.state!.rawValue)!
        rssi = newDevice.rssi?.int ?? -1
        name = newDevice.name
        state = _state
        uuid = newDevice.uuid
        macAddress = newDevice.macAddress
        otaMacAddress = newDevice.otaMacAddress
        btMacAddress = newDevice.btMacAddress
        deviceId = newDevice.deviceId?.int ?? 0
        deviceType = newDevice.deviceType?.int ?? 0
        isOta = newDevice.isOta ?? false
        isTlwOta = newDevice.isTlwOta ?? false
        bltVersion = newDevice.bltVersion?.int ?? 0
        isPair = newDevice.isPair ?? false
        platform = Int(newDevice.platform ?? 0)
        
    }
}

@objcMembers
public class IDOBluetoothStateModel: NSObject {
    public let type: IDOBluetoothStateType
    public let scanType: IDOBluetoothScanType

    public init(type: IDOBluetoothStateType, scanType: IDOBluetoothScanType) {
        self.type = type
        self.scanType = scanType
    }
}

@objcMembers
public class IDODeviceStateModel: NSObject {
    public internal(set) var uuid: String?
    public internal(set) var macAddress: String?
    public internal(set) var  state: IDODeviceStateType
    public internal(set) var errorState: IDOConnectErrorType

    public init(uuid: String?, macAddress: String?, state: IDODeviceStateType, errorState: IDOConnectErrorType) {
        self.uuid = uuid
        self.macAddress = macAddress
        self.state = state
        self.errorState = errorState
    }
}

@objcMembers
public class IDOWriteStateModel: NSObject {
    /// 写入状态是否成功
    public let state: Bool
    /// uuid
    public let uuid: String?
    /// mac address
    public let macAddress: String?
    /// 写入类型
    public let type: IDOWriteType

    public init(state: Bool, uuid: String?, macAddress: String?, type: IDOWriteType) {
        self.state = state
        self.uuid = uuid
        self.macAddress = macAddress
        self.type = type
    }
}

@objcMembers
public class IDOReceiveData: NSObject {
    /// 蓝牙字节数据
    public let data: Data?
    /// uuid
    public let uuid: String?
    /// mac address
    public let macAddress: String?
    /// spp
    public let spp: Bool
    
    /// 0 爱都, 1 恒玄, 2 VC
    public let platform: Int

    public init(data: Data?, uuid: String?, macAddress: String?, spp: Bool, platform: Int) {
        self.data = data
        self.uuid = uuid
        self.macAddress = macAddress
        self.spp = spp
        self.platform = platform
    }
}

@objcMembers
public class IDOSppStateModel: NSObject {
    public let type: IDOSppStateType

    public init(type: IDOSppStateType) {
        self.type = type
    }
}

/// 设备升级
@objcMembers
public class IDODfuConfig: NSObject {
    /// ota文件包路径
    public let filePath: String?
    /// 设备的uuid, iOS使用
    public let uuid: String?
    /// 设备的ble地址 安卓使用
    public let macAddress: String?
    /// 设备的id
    public let deviceId: String?
    /// 平台，默认为nordic，目前只支持nordic
    public let platform: Int
    /// 设备是否支持配对，根据功能表V3_dev_support_pair_each_connect  安卓使用
    public let isDeviceSupportPairedWithPhoneSystem: Bool
    /// 每次接受到包数，可不填
    public let prn: Int
    /// 在重试过程中，如果多次升级失败，是否需要重启蓝牙
    public let isNeedReOpenBluetoothSwitchIfFailed: Bool
    /// 最大重试次数
    public let maxRetryTime: Int
    /// RTK平台的OTA，在升级之前是否需要授权
    public let isNeedAuth: Bool
    /// RTK平台的OTA，模式
    public let otaWorkMode: Int

    public init(filePath: String?, uuid: String?, macAddress: String?, deviceId: String?, platform: Int, isDeviceSupportPairedWithPhoneSystem: Bool, prn: Int, isNeedReOpenBluetoothSwitchIfFailed: Bool, maxRetryTime: Int, isNeedAuth: Bool, otaWorkMode: Int) {
        self.filePath = filePath
        self.uuid = uuid
        self.macAddress = macAddress
        self.deviceId = deviceId
        self.platform = platform
        self.isDeviceSupportPairedWithPhoneSystem = isDeviceSupportPairedWithPhoneSystem
        self.prn = prn
        self.isNeedReOpenBluetoothSwitchIfFailed = isNeedReOpenBluetoothSwitchIfFailed
        self.maxRetryTime = maxRetryTime
        self.isNeedAuth = isNeedAuth
        self.otaWorkMode = otaWorkMode
    }
}

// MARK: -

extension BluetoothDelegateImpl {}
