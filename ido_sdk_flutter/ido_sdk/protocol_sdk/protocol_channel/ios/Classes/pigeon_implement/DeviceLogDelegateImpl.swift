//
//  DeviceLogDelegateImpl.swift
//  protocol_channel
//
//  Created by hedongyang on 2023/11/23.
//

import Foundation

class DeviceLogDelegateImpl: DeviceLogDelegate {
    
    static let shared = DeviceLogDelegateImpl()
    private init() {}
    
    private(set) var logStatus : Bool = false
    private(set) var logDirPath: String = ""
    var callbackProgress: BlockLogProgress?
    
    func listenLogStatus(status: Bool) throws {
        logStatus = status
    }
    
    func listenLogDirPath(dirPath: String) throws {
         logDirPath = dirPath
    }
    
    func callbackLogProgress(progress: Double) throws {
        callbackProgress?(progress)
    }
    
}
