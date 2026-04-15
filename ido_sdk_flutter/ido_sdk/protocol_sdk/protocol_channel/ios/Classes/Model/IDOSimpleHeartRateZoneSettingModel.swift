//
//  IDOSimpleHeartRateZoneSettingModel.swift
//  protocol_channel
//
//  Created by Davy on 2025/5/6.
//

import Foundation

// MARK: - 运动提醒设置参数模型

@objcMembers
public class IDOSimpleHeartRateZoneSettingModel: NSObject, IDOBaseModel {
    public var maxHrValue: Int = 0

    // JSON Key 映射（通过 Codable 实现）
    private enum CodingKeys: String, CodingKey {
        case maxHrValue = "max_hr_value"
    }
    
    public init(maxHrValue: Int) {
        self.maxHrValue = maxHrValue
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
