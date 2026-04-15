package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

open class IDOMenstruationRemindParamModel(
    startDay: Int,
    ovulationDay: Int,
    hour: Int,
    minute: Int,
    pregnancyDayBeforeRemind: Int,
    pregnancyDayEndRemind: Int,
    menstrualDayEndRemind: Int
) : IDOBaseModel {
    // Number of days before start day to send reminder
    @SerializedName("start_day")
    var startDay = startDay

    // Number of days before ovulation day to send reminder
    @SerializedName("ovulation_day")
    var ovulationDay = ovulationDay

    // Reminder time, hour
    @SerializedName("hour")
    var hour = hour

    // Reminder time, minute
    @SerializedName("minute")
    var minute = minute

    // Number of days before the start of the fertile period to send reminder
    @SerializedName("pregnancy_day_before_remind")
    var pregnancyDayBeforeRemind = pregnancyDayBeforeRemind

    // Number of days before the end of the fertile period to send reminder
    @SerializedName("pregnancy_day_end_remind")
    var pregnancyDayEndRemind = pregnancyDayEndRemind

    // Number of days before the end of the menstrual period to send reminder
    @SerializedName("menstrual_day_end_remind")
    var menstrualDayEndRemind = menstrualDayEndRemind

    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

}