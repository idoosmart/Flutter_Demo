//
//  IDOHeartRateModeModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Set Heart Rate Mode Event
@objcMembers
public class IDOHeartRateModeModel: NSObject, IDOBaseModel {
    /// 0: Turned Off
    /// 1: Manual Mode
    /// 2: Automatic
    /// 3: Continous Monitoring
    /// -1:Invalid
    public var mode: Int
    /// Whether there is a time range 0: No 1: Yes
    public var hasTimeRange: Int
    public var startHour: Int
    public var startMinute: Int
    public var endHour: Int
    public var endMinute: Int
    /// Measurement interval (in minutes)
    public var measurementInterval: Int
    
    enum CodingKeys: String, CodingKey {
        case mode
        case hasTimeRange = "has_time_range"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case measurementInterval = "measurement_interval"
    }
    
    public init(mode: Int, hasTimeRange: Int, startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, measurementInterval: Int) {
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

