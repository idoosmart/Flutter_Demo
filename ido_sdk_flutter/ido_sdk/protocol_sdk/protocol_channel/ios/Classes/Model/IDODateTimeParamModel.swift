//
//  IDODateTimeParamModel.swift
//  alexa_channel
//
//  Created by hc on 2023/10/11.
//

import Foundation

/// 设置时间
@objcMembers
public class IDODateTimeParamModel: NSObject, IDOBaseModel {
    
    public var year, monuth, day, hour: Int
    public var minute, second: Int
    /// Week: 0-6 for Monday to Sunday
    public var week: Int
    /// Timezone in a 24-hour format: 0-12 for East ,13-24 for West
    public var timeZone: Int

    enum CodingKeys: String, CodingKey {
        case year, monuth, day, hour, minute, second, week
        case timeZone = "time_zone"
    }

    public init(year: Int, monuth: Int, day: Int, hour: Int, minute: Int, second: Int, week: Int, timeZone: Int) {
        self.year = year
        self.monuth = monuth
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
        self.week = week
        self.timeZone = timeZone
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
    
}
