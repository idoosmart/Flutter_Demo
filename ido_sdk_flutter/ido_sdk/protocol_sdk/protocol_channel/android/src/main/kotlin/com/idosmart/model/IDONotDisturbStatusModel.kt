//
//  IDONotDisturbStatusModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get Do Not Disturb mode status event number

open class IDONotDisturbStatusModel(
    switchFlag: Int,
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int,
    haveTimeRange: Int,
    weekRepeat: Int,
    noontimeRestOnOff: Int,
    noontimeRestStartHour: Int,
    noontimeRestStartMinute: Int,
    noontimeRestEndHour: Int,
    noontimeRestEndMinute: Int,
    allDayOnOff: Int,
    intelligentOnOff: Int
) : IDOBaseModel {

    /// Switch status
    /// 1: On
    /// 0: Off
    /// -1:Not Support
    @SerializedName("switch_flag")
    var switchFlag: Int = switchFlag

    /// Start hour
    @SerializedName("start_hour")
    var startHour: Int = startHour

    /// Start minute
    @SerializedName("start_minute")
    var startMinute: Int = startMinute

    /// End hour
    @SerializedName("end_hour")
    var endHour: Int = endHour

    /// End minute
    @SerializedName("end_minute")
    var endMinute: Int = endMinute

    /// Whether there is a time range
    /// 0: Invalid
    /// 1: No time range
    /// 2: Has time range
    @SerializedName("have_time_range")
    var haveTimeRange: Int = haveTimeRange

    /// Repeat
    /// bit0: Invalid
    /// (bit1 - bit7): Monday to Sunday
    @SerializedName("week_repeat")
    var weekRepeat: Int = weekRepeat

    /// Noon rest switch, headset reminder switch
    /// 1: On
    /// 0: Off
    /// -1:Not Support
    @SerializedName("noontime_rest_on_off")
    var noontimeRestOnOff: Int = noontimeRestOnOff

    /// Reminder start hour
    @SerializedName("noontime_rest_start_hour")
    var noontimeRestStartHour: Int = noontimeRestStartHour

    /// Reminder start minute
    @SerializedName("noontime_rest_start_minute")
    var noontimeRestStartMinute: Int = noontimeRestStartMinute

    /// Reminder end hour
    @SerializedName("noontime_rest_end_hour")
    var noontimeRestEndHour: Int = noontimeRestEndHour

    /// Reminder end minute
    @SerializedName("noontime_rest_end_minute")
    var noontimeRestEndMinute: Int = noontimeRestEndMinute

    /// All day Do Not Disturb switch
    /// 1: On
    /// 0: Off
    /// -1:Not Support
    @SerializedName("all_day_on_off")
    var allDayOnOff: Int = allDayOnOff

    /// Intelligent Do Not Disturb switch
    /// 1: On
    /// 0: Off
    /// -1:Not Support
    @SerializedName("intelligent_on_off")
    var intelligentOnOff: Int = intelligentOnOff


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    