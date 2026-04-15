//
//  IDOFitnessGuidanceParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Fitness Guidance Event
public class IDOFitnessGuidanceParamModel: NSObject, IDOBaseModel {
    /// Fitness guidance mode switch
    /// 1: On
    /// 0: Off
    public var mode: Int
    /// Start hour
    public var startHour: Int
    /// Start minute
    public var startMinute: Int
    /// End hour
    public var endHour: Int
    /// End minute
    public var endMinute: Int
    /// Notification type
    /// 0: Invalid
    /// 1: Allow
    /// 2: Silent
    /// 3: Disable
    public var notifyFlag: Int
    /// Reminders to move switch
    /// 1: On
    /// 0: Off
    public var goMode: Int
    /// Repeat
    public var repeats: Set<IDOWeek>
    /// Target steps
    public var targetSteps: Int

    enum CodingKeys: String, CodingKey {
        case mode = "mode"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case notifyFlag = "notify_flag"
        case goMode = "go_mode"
        case repeats = "repeat"
        case targetSteps = "target_steps"
    }

    public init(mode: Int, startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, notifyFlag: Int, goMode: Int, repeats: Set<IDOWeek>, targetSteps: Int) {
        self.mode = mode
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.notifyFlag = notifyFlag
        self.goMode = goMode
        self.repeats = repeats
        self.targetSteps = targetSteps
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mode = try container.decode(Int.self, forKey: .mode)
        startHour = try container.decode(Int.self, forKey: .startHour)
        startMinute = try container.decode(Int.self, forKey: .startMinute)
        endHour = try container.decode(Int.self, forKey: .endHour)
        endMinute = try container.decode(Int.self, forKey: .endMinute)
        notifyFlag = try container.decode(Int.self, forKey: .notifyFlag)
        goMode = try container.decode(Int.self, forKey: .goMode)
        targetSteps = try container.decode(Int.self, forKey: .targetSteps)

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
        try container.encode(mode, forKey: .mode)
        try container.encode(startHour, forKey: .startHour)
        try container.encode(startMinute, forKey: .startMinute)
        try container.encode(endHour, forKey: .endHour)
        try container.encode(endMinute, forKey: .endMinute)
        try container.encode(notifyFlag, forKey: .notifyFlag)
        try container.encode(goMode, forKey: .goMode)
        try container.encode(targetSteps, forKey: .targetSteps)

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


/// Fitness Guidance Event
@objcMembers
public class IDOFitnessGuidanceParamModelObjc: NSObject, IDOBaseModel {
    /// Fitness guidance mode switch
    /// 1: On
    /// 0: Off
    public var mode: Int
    /// Start hour
    public var startHour: Int
    /// Start minute
    public var startMinute: Int
    /// End hour
    public var endHour: Int
    /// End minute
    public var endMinute: Int
    /// Notification type
    /// 0: Invalid
    /// 1: Allow
    /// 2: Silent
    /// 3: Disable
    public var notifyFlag: Int
    /// Reminders to move switch
    /// 1: On
    /// 0: Off
    public var goMode: Int
    /// Repeat
    public var repeats: [IDOWeekObjc]

    /// Target steps
    public var targetSteps: Int

    enum CodingKeys: String, CodingKey {
        case mode = "mode"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case notifyFlag = "notify_flag"
        case goMode = "go_mode"
        case repeats = "repeat"
        case targetSteps = "target_steps"
    }

    public init(mode: Int, startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, notifyFlag: Int, goMode: Int, repeats: [IDOWeekObjc], targetSteps: Int) {
        self.mode = mode
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.notifyFlag = notifyFlag
        self.goMode = goMode
        self.repeats = repeats
        self.targetSteps = targetSteps
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mode = try container.decode(Int.self, forKey: .mode)
        startHour = try container.decode(Int.self, forKey: .startHour)
        startMinute = try container.decode(Int.self, forKey: .startMinute)
        endHour = try container.decode(Int.self, forKey: .endHour)
        endMinute = try container.decode(Int.self, forKey: .endMinute)
        notifyFlag = try container.decode(Int.self, forKey: .notifyFlag)
        goMode = try container.decode(Int.self, forKey: .goMode)
        targetSteps = try container.decode(Int.self, forKey: .targetSteps)

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
        try container.encode(mode, forKey: .mode)
        try container.encode(startHour, forKey: .startHour)
        try container.encode(startMinute, forKey: .startMinute)
        try container.encode(endHour, forKey: .endHour)
        try container.encode(endMinute, forKey: .endMinute)
        try container.encode(notifyFlag, forKey: .notifyFlag)
        try container.encode(goMode, forKey: .goMode)
        try container.encode(targetSteps, forKey: .targetSteps)

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
