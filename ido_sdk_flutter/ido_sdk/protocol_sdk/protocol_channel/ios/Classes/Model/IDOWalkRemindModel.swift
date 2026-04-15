//
//  IDOWalkRemindModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Get walk reminder event number
public class IDOWalkRemindModel: NSObject, IDOBaseModel {
    /// 0 Off，1 On
    public var onOff: Int
    /// Goal step (deprecated)
    public var goalStep: Int
    /// Start time (hour)
    public var startHour: Int
    /// Start time (minute)
    public var startMinute: Int
    /// End time (hour)
    public var endHour: Int
    /// End time (minute)
    public var endMinute: Int
    /// Repeat
    public var repeats: Set<IDOWeek>
    /// Goal time (deprecated)
    public var goalTime: Int
    /// Notification type
    /// 0: Invalid
    /// 1: Allow notification
    /// 2: Silent notification
    /// 3: Close notification
    /// Requires firmware to enable `setWalkReminderAddNotify`
    public var notifyFlag: Int
    /// Do not disturb switch
    /// 0 Off
    /// 1 On
    /// Requires firmware to enable `getSupportSetGetNoReminderOnWalkReminderV2`
    public var doNotDisturbOnOff: Int
    /// Do not disturb start time (hour)
    /// Requires firmware to enable `getSupportSetGetNoReminderOnWalkReminderV2`
    public var noDisturbStartHour: Int
    /// Do not disturb start time (minute)
    /// Requires firmware to enable `getSupportSetGetNoReminderOnWalkReminderV2`
    public var noDisturbStartMinute: Int
    /// Do not disturb end time (hour)
    /// Requires firmware to enable `getSupportSetGetNoReminderOnWalkReminderV2`
    public var noDisturbEndHour: Int
    /// Do not disturb end time (minute)
    /// Requires firmware to enable `getSupportSetGetNoReminderOnWalkReminderV2`
    public var noDisturbEndMinute: Int

    enum CodingKeys: String, CodingKey {
        case onOff = "on_off"
        case goalStep = "goal_step"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case repeats = "repeat"
        case goalTime = "goal_time"
        case notifyFlag = "notify_flag"
        case doNotDisturbOnOff = "do_not_disturb_on_off"
        case noDisturbStartHour = "no_disturb_start_hour"
        case noDisturbStartMinute = "no_disturb_start_minute"
        case noDisturbEndHour = "no_disturb_end_hour"
        case noDisturbEndMinute = "no_disturb_end_minute"
    }

