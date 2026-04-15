//
//  IDOWeatherV3ParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/17.
//

import Foundation

/// V3设置天气数据
@objcMembers
public class IDOWeatherV3ParamModel: NSObject, IDOBaseModel {
    private let version: Int
    public var month: Int
    public var day: Int
    public var hour: Int
    public var min: Int
    public var sec: Int
    /// The day of the week
    /// bit0: Monday
    /// bit1: Tuesday and so on up to Sunday
    public var week: Int
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
    public var weatherType: Int
    /// Current temperature in Celsius
    /// For negative temperatures, add 100 to the temperature and transmit
    public var todayTmp: Int
    /// Maximum temperature in Celsius
    /// For negative temperatures, add 100 to the temperature and transmit
    public var todayMaxTemp: Int
    /// Minimum temperature in Celsius
    /// For negative temperatures, add 100 to the temperature and transmit
    public var todayMinTemp: Int
    /// City name
    /// Maximum of 74 bytes
    public var cityName: String
    /// Air quality
    /// Multiply by 10 for transmission
    public var airQuality: Int
    /// Precipitation probability
    /// 0-100 percentage
    public var precipitationProbability: Int
    public var humidity: Int
    /// UV intensity
    /// Multiply by 10 for transmission
    public var todayUvIntensity: Int
    public var windSpeed: Int
    public var windForce: Int
    public var sunriseHour: Int
    public var sunriseMin: Int
    public var sunsetHour: Int
    public var sunsetMin: Int
    /// Number of sunrise and sunset time details
    /// Currently, the maximum number of days is set to 7
    /// Invalid for version 1
    public var sunriseItemNum: Int
    public var airGradeItem: String
    public var hoursWeatherItems: [IDOHoursWeatherItem]
    public var futureItems: [IDOFutureItem]
    public var sunriseItem: [IDOSunriseItem]
    
    /// 未来空气质量
    public var aqiFutureItem: [Int]?
    /// 历史空气质量
    public var aqiHistoryItem: [Int]?
    private var aqiFutureItemNum: Int?
    private var aqiHistoryItemNum: Int?

    enum CodingKeys: String, CodingKey {
        case version
        case month
        case day
        case hour
        case min
        case sec
        case week
        case weatherType = "weather_type"
        case todayTmp = "today_tmp"
        case todayMaxTemp = "today_max_temp"
        case todayMinTemp = "today_min_temp"
        case cityName = "city_name"
        case airQuality = "air_quality"
        case precipitationProbability = "precipitation_probability"
        case humidity
        case todayUvIntensity = "today_uv_intensity"
        case windSpeed = "wind_speed"
        case windForce = "wind_force"
        case sunriseHour = "sunrise_hour"
        case sunriseMin = "sunrise_min"
        case sunsetHour = "sunset_hour"
        case sunsetMin = "sunset_min"
        case sunriseItemNum = "sunrise_item_num"
        case airGradeItem = "air_grade_item"
        case hoursWeatherItems = "hours_weather_items"
        case futureItems = "future_items"
        case sunriseItem = "sunrise_item"
        case aqiFutureItem = "aqi_future_item"
        case aqiHistoryItem = "aqi_history_item"
        case aqiFutureItemNum = "aqi_future_item_num"
        case aqiHistoryItemNum = "aqi_history_item_num"
    }

    public init(month: Int, day: Int, hour: Int, min: Int, sec: Int, week: Int, weatherType: Int, todayTmp: Int, todayMaxTemp: Int, todayMinTemp: Int, cityName: String, airQuality: Int, precipitationProbability: Int, humidity: Int, todayUvIntensity: Int, windSpeed: Int, windForce: Int, sunriseHour: Int, sunriseMin: Int, sunsetHour: Int, sunsetMin: Int, sunriseItemNum: Int, airGradeItem: String, hoursWeatherItems: [IDOHoursWeatherItem], futureItems: [IDOFutureItem], sunriseItem: [IDOSunriseItem], aqiFutureItem: [Int]? = nil, aqiHistoryItem: [Int]? = nil) {
        self.version = 1
        self.month = month
        self.day = day
        self.hour = hour
        self.min = min
        self.sec = sec
        self.week = week
        self.weatherType = weatherType
        self.todayTmp = todayTmp
        self.todayMaxTemp = todayMaxTemp
        self.todayMinTemp = todayMinTemp
        self.cityName = cityName
        self.airQuality = airQuality
        self.precipitationProbability = precipitationProbability
        self.humidity = humidity
        self.todayUvIntensity = todayUvIntensity
        self.windSpeed = windSpeed
        self.windForce = windForce
        self.sunriseHour = sunriseHour
        self.sunriseMin = sunriseMin
        self.sunsetHour = sunsetHour
        self.sunsetMin = sunsetMin
        self.sunriseItemNum = sunriseItemNum
        self.airGradeItem = airGradeItem
        self.hoursWeatherItems = hoursWeatherItems
        self.futureItems = futureItems
        self.sunriseItem = sunriseItem
        self.aqiFutureItem = aqiFutureItem
        self.aqiHistoryItem = aqiHistoryItem
        self.aqiFutureItemNum = aqiFutureItem?.count ?? 0
        self.aqiHistoryItemNum = aqiHistoryItem?.count ?? 0
        
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOFutureItem
@objcMembers
public class IDOFutureItem: NSObject, Codable {
    public var weatherType: Int
    public var maxTemp: Int
    public var minTemp: Int

    enum CodingKeys: String, CodingKey {
        case weatherType = "weather_type"
        case maxTemp = "max_temp"
        case minTemp = "min_temp"
    }

    public init(weatherType: Int, maxTemp: Int, minTemp: Int) {
        self.weatherType = weatherType
        self.maxTemp = maxTemp
        self.minTemp = minTemp
    }
}

// MARK: - IDOHoursWeatherItem
@objcMembers
public class IDOHoursWeatherItem: NSObject, Codable {
    public var weatherType: Int
    public var temperature: Int
    public var probability: Int

    enum CodingKeys: String, CodingKey {
        case weatherType = "weather_type"
        case temperature
        case probability
    }

    public init(weatherType: Int, temperature: Int, probability: Int) {
        self.weatherType = weatherType
        self.temperature = temperature
        self.probability = probability
    }
}

// MARK: - IDOSunriseItem
@objcMembers
public class IDOSunriseItem: NSObject, Codable {
    public var sunriseHour: Int
    public var sunriseMin: Int
    public var sunsetHour: Int
    public var sunsetMin: Int

    enum CodingKeys: String, CodingKey {
        case sunriseHour = "sunrise_hour"
        case sunriseMin = "sunrise_min"
        case sunsetHour = "sunset_hour"
        case sunsetMin = "sunset_min"
    }

    public init(sunriseHour: Int, sunriseMin: Int, sunsetHour: Int, sunsetMin: Int) {
        self.sunriseHour = sunriseHour
        self.sunriseMin = sunriseMin
        self.sunsetHour = sunsetHour
        self.sunsetMin = sunsetMin
    }
}
