//
//  IDOMenstruationRemindParamModel.swift
//  protocol_channel
//
//  Created by hc on 2024/1/24.
//

import Foundation

// MARK: - IDOMenstruationRemindParamModel
@objcMembers public class IDOMenstruationRemindParamModel: NSObject, Codable {
    /// Number of days before start day to send reminder
    public var startDay: Int
    /// Number of days before ovulation day to send reminder
    public var ovulationDay: Int
    /// Reminder time, hour
    public var hour: Int
    /// Reminder time, minute
    public var minute: Int
    /// Number of days before the start of the fertile period to send reminder
    public var pregnancyDayBeforeRemind: Int
    /// Number of days before the end of the fertile period to send reminder
    public var pregnancyDayEndRemind: Int
    /// Number of days before the end of the menstrual period to send reminder
    public var menstrualDayEndRemind: Int

    enum CodingKeys: String, CodingKey {
        case startDay = "start_day"
        case ovulationDay = "ovulation_day"
        case hour = "hour"
        case minute = "minute"
        case pregnancyDayBeforeRemind = "pregnancy_day_before_remind"
        case pregnancyDayEndRemind = "pregnancy_day_end_remind"
        case menstrualDayEndRemind = "menstrual_day_end_remind"
    }

    public init(startDay: Int, ovulationDay: Int, hour: Int, minute: Int, pregnancyDayBeforeRemind: Int, pregnancyDayEndRemind: Int, menstrualDayEndRemind: Int) {
        self.startDay = startDay
        self.ovulationDay = ovulationDay
        self.hour = hour
        self.minute = minute
        self.pregnancyDayBeforeRemind = pregnancyDayBeforeRemind
        self.pregnancyDayEndRemind = pregnancyDayEndRemind
        self.menstrualDayEndRemind = menstrualDayEndRemind
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
