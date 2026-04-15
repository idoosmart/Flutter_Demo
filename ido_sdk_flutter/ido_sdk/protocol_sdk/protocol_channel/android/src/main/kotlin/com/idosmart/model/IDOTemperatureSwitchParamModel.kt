//
//  IDOTemperatureSwitchParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.annotations.SerializedName

import com.google.gson.Gson
import com.google.gson.GsonBuilder

///
/// Set Night-time Temperature Switch Event Code

open class IDOTemperatureSwitchParamModel(
    mode: Int,
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int,
    unit: Int
) : IDOBaseModel {

    /// Mode:
    /// 1: On
    /// 0: Off
    @SerializedName("mode")
    var mode: Int = mode

    /// Start time, hour
    @SerializedName("start_hour")
    var startHour: Int = startHour

    /// Start time, minute
    @SerializedName("start_minute")
    var startMinute: Int = startMinute

    /// End time, hour
    @SerializedName("end_hour")
    var endHour: Int = endHour

    /// End time, minute
    @SerializedName("end_minute")
    var endMinute: Int = endMinute

    /// Temperature unit setting:
    /// 1 :Celsius
    /// 2 :Fahrenheit
    @SerializedName("unit")
    var unit: Int = unit


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    