    public init(onOff: Int, goalStep: Int, startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, repeats: Set<IDOWeek>, goalTime: Int, notifyFlag: Int = 0, doNotDisturbOnOff: Int = 0, noDisturbStartHour: Int = 0, noDisturbStartMinute: Int = 0, noDisturbEndHour: Int = 0, noDisturbEndMinute: Int = 0) {
        self.onOff = onOff
        self.goalStep = goalStep
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.repeats = repeats
        self.goalTime = goalTime
        self.notifyFlag = notifyFlag
        self.doNotDisturbOnOff = doNotDisturbOnOff
        self.noDisturbStartHour = noDisturbStartHour
        self.noDisturbStartMinute = noDisturbStartMinute
        self.noDisturbEndHour = noDisturbEndHour
        self.noDisturbEndMinute = noDisturbEndMinute
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        goalStep = try container.decode(Int.self, forKey: .goalStep)
        onOff = try container.decode(Int.self, forKey: .onOff)
        startHour = try container.decode(Int.self, forKey: .startHour)
        startMinute = try container.decode(Int.self, forKey: .startMinute)
        endHour = try container.decode(Int.self, forKey: .endHour)
        endMinute = try container.decode(Int.self, forKey: .endMinute)
        goalTime = try container.decode(Int.self, forKey: .goalTime)
        notifyFlag = try container.decode(Int.self, forKey: .notifyFlag)
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
        try container.encode(goalStep, forKey: .goalStep)
        try container.encode(onOff, forKey: .onOff)
        try container.encode(startHour, forKey: .startHour)
        try container.encode(startMinute, forKey: .startMinute)
        try container.encode(endHour, forKey: .endHour)
        try container.encode(endMinute, forKey: .endMinute)
        try container.encode(goalTime, forKey: .goalTime)
        try container.encode(doNotDisturbOnOff, forKey: .doNotDisturbOnOff)
        try container.encode(noDisturbStartHour, forKey: .noDisturbStartHour)
        try container.encode(noDisturbStartMinute, forKey: .noDisturbStartMinute)
        try container.encode(noDisturbEndHour, forKey: .noDisturbEndHour)
        try container.encode(noDisturbEndMinute, forKey: .noDisturbEndMinute)

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


/// Get walk reminder event number
@objcMembers
public class IDOWalkRemindModelObjc: NSObject, IDOBaseModel {
    /// 0 Off，1 On
    public var onOff: Int
    /// Goal step (deprecated)
    public var goalStep: Int
    /// Start time (hour)
    public var startHour: Int
    /// Start time (minute)
    public var startMinute: Int
    /// End time (hour)
    public var endHour: Int
    /// End time (minute)
    public var endMinute: Int
    /// Repeat
    public var repeats: [IDOWeekObjc]
    /// Goal time (deprecated)
    public var goalTime: Int
    /// Notification type
    /// 0: Invalid
    /// 1: Allow notification
    /// 2: Silent notification
    /// 3: Close notification
    /// Requires firmware to enable `setWalkReminderAddNotify`
    public var notifyFlag: Int
    /// Do not disturb switch
    /// 0 Off
    /// 1 On
    /// Requires firmware to enable `getSupportSetGetNoReminderOnWalkReminderV2`
    public var doNotDisturbOnOff: Int
    /// Do not disturb start time (hour)
    /// Requires firmware to enable `getSupportSetGetNoReminderOnWalkReminderV2`
    public var noDisturbStartHour: Int
    /// Do not disturb start time (minute)
    /// Requires firmware to enable `getSupportSetGetNoReminderOnWalkReminderV2`
    public var noDisturbStartMinute: Int
    /// Do not disturb end time (hour)
    /// Requires firmware to enable `getSupportSetGetNoReminderOnWalkReminderV2`
    public var noDisturbEndHour: Int
    /// Do not disturb end time (minute)
    /// Requires firmware to enable `getSupportSetGetNoReminderOnWalkReminderV2`
    public var noDisturbEndMinute: Int

    enum CodingKeys: String, CodingKey {
        case onOff = "on_off"
        case goalStep = "goal_step"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case repeats = "repeat"
        case goalTime = "goal_time"
        case notifyFlag = "notify_flag"
        case doNotDisturbOnOff = "do_not_disturb_on_off"
        case noDisturbStartHour = "no_disturb_start_hour"
        case noDisturbStartMinute = "no_disturb_start_minute"
        case noDisturbEndHour = "no_disturb_end_hour"
        case noDisturbEndMinute = "no_disturb_end_minute"
    }

    public init(onOff: Int, goalStep: Int, startHour: Int, startMinute: Int, endHour: Int, endMinute: Int,repeats: [IDOWeekObjc], goalTime: Int, notifyFlag: Int = 0, doNotDisturbOnOff: Int = 0, noDisturbStartHour: Int = 0, noDisturbStartMinute: Int = 0, noDisturbEndHour: Int = 0, noDisturbEndMinute: Int = 0) {
        self.onOff = onOff
        self.goalStep = goalStep
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.repeats = repeats
        self.goalTime = goalTime
        self.notifyFlag = notifyFlag
        self.doNotDisturbOnOff = doNotDisturbOnOff
        self.noDisturbStartHour = noDisturbStartHour
        self.noDisturbStartMinute = noDisturbStartMinute
        self.noDisturbEndHour = noDisturbEndHour
        self.noDisturbEndMinute = noDisturbEndMinute
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        goalStep = try container.decode(Int.self, forKey: .goalStep)
        onOff = try container.decode(Int.self, forKey: .onOff)
        startHour = try container.decode(Int.self, forKey: .startHour)
        startMinute = try container.decode(Int.self, forKey: .startMinute)
        endHour = try container.decode(Int.self, forKey: .endHour)
        endMinute = try container.decode(Int.self, forKey: .endMinute)
        goalTime = try container.decode(Int.self, forKey: .goalTime)
        notifyFlag = try container.decode(Int.self, forKey: .notifyFlag)
        doNotDisturbOnOff = try container.decode(Int.self, forKey: .doNotDisturbOnOff)
        noDisturbStartHour = try container.decode(Int.self, forKey: .noDisturbStartHour)
        noDisturbStartMinute = try container.decode(Int.self, forKey: .noDisturbStartMinute)
        noDisturbEndHour = try container.decode(Int.self, forKey: .noDisturbEndHour)
        noDisturbEndMinute = try container.decode(Int.self, forKey: .noDisturbEndMinute)

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
        try container.encode(goalStep, forKey: .goalStep)
        try container.encode(onOff, forKey: .onOff)
        try container.encode(startHour, forKey: .startHour)
        try container.encode(startMinute, forKey: .startMinute)
        try container.encode(endHour, forKey: .endHour)
        try container.encode(endMinute, forKey: .endMinute)
        try container.encode(goalTime, forKey: .goalTime)
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
