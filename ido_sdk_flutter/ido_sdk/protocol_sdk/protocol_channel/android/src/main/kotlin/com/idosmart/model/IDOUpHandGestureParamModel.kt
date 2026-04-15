//
//  IDOUpHandGestureParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Raise-to-wake gesture event number

open class IDOUpHandGestureParamModel(
    onOff: Int,
    showSecond: Int,
    hasTimeRange: Int,
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int
) : IDOBaseModel {

    /// Switch
    /// 1: On
    /// 0: Off                        
    @SerializedName("on_off")
    var onOff: Int = onOff

    /// Duration for the screen to stay on, in seconds
    @SerializedName("show_second")
    var showSecond: Int = showSecond

    /// Whether there is a time range
    /// 1: Yes
    /// 0: No 
    @SerializedName("has_time_range")
    var hasTimeRange: Int = hasTimeRange

    /// Starting hour of the time range
    @SerializedName("start_hour")
    var startHour: Int = startHour

    /// Starting minute of the time range
    @SerializedName("start_minute")
    var startMinute: Int = startMinute

    /// Ending hour of the time range
    @SerializedName("end_hour")
    var endHour: Int = endHour

    /// Ending minute of the time range
    @SerializedName("end_minute")
    var endMinute: Int = endMinute


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    