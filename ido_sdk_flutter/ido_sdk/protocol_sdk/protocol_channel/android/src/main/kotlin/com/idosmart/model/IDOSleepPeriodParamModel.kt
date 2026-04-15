//
//  IDOSleepPeriodParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Set sleep period event

open class IDOSleepPeriodParamModel(
    onOff: Int,
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int
) : IDOBaseModel {

    /// Switch
    /// 1 On
    /// 0 Off 
    @SerializedName("on_off")
    var onOff: Int = onOff

    /// Start time (hour)
    @SerializedName("start_hour")
    var startHour: Int = startHour

    /// Start time (minute)
    @SerializedName("start_minute")
    var startMinute: Int = startMinute

    /// End time (hour)
    @SerializedName("end_hour")
    var endHour: Int = endHour

    /// End time (minute)
    @SerializedName("end_minute")
    var endMinute: Int = endMinute


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    