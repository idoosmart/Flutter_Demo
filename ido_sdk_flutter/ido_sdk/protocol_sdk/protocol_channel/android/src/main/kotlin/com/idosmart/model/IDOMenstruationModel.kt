//
//  IDOMtuInfoModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
///IDOMenstruationModel

open class IDOMenstruationModel(
    onOff: Int,
    menstrualLength: Int,
    menstrualCycle: Int,
    lastMenstrualYear: Int,
    lastMenstrualMonth: Int,
    lastMenstrualDay: Int,
    ovulationIntervalDay: Int,
    ovulationBeforeDay: Int,
    ovulationAfterDay: Int,
    notifyFlag: Int,
    menstrualReminderOnOff: Int
) :
    IDOBaseModel {

    /// 经期开关 1开 0关闭
    /// Menstrual period switch 1 on 0 off
    @SerializedName("on_off")
    var onOff: Int = onOff

    /// 经期长度
    /// menstrual period length
    @SerializedName("menstrual_length")
    var menstrualLength: Int = menstrualLength

    /// 经期周期
    /// menstrual cycle
    @SerializedName("menstrual_cycle")
    var menstrualCycle: Int = menstrualCycle

    /// 最近一次经期开始时间 年
    /// Last menstrual period started year
    @SerializedName("last_menstrual_year")
    var lastMenstrualYear: Int = lastMenstrualYear

    /// 最近一次经期开始时间 月
    /// Last menstrual period start time month
    @SerializedName("last_menstrual_month")
    var lastMenstrualMonth: Int = lastMenstrualMonth

    /// 最近一次经期开始时间 日
    /// Last menstrual period start date
    @SerializedName("last_menstrual_day")
    var lastMenstrualDay: Int = lastMenstrualDay

    /// 从下一个经期开始前到排卵日的间隔,一般为14天
    /// The interval from the start of the next menstrual period to the day of ovulation is generally 14 days
    @SerializedName("ovulation_interval_day")
    var ovulationIntervalDay: Int = ovulationIntervalDay

    /// 排卵日之前易孕期的天数,一般为5
    /// The number of fertile days before ovulation, usually 5
    @SerializedName("ovulation_before_day")
    var ovulationBeforeDay: Int = ovulationBeforeDay

    /// 排卵日之后易孕期的天数,一般为5
    /// The number of fertile days after ovulation, usually 5
    @SerializedName("ovulation_after_day")
    var ovulationAfterDay: Int = ovulationAfterDay

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
    @SerializedName("notify_flag")
    var notifyFlag: Int = notifyFlag

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
    @SerializedName("menstrual_reminder_on_off")
    var menstrualReminderOnOff: Int = menstrualReminderOnOff

    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    