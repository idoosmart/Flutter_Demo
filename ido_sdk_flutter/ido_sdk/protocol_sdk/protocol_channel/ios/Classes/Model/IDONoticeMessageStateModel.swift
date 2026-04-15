//
//  IDONoticeMessageStateModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/19.
//

import Foundation

@objcMembers
public class IDONoticeMessageStateModel: NSObject, IDOBaseModel {
    private let version: Int
    /// Error code: 0 for success, non-zero for failure
    public var errCode: Int
    /// Operation
    /// 1: Add
    /// 2: Modify
    /// 3: Get and Query
    public var operat: Int
    /// Valid for querying
    /// Reply with overall notification switch status
    /// 1: Enable all notifications,
    /// 0: Disable all notifications
    /// -1:Invalid
    public var allOnOff: Int
    private let itemsNum: Int
    /// Message details content, valid for querying
    public var items: [IDONoticeMessageStateItem]?
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case errCode = "err_code"
        case operat = "operat"
        case allOnOff = "all_on_off"
        case itemsNum = "items_num"
        case items = "items"
    }
    
    public init(errCode: Int, operat: Int, allOnOff: Int, items: [IDONoticeMessageStateItem]) {
        self.version = 0
        self.errCode = errCode
        self.operat = operat
        self.allOnOff = allOnOff
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
