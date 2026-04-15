//
//  IDODeviceLogInterface.swift
//  alexa_channel
//
//  Created by hc on 2023/11/2.
//

import Foundation

/// 设备日志
@objc
public protocol IDODeviceLogInterface {
    
    /// 是否正在获取日志中
    var getLogIng: Bool { get }
    
    
    /// 获取所有日志目录地址
    /// 返回：/xx/../ido_sdk/devices/{macAddress}/device_logs
    /// lash 日志目录 Flash
    /// 电池日志目录 Battery
    /// 过热日志目录 Heat
    /// 旧的重启日志目录 Reboot
    var logDirPath: String { get }
    
    
    /// 开始获取日志
    /// - Parameters:
    ///   - types: 日志类型集合
    ///   - timeOut: 获取日志超时
    ///   - progress: 日志获取进度 (0-100)
    ///   - completion: 日志获取完成回调
    func startGet(types: [IDODeviceLogTypeClass],
                  timeOut: Int,
                  progress: @escaping BlockLogProgress,
                  completion: @escaping (Bool) -> Void)
    
    /// 取消获取日志
    func cancel(completion: @escaping () -> Void)
    
}


@objcMembers public class IDODeviceLogTypeClass: NSObject {
    let deviceLogType: IDODeviceLogType
    
    public init(logType: IDODeviceLogType) {
        self.deviceLogType = logType
    }
}
