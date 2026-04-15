//
//  IDOLongSitParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Set Long Sit Event

open class IDOLongSitParamModel(
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int,
    interval: Int,
    repetitions: Int
) : IDOBaseModel {

    /// Start Time of Sedentary Reminder (hour)
    @SerializedName("start_hour")
    var startHour: Int = startHour

    /// Start Time of Sedentary Reminder (minute)
    @SerializedName("start_minute")
    var startMinute: Int = startMinute

    /// End Time of Sedentary Reminder (hour)
    @SerializedName("end_hour")
    var endHour: Int = endHour

    /// End Time of Sedentary Reminder (minute)
    @SerializedName("end_minute")
    var endMinute: Int = endMinute

    /// Interval (in minutes)
    /// Value should be greater than 15 minutes
    @SerializedName("interval")
    var interval: Int = interval

    /// Repetitions and Switch
    /// bit0: 0 means off, 1 means on
    /// bit1-7: 0 means no repetition, 1 means repetition
    @SerializedName("repetitions")
    var repetitions: Int = repetitions


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    