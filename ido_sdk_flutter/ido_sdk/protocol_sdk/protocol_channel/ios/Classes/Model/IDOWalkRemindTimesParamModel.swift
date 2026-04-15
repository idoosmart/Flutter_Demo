//
//  IDOWalkRemindTimesParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/18.
//

import Foundation

@objcMembers
public class IDOWalkRemindTimesParamModel: NSObject, IDOBaseModel {
    private let version: Int
    /// Switch: 1:On 0:Off
    public var onOff: Int
    private let num: Int
    public var items: [IDOWalkRemindTimesItem]

    enum CodingKeys: String, CodingKey {
        case version
        case onOff = "on_off"
        case num
        case items
    }

    public init(onOff: Int, items: [IDOWalkRemindTimesItem]) {
        self.version = 0
        self.onOff = onOff
        self.num = items.count
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

// MARK: - IDOWalkRemindTimesItem
@objcMembers
public class IDOWalkRemindTimesItem: NSObject, Codable {
    /// Walk reminder time: Hour
    public var hour: Int
    /// Walk reminder time: Minute
    public var min: Int

    enum CodingKeys: String, CodingKey {
        case hour
        case min
    }

    public init(hour: Int, min: Int) {
        self.hour = hour
        self.min = min
    }
}
