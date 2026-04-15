//
//  IDODisplayModeParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Display mode event number
@objcMembers
public class IDODisplayModeParamModel: NSObject, IDOBaseModel {
    /// Mode 
    /// 0: Default 
    /// 1: Landscape 
    /// 2: Portrait 
    /// 3: Flipped (180 degrees) 
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

