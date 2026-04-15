//
//  DeviceLogImpl.swift
//  protocol_channel
//
//  Created by hc on 2023/9/21.
//

import Foundation

/// 日志整体进度 0-100
public typealias BlockLogProgress = (_ progress: Double) -> Void

private var _deviceLog: DeviceLog? {
    return SwiftProtocolChannelPlugin.shared.deviceLog
}

private var _delegate: DeviceLogDelegateImpl {
    return DeviceLogDelegateImpl.shared
}

class DeviceLogImpl: IDODeviceLogInterface {
    
    var logDirPath: String {
       return _delegate.logDirPath
    }
    
    var getLogIng: Bool {
        return _delegate.logStatus;
    }
    
    func startGet(types: [IDODeviceLogTypeClass], timeOut: Int, progress: @escaping (Double) -> Void, completion: @escaping (Bool) -> Void) {
        let logTypes = types.map { $0.deviceLogType.rawValue.int64 }
        DeviceLogDelegateImpl.shared.callbackProgress = progress;
        _runOnMainThread {
            _deviceLog?.startGet(types: logTypes, timeOut: timeOut.int64, completion: completion)
        }
    }
    
    func cancel(completion: @escaping () -> Void) {
        _runOnMainThread {
            _deviceLog?.cancel { }
        }
    }
    
}

/// 日志类型
@objc
public enum IDODeviceLogType: Int {
    case initial = 0
    /// 1: 旧的重启日志
    case reboot = 1
    /// 2: 通用日志
    case general = 2
    /// 3: 复位日志
    case reset = 3
    /// 4: 硬件日志
    case hardware = 4
    /// 5: 算法日志
    case algorithm = 5
    /// 6: 新重启日志
    case restart = 6
    /// 7:电池日志
    case battery = 7
    /// 8: 过热日志
    case heat = 8
}


