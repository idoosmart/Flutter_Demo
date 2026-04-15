//
//  IDOMenstruationModel.swift
//  protocol_channel
//
//  Created by hc on 2024/1/8.
//

import Foundation

@objcMembers
public class IDOMenstruationModel: NSObject, IDOBaseModel {
    /// 经期开关 1开 0关闭
    /// Menstrual period switch 1 on 0 off
    public var onOff: Int
    
    /// 经期长度
    /// menstrual period length
    public var menstrualLength: Int
    
    /// 经期周期
    /// menstrual cycle
    public var menstrualCycle: Int
    
    /// 最近一次经期开始时间 年
    /// Last menstrual period started year
    public var lastMenstrualYear: Int
    
    /// 最近一次经期开始时间 月
    /// Last menstrual period start time month
    public var lastMenstrualMonth: Int
    
    /// 最近一次经期开始时间 日
    /// Last menstrual period start date
    public var lastMenstrualDay: Int
    
    /// 从下一个经期开始前到排卵日的间隔,一般为14天
    /// The interval from the start of the next menstrual period to the day of ovulation is generally 14 days
    public var ovulationIntervalDay: Int
    
    /// 排卵日之前易孕期的天数,一般为5
    /// The number of fertile days before ovulation, usually 5
    public var ovulationBeforeDay: Int
    
    /// 排卵日之后易孕期的天数,一般为5
    /// The number of fertile days after ovulation, usually 5
    public var ovulationAfterDay: Int
    
    /// 通知类型
    /// 0：无效
    /// 1：允许通知
    /// 2：静默通知
    /// 3：关闭通知
    /// 需要固件开启功能表支持 getMenstrualAddNotifyFlagV3
    ///
    /// Notification type
    /// 0: invalid
    /// 1: Allow notifications
    /// 2: Silent notification
    /// 3: Close notification
    /// Requires firmware to enable menu support getMenstrualAddNotifyFlagV3
    public var notifyFlag: Int
    
    /// 经期提醒开关开关
    /// 1:开
    /// 0:关闭
    /// 需要固件开启功能表支持 getSupportSetMenstrualReminderOnOff
    /// 该开关无效时，功能开启就默认提醒。
    ///
    ///Menstrual reminder switch
    /// 1:On
    /// 0: Close
    /// Requires firmware to enable menu support getSupportSetMenstrualReminderOnOff
    /// When this switch is invalid, the default reminder will be when the function is turned on.
    public var menstrualReminderOnOff: Int
    
    enum CodingKeys: String, CodingKey {
        case onOff = "on_off"
        case menstrualLength = "menstrual_length"
        case menstrualCycle = "menstrual_cycle"
        case lastMenstrualYear = "last_menstrual_year"
        case lastMenstrualMonth = "last_menstrual_month"
        case lastMenstrualDay = "last_menstrual_day"
        case ovulationIntervalDay = "ovulation_interval_day"
        case ovulationBeforeDay = "ovulation_before_day"
        case ovulationAfterDay = "ovulation_after_day"
        case notifyFlag = "notify_flag"
        case menstrualReminderOnOff = "menstrual_reminder_on_off"
    }
    
    public init(onOff: Int, menstrualLength: Int, menstrualCycle: Int, lastMenstrualYear: Int, lastMenstrualMonth: Int, lastMenstrualDay: Int, ovulationIntervalDay: Int, ovulationBeforeDay: Int, ovulationAfterDay: Int, notifyFlag: Int, menstrualReminderOnOff: Int) {
        self.onOff = onOff
        self.menstrualLength = menstrualLength
        self.menstrualCycle = menstrualCycle
        self.lastMenstrualYear = lastMenstrualYear
        self.lastMenstrualMonth = lastMenstrualMonth
        self.lastMenstrualDay = lastMenstrualDay
        self.ovulationIntervalDay = ovulationIntervalDay
        self.ovulationBeforeDay = ovulationBeforeDay
        self.ovulationAfterDay = ovulationAfterDay
        self.notifyFlag = notifyFlag
        self.menstrualReminderOnOff = menstrualReminderOnOff
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
