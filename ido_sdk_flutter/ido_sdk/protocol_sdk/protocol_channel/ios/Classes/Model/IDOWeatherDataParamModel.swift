//
//  IDOWeatherDataParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/19.
//

import Foundation

// MARK: - IDOWeatherDataParamModel
@objcMembers
public class IDOWeatherDataParamModel: NSObject, IDOBaseModel {
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
    public var type: Int
    /// Current temperature
    public var temp: Int
    /// Maximum temperature of the day
    public var maxTemp: Int
    /// Minimum temperature of the day
    public var minTemp: Int
    /// Current humidity
    public var humidity: Int
    /// Current UV intensity
    public var uvIntensity: Int
    /// Current air quality index (AQI)
    public var aqi: Int
    public var future: [IDOWeatherDataFuture]

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case temp = "temp"
        case maxTemp = "max_temp"
        case minTemp = "min_temp"
        case humidity = "humidity"
        case uvIntensity = "uv_intensity"
        case aqi = "aqi"
        case future = "future"
    }

    public init(type: Int, temp: Int, maxTemp: Int, minTemp: Int, humidity: Int, uvIntensity: Int, aqi: Int, future: [IDOWeatherDataFuture]) {
        self.type = type
        self.temp = temp
        self.maxTemp = maxTemp
        self.minTemp = minTemp
        self.humidity = humidity
        self.uvIntensity = uvIntensity
        self.aqi = aqi
        self.future = future
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOWeatherDataFuture
@objcMembers
public class IDOWeatherDataFuture: NSObject, Codable {
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
    public var type: Int
    /// future minimum temperature
    public var minTemp: Int
    /// future maximum temperature
    public var maxTemp: Int

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case minTemp = "min_temp"
        case maxTemp = "max_temp"
    }

    public init(type: Int, minTemp: Int, maxTemp: Int) {
        self.type = type
        self.minTemp = minTemp
        self.maxTemp = maxTemp
    }
}
