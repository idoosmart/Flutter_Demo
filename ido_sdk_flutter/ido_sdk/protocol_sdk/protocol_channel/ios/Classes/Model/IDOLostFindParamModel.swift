
//
//  IDOLostFindParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Set Lost Find Event
@objcMembers
public class IDOLostFindParamModel: NSObject, IDOBaseModel {
    /// Mode
    /// 0: No anti-lost
    /// 1: Close-range anti-lost
    /// 2: Medium-range anti-lost
    /// 3: Long-range anti-lost 
    public var mode: Int
    
    enum CodingKeys: String, CodingKey {
        case mode
    }
    
    public init(mode: Int) {
        self.mode = mode
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

