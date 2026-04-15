//
//  IDOHeartRateModeModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Set Heart Rate Mode Event

open class IDOHeartRateModeModel(
    mode: Int,
    hasTimeRange: Int,
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int,
    measurementInterval: Int
) : IDOBaseModel {

    /// 0: Turned Off
    /// 1: Manual Mode
    /// 2: Automatic
    /// 3: Continous Monitoring
    /// -1:Invalid
    @SerializedName("mode")
    var mode: Int = mode

    /// Whether there is a time range 0: No 1: Yes
    @SerializedName("has_time_range")
    var hasTimeRange: Int = hasTimeRange

    @SerializedName("start_hour")
    var startHour: Int = startHour

    @SerializedName("start_minute")
    var startMinute: Int = startMinute

    @SerializedName("end_hour")
    var endHour: Int = endHour

    @SerializedName("end_minute")
    var endMinute: Int = endMinute

    /// Measurement interval (in minutes)
    @SerializedName("measurement_interval")
    var measurementInterval: Int = measurementInterval


    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    