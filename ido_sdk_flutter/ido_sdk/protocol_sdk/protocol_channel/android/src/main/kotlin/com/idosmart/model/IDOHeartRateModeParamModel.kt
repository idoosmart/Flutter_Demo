//
//  IDOHeartRateModeParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Set Heart Rate Mode Event

open class IDOHeartRateModeParamModel(
    mode: Int,
    hasTimeRange: Int,
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int,
    measurementInterval: Int
) : IDOBaseModel {

    /// 0: Off
    /// 1: Auto(5min)
    /// 2: Continuous Monitoring(5sec)
    /// 3: Manual Mode
    @SerializedName("mode")
    var mode: Int = mode

    /// Time Range
    /// 0: No
    /// 1: Yes
    @SerializedName("has_time_range")
    var hasTimeRange: Int = hasTimeRange

    /// Start Hour (24-hour format, 0-23)
    @SerializedName("start_hour")
    var startHour: Int = startHour

    /// Start Minute (0-59)
    @SerializedName("start_minute")
    var startMinute: Int = startMinute

    /// End Hour
    @SerializedName("end_hour")
    var endHour: Int = endHour

    /// End Minute
    @SerializedName("end_minute")
    var endMinute: Int = endMinute

    /// Measurement Interval
    /// Unit: minute
    @SerializedName("measurement_interval")
    var measurementInterval: Int = measurementInterval


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    