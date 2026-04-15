//
//  IDOAlgFileModel.swift
//  protocol_channel
//
//  Created by hc on 2024/8/8.
//


import Foundation

// MARK: - IDOAlgFileModel
@objcMembers public class IDOAlgFileModel: NSObject, IDOBaseModel {
    public var errorCode: Int
    public var items: [IDOAlgFileItem]?
    private var itemsNum: Int
    /// 操作类型 0:无效 1:查 2:请求传输
    public var operate: Int
    private var version: Int = 0
    
    public enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case items = "items"
        case itemsNum = "items_num"
        case operate = "operate"
        case version = "version"
    }
    
    public init(errorCode: Int, items: [IDOAlgFileItem]?, operate: Int) {
        self.errorCode = errorCode
        self.items = items
        self.itemsNum = items?.count ?? 0
        self.operate = operate
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
@objcMembers public class IDOAlgFileItem: NSObject, IDOBaseModel {
    /// 已完成数量
    public var quantityComplete: Int
    /// 总数量
    public var totalQuantity: Int
    /// 0:无效、1:ACC文件、2:GPS文件
    public var type: Int
    
    public enum CodingKeys: String, CodingKey {
        case quantityComplete = "quantity_complete"
        case totalQuantity = "total_quantity"
        case type = "type"
    }
    
    public init(quantityComplete: Int, totalQuantity: Int, type: Int) {
        self.quantityComplete = quantityComplete
        self.totalQuantity = totalQuantity
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

