//
//  IDODeviceLogStateModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Get device log state event number
@objcMembers
public class IDODeviceLogStateModel: NSObject, IDOBaseModel {
    /// 0: No corresponding log 
    /// 1: Firmware restart log 
    /// 2: Firmware exception 
    public var type: Int
    /// Error code of firmware restart log, 0 is normal             
    public var errCode: Int
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case errCode = "err_code"
    }
    
    public init(type: Int,errCode: Int) {
        self.type = type
        self.errCode = errCode
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

