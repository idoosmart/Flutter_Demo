//
//  IDOTakingMedicineReminderParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Set Taking Medicine Reminder Event Code
public class IDOTakingMedicineReminderParamModel: NSObject, IDOBaseModel {
    /// ID ranging from 1 to 5
    public var takingMedicineId: Int
    /// 0 for off
    /// 1 for on
    public var onOff: Int
    /// Starting hour of the reminder
    public var startHour: Int
    /// Starting minute of the reminder
    public var startMinute: Int
    /// Ending hour of the reminder
    public var endHour: Int
    /// Ending minute of the reminder
    public var endMinute: Int
    /// Repeat
    public var repeats: Set<IDOWeek>
    /// Reminder interval in minutes
    /// Default is 60 minutes
    public var interval: Int
    /// Do not disturb time period switch
    /// 0 for off
    /// 1 for on
    /// Default is off
    public var doNotDisturbOnOff: Int
    /// Do not disturb start hour
    public var doNotDisturbStartHour: Int
    /// Do not disturb start minute
    public var doNotDisturbStartMinute: Int
    /// Do not disturb end hour
    public var doNotDisturbEndHour: Int
    /// Do not disturb end minute
    public var doNotDisturbEndMinute: Int

    enum CodingKeys: String, CodingKey {
        case takingMedicineId = "taking_medicine_id"
        case onOff = "on_off"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case repeats = "repeat"
        case interval = "interval"
        case doNotDisturbOnOff = "do_not_disturb_on_off"
        case doNotDisturbStartHour = "do_not_disturb_start_hour"
        case doNotDisturbStartMinute = "do_not_disturb_start_minute"
        case doNotDisturbEndHour = "do_not_disturb_end_hour"
        case doNotDisturbEndMinute = "do_not_disturb_end_minute"
    }

