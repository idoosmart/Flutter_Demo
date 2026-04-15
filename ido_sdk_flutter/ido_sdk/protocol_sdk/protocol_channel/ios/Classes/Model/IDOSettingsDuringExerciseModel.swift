//
//  IDOSettingsDuringExercise.swift
//  protocol_channel
//
//  Created by hc on 2025/5/6.
//

import Foundation

@objcMembers
public class IDOSettingsDuringExerciseModel: NSObject, IDOBaseModel {
    
    /// 0x55关， 0xAA开
    public var notificationSwitch: Int
    
    enum CodingKeys: String, CodingKey {
        case notificationSwitch = "notification_switch"
    }
    
    public init(notificationSwitch: Int) {
        self.notificationSwitch = notificationSwitch
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
