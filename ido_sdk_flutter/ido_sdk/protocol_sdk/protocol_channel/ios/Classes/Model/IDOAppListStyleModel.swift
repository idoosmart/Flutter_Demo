//
//  IDOAppListStyleModel.swift
//  protocol_channel
//
//  Created by hc on 2025/12/04.
//

import Foundation

// MARK: - Application List Style Param Model (App sends to device)

/// Application list style parameter model
@objcMembers
public class IDOAppListStyleParamModel: NSObject, IDOBaseModel {
    /// Protocol version number
    private var version: Int
    
    /// Operation type: 1:Set 2:Query 3:Delete
    public var operate: Int
    
    /// Font color
    public var fontColor: Int
    
    /// Wallpaper name
    public var name: String
    
    /// Wallpaper version
    public var wallpaperVersion: Int
    
    /// Reserved data (6 bytes)
    private var data: [Int]
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case operate = "operate"
        case fontColor = "font_color"
        case name = "name"
        case wallpaperVersion = "wallpaper_version"
        case data = "data"
    }
    
    public init(operate: Int, fontColor: Int = 0, name: String = "", wallpaperVersion: Int = 0) {
        self.version = 0
        self.operate = operate
        self.fontColor = fontColor
        self.name = name
        self.wallpaperVersion = wallpaperVersion
        self.data = []
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - Application List Item

/// Application list wallpaper item
public class IDOApplicationListItem: NSObject, Codable {
    /// Application list wallpaper sort number, starting from 0
    public var sortNumber: Int
    
    /// Font color
    public var fontColor: Int
    
    /// Current application list wallpaper space usage, unit: byte
    public var size: Int
    
    /// Wallpaper name
    public var name: String
    
    /// Wallpaper version
    public var wallpaperVersion: Int
    
    /// Reserved data (5 bytes)
    private var data: [Int] = []
    
    enum CodingKeys: String, CodingKey {
        case sortNumber = "sort_number"
        case fontColor = "font_color"
        case size = "size"
        case name = "name"
        case wallpaperVersion = "wallpaper_version"
        case data = "data"
    }
    
    public init(sortNumber: Int, fontColor: Int, size: Int, name: String, wallpaperVersion: Int) {
        self.sortNumber = sortNumber
        self.fontColor = fontColor
        self.size = size
        self.name = name
        self.wallpaperVersion = wallpaperVersion
        self.data = []
    }
}

// MARK: - Application List Style Reply Model (BLE device replies to app)

/// Application list style reply model
@objcMembers
public class IDOAppListStyleReplyModel: NSObject, IDOBaseModel {
    /// Protocol version number
    private var version: Int
    
    /// Operation type: 1:Set 2:Query 3:Delete
    public var operate: Int
    
    /// Error code: 0:Success 1:Failure
    public var errorCode: Int
    
    /// Total number of application list wallpapers
    public var applicationListTotalNum: Int
    
    /// Number of application list wallpapers already used, max 20
    public var userApplicationListItemNum: Int
    
    /// Total capacity of application list wallpapers, unit: Byte
    public var applicationListCapacitySize: Int
    
    /// Used capacity of application list wallpapers, unit: Byte
    public var userApplicationListCapacitySize: Int
    
    /// Application list wallpaper items, controlled by used count, valid for query operation
    public var listItems: [IDOApplicationListItem]?
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case operate = "operate"
        case errorCode = "error_code"
        case applicationListTotalNum = "application_list_total_num"
        case userApplicationListItemNum = "user_application_list_item_num"
        case applicationListCapacitySize = "application_list_capacity_size"
        case userApplicationListCapacitySize = "user_application_list_capacity_size"
        case listItems = "list_items"
    }
    
    public init(operate: Int, errorCode: Int, applicationListTotalNum: Int = 0, userApplicationListItemNum: Int = 0, applicationListCapacitySize: Int = 0, userApplicationListCapacitySize: Int = 0, listItems: [IDOApplicationListItem]? = nil) {
        self.version = 4
        self.operate = operate
        self.errorCode = errorCode
        self.applicationListTotalNum = applicationListTotalNum
        self.userApplicationListItemNum = userApplicationListItemNum
        self.applicationListCapacitySize = applicationListCapacitySize
        self.userApplicationListCapacitySize = userApplicationListCapacitySize
        self.listItems = listItems
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
