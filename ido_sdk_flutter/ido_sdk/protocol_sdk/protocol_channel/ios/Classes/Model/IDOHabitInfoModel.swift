//
//  IDOHabitInfoModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/19.
//

import Foundation

@objcMembers
public class IDOHabitInfoModel: NSObject, IDOBaseModel {
    public var browseCount: Int
    public var implementCount: Int
    public var broItems: [IDOHabitBroItem]
    public var impItems: [IDOHabitImpItem]

    enum CodingKeys: String, CodingKey {
        case browseCount = "browse_count"
        case implementCount = "implement_count"
        case broItems = "bro_items"
        case impItems = "imp_items"
    }

    public init(browseCount: Int, implementCount: Int, broItems: [IDOHabitBroItem], impItems: [IDOHabitImpItem]) {
        self.browseCount = browseCount
        self.implementCount = implementCount
        self.broItems = broItems
        self.impItems = impItems
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOBroItem
@objcMembers
public class IDOHabitBroItem: NSObject, Codable {
    public var type: Int
    public var evt: Int
    public var year: Int
    public var month: Int
    public var day: Int
    public var hour: Int
    public var min: Int
    public var sec: Int
    public var count: Int

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case evt = "evt"
        case year = "year"
        case month = "month"
        case day = "day"
        case hour = "hour"
        case min = "min"
        case sec = "sec"
        case count = "count"
    }

    public init(type: Int, evt: Int, year: Int, month: Int, day: Int, hour: Int, min: Int, sec: Int, count: Int) {
        self.type = type
        self.evt = evt
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.min = min
        self.sec = sec
        self.count = count
    }
}

// MARK: - IDOImpItem
@objcMembers
public class IDOHabitImpItem: NSObject, Codable {
    public var type: Int
    public var evt: Int
    public var startYear: Int
    public var startMonth: Int
    public var startDay: Int
    public var startHour: Int
    public var startMin: Int
    public var startSEC: Int
    public var endYear: Int
    public var endMonth: Int
    public var endDay: Int
    public var endHour: Int
    public var endMin: Int
    public var endSEC: Int
    public var completionRate: Int

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case evt = "evt"
        case startYear = "start_year"
        case startMonth = "start_month"
        case startDay = "start_day"
        case startHour = "start_hour"
        case startMin = "start_min"
        case startSEC = "start_sec"
        case endYear = "end_year"
        case endMonth = "end_month"
        case endDay = "end_day"
        case endHour = "end_hour"
        case endMin = "end_min"
        case endSEC = "end_sec"
        case completionRate = "completion_rate"
    }

    public init(type: Int, evt: Int, startYear: Int, startMonth: Int, startDay: Int, startHour: Int, startMin: Int, startSEC: Int, endYear: Int, endMonth: Int, endDay: Int, endHour: Int, endMin: Int, endSEC: Int, completionRate: Int) {
        self.type = type
        self.evt = evt
        self.startYear = startYear
        self.startMonth = startMonth
        self.startDay = startDay
        self.startHour = startHour
        self.startMin = startMin
        self.startSEC = startSEC
        self.endYear = endYear
        self.endMonth = endMonth
        self.endDay = endDay
        self.endHour = endHour
        self.endMin = endMin
        self.endSEC = endSEC
        self.completionRate = completionRate
    }
}
