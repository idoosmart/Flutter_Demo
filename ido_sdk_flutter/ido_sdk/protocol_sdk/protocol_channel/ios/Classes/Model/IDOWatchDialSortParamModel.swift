//
//  IDOWatchDialSortParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/18.
//

import Foundation

@objcMembers
public class IDOWatchDialSortParamModel: NSObject, IDOBaseModel {
    /// Number of items in the watch dial sort list
    public var sortItemNumb: Int
    /// Array of watch dial sort items type, sort_number, and name
    public var pSortItem: [IDOWatchDialSortItem]

    enum CodingKeys: String, CodingKey {
        case sortItemNumb = "sort_item_numb"
        case pSortItem = "p_sort_item"
    }

    public init(sortItemNumb: Int, pSortItem: [IDOWatchDialSortItem]) {
        self.sortItemNumb = sortItemNumb
        self.pSortItem = pSortItem
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOWatchDialSortItem
@objcMembers
public class IDOWatchDialSortItem: NSObject, Codable {
    /// Watch dial type 1: Normal Dial, 2: Wallpaper Dial, 3: Cloud Dial
    public var type: Int
    /// Serial number, starting from 0, not exceeding the total number of supported watch dials
    public var sortNumber: Int
    /// Watch dial ID, maximum 29 bytes
    public var name: String

    enum CodingKeys: String, CodingKey {
        case type
        case sortNumber = "sort_number"
        case name
    }

    public init(type: Int, sortNumber: Int, name: String) {
        self.type = type
        self.sortNumber = sortNumber
        self.name = name
    }
}
