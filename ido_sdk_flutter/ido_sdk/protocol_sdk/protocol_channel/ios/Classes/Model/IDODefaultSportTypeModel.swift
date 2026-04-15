//
//  IDODefaultSportTypeModel.swift
//  protocol_channel
//
//  Created by hc on 2024/1/24.
//

import Foundation

// MARK: - IDODefaultSportTypeModel
@objcMembers
public class IDODefaultSportTypeModel: NSObject, IDOBaseModel {
    /// 默认显示的数量
    public var defaultShowNum: Int
    /// 最小支持的数量
    public var minShowNum: Int
    /// 最大支持的数量
    public var maxShowNum: Int
    // 0 不支持 ，1 支持
    /// 是否支持默认排序
    public var isSupportsSort: Bool
    /// 运动类型列表集合 type的集合
    //public var sportTypes: [IDOSportTypeItem]
    // 使用 NSArray<NSNumber*> *  兼容 OC
    private dynamic var sportTypeRawValues: [NSNumber] = []
    
    // Swift 中使用的枚举数组，通过计算属性桥接
    public var sportTypes: [IDOSportType] {
        get {
            return sportTypeRawValues.compactMap { IDOSportType(rawValue: $0.intValue) }
        }
        set {
            sportTypeRawValues = newValue.map { NSNumber(value: $0.rawValue) }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case defaultShowNum = "default_show_num"
        case minShowNum = "min_show_num"
        case maxShowNum = "max_show_num"
        case isSupportsSort = "is_supports_sort"
        case sportTypes = "sport_type"
    }
    
    public init(defaultShowNum: Int, minShowNum: Int, maxShowNum: Int, isSupportsSort: Bool, sportTypes: [IDOSportType]) {
        self.defaultShowNum = defaultShowNum
        self.minShowNum = minShowNum
        self.maxShowNum = maxShowNum
        self.isSupportsSort = isSupportsSort
        sportTypeRawValues = sportTypes.map { NSNumber(value: $0.rawValue) }
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        defaultShowNum = try container.decode(Int.self, forKey: .defaultShowNum)
        minShowNum = try container.decode(Int.self, forKey: .minShowNum)
        maxShowNum = try container.decode(Int.self, forKey: .maxShowNum)
        isSupportsSort = try container.decode(Int.self, forKey: .isSupportsSort) == 1 ? true : false
        
        let sportTypeIntArray = try container.decodeIfPresent([Int].self, forKey: .sportTypes) ?? []
        sportTypeRawValues = sportTypeIntArray.map{ NSNumber(value: $0) }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(defaultShowNum, forKey: .defaultShowNum)
        try container.encode(isSupportsSort ? 1 : 0, forKey: .isSupportsSort)
        try container.encode(maxShowNum, forKey: .maxShowNum)
        try container.encode(minShowNum, forKey: .minShowNum)
        
        let sportTypeIntArray = sportTypes.map { $0.rawValue }
        try container.encode(sportTypeIntArray, forKey: .sportTypes)
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}


