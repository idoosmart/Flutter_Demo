//
//  IDOUpHandGestureModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Raise-to-wake gesture event number

open class IDOUpHandGestureModel(
    endHour: Int,
    endMinute: Int,
    hasTimeRange: Int,
    onOff: Int,
    showSecond: Int,
    startHour: Int,
    startMinute: Int
) : IDOBaseModel {

    /// End time, hour
    @SerializedName("end_hour")
    var endHour: Int = endHour

    /// End time, minute
    @SerializedName("end_minute")
    var endMinute: Int = endMinute

    /// Whether time range is available 1: Yes 0: No
    @SerializedName("has_time_range")
    var hasTimeRange: Int = hasTimeRange

    /// Switch 1: On 0: Off -1:Not Support
    @SerializedName("on_off")
    var onOff: Int = onOff

    /// Screen on duration in seconds
    @SerializedName("show_second")
    var showSecond: Int = showSecond

    /// Start time, hour
    @SerializedName("start_hour")
    var startHour: Int = startHour

    /// Start time, minute
    @SerializedName("start_minute")
    var startMinute: Int = startMinute


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    