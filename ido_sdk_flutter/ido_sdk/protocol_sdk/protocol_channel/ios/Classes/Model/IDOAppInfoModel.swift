//
//  IDOAppInfoModel.swift
//  protocol_channel
//
//  Created by hc on 2025/3/17.
//

import Foundation

@objcMembers
public class IDOAppInfoModel: NSObject, IDOBaseModel {
    
    private var version: Int
    
    /// user name
    public var userName: String
    
    /// 1：发送
    public var operate: Int
    
    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case operate
        case version
    }
    
    public init(userName: String, operate: Int = 1) {
        self.userName = userName
        self.operate = operate
        self.version = 0
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

