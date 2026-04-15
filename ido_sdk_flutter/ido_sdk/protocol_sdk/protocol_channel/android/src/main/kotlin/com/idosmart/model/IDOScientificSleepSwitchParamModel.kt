package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

class IDOScientificSleepSwitchParamModel(
    mode: Int,
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int
) : IDOBaseModel {

    /// Mode
    /// 2: Scientific sleep
    /// 1: Normal sleep
    @SerializedName("mode")
    var mode: Int = mode

    /// Start time - hour
    @SerializedName("start_hour")
    var startHour: Int = startHour

    /// Start time - minute
    @SerializedName("start_minute")
    var startMinute: Int = startMinute

    /// End time - hour
    @SerializedName("end_hour")
    var endHour: Int = endHour

    /// End time - minute
    @SerializedName("end_minute")
    var endMinute: Int = endMinute

    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

}