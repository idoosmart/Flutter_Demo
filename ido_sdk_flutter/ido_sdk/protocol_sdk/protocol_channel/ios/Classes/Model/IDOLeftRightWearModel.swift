//
//  IDOLeftRightWearModel.swift
//  protocol_channel
//
//  Created by hc on 2025/5/6.
//

import Foundation

@objcMembers
public class IDOLeftRightWearModel: NSObject, IDOBaseModel {
    
    /// 0x00 左手，0x01 右手
    public var handType: Int
    
    enum CodingKeys: String, CodingKey {
        case handType = "hand_type"
    }
    
    public init(handType: Int) {
        self.handType = handType
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
