//
//  IDOV3NoiseParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Set Environmental Noise Volume On/Off and Threshold Event

open class IDOV3NoiseParamModel(
    mode: Int,
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int,
    highNoiseOnOff: Int,
    highNoiseValue: Int
) : IDOBaseModel {

    /// All-day environmental noise volume switch
    /// 1: On
    /// 0: Off 
    @SerializedName("mode")
    var mode: Int = mode

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

    /// Threshold switch
    /// 1: On
    /// 0: Off                      
    @SerializedName("high_noise_on_off")
    var highNoiseOnOff: Int = highNoiseOnOff

    /// Threshold value
    @SerializedName("high_noise_value")
    var highNoiseValue: Int = highNoiseValue


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    