//
//  IDONotDisturbParamModel.swift
//  protocol_channel
//
//  Created by hc on 2024/1/24.
//

import Foundation

// MARK: - IDONotDisturbParamModel
@objcMembers public class IDONotDisturbParamModel: NSObject, Codable {
    /// Switch 1 is on, 0 is off
    public var switchFlag: Int
    /// Start time
    public var startHour: Int
    /// Start time minutes
    public var startMinute: Int
    /// End time
    public var endHour: Int
    /// End time minutes
    public var endMinute: Int
    /// Whether there is a time range
    /// 0 invalid
    /// 1 means no time range
    /// 2 means there is a time range
    /// The menu disturbHaveRangRepeat is enabled when enabled
    public var haveTimeRange: Int
    /// Daytime Do Not Disturb switch 1 is on, 0 is off
    public var noontimeRESTOnOff: Int
    /// Start time
    public var noontimeRESTStartHour: Int
    /// Start time minutes
    public var noontimeRESTStartMinute: Int
    /// End time
    public var noontimeRESTEndHour: Int
    /// End time minutes
    public var noontimeRESTEndMinute: Int
    /// Do not disturb me all day
    /// 1 open
    /// 0 close
    /// The menu setOnlyNoDisturbAllDayOnOff is enabled when enabled
    public var allDayOnOff: Int
    ///Smart Do Not Disturb Switch
    /// 1 open
    /// 0 close
    /// The menu setOnlyNoDisturbSmartOnOff is enabled when enabled
    public var intelligentOnOff: Int
    
    enum CodingKeys: String, CodingKey {
        case switchFlag = "switch_flag"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case haveTimeRange = "have_time_range"
        case noontimeRESTOnOff = "noontime_rest_on_off"
        case noontimeRESTStartHour = "noontime_rest_start_hour"
        case noontimeRESTStartMinute = "noontime_rest_start_minute"
        case noontimeRESTEndHour = "noontime_rest_end_hour"
        case noontimeRESTEndMinute = "noontime_rest_end_minute"
        case allDayOnOff = "all_day_on_off"
        case intelligentOnOff = "intelligent_on_off"
    }
    
    public init(switchFlag: Int, startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, haveTimeRange: Int = 0, noontimeRESTOnOff: Int, noontimeRESTStartHour: Int, noontimeRESTStartMinute: Int, noontimeRESTEndHour: Int, noontimeRESTEndMinute: Int, allDayOnOff: Int = 0, intelligentOnOff: Int = 0) {
        self.switchFlag = switchFlag
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.haveTimeRange = haveTimeRange
        self.noontimeRESTOnOff = noontimeRESTOnOff
        self.noontimeRESTStartHour = noontimeRESTStartHour
        self.noontimeRESTStartMinute = noontimeRESTStartMinute
        self.noontimeRESTEndHour = noontimeRESTEndHour
        self.noontimeRESTEndMinute = noontimeRESTEndMinute
        self.allDayOnOff = allDayOnOff
        self.intelligentOnOff = intelligentOnOff
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
