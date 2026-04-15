//
//  IDOWeatherSunTimeParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Set sunrise and sunset time event number
@objcMembers
public class IDOWeatherSunTimeParamModel: NSObject, IDOBaseModel {
    /// Hour of sunrise   
    public var sunriseHour: Int
    /// Minute of sunrise 
    public var sunriseMin: Int
    /// Hour of sunset    
    public var sunsetHour: Int
    /// Minute of sunset  
    public var sunsetMin: Int
    
    enum CodingKeys: String, CodingKey {
        case sunriseHour = "sunrise_hour"
        case sunriseMin = "sunrise_min"
        case sunsetHour = "sunset_hour"
        case sunsetMin = "sunset_min"
    }
    
    public init(sunriseHour: Int,sunriseMin: Int,sunsetHour: Int,sunsetMin: Int) {
        self.sunriseHour = sunriseHour
        self.sunriseMin = sunriseMin
        self.sunsetHour = sunsetHour
        self.sunsetMin = sunsetMin
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

