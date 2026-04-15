//
//  IDOWeatherV3ParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName
import java.io.Serializable

///

/// V3设置天气数据

open class IDOWeatherV3ParamModel(
    month: Int,
    day: Int,
    hour: Int,
    min: Int,
    sec: Int,
    week: Int,
    weatherType: Int,
    todayTmp: Int,
    todayMaxTemp: Int,
    todayMinTemp: Int,
    cityName: String,
    airQuality: Int,
    precipitationProbability: Int,
    humidity: Int,
    todayUvIntensity: Int,
    windSpeed: Int,
    windForce: Int,
    sunriseHour: Int,
    sunriseMin: Int,
    sunsetHour: Int,
    sunsetMin: Int,
    sunriseItemNum: Int,
    airGradeItem: String,
    hoursWeatherItems: List<IDOHoursWeatherItem>,
    futureItems: List<IDOFutureItem>,
    sunriseItem: List<IDOSunriseItem>,
    aqiFutureItem: List<Int>? = null,
    aqiHistoryItem: List<Int>? = null
) : IDOBaseModel {

    @SerializedName("version")
    private var version: Int = 1

    @SerializedName("month")
    var month: Int = month

    @SerializedName("day")
    var day: Int = day

    @SerializedName("hour")
    var hour: Int = hour

    @SerializedName("min")
    var min: Int = min

    @SerializedName("sec")
    var sec: Int = sec

    /// The day of the week
    /// bit0: Monday
    /// bit1: Tuesday and so on up to Sunday
    @SerializedName("week")
    var week: Int = week

    ///
    /// Weather type
    /// ```
    /// 0: Other
    /// 1: Sunny
    /// 2: Cloudy
    /// 3: Overcast
    /// 4: Rain
    /// 5: Heavy rain
    /// 6: Thunderstorm
    /// 7: Snow
    /// 8: Sleet
    /// 9: Typhoon
    /// 10: Sandstorm
    /// 11: Night clear
    /// 12: Night cloudy
    /// 13: Hot
    /// 14: Cold
    /// 15: Gentle breeze
    /// 16: Strong wind
    /// 17: Haze
    /// 18: Shower
    /// 19: Cloudy to sunny
    /// 48: Thunder
    /// 49: Hail
    /// 50: Blowing sand
    /// 51: Tornado (realme custom weather type idw02)
    /// ```
    @SerializedName("weather_type")
    var weatherType: Int = weatherType

    /// Current temperature in Celsius
    /// For negative temperatures, add 100 to the temperature and transmit
    @SerializedName("today_tmp")
    var todayTmp: Int = todayTmp

    /// Maximum temperature in Celsius
    /// For negative temperatures, add 100 to the temperature and transmit
    @SerializedName("today_max_temp")
    var todayMaxTemp: Int = todayMaxTemp

    /// Minimum temperature in Celsius
    /// For negative temperatures, add 100 to the temperature and transmit
    @SerializedName("today_min_temp")
    var todayMinTemp: Int = todayMinTemp

    /// City name
    /// Maximum of 74 bytes
    @SerializedName("city_name")
    var cityName: String = cityName

    /// Air quality
    /// Multiply by 10 for transmission
    @SerializedName("air_quality")
    var airQuality: Int = airQuality

    /// Precipitation probability
    /// 0-100 percentage
    @SerializedName("precipitation_probability")
    var precipitationProbability: Int = precipitationProbability

    @SerializedName("humidity")
    var humidity: Int = humidity

    /// UV intensity
    /// Multiply by 10 for transmission
    @SerializedName("today_uv_intensity")
    var todayUvIntensity: Int = todayUvIntensity

    @SerializedName("wind_speed")
    var windSpeed: Int = windSpeed

    @SerializedName("wind_force")
    var windForce: Int = windForce

    @SerializedName("sunrise_hour")
    var sunriseHour: Int = sunriseHour

    @SerializedName("sunrise_min")
    var sunriseMin: Int = sunriseMin

    @SerializedName("sunset_hour")
    var sunsetHour: Int = sunsetHour

    @SerializedName("sunset_min")
    var sunsetMin: Int = sunsetMin

    /// Number of sunrise and sunset time details
    /// Currently, the maximum number of days is set to 7
    /// Invalid for version 1
    @SerializedName("sunrise_item_num")
    var sunriseItemNum: Int = sunriseItemNum

    @SerializedName("air_grade_item")
    var airGradeItem: String = airGradeItem

    @SerializedName("hours_weather_items")
    var hoursWeatherItems: List<IDOHoursWeatherItem> = hoursWeatherItems

    @SerializedName("future_items")
    var futureItems: List<IDOFutureItem> = futureItems

    @SerializedName("sunrise_item")
    var sunriseItem: List<IDOSunriseItem> = sunriseItem

    @SerializedName("aqi_future_item")
    var aqiFutureItem: List<Int>? = aqiFutureItem

    @SerializedName("aqi_history_item")
    var aqiHistoryItem: List<Int>? = aqiHistoryItem

    @SerializedName("aqi_future_item_num")
    private var aqiFutureItemNum: Int? = aqiFutureItem?.size ?: 0

    @SerializedName("aqi_history_item_num")
    private var aqiHistoryItemNum: Int? = aqiHistoryItem?.size ?: 0

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

// MARK: - IDOFutureItem
open class IDOFutureItem(weatherType: Int, maxTemp: Int, minTemp: Int) : Serializable {
    @SerializedName("weather_type")
    var weatherType: Int = weatherType

    @SerializedName("max_temp")
    var maxTemp: Int = maxTemp

    @SerializedName("min_temp")
    var minTemp: Int = minTemp

}

// MARK: - IDOHoursWeatherItem
open class IDOHoursWeatherItem(weatherType: Int, temperature: Int, probability: Int) :
    Serializable {
    @SerializedName("weather_type")
    var weatherType: Int = weatherType

    @SerializedName("temperature")
    var temperature: Int = temperature

    @SerializedName("probability")
    var probability: Int = probability
}

// MARK: - IDOSunriseItem
open class IDOSunriseItem(sunriseHour: Int, sunriseMin: Int, sunsetHour: Int, sunsetMin: Int) :
    Serializable {
    @SerializedName("sunrise_hour")
    var sunriseHour: Int = sunriseHour

    @SerializedName("sunrise_min")
    var sunriseMin: Int = sunriseMin

    @SerializedName("sunset_hour")
    var sunsetHour: Int = sunsetHour

    @SerializedName("sunset_min")
    var sunsetMin: Int = sunsetMin

}
