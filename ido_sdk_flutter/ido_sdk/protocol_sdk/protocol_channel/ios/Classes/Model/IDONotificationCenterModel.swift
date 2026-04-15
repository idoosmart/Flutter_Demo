//
//  IDONotificationCenterModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Set Notification Center Event
@objcMembers
public class IDONotificationCenterModel: NSObject, IDOBaseModel {
    /// Notification reminder switch
    public var notifySwitch: Int
    /// Status
    /// 0: Unknown timeout
    /// 1: Success
    /// 2: Failed (canceled)
    /// 3: Firmware pairing timeout
    public var statusCode: Int
    /// 0: Success
    /// Non-zero: Failure
    public var errCode: Int
    
    enum CodingKeys: String, CodingKey {
        case notifySwitch = "notify_switch"
        case statusCode = "status_code"
        case errCode = "err_code"
    }
    
    public init(notifySwitch: Int,statusCode: Int,errCode: Int) {
        self.notifySwitch = notifySwitch
        self.statusCode = statusCode
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

