//
//  DeviceDelegateImpl.swift
//  protocol_channel
//
//  Created by hc on 2023/7/24.
//

import Foundation

class DeviceDelegateImpl: DeviceDelegate {
    static let shared = DeviceDelegateImpl()
    private init() {}
    
    private var _deviceInfo: DeviceInfo?
    var deviceInfo: DeviceInfo? {
        return _deviceInfo
    }
    
    var callbackDeviceInfo: ((IDODeviceInterface) -> Void)?
    
    /// 设备信息变更通知
    func listenDeviceChanged(deviceInfo: DeviceInfo) throws {
        _deviceInfo = deviceInfo
    }
    
    /// 绑定时获取的设备信息通知(绑定专用)
    func listenDeviceOnBind(deviceInfo: DeviceInfo) throws {
        callbackDeviceInfo?(DeviceImpl(deviceInfo: deviceInfo))
        callbackDeviceInfo = nil
    }
}
