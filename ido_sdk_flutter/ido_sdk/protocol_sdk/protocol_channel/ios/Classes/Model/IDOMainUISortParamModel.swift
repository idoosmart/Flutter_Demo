//
//  IDOMainUISortParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/19.
//

import Foundation

// MARK: - IDOMainUISortParamModel
@objcMembers
public class IDOMainUISortParamModel: NSObject, IDOBaseModel {
    private let version: Int
    /// Operation
    /// 0: Invalid 1: Query 2: Set
    public var operate: Int
    private let allNum: Int
    public var items: [Int]
    /// Coordinate x-axis, starting from 1
    public var locationX: Int
    /// Coordinate y-axis, starting from 1
    /// One y-axis represents a horizontal grid
    public var locationY: Int
    /// 0: Invalid 1: Large icon 2: Small icon
    public var sizeType: Int
    /// Types of controls
    /// 0: Invalid
    /// 1: Week/Date
    /// 2: Steps
    /// 3: Distance
    /// 4: Calories
    /// 5: Heart Rate
    /// 6: Battery
    public var widgetsType: Int
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case operate = "operate"
        case allNum = "all_num"
        case items = "items"
        case locationX = "location_x"
        case locationY = "location_y"
        case sizeType = "size_type"
        case widgetsType = "widgets_type"
    }
    
    public init(operate: Int, items: [Int], locationX: Int, locationY: Int, sizeType: Int, widgetsType: Int) {
        self.version = 0
        self.operate = operate
        self.allNum = items.count
        self.items = items
        self.locationX = locationX
        self.locationY = locationY
        self.sizeType = sizeType
        self.widgetsType = widgetsType
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}


// MARK: - IDOMainUISortModel
@objcMembers
public class IDOMainUISortModel: NSObject, IDOBaseModel {
    private let version: Int
    /// 0: Success, Non-zero: Failure
    public var errCode: Int
    /// Operation
    /// 0: Invalid 1: Query 2: Set
    public var operate: Int
    /// Number of currently displayed list in firmware
    public var allNum: Int
    public var supportItems: [IDOMainUISortSupportItem]
    public var items: [IDOMainUISortItem]
    public var locationX: Int
    public var locationY: Int
    public var sizeType: Int
    public var widgetsType: Int
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case errCode = "err_code"
        case operate = "operate"
        case allNum = "all_num"
        case supportItems = "support_items"
        case items = "items"
        case locationX = "location_x"
        case locationY = "location_y"
        case sizeType = "size_type"
        case widgetsType = "widgets_type"
    }
    
    public init(errCode: Int, operate: Int, allNum: Int, supportItems: [IDOMainUISortSupportItem], items: [IDOMainUISortItem], locationX: Int, locationY: Int, sizeType: Int, widgetsType: Int) {
        self.version = 0
        self.errCode = errCode
        self.operate = operate
        self.allNum = allNum
        self.supportItems = supportItems
        self.items = items
        self.locationX = locationX
        self.locationY = locationY
        self.sizeType = sizeType
        self.widgetsType = widgetsType
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOMainUISortItem
@objcMembers
public class IDOMainUISortItem: NSObject, Codable {
    /// Coordinate x-axis, starting from 1
    public var locationX: Int
    /// Coordinate y-axis, starting from 1
    /// One y-axis represents a horizontal grid
    public var locationY: Int
    /// 0: Invalid 1: Large icon 2: Small icon
    public var sizeType: Int
    /// Types of controls
    /// ```
    /// 0: Invalid
    /// 1: Week/Date
    /// 2: Steps
    /// 3: Distance
    /// 4: Calories
    /// 5: Heart Rate
    /// 6: Battery
    /// ```
    public var widgetsType: Int
    
    /// Editable icon types supported by the firmware
    /// ```
    /// 0: Invalid
    /// 1: Large icon
    /// 2: Small icon
    /// 3: Large icon + Small icon
    /// ```
    public var supportSizeType: Int
    
    enum CodingKeys: String, CodingKey {
        case locationX = "location_x"
        case locationY = "location_y"
        case sizeType = "size_type"
        case widgetsType = "widgets_type"
        case supportSizeType = "support_size_type"
    }
    
    public init(locationX: Int, locationY: Int, sizeType: Int, widgetsType: Int, supportSizeType: Int) {
        self.locationX = locationX
        self.locationY = locationY
        self.sizeType = sizeType
        self.widgetsType = widgetsType
        self.supportSizeType = supportSizeType
    }
}

// MARK: - IDOMainUISortSupportItem
@objcMembers
public class IDOMainUISortSupportItem: NSObject, Codable {
    /// Types of controls
    /// ```
    /// 0: Invalid
    /// 1: Week/Date
    /// 2: Steps
    /// 3: Distance
    /// 4: Calories
    /// 5: Heart Rate
    /// 6: Battery
    /// ```
    public var widgetsType: Int
    
    /// Editable icon types supported by the firmware
    /// ```
    /// 0: Invalid
    /// 1: Large icon
    /// 2: Small icon
    /// 3: Large icon + Small icon
    /// ```
    public var supportSizeType: Int
    
    enum CodingKeys: String, CodingKey {
        case supportSizeType = "support_size_type"
        case widgetsType = "widgets_type"
    }
    
    public init(supportSizeType: Int, widgetsType: Int) {
        self.supportSizeType = supportSizeType
        self.widgetsType = widgetsType
    }
}

