//
//  DeviceImpl.swift
//  protocol_channel
//
//  Created by hc on 2023/7/24.
//

import Foundation

private var _delegate: DeviceDelegateImpl {
    return DeviceDelegateImpl.shared
}

private var _deviceTool: Device? {
    return SwiftProtocolChannelPlugin.shared.device
}

class DeviceImpl: IDODeviceInterface {
    func printProperties() -> String? {
        guard let obj = _delegate.deviceInfo else { return nil }
        return obj.printProperties()
    }
    
    // 优先映射该类属性，由构造方法传入，可选
    private var deviceInfo: DeviceInfo?
    private var devInfo: DeviceInfo? {
        return deviceInfo ?? _delegate.deviceInfo
    }

    var deviceMode: Int {
        return Int(devInfo?.deviceMode ?? 0)
    }

    var battStatus: Int {
        return Int(devInfo?.battStatus ?? 0)
    }

    var battLevel: Int {
        return Int(devInfo?.battLevel ?? 0)
    }

    var rebootFlag: Int {
        return Int(devInfo?.rebootFlag ?? 0)
    }

    var bindState: Int {
        return Int(devInfo?.bindState ?? 0)
    }

    var bindType: Int {
        return Int(devInfo?.bindType ?? 0)
    }

    var bindTimeout: Int {
        return Int(devInfo?.bindTimeout ?? 0)
    }

    var platform: Int {
        return Int(devInfo?.platform ?? 0)
    }

    var deviceShapeType: Int {
        return Int(devInfo?.deviceShapeType ?? 0)
    }

    var deviceType: Int {
        return Int(devInfo?.deviceType ?? 0)
    }

    var dialMainVersion: Int {
        return Int(devInfo?.dialMainVersion ?? 0)
    }

    var showBindChoiceUi: Int {
        return Int(devInfo?.showBindChoiceUi ?? 0)
    }

    var deviceId: Int {
        return Int(devInfo?.deviceId ?? 0)
    }

    var firmwareVersion: Int {
        return Int(devInfo?.firmwareVersion ?? 0)
    }

    var macAddress: String {
        return devInfo?.macAddress ?? ""
    }

    var macAddressFull: String {
        return devInfo?.macAddressFull ?? ""
    }

    var deviceName: String {
        return devInfo?.deviceName ?? ""
    }

    var otaMode: Bool {
        return devInfo?.otaMode ?? false
    }

    var uuid: String {
        return devInfo?.uuid ?? ""
    }

    var macAddressBt: String {
        return devInfo?.macAddressBt ?? ""
    }

    var fwVersion1: Int {
        return Int(devInfo?.fwVersion1 ?? 0)
    }

    var fwVersion2: Int {
        return Int(devInfo?.fwVersion2 ?? 0)
    }

    var fwVersion3: Int {
        return Int(devInfo?.fwVersion3 ?? 0)
    }

    var fwBtFlag: Int {
        return Int(devInfo?.fwBtFlag ?? 0)
    }

    var fwBtVersion1: Int {
        return Int(devInfo?.fwBtVersion1 ?? 0)
    }

    var fwBtVersion2: Int {
        return Int(devInfo?.fwBtVersion2 ?? 0)
    }

    var fwBtVersion3: Int {
        return Int(devInfo?.fwBtVersion3 ?? 0)
    }

    var fwBtMatchVersion1: Int {
        return Int(devInfo?.fwBtMatchVersion1 ?? 0)
    }

    var fwBtMatchVersion2: Int {
        return Int(devInfo?.fwBtMatchVersion2 ?? 0)
    }

    var fwBtMatchVersion3: Int {
        return Int(devInfo?.fwBtMatchVersion3 ?? 0)
    }
    
    var sn: String? {
        return devInfo?.sn
    }
    
    var btName: String? {
        return devInfo?.btName
    }
    
    var gpsPlatform: Int {
        return Int(devInfo?.gpsPlatform ?? 0)
    }

    init(deviceInfo: DeviceInfo? = nil) {
        self.deviceInfo = deviceInfo
    }
    
    func refreshDeviceInfo(forced: Bool, completion: @escaping (Bool) -> Void) {
        guard let tool = _deviceTool else {
            completion(false)
            return
        }
        _runOnMainThread {
            tool.refreshDeviceInfo(forced: forced, completion: completion)
        }
    }

    func refreshFirmwareVersion(forced: Bool, completion: @escaping (Bool) -> Void) {
        guard let tool = _deviceTool else {
            completion(false)
            return
        }
        _runOnMainThread {
            tool.refreshFirmwareVersion(forced: forced, completion: completion)
        }
    }
}

extension DeviceInfo {
    func printProperties() -> String {
        let mirror = Mirror(reflecting: self)
        var rs = "\(type(of: self)) : {\n"
        for case let (label?, value) in mirror.children {
            rs += "\(label): \(value)\n"
        }
        rs += "}"
        return rs
    }
}
