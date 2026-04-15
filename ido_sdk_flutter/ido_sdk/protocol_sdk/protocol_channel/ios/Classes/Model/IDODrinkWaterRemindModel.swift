//
//  IDODrinkWaterRemindModel.swift
//  protocol_channel
//
//  Created by hc on 2024/1/24.
//

import Foundation

// MARK: - IDODrinkWaterRemindModel
public class IDODrinkWaterRemindModel: NSObject, IDOBaseModel {
    /// Switch 0: Off 1: On
    public var onOff: Int
    /// Start time Hour
    public var startHour: Int
    /// Start time Minute
    public var startMinute: Int
    /// End time Hour
    public var endHour: Int
    /// End time Minute
    public var endMinute: Int
    /// Repeat
    public var repeats: Set<IDOWeek>
    /// Reminder interval in minutes
    public var interval: Int
    /// Notification type
    /// 0: Invalid
    /// 1: Allow notification
    /// 2: Silent notification
    /// 3: Notification off
    /// Need to open firmware table support setDrinkWaterAddNotifyFlag
    public var notifyFlag: Int
    /// Do not disturb switch
    /// 00: Off
    /// 01: On
    /// Need to open firmware table support setNoReminderOnDrinkReminder
    public var doNotDisturbOnOff: Int
    /// Do not disturb start time Hour
    /// Need to open firmware table support setNoReminderOnDrinkReminder
    public var noDisturbStartHour: Int
    /// Do not disturb start time Minute
    /// Need to open firmware table support setNoReminderOnDrinkReminder
    public var noDisturbStartMinute: Int
    /// Do not disturb end time Hour
    /// Need to open firmware table support setNoReminderOnDrinkReminder
    public var noDisturbEndHour: Int
    /// Do not disturb end time Minute
    /// Need to open firmware table support setNoReminderOnDrinkReminder
    public var noDisturbEndMinute: Int

    enum CodingKeys: String, CodingKey {
        case onOff = "on_off"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case repeats = "repeat"
        case interval = "interval"
        case notifyFlag = "notify_flag"
        case doNotDisturbOnOff = "do_not_disturb_on_off"
        case noDisturbStartHour = "no_disturb_start_hour"
        case noDisturbStartMinute = "no_disturb_start_minute"
        case noDisturbEndHour = "no_disturb_end_hour"
        case noDisturbEndMinute = "no_disturb_end_minute"
    }

