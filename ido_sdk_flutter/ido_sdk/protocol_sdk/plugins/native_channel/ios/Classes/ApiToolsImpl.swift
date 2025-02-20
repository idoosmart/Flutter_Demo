//
//  ApiToolsImpl.swift
//  native_channel
//
//  Created by hc on 12/11/23.
//

import Foundation

class ApiToolsImpl: ApiTools {
    static let shared = ApiToolsImpl()
    private init() {}
    
    func getAppName() throws -> String {
        let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "-"
        return appName
    }
    
    func getCurrentTimeZone() throws -> String {
        let currentTimeZone = TimeZone.current
        let timeZoneString = currentTimeZone.identifier
        return timeZoneString
    }
    
    func getDocumentPath() throws -> String? {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    }
    
    func getPlatformDeviceInfo() throws -> [AnyHashable : Any?]? {
        let devInfo = DeviceInfoManager.getDeviceInfo()
        return [
            "model": devInfo.model,
            "systemVersion": devInfo.systemVersion,
            "isJailbroken": devInfo.isJailbroken
        ]
    }
}

fileprivate struct DeviceInfo {
    let model: String
    let systemVersion: String
    let isJailbroken: Bool
}

fileprivate class DeviceInfoManager {
    static func getDeviceInfo() -> DeviceInfo {
        let model = getModeName()
        let systemVersion = UIDevice.current.systemVersion
        let isJailbroken = checkJailbreak()
        return DeviceInfo(model: model, systemVersion: systemVersion, isJailbroken: isJailbroken)
    }
    
    private static func checkJailbreak() -> Bool {
        if #available(iOS 11.0, *) {
            return false
        }
        let path = "/private/" + "Applications"
        if FileManager.default.fileExists(atPath: path) {
            return true
        }
        return false
    }
    
    private static func getModeName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let elementValue = element.value as? Int8, elementValue != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(elementValue)))
        }
        return identifier
    }
    
}
