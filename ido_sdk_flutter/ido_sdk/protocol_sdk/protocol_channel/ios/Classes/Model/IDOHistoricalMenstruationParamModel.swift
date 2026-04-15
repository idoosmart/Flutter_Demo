//
//  IDOHistoricalMenstruationParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation

@objcMembers
public class IDOHistoricalMenstruationParamModel: NSObject, IDOBaseModel {
    private let version: Int
    /// Average length of menstrual cycle Uint:day
    public var avgMenstrualDay: Int
    /// Average length of menstrual cycle Uint:day
    public var avgCycleDay: Int
    private let itemsLen: Int
    public var items: [IDOHistoricalMenstruationParamItem]

    enum CodingKeys: String, CodingKey {
        case version
        case avgMenstrualDay = "avg_menstrual_day"
        case avgCycleDay = "avg_cycle_day"
        case itemsLen = "items_len"
        case items
    }

    public init(avgMenstrualDay: Int, avgCycleDay: Int, items: [IDOHistoricalMenstruationParamItem]) {
        self.version = 0
        self.avgMenstrualDay = avgMenstrualDay
        self.avgCycleDay = avgCycleDay
        self.itemsLen = items.count
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

// MARK: - IDOHistoricalMenstruationParamItem
@objcMembers
public class IDOHistoricalMenstruationParamItem: NSObject, Codable {
    public var year: Int
    public var mon: Int
    public var day: Int
    /// Length of menstrual cycle (days)
    public var menstrualDay: Int
    public var cycleDay: Int
    /// The interval from the start of the next menstrual period to the ovulation day is usually 14 days when the Function
    public var ovulationIntervalDay: Int
    /// The number of days of fertility before the ovulation day is usually 5 when the Function
    public var ovulationBeforeDay: Int
    /// The number of days of fertility after the ovulation day is usually 5 when the Function
    public var ovulationAfterDay: Int

    enum CodingKeys: String, CodingKey {
        case year
        case mon
        case day
        case menstrualDay
        case cycleDay
        case ovulationIntervalDay
        case ovulationBeforeDay
        case ovulationAfterDay
    }

    public init(year: Int, mon: Int, day: Int, menstrualDay: Int, cycleDay: Int, ovulationIntervalDay: Int, ovulationBeforeDay: Int, ovulationAfterDay: Int) {
        self.year = year
        self.mon = mon
        self.day = day
        self.menstrualDay = menstrualDay
        self.cycleDay = cycleDay
        self.ovulationIntervalDay = ovulationIntervalDay
        self.ovulationBeforeDay = ovulationBeforeDay
        self.ovulationAfterDay = ovulationAfterDay
    }
}

