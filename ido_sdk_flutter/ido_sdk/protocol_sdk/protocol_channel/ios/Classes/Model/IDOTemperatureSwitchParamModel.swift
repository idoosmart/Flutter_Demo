//
//  IDOTemperatureSwitchParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Set Night-time Temperature Switch Event Code
@objcMembers
public class IDOTemperatureSwitchParamModel: NSObject, IDOBaseModel {
    /// Mode:
    /// 1: On
    /// 0: Off
    public var mode: Int
    /// Start time, hour
    public var startHour: Int
    /// Start time, minute
    public var startMinute: Int
    /// End time, hour
    public var endHour: Int
    /// End time, minute
    public var endMinute: Int
    /// Temperature unit setting:
    /// 1 :Celsius
    /// 2 :Fahrenheit
    public var unit: Int
    
    enum CodingKeys: String, CodingKey {
        case mode = "mode"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case unit = "unit"
    }
    
    public init(mode: Int,startHour: Int,startMinute: Int,endHour: Int,endMinute: Int,unit: Int) {
        self.mode = mode
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.unit = unit
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

