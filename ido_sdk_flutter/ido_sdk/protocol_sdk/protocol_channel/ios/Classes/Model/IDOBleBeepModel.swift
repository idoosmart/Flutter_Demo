//
//  IDOBleBeepModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/19.
//

import Foundation

// MARK: - IDOBleBeepModel
@objcMembers
public class IDOBleBeepModel: NSObject, IDOBaseModel {
    private let version: Int
    /// Error code, 0 for success, non-zero for failure
    public var errCode: Int
    private let itemCount: Int
    public var items: [IDOBleBeepItem]?
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case errCode = "err_code"
        case itemCount = "item_count"
        case items = "item"
    }
    
    public init(errCode: Int, items: [IDOBleBeepItem]) {
        self.version = 0
        self.errCode = errCode
        self.itemCount = items.count
        self.items = items
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOItem
@objcMembers
public class IDOBleBeepItem: NSObject, Codable {
    public var name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
    
    public init(name: String) {
        self.name = name
    }
}
