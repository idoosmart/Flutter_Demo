//
//  IDOBikeLockModel.swift
//  protocol_channel
//
//  Created by hc on 2025/12/24.
//

import Foundation

// MARK: - IDOBikeLockModel

// 车锁管理
@objcMembers
internal class IDOBikeLockModel: NSObject, IDOBaseModel {
    
    private var version: Int = 0
    
    /// 操作类型 1:设置 2:查询
    public var operate: Int
    
    /// 车锁总item个数，最大10 个，operate=1设置有效
    private var itemNum: Int
    
    // 预留字节
    // private var data: [Int]
    
    /// 车锁信息，operate=1设置有效
    public var items: [IDOBikeLockInfo]?
    
    public init(operate: Int, items: [IDOBikeLockInfo]? = nil) {
        self.operate = operate
        self.items = items
        self.itemNum = items?.count ?? 0
    }
    
    public enum CodingKeys: String, CodingKey {
        case version
        case operate
        case itemNum = "all_items_num"
        case items
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
}

// MARK: - IDOBikeLockInfo

@objcMembers
public class IDOBikeLockInfo: NSObject, IDOBaseModel {
    
    /// 车锁的mac地址,按照大端排序 mac0 mac1 mac2 mac3 mac4 mac5
    public var mac: [Int]
    
    /// 车锁与手表交互需要的密钥
    public var secret: String
    
    /// 车锁名称
    public var name: String?
    
    // 预留
    // private var data: [Int]

    /// mac的字符串形式，形如：AA:BB:CC:DD:EE:FF
    public var macStr: String {
        return mac.map { String(format: "%02X", $0) }.joined(separator: ":")
    }
    
    public init(mac: [Int], secret: String, name: String? = nil) {
        self.mac = mac
        self.secret = secret
        self.name = name
    }
    
    public enum CodingKeys: String, CodingKey {
        case mac
        case secret
        case name
    }
}

// MARK: - IDOBikeLockReplyModel

@objcMembers
public class IDOBikeLockReplyModel: NSObject, IDOBaseModel {
    
    private var version: Int = 0
    
    /// 操作类型 1:设置 2:查询
    public var operate: Int
    
    /// 错误码 0:成功 1:失败
    public var errorCode: Int
    
    /// 车锁总item个数，最大10 个，operate=2查询有效
    private var itemNum: Int
    
    /// 车锁信息，operate=2查询有效
    public var items: [IDOBikeLockInfo]?
    
    public init(operate: Int, errorCode: Int, items: [IDOBikeLockInfo]? = nil) {
        self.operate = operate
        self.errorCode = errorCode
        self.items = items
        self.itemNum = items?.count ?? 0
    }
    
    public enum CodingKeys: String, CodingKey {
        case version
        case operate
        case errorCode = "error_code"
        case itemNum = "all_items_num"
        case items
    }
}