    public init(takingMedicineId: Int, onOff: Int, startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, repeats: Set<IDOWeek>, interval: Int, doNotDisturbOnOff: Int, doNotDisturbStartHour: Int, doNotDisturbStartMinute: Int, doNotDisturbEndHour: Int, doNotDisturbEndMinute: Int) {
        self.takingMedicineId = takingMedicineId
        self.onOff = onOff
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.repeats = repeats
        self.interval = interval
        self.doNotDisturbOnOff = doNotDisturbOnOff
        self.doNotDisturbStartHour = doNotDisturbStartHour
        self.doNotDisturbStartMinute = doNotDisturbStartMinute
        self.doNotDisturbEndHour = doNotDisturbEndHour
        self.doNotDisturbEndMinute = doNotDisturbEndMinute
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        takingMedicineId = try container.decode(Int.self, forKey: .takingMedicineId)
        onOff = try container.decode(Int.self, forKey: .onOff)
        startHour = try container.decode(Int.self, forKey: .startHour)
        startMinute = try container.decode(Int.self, forKey: .startMinute)
        endHour = try container.decode(Int.self, forKey: .endHour)
        endMinute = try container.decode(Int.self, forKey: .endMinute)
        interval = try container.decode(Int.self, forKey: .interval)
        doNotDisturbOnOff = try container.decode(Int.self, forKey: .doNotDisturbOnOff)
        doNotDisturbStartHour = try container.decode(Int.self, forKey: .doNotDisturbStartHour)
        doNotDisturbStartMinute = try container.decode(Int.self, forKey: .doNotDisturbStartMinute)
        doNotDisturbEndHour = try container.decode(Int.self, forKey: .doNotDisturbEndHour)
        doNotDisturbEndMinute = try container.decode(Int.self, forKey: .doNotDisturbEndMinute)

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
        try container.encode(takingMedicineId, forKey: .takingMedicineId)
        try container.encode(onOff, forKey: .onOff)
        try container.encode(startHour, forKey: .startHour)
        try container.encode(startMinute, forKey: .startMinute)
        try container.encode(endHour, forKey: .endHour)
        try container.encode(endMinute, forKey: .endMinute)
        try container.encode(interval, forKey: .interval)
        try container.encode(doNotDisturbOnOff, forKey: .doNotDisturbOnOff)
        try container.encode(doNotDisturbStartHour, forKey: .doNotDisturbStartHour)
        try container.encode(doNotDisturbStartMinute, forKey: .doNotDisturbStartMinute)
        try container.encode(doNotDisturbEndHour, forKey: .doNotDisturbEndHour)
        try container.encode(doNotDisturbEndMinute, forKey: .doNotDisturbEndMinute)

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


/// Set Taking Medicine Reminder Event Code
@objcMembers
public class IDOTakingMedicineReminderParamModelObjc: NSObject, IDOBaseModel {
    /// ID ranging from 1 to 5
    public var takingMedicineId: Int
    /// 0 for off
    /// 1 for on
    public var onOff: Int
    /// Starting hour of the reminder
    public var startHour: Int
    /// Starting minute of the reminder
    public var startMinute: Int
    /// Ending hour of the reminder
    public var endHour: Int
    /// Ending minute of the reminder
    public var endMinute: Int
    /// Repeat
    public var repeats: [IDOWeekObjc]
    /// Reminder interval in minutes
    /// Default is 60 minutes
    public var interval: Int
    /// Do not disturb time period switch
    /// 0 for off
    /// 1 for on
    /// Default is off
    public var doNotDisturbOnOff: Int
    /// Do not disturb start hour
    public var doNotDisturbStartHour: Int
    /// Do not disturb start minute
    public var doNotDisturbStartMinute: Int
    /// Do not disturb end hour
    public var doNotDisturbEndHour: Int
    /// Do not disturb end minute
    public var doNotDisturbEndMinute: Int

    enum CodingKeys: String, CodingKey {
        case takingMedicineId = "taking_medicine_id"
        case onOff = "on_off"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case repeats = "repeat"
        case interval = "interval"
        case doNotDisturbOnOff = "do_not_disturb_on_off"
        case doNotDisturbStartHour = "do_not_disturb_start_hour"
        case doNotDisturbStartMinute = "do_not_disturb_start_minute"
        case doNotDisturbEndHour = "do_not_disturb_end_hour"
        case doNotDisturbEndMinute = "do_not_disturb_end_minute"
    }

    public init(takingMedicineId: Int, onOff: Int, startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, repeats: [IDOWeekObjc], interval: Int, doNotDisturbOnOff: Int, doNotDisturbStartHour: Int, doNotDisturbStartMinute: Int, doNotDisturbEndHour: Int, doNotDisturbEndMinute: Int) {
        self.takingMedicineId = takingMedicineId
        self.onOff = onOff
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.repeats = repeats
        self.interval = interval
        self.doNotDisturbOnOff = doNotDisturbOnOff
        self.doNotDisturbStartHour = doNotDisturbStartHour
        self.doNotDisturbStartMinute = doNotDisturbStartMinute
        self.doNotDisturbEndHour = doNotDisturbEndHour
        self.doNotDisturbEndMinute = doNotDisturbEndMinute
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        takingMedicineId = try container.decode(Int.self, forKey: .takingMedicineId)
        onOff = try container.decode(Int.self, forKey: .onOff)
        startHour = try container.decode(Int.self, forKey: .startHour)
        startMinute = try container.decode(Int.self, forKey: .startMinute)
        endHour = try container.decode(Int.self, forKey: .endHour)
        endMinute = try container.decode(Int.self, forKey: .endMinute)
        interval = try container.decode(Int.self, forKey: .interval)
        doNotDisturbOnOff = try container.decode(Int.self, forKey: .doNotDisturbOnOff)
        doNotDisturbStartHour = try container.decode(Int.self, forKey: .doNotDisturbStartHour)
        doNotDisturbStartMinute = try container.decode(Int.self, forKey: .doNotDisturbStartMinute)
        doNotDisturbEndHour = try container.decode(Int.self, forKey: .doNotDisturbEndHour)
        doNotDisturbEndMinute = try container.decode(Int.self, forKey: .doNotDisturbEndMinute)

        if let value = try container.decodeIfPresent(Int.self, forKey: .repeats) {
            var items = [IDOWeekObjc]()
            for i in 0...6 {
                if value & (1 << (i + 1)) != 0 {
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
        try container.encode(takingMedicineId, forKey: .takingMedicineId)
        try container.encode(onOff, forKey: .onOff)
        try container.encode(startHour, forKey: .startHour)
        try container.encode(startMinute, forKey: .startMinute)
        try container.encode(endHour, forKey: .endHour)
        try container.encode(endMinute, forKey: .endMinute)
        try container.encode(interval, forKey: .interval)
        try container.encode(doNotDisturbOnOff, forKey: .doNotDisturbOnOff)
        try container.encode(doNotDisturbStartHour, forKey: .doNotDisturbStartHour)
        try container.encode(doNotDisturbStartMinute, forKey: .doNotDisturbStartMinute)
        try container.encode(doNotDisturbEndHour, forKey: .doNotDisturbEndHour)
        try container.encode(doNotDisturbEndMinute, forKey: .doNotDisturbEndMinute)

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
