package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

open class IDONotDisturbParamModel(

    switchFlag: Int,
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int,
    haveTimeRange: Int?,
    noontimeRESTOnOff: Int,
    noontimeRESTStartHour: Int,
    noontimeRESTStartMinute: Int,
    noontimeRESTEndHour: Int,
    noontimeRESTEndMinute: Int,
    allDayOnOff: Int?,
    intelligentOnOff: Int?


) : IDOBaseModel {
    // Switch 1 is on, 0 is off
    @SerializedName("switch_flag")
    var switchFlag = switchFlag

    // Start time
    @SerializedName("start_hour")
    var startHour = startHour

    // Start time minutes
    @SerializedName("start_minute")
    var startMinute = startMinute

    // End time
    @SerializedName("end_hour")
    var endHour = endHour

    // End time minutes
    @SerializedName("end_minute")
    var endMinute = endMinute

    /** Whether there is a time range
     * 0 invalid
     * 1 means no time range
     * 2 means there is a time range
     * The menu disturbHaveRangRepeat is enabled when enabled
     */
    @SerializedName("have_time_range")
    var haveTimeRange = haveTimeRange

    // Daytime Do Not Disturb switch 1 is on, 0 is off
    @SerializedName("noontime_rest_on_off")
    var noontimeRESTOnOff = noontimeRESTOnOff

    // Start time
    @SerializedName("noontime_rest_start_hour")
    var noontimeRESTStartHour = noontimeRESTStartHour

    // Start time minutes
    @SerializedName("noontime_rest_start_minute")
    var noontimeRESTStartMinute = noontimeRESTStartMinute

    // End time
    @SerializedName("noontime_rest_end_hour")
    var noontimeRESTEndHour = noontimeRESTEndHour

    // End time minutes
    @SerializedName("noontime_rest_end_minute")
    var noontimeRESTEndMinute = noontimeRESTEndMinute

    /** Do not disturb me all day
     *  1 open
     *  0 close
     * The menu setOnlyNoDisturbAllDayOnOff is enabled when enabled
     * */
    @SerializedName("all_day_on_off")
    var allDayOnOff = allDayOnOff

    /**Smart Do Not Disturb Switch
     *1 open
     * 0 close
     * The menu setOnlyNoDisturbSmartOnOff is enabled when enabled
     */
    @SerializedName("intelligent_on_off")
    var intelligentOnOff = intelligentOnOff


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}