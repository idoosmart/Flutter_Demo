//
//  IDOShortcutParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Set shortcut
@objcMembers
public class IDOShortcutParamModel: NSObject, IDOBaseModel {
    /// Function of Shortcut 1
    /// 0: Invalid
    /// 1: Quick access to camera control
    /// 2: Quick access to motion mode
    /// 3: Quick access to do not disturb 
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

