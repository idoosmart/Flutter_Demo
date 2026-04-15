//
//  IDOCmdGetResponseModel.swift
//  protocol_channel
//
//  Created by hc on 2023/11/3.
//

import Foundation

@objcMembers
public class IDOCmdGetResponseModel: NSObject, IDOBaseModel {
    /// Switch status
    /// 1: On
    /// 0: Off
    /// -1:Not Support
    public var onOff: Int
    
    enum CodingKeys: String, CodingKey {
        case onOff = "on_off"
    }
    
    public init(onOff: Int) {
        self.onOff = onOff
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
