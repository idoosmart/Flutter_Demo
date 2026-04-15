//
//  IDOWeatherDataParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import java.io.Serializable
import com.google.gson.annotations.SerializedName

///

// MARK: - IDOWeatherDataParamModel

open class IDOWeatherDataParamModel(
    type: Int,
    temp: Int,
    maxTemp: Int,
    minTemp: Int,
    humidity: Int,
    uvIntensity: Int,
    aqi: Int,
    future: List<IDOWeatherDataFuture>
) : IDOBaseModel {

    /// Weather type
    /// ```
    /// 0x00    Other
    /// 0x01    Sunny
    /// 0x02    Cloudy
    /// 0x03    Overcast
    /// 0x04    Rain
    /// 0x05    Heavy Rain
    /// 0x06    Thunderstorm
    /// 0x07    Snow
    /// 0x08    Sleet
    /// 0x09    Typhoon
    /// 0x0A    Sandstorm
    /// 0x0B    Clear Night
    /// 0x0C    Cloudy Night
    /// 0x0D    Hot
    /// 0x0E    Cold
    /// 0x0F    Gentle Breeze
    /// 0x10    Strong Wind
    /// 0x11    Haze
    /// 0x12    Shower
    /// 0x13    Cloudy to Sunny
    /// 0x30    Thunder
    /// 0x31    Hail
    /// 0x32    Dust
    /// 0x33    Tornado
    /// ```
    @SerializedName("type")
    var type: Int = type

    /// Current temperature
    @SerializedName("temp")
    var temp: Int = temp

    /// Maximum temperature of the day
    @SerializedName("max_temp")
    var maxTemp: Int = maxTemp

    /// Minimum temperature of the day
    @SerializedName("min_temp")
    var minTemp: Int = minTemp

    /// Current humidity
    @SerializedName("humidity")
    var humidity: Int = humidity

    /// Current UV intensity
    @SerializedName("uv_intensity")
    var uvIntensity: Int = uvIntensity

    /// Current air quality index (AQI)
    @SerializedName("aqi")
    var aqi: Int = aqi

    @SerializedName("future")
    var future: List<IDOWeatherDataFuture> = future


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

// MARK: - IDOWeatherDataFuture
open class IDOWeatherDataFuture(type: Int, minTemp: Int, maxTemp: Int) : Serializable {
    /// Weather type
    /// ```
    /// 0x00    Other
    /// 0x01    Sunny
    /// 0x02    Cloudy
    /// 0x03    Overcast
    /// 0x04    Rain
    /// 0x05    Heavy Rain
    /// 0x06    Thunderstorm
    /// 0x07    Snow
    /// 0x08    Sleet
    /// 0x09    Typhoon
    /// 0x0A    Sandstorm
    /// 0x0B    Clear Night
    /// 0x0C    Cloudy Night
    /// 0x0D    Hot
    /// 0x0E    Cold
    /// 0x0F    Gentle Breeze
    /// 0x10    Strong Wind
    /// 0x11    Haze
    /// 0x12    Shower
    /// 0x13    Cloudy to Sunny
    /// 0x30    Thunder
    /// 0x31    Hail
    /// 0x32    Dust
    /// 0x33    Tornado
    /// ```
    @SerializedName("type")
    var type: Int = type

    @SerializedName("min_temp")
    var minTemp: Int = minTemp

    @SerializedName("max_temp")
    var maxTemp: Int = maxTemp

}
