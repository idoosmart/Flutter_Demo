//
//  IDOHeartModeParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///

// MARK: - IDOHeartRateIntervalModel

open class IDOHeartRateIntervalModel(
    burnFatThreshold: Int,
    aerobicThreshold: Int,
    limitThreshold: Int,
    userMaxHr: Int,
    range1: Int,
    range2: Int,
    range3: Int,
    range4: Int,
    range5: Int,
    minHr: Int,
    maxHrRemind: Int,
    minHrRemind: Int,
    remindStartHour: Int,
    remindStartMinute: Int,
    remindStopHour: Int,
    remindStopMinute: Int
) : IDOBaseModel {

    /// 脂肪训练心率区间
    /// 计算规则:最大心率的50%-69%
    /// 单位:次/分钟
    ///
    /// Fat training heart rate zone
    ///Calculation rules: 50%-69% of maximum heart rate
    /// Unit: times/minute
    @SerializedName("burn_fat_threshold")
    var burnFatThreshold: Int = burnFatThreshold

    /// 心肺训练心率区间
    /// 计算规则:最大心率的70%-84%
    /// 单位:次/分钟
    ///
    /// Cardio training heart rate zones
    /// Calculation rule: 70%-84% of maximum heart rate
    /// Unit: times/minute
    @SerializedName("aerobic_threshold")
    var aerobicThreshold: Int = aerobicThreshold

    /// 峰值训练心率区间
    /// 计算规则:最大心率的85%-100%
    /// 单位:次/分钟
    ///
    /// Peak training heart rate zone
    /// Calculation rules: 85%-100% of maximum heart rate
    /// Unit: times/minute
    @SerializedName("limit_threshold")
    var limitThreshold: Int = limitThreshold

    /// 心率上限,最大心率提醒
    /// 单位:次/分钟
    ///
    /// Heart rate upper limit, maximum heart rate reminder
    /// Unit: times/minute
    @SerializedName("user_max_hr")
    var userMaxHr: Int = userMaxHr

    /// 热身运动心率区间
    /// 计算规则：(200-年龄) * 50
    /// 单位:次/分钟
    ///
    /// Warm-up exercise heart rate zone
    /// Calculation rule: (200-age) * 50
    /// Unit: times/minute
    @SerializedName("range1")
    var range1: Int = range1

    /// 脂肪燃烧心率区间
    /// 计算规则：(200-年龄) * 60
    /// 单位:次/分钟
    ///
    /// Fat burning heart rate zone
    /// Calculation rule: (200-age) * 60
    /// Unit: times/minute
    @SerializedName("range2")
    var range2: Int = range2

    /// 有氧运动心率区间
    /// 计算规则：(200-年龄) * 70
    /// 单位:次/分钟
    ///
    /// Aerobic exercise heart rate zones
    /// Calculation rule: (200-age) * 70
    /// Unit: times/minute
    @SerializedName("range3")
    var range3: Int = range3

    /// 无氧运动心率区间
    /// 计算规则：(200-年龄) * 80
    /// 单位:次/分钟
    ///
    /// Anaerobic exercise heart rate zone
    /// Calculation rule: (200-age) * 80
    /// Unit: times/minute
    @SerializedName("range4")
    var range4: Int = range4

    /// 极限锻炼心率区间
    /// 计算规则：(200-年龄) * 90
    /// 单位:次/分钟
    ///
    /// Extreme exercise heart rate zone
    /// Calculation rule: (200-age) * 90
    /// Unit: times/minute
    @SerializedName("range5")
    var range5: Int = range5

    /// 心率最小值
    /// 单位:次/分钟
    ///
    ///Minimum heart rate
    /// Unit: times/minute
    @SerializedName("min_hr")
    var minHr: Int = minHr

    /// 最大心率提醒
    /// 0 关闭,1 开启
    ///
    /// Maximum heart rate reminder
    /// 0 off, 1 on
    @SerializedName("max_hr_remind")
    var maxHrRemind: Int = maxHrRemind

    /// 最小心率提醒
    /// 0 关闭,1 开启
    ///
    /// Minimum heart rate reminder
    /// 0 off, 1 on
    @SerializedName("min_hr_remind")
    var minHrRemind: Int = minHrRemind

    /// 提醒开始 时
    /// Reminder starts hour
    @SerializedName("remind_start_hour")
    var remindStartHour: Int = remindStartHour

    /// 提醒开始 分
    /// Reminder starts minutes
    @SerializedName("remind_start_minute")
    var remindStartMinute: Int = remindStartMinute

    /// 提醒结束 时
    /// Reminder ends hour
    @SerializedName("remind_stop_hour")
    var remindStopHour: Int = remindStopHour

    /// 提醒结束 分
    /// Reminder ends minutes
    @SerializedName("remind_stop_minute")
    var remindStopMinute: Int = remindStopMinute


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
