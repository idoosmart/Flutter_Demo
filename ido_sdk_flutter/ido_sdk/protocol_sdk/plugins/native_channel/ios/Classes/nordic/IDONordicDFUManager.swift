//
//  DFU.swift
//  IDOBlueUpdate
//
//  Created by cyf on 2025/3/8.
//  Copyright © 2025 何东阳. All rights reserved.
//

import Foundation
import CoreBluetooth
// import iOSMcuManagerLibrary

/// Callbacks for firmware upgrades started using FirmwareUpgradeManager

@objc public protocol IDONordicDFUManagerDelegate: NSObjectProtocol {
    
    func upgradeDidStart()
    
    /// Called when the firmware upgrade has succeeded.
    func upgradeDidComplete()
    
    /// Called when the firmware upgrade has failed.
    ///
    /// - parameter state: The state in which the upgrade has failed.
    /// - parameter error: The error.
    func upgradeDidFail(error: Error)
    
    /// Called when the firmware upgrade has been cancelled using cancel()
    /// method. The upgrade may be cancelled only during uploading the image.
    /// When the image is uploaded, the test and/or confirm commands will be
    /// sent depending on the mode.
    func upgradeDidCancel()
    
    /// Called when the upload progress has changed.
    ///
    /// - parameter bytesSent: Number of bytes sent so far.
    /// - parameter imageSize: Total number of bytes to be sent.
    /// - parameter timestamp: The time that the successful response packet for
    ///   the progress was received.
    func uploadProgressDidChange(speed: String,progress:Float,bytesSent: Int, imageSize: Int, timestamp: Date)
    
    /// 记录日志
    func nativeLog(logMsg: String)
}

@objc public class IDONordicDFUManager:NSObject {
    
    
    @objc public static let share = IDONordicDFUManager()
    @objc public weak var delegate: IDONordicDFUManagerDelegate?
    
    private var initialBytes: Int = 0
    private var uploadImageSize: Int!
    private var uploadTimestamp: Date!
    private var dfuManager: FirmwareUpgradeManager!
    private var bleTransport: McuMgrBleTransport!
    
    @objc public func startDFU(targetIdentifier: String,from url: URL, mtu: Int) {
        _logNative("[Ring OTA] startDFU peripheral.identifier.uuidString：\(targetIdentifier),url: \(url)")
        guard let identifier = UUID(uuidString: targetIdentifier) else { return; }
        bleTransport = McuMgrBleTransport.init(identifier)
        bleTransport.logDelegate = self
        
        
        // Initialize the FirmwareUpgradeManager using the transport and a delegate
        dfuManager = FirmwareUpgradeManager(transport: bleTransport, delegate: self)
        
        do {
            try? dfuManager.setUploadMtu(mtu: mtu)
            let imageArray:  [ImageManager.Image]  = try self.imageFromBinFile(from: url);
            let isPhone8Below = isPhone8Below()
            let pipelineDepth = isPhone8Below ? 1 : 3
            let byteAlignment = isPhone8Below ? ImageUploadAlignment.disabled : ImageUploadAlignment.fourByte
            var dfuManagerConfiguration = FirmwareUpgradeConfiguration(eraseAppSettings: false, pipelineDepth: pipelineDepth, byteAlignment: byteAlignment)
            dfuManagerConfiguration.upgradeMode = .confirmOnly
            // Start the firmware upgrade with the given package
            dfuManager.start(images: imageArray,using: dfuManagerConfiguration)
            
        }catch {
            _logNative("[Ring OTA] dfuManager start error")
            
        }
    }
    
    func isPhone8Below() -> Bool {
        var systemInfo = utsname()
        uname(&systemInfo)
        let platform = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: Int(_SYS_NAMELEN)) {
                String(cString: $0)
            }
        }
        
        let desc = "isPhone8Below:\(platform)"
        // 假设已实现 Swift 版本的日志记录（根据实际框架调整）
        _logNative("[Ring OTA] : \(desc)")
        
        // iPhone 8 及以下所有型号列表
        let oldPhoneModels = [
            "iPhone1,1", "iPhone1,2", "iPhone2,1",
            "iPhone3,1", "iPhone3,2", "iPhone3,3", "iPhone4,1",
            "iPhone5,1", "iPhone5,2", "iPhone5,3", "iPhone5,4",
            "iPhone6,1", "iPhone6,2", "iPhone7,1", "iPhone7,2",
            "iPhone8,1", "iPhone8,2", "iPhone8,4",
            "iPhone9,1", "iPhone9,2"
        ]
        
        return oldPhoneModels.contains(platform)
    }
    
    func imageFromBinFile(from url: URL) throws -> [ImageManager.Image] {
        let binData = try Data(contentsOf: url)
        _logNative("[Ring OTA] imageFromBinFile(from: url) binData count \(binData.count)")
        
        let binHash = try McuMgrImage(data: binData).hash
        _logNative("[Ring OTA] imageFromBinFile(from: url) binData  McuMgrImage(data: binData) hash: \(binHash.hexEncodedString())")
        
        return [ImageManager.Image(image: 0, hash: binHash, data: binData)]
    }
    
    @objc public func stopDFU(){
        if(dfuManager != nil){
            dfuManager.cancel()
            _logNative("[Ring OTA] stop ota")
        }
    }
    
    
    func _logNative(_ msg: String) {
        delegate?.nativeLog(logMsg: msg)
    }
    
}

