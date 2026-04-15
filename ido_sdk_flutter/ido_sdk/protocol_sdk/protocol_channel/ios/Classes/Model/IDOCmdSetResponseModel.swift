//
//  IDOCmdSetResponseModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation

@objcMembers
public class IDOCmdSetResponseModel: NSObject, IDOBaseModel {
    /// 0: Success， other: Failed
    public var isSuccess: Int
    
    enum CodingKeys: String, CodingKey {
        case isSuccess = "is_success"
    }
    
    public init(isSuccess: Int) {
        self.isSuccess = isSuccess
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
