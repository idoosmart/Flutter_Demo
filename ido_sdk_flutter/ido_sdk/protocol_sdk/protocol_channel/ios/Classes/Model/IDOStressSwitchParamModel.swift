//
//  IDOStressSwitchParamModel.swift
//  protocol_channel
//
//  Created by hc on 2024/1/24.
//

import Foundation

// MARK: - IDOStressSwitchParamModel
public class IDOStressSwitchParamModel: NSObject, IDOBaseModel {
    /// Overall switch 1: On 0: Off
    public var onOff: Int
    /// Start time - hour
    public var startHour: Int
    /// Start time - minute
    public var startMinute: Int
    /// End time - hour
    public var endHour: Int
    /// End time - minute
    public var endMinute: Int
    /// Stress reminder switch 1: On 0: Off
    /// Doesn't work if on_off is off
    public var remindOnOff: Int
    /// Reminder interval in minutes, default is 60 minutes
    public var interval: Int
    /// High pressure threshold
    public var highThreshold: Int
    /// Pressure calibration threshold, default is 80
    /// Requires firmware support for setSendCalibrationThreshold
    public var stressThreshold: Int
    /// Notification type
    /// 0: Invalid
    /// 1: Allow notification
    /// 2: Silent notification
    /// 3: Disable notification
    /// Requires firmware support for getPressureNotifyFlagMode
    public var notifyFlag: Int
    
    /// Repeat
    public var repeats: Set<IDOWeek>

    enum CodingKeys: String, CodingKey {
        case onOff = "on_off"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case remindOnOff = "remind_on_off"
        case interval = "interval"
        case highThreshold = "high_threshold"
        case stressThreshold = "stress_threshold"
        case notifyFlag = "notify_flag"
        case repeats = "repeat"
    }

