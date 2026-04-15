//
//  IDOMenuListModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/19.
//

import Foundation

@objcMembers
public class IDOMenuListModel: NSObject, IDOBaseModel {
    public var currentShowNum: Int
    public var items: [IDOMenuItem]?
    public var maxNum: Int
    public var maxShowNum: Int
    public var minShowNum: Int

    enum CodingKeys: String, CodingKey {
        case currentShowNum = "current_show_num"
        case items = "items"
        case maxNum = "max_num"
        case maxShowNum = "max_show_num"
        case minShowNum = "min_show_num"
    }

    public init(currentShowNum: Int, items: [IDOMenuItem]? = nil, maxNum: Int, maxShowNum: Int, minShowNum: Int) {
        self.currentShowNum = currentShowNum
        self.items = items
        self.maxNum = maxNum
        self.maxShowNum = maxShowNum
        self.minShowNum = minShowNum
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOMenuItem
@objcMembers
public class IDOMenuItem: NSObject, Codable {
    public var index: Int
    public var value: Int

    enum CodingKeys: String, CodingKey {
        case index = "index"
        case value = "value"
    }

    public init(index: Int, value: Int) {
        self.index = index
        self.value = value
    }
}
