//
//  IDOHeartRateModeParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Set Heart Rate Mode Event
@objcMembers
public class IDOHeartRateModeParamModel: NSObject, IDOBaseModel {
    /// 0: Off
    /// 1: Auto(5min)
    /// 2: Continuous Monitoring(5sec)
    /// 3: Manual Mode
    public var mode: Int
    /// Time Range
    /// 0: No
    /// 1: Yes
    public var hasTimeRange: Int
    /// Start Hour (24-hour format, 0-23)
    public var startHour: Int
    /// Start Minute (0-59)
    public var startMinute: Int
    /// End Hour
    public var endHour: Int
    /// End Minute
    public var endMinute: Int
    /// Measurement Interval
    /// Unit: minute
    public var measurementInterval: Int
    
    enum CodingKeys: String, CodingKey {
        case mode = "mode"
        case hasTimeRange = "has_time_range"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case measurementInterval = "measurement_interval"
    }
    
    public init(mode: Int,hasTimeRange: Int,startHour: Int,startMinute: Int,endHour: Int,endMinute: Int,measurementInterval: Int) {
        self.mode = mode
        self.hasTimeRange = hasTimeRange
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.measurementInterval = measurementInterval
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