    public init(onOff: Int, startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, remindOnOff: Int, interval: Int, highThreshold: Int, stressThreshold: Int = 0, notifyFlag: Int, repeats: Set<IDOWeek> = [.monday]) {
        self.onOff = onOff
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.remindOnOff = remindOnOff
        self.interval = interval
        self.highThreshold = highThreshold
        self.stressThreshold = stressThreshold
        self.notifyFlag = notifyFlag
        self.repeats = repeats
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        onOff = try container.decode(Int.self, forKey: .onOff)
        startHour = try container.decode(Int.self, forKey: .startHour)
        startMinute = try container.decode(Int.self, forKey: .startMinute)
        endHour = try container.decode(Int.self, forKey: .endHour)
        endMinute = try container.decode(Int.self, forKey: .endMinute)
        notifyFlag = try container.decode(Int.self, forKey: .notifyFlag)
        remindOnOff = try container.decode(Int.self, forKey: .remindOnOff)
        interval = try container.decode(Int.self, forKey: .interval)
        highThreshold = try container.decode(Int.self, forKey: .highThreshold)
        stressThreshold = try container.decode(Int.self, forKey: .stressThreshold)

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
        try container.encode(notifyFlag, forKey: .notifyFlag)
        try container.encode(remindOnOff, forKey: .remindOnOff)
        try container.encode(interval, forKey: .interval)
        try container.encode(highThreshold, forKey: .highThreshold)
        try container.encode(stressThreshold, forKey: .stressThreshold)

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



// MARK: - IDOStressSwitchParamModelObjc
@objcMembers
public class IDOStressSwitchParamModelObjc: NSObject, Codable {
    /// Overall switch 1: On 0: Off
    public var onOff: Int
    /// Start time - hour
    public var startHour: Int
    /// Start time - minute
    public var startMinute: Int
    /// End time - hour
    public var endHour: Int
    /// End time - minute
    public var endMinute: Int
    /// Stress reminder switch 1: On 0: Off
    /// Doesn't work if on_off is off
    public var remindOnOff: Int
    /// Reminder interval in minutes, default is 60 minutes
    public var interval: Int
    /// High pressure threshold
    public var highThreshold: Int
    /// Pressure calibration threshold, default is 80
    /// Requires firmware support for setSendCalibrationThreshold
    public var stressThreshold: Int
    /// Notification type
    /// 0: Invalid
    /// 1: Allow notification
    /// 2: Silent notification
    /// 3: Disable notification
    /// Requires firmware support for getPressureNotifyFlagMode
    public var notifyFlag: Int
    
    /// Repeat
    public var repeats: [IDOWeekObjc]

    enum CodingKeys: String, CodingKey {
        case onOff = "on_off"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case remindOnOff = "remind_on_off"
        case interval = "interval"
        case highThreshold = "high_threshold"
        case stressThreshold = "stress_threshold"
        case notifyFlag = "notify_flag"
        case repeats = "repeat"
    }

    public init(onOff: Int, startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, remindOnOff: Int, interval: Int, highThreshold: Int, stressThreshold: Int = 0, notifyFlag: Int, repeats: [IDOWeekObjc]) {
        self.onOff = onOff
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.remindOnOff = remindOnOff
        self.interval = interval
        self.highThreshold = highThreshold
        self.stressThreshold = stressThreshold
        self.notifyFlag = notifyFlag
        self.repeats = repeats
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        onOff = try container.decode(Int.self, forKey: .onOff)
        startHour = try container.decode(Int.self, forKey: .startHour)
        startMinute = try container.decode(Int.self, forKey: .startMinute)
        endHour = try container.decode(Int.self, forKey: .endHour)
        endMinute = try container.decode(Int.self, forKey: .endMinute)
        notifyFlag = try container.decode(Int.self, forKey: .notifyFlag)
        remindOnOff = try container.decode(Int.self, forKey: .remindOnOff)
        interval = try container.decode(Int.self, forKey: .interval)
        highThreshold = try container.decode(Int.self, forKey: .highThreshold)
        stressThreshold = try container.decode(Int.self, forKey: .stressThreshold)

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
        try container.encode(notifyFlag, forKey: .notifyFlag)
        try container.encode(remindOnOff, forKey: .remindOnOff)
        try container.encode(interval, forKey: .interval)
        try container.encode(highThreshold, forKey: .highThreshold)
        try container.encode(stressThreshold, forKey: .stressThreshold)

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


// MARK: - IDOStressSwitchModel
public class IDOStressSwitchModel: NSObject, IDOBaseModel {
    /// Overall switch 1: On 0: Off
    public var onOff: Int
    /// Start time - hour
    public var startHour: Int
    /// Start time - minute
    public var startMinute: Int
    /// End time - hour
    public var endHour: Int
    /// End time - minute
    public var endMinute: Int
    /// Stress reminder switch 1: On 0: Off
    /// Doesn't work if on_off is off
    public var remindOnOff: Int
    /// Reminder interval in minutes, default is 60 minutes
    public var interval: Int
    /// High pressure threshold
    public var highThreshold: Int
    /// Pressure calibration threshold, default is 80
    /// Requires firmware support for setSendCalibrationThreshold
    public var stressThreshold: Int
    /// Notification type
    /// 0: Invalid
    /// 1: Allow notification
    /// 2: Silent notification
    /// 3: Disable notification
    /// Requires firmware support for getPressureNotifyFlagMode
    public var notifyFlag: Int
    
    /// Repeat
    public var repeats: Set<IDOWeek>

    enum CodingKeys: String, CodingKey {
        case onOff = "on_off"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case remindOnOff = "remind_on_off"
        case interval = "interval"
        case highThreshold = "high_threshold"
        case stressThreshold = "stress_threshold"
        case notifyFlag = "notify_flag"
        case repeats = "repeat"
    }

    public init(onOff: Int, startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, remindOnOff: Int, interval: Int, highThreshold: Int, stressThreshold: Int = 0, notifyFlag: Int, repeats: Set<IDOWeek> = [.monday]) {
        self.onOff = onOff
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.remindOnOff = remindOnOff
        self.interval = interval
        self.highThreshold = highThreshold
        self.stressThreshold = stressThreshold
        self.notifyFlag = notifyFlag
        self.repeats = repeats
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        onOff = try container.decode(Int.self, forKey: .onOff)
        startHour = try container.decode(Int.self, forKey: .startHour)
        startMinute = try container.decode(Int.self, forKey: .startMinute)
        endHour = try container.decode(Int.self, forKey: .endHour)
        endMinute = try container.decode(Int.self, forKey: .endMinute)
        notifyFlag = try container.decode(Int.self, forKey: .notifyFlag)
        remindOnOff = try container.decode(Int.self, forKey: .remindOnOff)
        interval = try container.decode(Int.self, forKey: .interval)
        highThreshold = try container.decode(Int.self, forKey: .highThreshold)
        stressThreshold = try container.decode(Int.self, forKey: .stressThreshold)

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
        try container.encode(notifyFlag, forKey: .notifyFlag)
        try container.encode(remindOnOff, forKey: .remindOnOff)
        try container.encode(interval, forKey: .interval)
        try container.encode(highThreshold, forKey: .highThreshold)
        try container.encode(stressThreshold, forKey: .stressThreshold)

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



// MARK: - IDOStressSwitchModelObjc
@objcMembers
public class IDOStressSwitchModelObjc: NSObject, Codable {
    /// Overall switch 1: On 0: Off
    public var onOff: Int
    /// Start time - hour
    public var startHour: Int
    /// Start time - minute
    public var startMinute: Int
    /// End time - hour
    public var endHour: Int
    /// End time - minute
    public var endMinute: Int
    /// Stress reminder switch 1: On 0: Off
    /// Doesn't work if on_off is off
    public var remindOnOff: Int
    /// Reminder interval in minutes, default is 60 minutes
    public var interval: Int
    /// High pressure threshold
    public var highThreshold: Int
    /// Pressure calibration threshold, default is 80
    /// Requires firmware support for setSendCalibrationThreshold
    public var stressThreshold: Int
    /// Notification type
    /// 0: Invalid
    /// 1: Allow notification
    /// 2: Silent notification
    /// 3: Disable notification
    /// Requires firmware support for getPressureNotifyFlagMode
    public var notifyFlag: Int
    
    /// Repeat
    public var repeats: [IDOWeekObjc]

    enum CodingKeys: String, CodingKey {
        case onOff = "on_off"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case remindOnOff = "remind_on_off"
        case interval = "interval"
        case highThreshold = "high_threshold"
        case stressThreshold = "stress_threshold"
        case notifyFlag = "notify_flag"
        case repeats = "repeat"
    }

    public init(onOff: Int, startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, remindOnOff: Int, interval: Int, highThreshold: Int, stressThreshold: Int = 0, notifyFlag: Int, repeats: [IDOWeekObjc]) {
        self.onOff = onOff
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.remindOnOff = remindOnOff
        self.interval = interval
        self.highThreshold = highThreshold
        self.stressThreshold = stressThreshold
        self.notifyFlag = notifyFlag
        self.repeats = repeats
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        onOff = try container.decode(Int.self, forKey: .onOff)
        startHour = try container.decode(Int.self, forKey: .startHour)
        startMinute = try container.decode(Int.self, forKey: .startMinute)
        endHour = try container.decode(Int.self, forKey: .endHour)
        endMinute = try container.decode(Int.self, forKey: .endMinute)
        notifyFlag = try container.decode(Int.self, forKey: .notifyFlag)
        remindOnOff = try container.decode(Int.self, forKey: .remindOnOff)
        interval = try container.decode(Int.self, forKey: .interval)
        highThreshold = try container.decode(Int.self, forKey: .highThreshold)
        stressThreshold = try container.decode(Int.self, forKey: .stressThreshold)

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
        try container.encode(notifyFlag, forKey: .notifyFlag)
        try container.encode(remindOnOff, forKey: .remindOnOff)
        try container.encode(interval, forKey: .interval)
        try container.encode(highThreshold, forKey: .highThreshold)
        try container.encode(stressThreshold, forKey: .stressThreshold)

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
