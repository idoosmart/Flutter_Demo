//
//  IDOWorldTimeParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

open class IDOWorldTimeParamModel(
    id: Int,
    minOffset: Int,
    cityName: String,
    sunriseHour: Int,
    sunriseMin: Int,
    sunsetHour: Int,
    sunsetMin: Int,
    longitudeFlag: Int,
    longitude: Int,
    latitudeFlag: Int,
    latitude: Int
) : IDOBaseModel {
    /// Detail ID,Uniqueness
    @SerializedName("id")
    var id: Int = id

    /// Minute offset from current time to UTC 0
    @SerializedName("min_offset")
    var minOffset: Int = minOffset

    /// City name, up to 59 bytes
    @SerializedName("city_name")
    var cityName: String = cityName

    @SerializedName("sunrise_hour")
    var sunriseHour: Int = sunriseHour

    @SerializedName("sunrise_min")
    var sunriseMin: Int = sunriseMin

    @SerializedName("sunset_hour")
    var sunsetHour: Int = sunsetHour

    @SerializedName("sunset_min")
    var sunsetMin: Int = sunsetMin

    /// 1: East longitude 2: West longitude
    @SerializedName("longitude_flag")
    var longitudeFlag: Int = longitudeFlag

    /// Longitude, multiplied by 100, with 2 decimal places
    @SerializedName("longitude")
    var longitude: Int = longitude

    /// 1: North latitude 2: South latitude
    @SerializedName("latitude_flag")
    var latitudeFlag: Int = latitudeFlag

    /// Latitude, multiplied by 100, with 2 decimal places
    @SerializedName("latitude")
    var latitude: Int = latitude

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

}

internal data class Wrap(val version:Int,val items_num:Int,val items:List<IDOWorldTimeParamModel>)

internal fun List<IDOWorldTimeParamModel>.toJsonString(): String {
    val gson = Gson()
    return gson.toJson(Wrap(0,this.size,this))
}
    