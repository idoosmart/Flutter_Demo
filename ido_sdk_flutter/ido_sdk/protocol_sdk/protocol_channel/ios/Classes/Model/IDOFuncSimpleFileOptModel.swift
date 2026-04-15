//
//  IDOFuncSimpleFileOptModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Simple file operations event
@objcMembers
public class IDOFuncSimpleFileOptModel: NSObject, IDOBaseModel {
    /// Error code
    /// 0 for success, others for errors 
    public var error: Int
    /// Operation type
    /// 0: Get
    /// 1: Overwrite
    /// 2: Delete 
    public var operate: Int
    /// Index number                           
    public var index: Int
    
    enum CodingKeys: String, CodingKey {
        case error = "error"
        case operate = "operate"
        case index = "index"
    }
    
    public init(error: Int,operate: Int,index: Int) {
        self.error = error
        self.operate = operate
        self.index = index
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

