//
//  IDODefaultMessageConfigModel.swift
//  protocol_channel
//
//  Created by hc on 2024/05/21.
//

import Foundation


@objcMembers
public class IDODefaultMessageConfigParamModel: NSObject, IDOBaseModel {
    /// 操作类型 0:无效 1:设置 2:查询
    public var operate: Int
    private var itemsNum: Int
    /// 包列表
    /// ```
    /// 包名详情个数 最多设置50个详情
    /// operate = 1 时有效
    /// ```
    public var items: [IDODefaultMessageItem]?
    
    public enum CodingKeys: String, CodingKey {
        case operate = "operate"
        case itemsNum = "items_num"
        case items = "items"
    }
    
    public init(operate: Int, items: [IDODefaultMessageItem]? = nil) {
        self.operate = operate
        self.itemsNum = (items ?? []).count
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


@objcMembers
public class IDODefaultMessageConfigModel: NSObject, IDOBaseModel {
    /// 操作类型 0:无效 1:设置 2:查询
    public var operate: Int
    /// 错误码 0:成功 非0失败
    public var errorCode: Int
    /// 支持总items的个数 默认最多50个 操作查询有效
    public var supportMaxAllItemsNum: Int?
    /// 支持每个详情的包名长度 默认50个字节 操作查询有效
    public var supportMaxPackNameLen: Int?
    public var items: [IDODefaultMessageItem]?
    
    public enum CodingKeys: String, CodingKey {
        case operate = "operate"
        case errorCode = "error_code"
        case supportMaxAllItemsNum = "support_max_all_items_num"
        case supportMaxPackNameLen = "support_max_pack_name_len"
        case items = "items"
    }
    
    public init(operate: Int, errorCode: Int, supportMaxAllItemsNum: Int? = nil, supportMaxPackNameLen: Int? = nil, items: [IDODefaultMessageItem]? = nil) {
        self.operate = operate
        self.errorCode = errorCode
        self.supportMaxAllItemsNum = supportMaxAllItemsNum
        self.supportMaxPackNameLen = supportMaxPackNameLen
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

// MARK: - IDODefaultMessageItem
@objcMembers public class IDODefaultMessageItem: NSObject, Codable {
    /// 包名
    public var packageName: String
    
    public enum CodingKeys: String, CodingKey {
        case packageName = "pack_name"
    }
    
    public init(packageName: String) {
        self.packageName = packageName
    }
}
