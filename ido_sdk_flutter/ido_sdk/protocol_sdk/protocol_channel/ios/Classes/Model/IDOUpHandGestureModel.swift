//
//  IDOUpHandGestureModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Raise-to-wake gesture event number
@objcMembers
public class IDOUpHandGestureModel: NSObject, IDOBaseModel {
    /// End time, hour
    public var endHour: Int
    /// End time, minute
    public var endMinute: Int
    /// Whether time range is available 1: Yes 0: No
    public var hasTimeRange: Int
    /// Switch 1: On 0: Off -1:Not Support
    public var onOff: Int
    /// Screen on duration in seconds
    public var showSecond: Int
    /// Start time, hour
    public var startHour: Int
    /// Start time, minute
    public var startMinute: Int
    
    enum CodingKeys: String, CodingKey {
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case hasTimeRange = "has_time_range"
        case onOff = "on_off"
        case showSecond = "show_second"
        case startHour = "start_hour"
        case startMinute = "start_minute"
    }
    
    public init(endHour: Int, endMinute: Int, hasTimeRange: Int, onOff: Int, showSecond: Int, startHour: Int, startMinute: Int) {
        self.endHour = endHour
        self.endMinute = endMinute
        self.hasTimeRange = hasTimeRange
        self.onOff = onOff
        self.showSecond = showSecond
        self.startHour = startHour
        self.startMinute = startMinute
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
