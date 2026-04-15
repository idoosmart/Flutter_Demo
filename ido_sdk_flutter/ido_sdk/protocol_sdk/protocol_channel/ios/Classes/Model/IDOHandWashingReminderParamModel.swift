//
//  IDOHandWashingReminderParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Set Hand Washing Reminder Event
public class IDOHandWashingReminderParamModel: NSObject, IDOBaseModel {
    /// 0: Off
    /// 1: On
    /// Default is off
    public var onOff: Int
    /// Start hour of the reminder
    public var startHour: Int
    /// Start minute of the reminder
    public var startMinute: Int
    /// End hour of the reminder
    public var endHour: Int
    /// End minute of the reminder
    public var endMinute: Int
    /// Repeat
    public var repeats: Set<IDOWeek>
    /// Reminder interval in minutes
    /// Default is 60 minutes
    public var interval: Int

    enum CodingKeys: String, CodingKey {
        case onOff = "on_off"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case repeats = "repeat"
        case interval = "interval"
    }

    public init(onOff: Int, startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, repeats: Set<IDOWeek>, interval: Int) {
        self.onOff = onOff
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.repeats = repeats
        self.interval = interval
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        onOff = try container.decode(Int.self, forKey: .onOff)
        startHour = try container.decode(Int.self, forKey: .startHour)
        startMinute = try container.decode(Int.self, forKey: .startMinute)
        endHour = try container.decode(Int.self, forKey: .endHour)
        endMinute = try container.decode(Int.self, forKey: .endMinute)
        interval = try container.decode(Int.self, forKey: .interval)

        if let value = try container.decodeIfPresent(Int.self, forKey: .repeats) {
            var items = Set<IDOWeek>()
            for i in 0...6 {
                if value & (1 << (i + 1)) != 0 {
                    items.insert(IDOWeek(rawValue: i)!)
                }
            }
            repeats = items
        } else {
            repeats = Set<IDOWeek>()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(onOff, forKey: .onOff)
        try container.encode(startHour, forKey: .startHour)
        try container.encode(startMinute, forKey: .startMinute)
        try container.encode(endHour, forKey: .endHour)
        try container.encode(endMinute, forKey: .endMinute)
        try container.encode(interval, forKey: .interval)

        var value = 0
        for item in repeats {
            value |= (1 << (item.rawValue + 1))
        }
        try container.encode(value, forKey: .repeats)
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

/// Set Hand Washing Reminder Event
@objcMembers
public class IDOHandWashingReminderParamModelObjc: NSObject, IDOBaseModel {
    /// 0: Off
    /// 1: On
    /// Default is off
    public var onOff: Int
    /// Start hour of the reminder
    public var startHour: Int
    /// Start minute of the reminder
    public var startMinute: Int
    /// End hour of the reminder
    public var endHour: Int
    /// End minute of the reminder
    public var endMinute: Int
    /// Repeat
    public var repeats: [IDOWeekObjc]
    /// Reminder interval in minutes
    /// Default is 60 minutes
    public var interval: Int

    enum CodingKeys: String, CodingKey {
        case onOff = "on_off"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case repeats = "repeat"
        case interval = "interval"
    }

    public init(onOff: Int, startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, repeats: [IDOWeekObjc], interval: Int) {
        self.onOff = onOff
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.repeats = repeats
        self.interval = interval
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        onOff = try container.decode(Int.self, forKey: .onOff)
        startHour = try container.decode(Int.self, forKey: .startHour)
        startMinute = try container.decode(Int.self, forKey: .startMinute)
        endHour = try container.decode(Int.self, forKey: .endHour)
        endMinute = try container.decode(Int.self, forKey: .endMinute)
        interval = try container.decode(Int.self, forKey: .interval)

        if let value = try container.decodeIfPresent(Int.self, forKey: .repeats) {
            var items = [IDOWeekObjc]()
            for i in 0...6 {
                if ((value >> i) & 1) > 0 {
                    items.append(IDOWeekObjc(week: IDOWeek(rawValue: i)!))
                }
            }
            repeats = items
        } else {
            repeats = [IDOWeekObjc]()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(onOff, forKey: .onOff)
        try container.encode(startHour, forKey: .startHour)
        try container.encode(startMinute, forKey: .startMinute)
        try container.encode(endHour, forKey: .endHour)
        try container.encode(endMinute, forKey: .endMinute)
        try container.encode(interval, forKey: .interval)

        var value = 0
        for item in repeats {
            value |= (1 << (item.week.rawValue + 1))
        }
        try container.encode(value, forKey: .repeats)
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
