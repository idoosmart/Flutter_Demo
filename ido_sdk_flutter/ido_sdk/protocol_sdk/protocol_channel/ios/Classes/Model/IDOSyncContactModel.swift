//
//  IDOSyncContactModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/19.
//

import Foundation

// MARK: - IDOSyncContactParamModel
@objcMembers
public class IDOSyncContactParamModel: NSObject, IDOBaseModel {
    private let version: Int
    /// Operation
    /// 0: invalid
    /// 1: set contacts
    /// 2: query contacts
    /// 3: set emergency contacts (requires support for `getSupportSetGetEmergencyContactV3` in the menu)
    /// 4: query emergency contacts (requires support for `getSupportSetGetEmergencyContactV3` in the menu)
    public var operat: Int
    private let itemsNum: Int
    public var items: [IDOContactItem]
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case operat = "operat"
        case itemsNum = "items_num"
        case items = "items"
    }
    
    public init(operat: Int, items: [IDOContactItem]) {
        self.version = 0
        self.operat = operat
        self.itemsNum = items.count
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

// MARK: - IDOSyncContactModel
@objcMembers
public class IDOSyncContactModel: NSObject, IDOBaseModel {
    private let version: Int
    /// Error code, 0 for success, non-zero for error code
    public var errCode: Int
    /// Operation
    /// 0: invalid
    /// 1: set
    /// 2: query
    /// 3: set emergency contacts (requires support for `getSupportSetGetEmergencyContactV3` in the menu)
    /// 4: query emergency contacts (requires support for `getSupportSetGetEmergencyContactV3` in the menu)
    public var operat: Int
    private var itemsNum: Int? = 0
    public var items: [IDOContactItem]?
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case errCode = "err_code"
        case operat = "operat"
        case itemsNum = "items_num"
        case items = "items"
    }
    
    public init(errCode: Int, operat: Int, items: [IDOContactItem]?) {
        self.version = 0
        self.errCode = errCode
        self.operat = operat
        self.itemsNum = items?.count ?? 0
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

// MARK: - IDOContactItem
@objcMembers
public class IDOContactItem: NSObject, Codable {
    /// Contact phone number content, maximum of 14 bytes + '\0' line break
    public var phone: String
    /// Contact name content, maximum of 31 bytes + '\0' line break
    public var name: String
    
    enum CodingKeys: String, CodingKey {
        case phone = "phone"
        case name = "name"
    }
    
    public init(phone: String, name: String) {
        self.phone = phone
        self.name = name
    }
}
