//
//  IDOLongSitParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Set Long Sit Event
@objcMembers
public class IDOLongSitParamModel: NSObject, IDOBaseModel {
    /// Start Time of Sedentary Reminder (hour)
    public var startHour: Int
    /// Start Time of Sedentary Reminder (minute)
    public var startMinute: Int
    /// End Time of Sedentary Reminder (hour)
    public var endHour: Int
    /// End Time of Sedentary Reminder (minute)
    public var endMinute: Int
    /// Interval (in minutes)
    /// Value should be greater than 15 minutes
    public var interval: Int
    /// Repetitions and Switch
    /// bit0: 0 means off, 1 means on
    /// bit1-7: 0 means no repetition, 1 means repetition
    public var repetitions: Int
    
    enum CodingKeys: String, CodingKey {
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case interval = "interval"
        case repetitions = "repetitions"
    }
    
    public init(startHour: Int,startMinute: Int,endHour: Int,endMinute: Int,interval: Int,repetitions: Int) {
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.interval = interval
        self.repetitions = repetitions
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

