//
//  IDOAlarmModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/19.
//

import Foundation

public class IDOAlarmModel: NSObject, IDOBaseModel {
    public var items: [IDOAlarmItem]
    private let num: Int
    private let version: Int

    enum CodingKeys: String, CodingKey {
        case items = "item"
        case num
        case version
    }

    public init(items: [IDOAlarmItem]) {
        self.items = items
        self.num = items.count
        self.version = 0
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOItem

public class IDOAlarmItem: NSObject, Codable {
    /// Alarm ID, starting from 1, 1~maximum supported number of alarms
    public var alarmID: Int
    /// Delay in minutes
    public var delayMin: Int
    public var hour: Int
    public var minute: Int
    /// Alarm name, maximum 23 bytes
    public var name: String
    /// Repeat
    public var repeats = Set<IDOWeek>()
    /// on/off
    public var isOpen: Bool
    /// Number of repeated alarms
    /// Number of times the alarm is repeated, delay switch, set to 0 to turn off, set to a number to repeat that many times
    public var repeatTimes: Int
    public var shockOnOff: Int
    /// 0: Hidden (deleted) 1: Displayed -1:Invailed
    public var status: IDOAlarmStatus
    public var tsnoozeDuration: Int
    /// Alarm type
    public var type: IDOAlarmType

    enum CodingKeys: String, CodingKey {
        case alarmID = "alarm_id"
        case delayMin = "delay_min"
        case hour
        case minute
        case name
        case repeats = "repeat"
        case repeatTimes = "repeat_times"
        case shockOnOff = "shock_on_off"
        case status
        case tsnoozeDuration = "tsnooze_duration"
        case type
    }

    public init(alarmID: Int, delayMin: Int, hour: Int, minute: Int, name: String, repeats: Set<IDOWeek>, isOpen: Bool, repeatTimes: Int, shockOnOff: Int, status: IDOAlarmStatus, tsnoozeDuration: Int, type: IDOAlarmType) {
        self.alarmID = alarmID
        self.delayMin = delayMin
        self.hour = hour
        self.minute = minute
        self.name = name
        self.repeats = repeats
        self.repeatTimes = repeatTimes
        self.shockOnOff = shockOnOff
        self.status = status
        self.tsnoozeDuration = tsnoozeDuration
        self.type = type
        self.isOpen = isOpen
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        alarmID = try container.decode(Int.self, forKey: .alarmID)
        delayMin = try container.decode(Int.self, forKey: .delayMin)
        hour = try container.decode(Int.self, forKey: .hour)
        minute = try container.decode(Int.self, forKey: .minute)
        name = try container.decode(String.self, forKey: .name)
        shockOnOff = try container.decode(Int.self, forKey: .shockOnOff)
        repeatTimes = try container.decode(Int.self, forKey: .repeatTimes)
        tsnoozeDuration = try container.decode(Int.self, forKey: .tsnoozeDuration)

        if let value = try container.decodeIfPresent(Int.self, forKey: .type) {
            type = IDOAlarmType(rawValue: value) ?? .other
        } else {
            type = .other
        }
        if let value = try container.decodeIfPresent(Int.self, forKey: .status) {
            status = IDOAlarmStatus(rawValue: value)!
        } else {
            status = .invalid
        }
        if let value = try container.decodeIfPresent(Int.self, forKey: .repeats) {
            isOpen = (value & (1 << 0) != 0)
            var items = Set<IDOWeek>()
            for i in 0...6 {
                if value & (1 << (i + 1)) != 0 {
                    items.insert(IDOWeek(rawValue: i)!)
                }
            }
            repeats = items
        } else {
            isOpen = false
            repeats = Set<IDOWeek>()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(alarmID, forKey: .alarmID)
        try container.encode(delayMin, forKey: .delayMin)
        try container.encode(hour, forKey: .hour)
        try container.encode(minute, forKey: .minute)
        try container.encode(name, forKey: .name)
        try container.encode(shockOnOff, forKey: .shockOnOff)
        try container.encode(repeatTimes, forKey: .repeatTimes)

        try container.encode(type.rawValue, forKey: .type)
        try container.encode(status.rawValue, forKey: .status)

        var value = 0
        value |= (isOpen ? 1 : 0) << 0
        for item in repeats {
            value |= (1 << (item.rawValue + 1))
        }
        try container.encode(value, forKey: .repeats)
    }
}

@objc
public enum IDOAlarmType: Int {
    case wakeUp = 0x00
    case sleep = 0x01
    case exercise = 0x02
    case medication = 0x03
    case date = 0x04
    case gathering = 0x05
    case meeting = 0x06
    case other = 0x07
}

@objc
public enum IDOWeek: Int {
    case monday = 0, tuesday, wednesday, thursday, friday, saturday, sunday
}

@objc
public enum IDOAlarmStatus: Int {
    case invalid = -1
    case hidden = 0
    case displayed = 1
}


@objcMembers
public class IDOAlarmModelObjc: NSObject, IDOBaseModel {
    public var items: [IDOAlarmItemObjc]
    private let num: Int
    private let version: Int

    enum CodingKeys: String, CodingKey {
        case items = "item"
        case num
        case version
    }

    public init(items: [IDOAlarmItemObjc]) {
        self.items = items
        self.num = items.count
        self.version = 0
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOItem

@objcMembers
public class IDOAlarmItemObjc: NSObject, Codable {
    /// Alarm ID, starting from 1, 1~maximum supported number of alarms
    public var alarmID: Int
    /// Delay in minutes
    public var delayMin: Int
    public var hour: Int
    public var minute: Int
    /// Alarm name, maximum 23 bytes
    public var name: String
    /// Repeat
    public var repeats = [IDOWeekObjc]()
    /// on/off
    public var isOpen: Bool
    /// Number of repeated alarms
    /// Number of times the alarm is repeated, delay switch, set to 0 to turn off, set to a number to repeat that many times
    public var repeatTimes: Int
    public var shockOnOff: Int
    /// 0: Hidden (deleted) 1: Displayed -1:Invailed
    public var status: IDOAlarmStatus
    public var tsnoozeDuration: Int
    /// Alarm type
    public var type: IDOAlarmType

    enum CodingKeys: String, CodingKey {
        case alarmID = "alarm_id"
        case delayMin = "delay_min"
        case hour
        case minute
        case name
        case repeats = "repeat"
        case repeatTimes = "repeat_times"
        case shockOnOff = "shock_on_off"
        case status
        case tsnoozeDuration = "tsnooze_duration"
        case type
    }

    public init(alarmID: Int, delayMin: Int, hour: Int, minute: Int, name: String, repeats: [IDOWeekObjc], isOpen: Bool, repeatTimes: Int, shockOnOff: Int, status: IDOAlarmStatus, tsnoozeDuration: Int, type: IDOAlarmType) {
        self.alarmID = alarmID
        self.delayMin = delayMin
        self.hour = hour
        self.minute = minute
        self.name = name
        self.repeats = repeats
        self.repeatTimes = repeatTimes
        self.shockOnOff = shockOnOff
        self.status = status
        self.tsnoozeDuration = tsnoozeDuration
        self.type = type
        self.isOpen = isOpen
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        alarmID = try container.decode(Int.self, forKey: .alarmID)
        delayMin = try container.decode(Int.self, forKey: .delayMin)
        hour = try container.decode(Int.self, forKey: .hour)
        minute = try container.decode(Int.self, forKey: .minute)
        name = try container.decode(String.self, forKey: .name)
        shockOnOff = try container.decode(Int.self, forKey: .shockOnOff)
        repeatTimes = try container.decode(Int.self, forKey: .repeatTimes)
        tsnoozeDuration = try container.decode(Int.self, forKey: .tsnoozeDuration)

        if let value = try container.decodeIfPresent(Int.self, forKey: .type) {
            type = IDOAlarmType(rawValue: value)!
        } else {
            type = .other
        }
        if let value = try container.decodeIfPresent(Int.self, forKey: .status) {
            status = IDOAlarmStatus(rawValue: value)!
        } else {
            status = .invalid
        }
        if let value = try container.decodeIfPresent(Int.self, forKey: .repeats) {
            isOpen = (value & (1 << 0) != 0)
            var items = [IDOWeekObjc]()
            for i in 0...6 {
                if value & (1 << (i + 1)) != 0 {
                    items.append(IDOWeekObjc(week: IDOWeek(rawValue: i)!))
                }
            }
            repeats = items
        } else {
            isOpen = false
            repeats = [IDOWeekObjc]()
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(alarmID, forKey: .alarmID)
        try container.encode(delayMin, forKey: .delayMin)
        try container.encode(hour, forKey: .hour)
        try container.encode(minute, forKey: .minute)
        try container.encode(name, forKey: .name)
        try container.encode(shockOnOff, forKey: .shockOnOff)
        try container.encode(repeatTimes, forKey: .repeatTimes)

        try container.encode(type.rawValue, forKey: .type)
        try container.encode(status.rawValue, forKey: .status)

        var value = 0
        value |= (isOpen ? 1 : 0) << 0
        for item in repeats {
            value |= (1 << (item.week.rawValue + 1))
        }
        try container.encode(value, forKey: .repeats)
    }
}

@objcMembers
public class IDOWeekObjc: NSObject {
    public var week: IDOWeek
    
    public init(week: IDOWeek) {
        self.week = week
    }
}
