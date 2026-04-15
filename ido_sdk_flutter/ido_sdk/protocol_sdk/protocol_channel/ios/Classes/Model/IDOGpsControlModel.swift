//
//  IDOGpsControlModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Control GPS event number
@objcMembers
public class IDOGpsControlModel: NSObject, IDOBaseModel {
    /// 1: Enable log 
    /// 2: Disable log 
    /// 3: Write AGPS data 
    /// 4: Erase AGPS data 
    /// 5: Write GPS firmware 
    public var type: Int
    /// 0: Invalid 
    /// 1: Command in progress 
    /// 2: Completed    
    public var status: Int
    /// 0 for success, non-zero for failure                            
    public var errorCode: Int
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case status = "status"
        case errorCode = "error_code"
    }
    
    public init(type: Int,status: Int,errorCode: Int) {
        self.type = type
        self.status = status
        self.errorCode = errorCode
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