extension IDONordicDFUManager: FirmwareUpgradeDelegate{
    
    internal func upgradeDidStart(controller: FirmwareUpgradeController) {
        delegate?.upgradeDidStart()
        _logNative("[Ring OTA] upgradeDidStart: \(controller)")
        
    }
    
    internal func upgradeStateDidChange(from previousState: FirmwareUpgradeState, to newState: FirmwareUpgradeState) {
        _logNative("[Ring OTA] upgradeStateDidChange previousState: \(previousState)  newState: \(newState)")
        
    }
    
    internal func upgradeDidComplete() {
        delegate?.upgradeDidComplete()
        _logNative("[Ring OTA] pgradeDidComplete")
    }
    
    internal func upgradeDidFail(inState state: FirmwareUpgradeState, with error: Error) {
        delegate?.upgradeDidFail(error: error)
        _logNative("[Ring OTA] upgradeDidFail state : \(state)  error: \(error)")
        
    }
    
    internal func upgradeDidCancel(state: FirmwareUpgradeState) {
        delegate?.upgradeDidCancel()
        _logNative("[Ring OTA] upgradeDidCancel state : \(state)")
        
    }
    
    internal func uploadProgressDidChange(bytesSent: Int, imageSize: Int, timestamp: Date) {
        
        if uploadImageSize == nil || uploadImageSize != imageSize {
            uploadTimestamp = timestamp
            uploadImageSize = imageSize
            initialBytes = bytesSent
        }
        // Date.timeIntervalSince1970 returns seconds
        let msSinceUploadBegan = max((timestamp.timeIntervalSince1970 - uploadTimestamp.timeIntervalSince1970) * 1000, 1)
        
        guard bytesSent < imageSize else {
            let averageSpeedInKiloBytesPerSecond = Double(imageSize - initialBytes) / msSinceUploadBegan
            _logNative("[Ring OTA] uploadProgressDidChange:\(imageSize) bytes sent avg \(String(format: "%.2f kB/s",averageSpeedInKiloBytesPerSecond))")
            return
        }
        
        let bytesSentSinceUploadBegan = bytesSent - initialBytes
        // bytes / ms = kB/s
        let speedInKiloBytesPerSecond = Double(bytesSentSinceUploadBegan) / msSinceUploadBegan
        let speed = String(format: "%.2f kB/s", speedInKiloBytesPerSecond)
        let progress = Float(bytesSent) / Float(imageSize)
        //        print("uploadProgressDidChange progress: \(progress) speed: \(speed) bytesSent : \(bytesSent) , imageSize: \(imageSize),timestamp: \(timestamp)")
        delegate?.uploadProgressDidChange(speed: speed,progress:progress,bytesSent: bytesSent, imageSize: imageSize, timestamp: timestamp)
        _logNative("[Ring OTA] uploadProgressDidChange progress: \(progress) speed: \(speed) bytesSent : \(bytesSent) , imageSize: \(imageSize),timestamp: \(timestamp)")
        
    }
    
    
}

extension IDONordicDFUManager: McuMgrLogDelegate {
    
    internal func log(_ msg: String,
                    ofCategory category: McuMgrLogCategory,
                    atLevel level: McuMgrLogLevel) {
        let msg = "[Ring OTA] [\(category.rawValue)]  [level:\(level.name)]  msg:\(msg)"
        debugPrint(msg)
        delegate?.nativeLog(logMsg: msg)
    }
    
    internal func minLogLevel() -> McuMgrLogLevel {
//        #if DEBUG
//            return .debug
//        #else
//            return .info
//        #endif
        return .warning
    }
    
}


