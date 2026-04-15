//
//  IDOEmotionHealthReminderModel.swift
//  protocol_channel
//
//  Created by hc on 2025/12/04.
//

import Foundation

// V3 Emotion Health Reminder Param Model
@objcMembers
public class IDOEmotionHealthReminderParamModel: NSObject, IDOBaseModel {
    /// Protocol version number
    private var version: Int
    
    /// Operation type: 0:Invalid 1:Set 2:Query
    public var operate: Int
    
    /// Notification type: 0:Invalid 1:Allow notification 2:Silent notification 3:Close notification
    public var notifyType: Int
    
    /// Emotional health master switch: 1:On 0:Off
    public var emotionalHealthSwitch: Int
    
    /// Pressure reminder configuration
    public var pressureRemind: IDOPressureRemindConfig?
    
    /// Unpleasant reminder configuration
    public var unpleasantRemind: IDOUnpleasantRemindConfig?
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case operate = "operate"
        case notifyType = "notify_type"
        case emotionalHealthSwitch = "emotional_health_switch"
        case pressureRemind = "pressure_remind"
        case unpleasantRemind = "unpleasant_remind"
    }
    
    public init(operate: Int, notifyType: Int = 0, emotionalHealthSwitch: Int, pressureRemind: IDOPressureRemindConfig? = nil, unpleasantRemind: IDOUnpleasantRemindConfig? = nil) {
        self.version = 4
        self.operate = operate
        self.notifyType = notifyType
        self.emotionalHealthSwitch = emotionalHealthSwitch
        self.pressureRemind = pressureRemind
        self.unpleasantRemind = unpleasantRemind
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - Pressure Remind Config

/// Pressure reminder configuration
public class IDOPressureRemindConfig: NSObject, Codable {
    /// Pressure reminder switch: 1:On 0:Off
    public var pressureSwitch: Int
    
    /// Reminder start time (hour)
    public var startHour: Int
    
    /// Reminder start time (minute)
    public var startMinute: Int
    
    /// Reminder end time (hour)
    public var endHour: Int
    
    /// Reminder end time (minute)
    public var endMinute: Int
    
    /// Repeat cycle
    public var repeats = Set<IDOWeek>()
    
    // /// Repeat On/Off
    // public var isOpenRepeat: Bool
    
    /// Reminder interval, unit: minutes
    public var reminderInterval: Int
    
    enum CodingKeys: String, CodingKey {
        case pressureSwitch = "pressure_switch"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case repetitions = "repetitions"
        case reminderInterval = "reminder_interval"
    }
    
    public init(pressureSwitch: Int, startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, repeats: Set<IDOWeek>, reminderInterval: Int) {
        self.pressureSwitch = pressureSwitch
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.repeats = repeats
        // self.isOpenRepeat = isOpenRepeat
        self.reminderInterval = reminderInterval
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pressureSwitch = try container.decode(Int.self, forKey: .pressureSwitch)
        startHour = try container.decode(Int.self, forKey: .startHour)
        startMinute = try container.decode(Int.self, forKey: .startMinute)
        endHour = try container.decode(Int.self, forKey: .endHour)
        endMinute = try container.decode(Int.self, forKey: .endMinute)
        reminderInterval = try container.decode(Int.self, forKey: .reminderInterval)
        
        // Decode repetitions: bit0 is master switch, bit1~bit7 are Monday to Sunday
        if let value = try container.decodeIfPresent(Int.self, forKey: .repetitions) {
            // isOpenRepeat = (value & (1 << 0) != 0)
            var items = Set<IDOWeek>()
            for i in 0...6 {
                if value & (1 << (i + 1)) != 0 {
                    items.insert(IDOWeek(rawValue: i)!)
                }
            }
            repeats = items
        } else {
            //isOpenRepeat = false
            repeats = Set<IDOWeek>()
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pressureSwitch, forKey: .pressureSwitch)
        try container.encode(startHour, forKey: .startHour)
        try container.encode(startMinute, forKey: .startMinute)
        try container.encode(endHour, forKey: .endHour)
        try container.encode(endMinute, forKey: .endMinute)
        try container.encode(reminderInterval, forKey: .reminderInterval)
        
        // Encode repetitions: bit0 is master switch, bit1~bit7 are Monday to Sunday
        var value = 0
        //value |= (isOpenRepeat ? 1 : 0) << 0 // bit0为预留
        for item in repeats {
            value |= (1 << (item.rawValue + 1))
        }
        try container.encode(value, forKey: .repetitions)
    }
}

// MARK: - Unpleasant Remind Config

/// Unpleasant reminder configuration
public class IDOUnpleasantRemindConfig: NSObject, Codable {
    /// Unpleasant reminder switch: 1:On 0:Off
    public var unpleasantSwitch: Int
    
    /// Unhappy reminder threshold, 0 is invalid
    public var unhappyReminderNum: Int
    
    enum CodingKeys: String, CodingKey {
        case unpleasantSwitch = "unpleasant_switch"
        case unhappyReminderNum = "unhappy_reminder_num"
    }
    
    public init(unpleasantSwitch: Int, unhappyReminderNum: Int) {
        self.unpleasantSwitch = unpleasantSwitch
        self.unhappyReminderNum = unhappyReminderNum
    }
}

// MARK: - Reply Model

/// V3 Emotion Health Reminder Reply Model
@objcMembers
public class IDOEmotionHealthReminderReplyModel: NSObject, IDOBaseModel {
    /// Protocol version number
    private var version: Int
    
    /// Operation type: 0:Invalid 1:Set 2:Query
    public var operate: Int
    
    /// Error code: 0:Success, non-zero is error code
    public var errorCode: Int
    
    /// Notification type: 0:Invalid 1:Allow notification 2:Silent notification 3:Close notification
    public var notifyType: Int
    
    /// Emotional health master switch: 1:On 0:Off
    public var emotionalHealthSwitch: Int
    
    /// Pressure reminder configuration
    public var pressureRemind: IDOPressureRemindConfig?
    
    /// Unpleasant reminder configuration
    public var unpleasantRemind: IDOUnpleasantRemindConfig?
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case operate = "operate"
        case errorCode = "error_code"
        case notifyType = "notify_type"
        case emotionalHealthSwitch = "emotional_health_switch"
        case pressureRemind = "pressure_remind"
        case unpleasantRemind = "unpleasant_remind"
    }
    
    public init(operate: Int, errorCode: Int, notifyType: Int = 0, emotionalHealthSwitch: Int = 0, pressureRemind: IDOPressureRemindConfig? = nil, unpleasantRemind: IDOUnpleasantRemindConfig? = nil) {
        self.version = 0
        self.operate = operate
        self.errorCode = errorCode
        self.notifyType = notifyType
        self.emotionalHealthSwitch = emotionalHealthSwitch
        self.pressureRemind = pressureRemind
        self.unpleasantRemind = unpleasantRemind
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