    public init(onOff: Int, startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, repeats: Set<IDOWeek>, interval: Int, notifyFlag: Int = 0, doNotDisturbOnOff: Int = 0, noDisturbStartHour: Int = 0, noDisturbStartMinute: Int = 0, noDisturbEndHour: Int = 0, noDisturbEndMinute: Int = 0) {
        self.onOff = onOff
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.repeats = repeats
        self.interval = interval
        self.notifyFlag = notifyFlag
        self.doNotDisturbOnOff = doNotDisturbOnOff
        self.noDisturbStartHour = noDisturbStartHour
        self.noDisturbStartMinute = noDisturbStartMinute
        self.noDisturbEndHour = noDisturbEndHour
        self.noDisturbEndMinute = noDisturbEndMinute
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        onOff = try container.decode(Int.self, forKey: .onOff)
        startHour = try container.decode(Int.self, forKey: .startHour)
        startMinute = try container.decode(Int.self, forKey: .startMinute)
        endHour = try container.decode(Int.self, forKey: .endHour)
        endMinute = try container.decode(Int.self, forKey: .endMinute)
        notifyFlag = try container.decode(Int.self, forKey: .notifyFlag)
        interval = try container.decode(Int.self, forKey: .interval)
        doNotDisturbOnOff = try container.decode(Int.self, forKey: .doNotDisturbOnOff)
        noDisturbStartHour = try container.decode(Int.self, forKey: .noDisturbStartHour)
        noDisturbStartMinute = try container.decode(Int.self, forKey: .noDisturbStartMinute)
        noDisturbEndHour = try container.decode(Int.self, forKey: .noDisturbEndHour)
        noDisturbEndMinute = try container.decode(Int.self, forKey: .noDisturbEndMinute)

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
        try container.encode(doNotDisturbOnOff, forKey: .doNotDisturbOnOff)
        try container.encode(noDisturbStartHour, forKey: .noDisturbStartHour)
        try container.encode(noDisturbStartMinute, forKey: .noDisturbStartMinute)
        try container.encode(noDisturbEndHour, forKey: .noDisturbEndHour)
        try container.encode(noDisturbEndMinute, forKey: .noDisturbEndMinute)
        try container.encode(notifyFlag, forKey: .notifyFlag)

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


// MARK: - IDODrinkWaterRemindModelObjc
@objcMembers
public class IDODrinkWaterRemindModelObjc: NSObject, IDOBaseModel {
    /// Switch 0: Off 1: On
    public var onOff: Int
    /// Start time Hour
    public var startHour: Int
    /// Start time Minute
    public var startMinute: Int
    /// End time Hour
    public var endHour: Int
    /// End time Minute
    public var endMinute: Int
    /// Repeat
    public var repeats: [IDOWeekObjc]
    /// Reminder interval in minutes
    public var interval: Int
    /// Notification type
    /// 0: Invalid
    /// 1: Allow notification
    /// 2: Silent notification
    /// 3: Notification off
    /// Need to open firmware table support setDrinkWaterAddNotifyFlag
    public var notifyFlag: Int
    /// Do not disturb switch
    /// 00: Off
    /// 01: On
    /// Need to open firmware table support setNoReminderOnDrinkReminder
    public var doNotDisturbOnOff: Int
    /// Do not disturb start time Hour
    /// Need to open firmware table support setNoReminderOnDrinkReminder
    public var noDisturbStartHour: Int
    /// Do not disturb start time Minute
    /// Need to open firmware table support setNoReminderOnDrinkReminder
    public var noDisturbStartMinute: Int
    /// Do not disturb end time Hour
    /// Need to open firmware table support setNoReminderOnDrinkReminder
    public var noDisturbEndHour: Int
    /// Do not disturb end time Minute
    /// Need to open firmware table support setNoReminderOnDrinkReminder
    public var noDisturbEndMinute: Int

    enum CodingKeys: String, CodingKey {
        case onOff = "on_off"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case repeats = "repeat"
        case interval = "interval"
        case notifyFlag = "notify_flag"
        case doNotDisturbOnOff = "do_not_disturb_on_off"
        case noDisturbStartHour = "no_disturb_start_hour"
        case noDisturbStartMinute = "no_disturb_start_minute"
        case noDisturbEndHour = "no_disturb_end_hour"
        case noDisturbEndMinute = "no_disturb_end_minute"
    }

    public init(onOff: Int, startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, repeats: [IDOWeekObjc], interval: Int, notifyFlag: Int = 0, doNotDisturbOnOff: Int = 0, noDisturbStartHour: Int = 0, noDisturbStartMinute: Int = 0, noDisturbEndHour: Int = 0, noDisturbEndMinute: Int = 0) {
        self.onOff = onOff
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.repeats = repeats
        self.interval = interval
        self.notifyFlag = notifyFlag
        self.doNotDisturbOnOff = doNotDisturbOnOff
        self.noDisturbStartHour = noDisturbStartHour
        self.noDisturbStartMinute = noDisturbStartMinute
        self.noDisturbEndHour = noDisturbEndHour
        self.noDisturbEndMinute = noDisturbEndMinute
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        onOff = try container.decode(Int.self, forKey: .onOff)
        startHour = try container.decode(Int.self, forKey: .startHour)
        startMinute = try container.decode(Int.self, forKey: .startMinute)
        endHour = try container.decode(Int.self, forKey: .endHour)
        endMinute = try container.decode(Int.self, forKey: .endMinute)
        notifyFlag = try container.decode(Int.self, forKey: .notifyFlag)
        interval = try container.decode(Int.self, forKey: .interval)
        doNotDisturbOnOff = try container.decode(Int.self, forKey: .doNotDisturbOnOff)
        noDisturbStartHour = try container.decode(Int.self, forKey: .noDisturbStartHour)
        noDisturbStartMinute = try container.decode(Int.self, forKey: .noDisturbStartMinute)
        noDisturbEndHour = try container.decode(Int.self, forKey: .noDisturbEndHour)
        noDisturbEndMinute = try container.decode(Int.self, forKey: .noDisturbEndMinute)

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
        try container.encode(onOff, forKey: .onOff)
        try container.encode(startHour, forKey: .startHour)
        try container.encode(startMinute, forKey: .startMinute)
        try container.encode(endHour, forKey: .endHour)
        try container.encode(endMinute, forKey: .endMinute)
        try container.encode(interval, forKey: .interval)
        try container.encode(doNotDisturbOnOff, forKey: .doNotDisturbOnOff)
        try container.encode(noDisturbStartHour, forKey: .noDisturbStartHour)
        try container.encode(noDisturbStartMinute, forKey: .noDisturbStartMinute)
        try container.encode(noDisturbEndHour, forKey: .noDisturbEndHour)
        try container.encode(noDisturbEndMinute, forKey: .noDisturbEndMinute)

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
