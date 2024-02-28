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
    
}
