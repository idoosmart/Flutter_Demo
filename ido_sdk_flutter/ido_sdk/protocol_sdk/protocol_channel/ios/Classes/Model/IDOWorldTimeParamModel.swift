//
//  IDOWorldTimeParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/17.
//

import Foundation

@objcMembers
public class IDOWorldTimeParamModel: NSObject, IDOBaseModel {
    /// Detail ID,Uniqueness
    public var id: Int
    /// Minute offset from current time to UTC 0
    public var minOffset: Int
    /// City name, up to 59 bytes
    public var cityName: String
    public var sunriseHour: Int
    public var sunriseMin: Int
    public var sunsetHour: Int
    public var sunsetMin: Int
    /// 1: East longitude 2: West longitude
    public var longitudeFlag: Int
    /// Longitude, multiplied by 100, with 2 decimal places
    public var longitude: Int
    /// 1: North latitude 2: South latitude
    public var latitudeFlag: Int
    /// Latitude, multiplied by 100, with 2 decimal places
    public var latitude: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case minOffset = "min_offset"
        case cityName = "city_name"
        case sunriseHour = "sunrise_hour"
        case sunriseMin = "sunrise_min"
        case sunsetHour = "sunset_hour"
        case sunsetMin = "sunset_min"
        case longitudeFlag = "longitude_flag"
        case longitude = "longitude"
        case latitudeFlag = "latitude_flag"
        case latitude = "latitude"
    }
    
    public init(id: Int, minOffset: Int, cityName: String, sunriseHour: Int, sunriseMin: Int, sunsetHour: Int, sunsetMin: Int, longitudeFlag: Int, longitude: Int, latitudeFlag: Int, latitude: Int) {
        self.id = id
        self.minOffset = minOffset
        self.cityName = cityName
        self.sunriseHour = sunriseHour
        self.sunriseMin = sunriseMin
        self.sunsetHour = sunsetHour
        self.sunsetMin = sunsetMin
        self.longitudeFlag = longitudeFlag
        self.longitude = longitude
        self.latitudeFlag = latitudeFlag
        self.latitude = latitude
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

