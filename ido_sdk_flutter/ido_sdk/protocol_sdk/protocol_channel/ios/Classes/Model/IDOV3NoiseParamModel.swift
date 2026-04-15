//
//  IDOV3NoiseParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Set Environmental Noise Volume On/Off and Threshold Event
@objcMembers
public class IDOV3NoiseParamModel: NSObject, IDOBaseModel {
    /// All-day environmental noise volume switch
    /// 1: On
    /// 0: Off 
    public var mode: Int
    /// Start time (hour)                                            
    public var startHour: Int
    /// Start time (minute)                                          
    public var startMinute: Int
    /// End time (hour)                                              
    public var endHour: Int
    /// End time (minute)                                            
    public var endMinute: Int
    /// Threshold switch
    /// 1: On
    /// 0: Off                      
    public var highNoiseOnOff: Int
    /// Threshold value                                              
    public var highNoiseValue: Int
    
    enum CodingKeys: String, CodingKey {
        case mode = "mode"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case highNoiseOnOff = "high_noise_on_off"
        case highNoiseValue = "high_noise_value"
    }
    
    public init(mode: Int,startHour: Int,startMinute: Int,endHour: Int,endMinute: Int,highNoiseOnOff: Int,highNoiseValue: Int) {
        self.mode = mode
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.highNoiseOnOff = highNoiseOnOff
        self.highNoiseValue = highNoiseValue
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

