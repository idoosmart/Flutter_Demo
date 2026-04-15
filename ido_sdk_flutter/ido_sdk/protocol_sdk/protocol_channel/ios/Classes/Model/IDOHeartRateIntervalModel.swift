//
//  IDOHeartRateIntervalModel.swift
//  protocol_channel
//
//  Created by hc on 2024/1/8.
//

import Foundation


@objcMembers
public class IDOHeartRateIntervalModel: NSObject, IDOBaseModel {
    /// 脂肪训练心率区间
    /// 计算规则:最大心率的50%-69%
    /// 单位:次/分钟
    ///
    /// Fat training heart rate zone
    ///Calculation rules: 50%-69% of maximum heart rate
    /// Unit: times/minute
    public var burnFatThreshold: Int
    
    /// 心肺训练心率区间
    /// 计算规则:最大心率的70%-84%
    /// 单位:次/分钟
    ///
    /// Cardio training heart rate zones
    /// Calculation rule: 70%-84% of maximum heart rate
    /// Unit: times/minute
    public var aerobicThreshold: Int
    
    /// 峰值训练心率区间
    /// 计算规则:最大心率的85%-100%
    /// 单位:次/分钟
    ///
    /// Peak training heart rate zone
    /// Calculation rules: 85%-100% of maximum heart rate
    /// Unit: times/minute
    public var limitThreshold: Int
    
    /// 心率上限,最大心率提醒
    /// 单位:次/分钟
    ///
    /// Heart rate upper limit, maximum heart rate reminder
    /// Unit: times/minute
    public var userMaxHr: Int
    
    /// 热身运动心率区间
    /// 计算规则：(200-年龄) * 50
    /// 单位:次/分钟
    ///
    /// Warm-up exercise heart rate zone
    /// Calculation rule: (200-age) * 50
    /// Unit: times/minute
    public var range1: Int
    
    /// 脂肪燃烧心率区间
    /// 计算规则：(200-年龄) * 60
    /// 单位:次/分钟
    ///
    /// Fat burning heart rate zone
    /// Calculation rule: (200-age) * 60
    /// Unit: times/minute
    public var range2: Int
    
    /// 有氧运动心率区间
    /// 计算规则：(200-年龄) * 70
    /// 单位:次/分钟
    ///
    /// Aerobic exercise heart rate zones
    /// Calculation rule: (200-age) * 70
    /// Unit: times/minute
    public var range3: Int
    
    /// 无氧运动心率区间
    /// 计算规则：(200-年龄) * 80
    /// 单位:次/分钟
    ///
    /// Anaerobic exercise heart rate zone
    /// Calculation rule: (200-age) * 80
    /// Unit: times/minute
    public var range4: Int
    
    /// 极限锻炼心率区间
    /// 计算规则：(200-年龄) * 90
    /// 单位:次/分钟
    ///
    /// Extreme exercise heart rate zone
    /// Calculation rule: (200-age) * 90
    /// Unit: times/minute
    public var range5: Int
    
    /// 心率最小值
    /// 单位:次/分钟
    ///
    ///Minimum heart rate
    /// Unit: times/minute
    public var minHr: Int
    
    /// 最大心率提醒
    /// 0 关闭,1 开启
    ///
    /// Maximum heart rate reminder
    /// 0 off, 1 on
    public var maxHrRemind: Int
    
    /// 最小心率提醒
    /// 0 关闭,1 开启
    ///
    /// Minimum heart rate reminder
    /// 0 off, 1 on
    public var minHrRemind: Int
    
    /// 提醒开始 时
    /// Reminder starts hour
    public var remindStartHour: Int
    
    /// 提醒开始 分
    /// Reminder starts minutes
    public var remindStartMinute: Int
    
    /// 提醒结束 时
    /// Reminder ends hour
    public var remindStopHour: Int
    
    /// 提醒结束 分
    /// Reminder ends minutes
    public var remindStopMinute: Int
    
    enum CodingKeys: String, CodingKey {
        case burnFatThreshold = "burn_fat_threshold"
        case aerobicThreshold = "aerobic_threshold"
        case limitThreshold = "limit_threshold"
        case userMaxHr = "user_max_hr"
        case range1, range2, range3, range4, range5
        case minHr = "min_hr"
        case maxHrRemind = "max_hr_remind"
        case minHrRemind = "min_hr_remind"
        case remindStartHour = "remind_start_hour"
        case remindStartMinute = "remind_start_minute"
        case remindStopHour = "remind_stop_hour"
        case remindStopMinute = "remind_stop_minute"
    }
    
    public init(burnFatThreshold: Int, aerobicThreshold: Int, limitThreshold: Int, userMaxHr: Int, range1: Int, range2: Int, range3: Int, range4: Int, range5: Int, minHr: Int, maxHrRemind: Int, minHrRemind: Int, remindStartHour: Int, remindStartMinute: Int, remindStopHour: Int, remindStopMinute: Int) {
        self.burnFatThreshold = burnFatThreshold
        self.aerobicThreshold = aerobicThreshold
        self.limitThreshold = limitThreshold
        self.userMaxHr = userMaxHr
        self.range1 = range1
        self.range2 = range2
        self.range3 = range3
        self.range4 = range4
        self.range5 = range5
        self.minHr = minHr
        self.maxHrRemind = maxHrRemind
        self.minHrRemind = minHrRemind
        self.remindStartHour = remindStartHour
        self.remindStartMinute = remindStartMinute
        self.remindStopHour = remindStopHour
        self.remindStopMinute = remindStopMinute
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
