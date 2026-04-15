//
//  IDONotDisturbStatusModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Get Do Not Disturb mode status event number
@objcMembers
public class IDONotDisturbStatusModel: NSObject, IDOBaseModel {
    /// Switch status
    /// 1: On
    /// 0: Off
    /// -1:Not Support
    public var switchFlag: Int
    /// Start hour
    public var startHour: Int
    /// Start minute
    public var startMinute: Int
    /// End hour
    public var endHour: Int
    /// End minute
    public var endMinute: Int
    /// Whether there is a time range
    /// 0: Invalid
    /// 1: No time range
    /// 2: Has time range
    public var haveTimeRange: Int
    /// Repeat
    /// bit0: Invalid
    /// (bit1 - bit7): Monday to Sunday
    public var weekRepeat: Int
    /// Noon rest switch, headset reminder switch
    /// 1: On
    /// 0: Off
    /// -1:Not Support
    public var noontimeRestOnOff: Int
    /// Reminder start hour
    public var noontimeRestStartHour: Int
    /// Reminder start minute
    public var noontimeRestStartMinute: Int
    /// Reminder end hour
    public var noontimeRestEndHour: Int
    /// Reminder end minute
    public var noontimeRestEndMinute: Int
    /// All day Do Not Disturb switch
    /// 1: On
    /// 0: Off
    /// -1:Not Support
    public var allDayOnOff: Int
    /// Intelligent Do Not Disturb switch
    /// 1: On
    /// 0: Off
    /// -1:Not Support
    public var intelligentOnOff: Int

    enum CodingKeys: String, CodingKey {
        case switchFlag = "switch_flag"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case haveTimeRange = "have_time_range"
        case weekRepeat = "week_repeat"
        case noontimeRestOnOff = "noontime_rest_on_off"
        case noontimeRestStartHour = "noontime_rest_start_hour"
        case noontimeRestStartMinute = "noontime_rest_start_minute"
        case noontimeRestEndHour = "noontime_rest_end_hour"
        case noontimeRestEndMinute = "noontime_rest_end_minute"
        case allDayOnOff = "all_day_on_off"
        case intelligentOnOff = "intelligent_on_off"
    }

    public init(switchFlag: Int, startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, haveTimeRange: Int, weekRepeat: Int, noontimeRestOnOff: Int, noontimeRestStartHour: Int, noontimeRestStartMinute: Int, noontimeRestEndHour: Int, noontimeRestEndMinute: Int, allDayOnOff: Int, intelligentOnOff: Int) {
        self.switchFlag = switchFlag
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.haveTimeRange = haveTimeRange
        self.weekRepeat = weekRepeat
        self.noontimeRestOnOff = noontimeRestOnOff
        self.noontimeRestStartHour = noontimeRestStartHour
        self.noontimeRestStartMinute = noontimeRestStartMinute
        self.noontimeRestEndHour = noontimeRestEndHour
        self.noontimeRestEndMinute = noontimeRestEndMinute
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
