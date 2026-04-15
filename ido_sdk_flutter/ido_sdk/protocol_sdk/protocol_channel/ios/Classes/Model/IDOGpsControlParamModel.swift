//
//  IDOGpsControlParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Control GPS event number
@objcMembers
public class IDOGpsControlParamModel: NSObject, IDOBaseModel {
    /// 1: Control 
    /// 2: Query                                
    public var operate: Int
    /// 1: Enable log 
    /// 2: Disable log 
    /// 3: Write AGPS data 
    /// 4: Erase AGPS data 
    /// 5: Write GPS firmware 
    public var type: Int
    
    enum CodingKeys: String, CodingKey {
        case operate = "operate"
        case type = "type"
    }
    
    public init(operate: Int,type: Int) {
        self.operate = operate
        self.type = type
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

