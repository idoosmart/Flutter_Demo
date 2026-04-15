//
//  IDOWeatherSunTimeParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Set sunrise and sunset time event number

open class IDOWeatherSunTimeParamModel(
    sunriseHour: Int,
    sunriseMin: Int,
    sunsetHour: Int,
    sunsetMin: Int
) : IDOBaseModel {

    /// Hour of sunrise   
    @SerializedName("sunrise_hour")
    var sunriseHour: Int = sunriseHour

    /// Minute of sunrise
    @SerializedName("sunrise_min")
    var sunriseMin: Int = sunriseMin

    /// Hour of sunset
    @SerializedName("sunset_hour")
    var sunsetHour: Int = sunsetHour

    /// Minute of sunset
    @SerializedName("sunset_min")
    var sunsetMin: Int = sunsetMin


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    