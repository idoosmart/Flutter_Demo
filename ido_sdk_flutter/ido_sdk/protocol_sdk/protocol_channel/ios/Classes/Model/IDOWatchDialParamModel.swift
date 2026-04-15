//
//  IDOWatchDialParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Set watch face event number
@objcMembers
public class IDOWatchDialParamModel: NSObject, IDOBaseModel {
    /// ID of the watch face to be set
    /// Dial id
    /// 0 invalid,currently supports1~4 
    public var dialId: Int
    
    enum CodingKeys: String, CodingKey {
        case dialId = "dial_id"
    }
    
    public init(dialId: Int) {
        self.dialId = dialId
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

