//
//  IDOUpHandGestureParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Raise-to-wake gesture event number
@objcMembers
public class IDOUpHandGestureParamModel: NSObject, IDOBaseModel {
    /// Switch
    /// 1: On
    /// 0: Off                        
    public var onOff: Int
    /// Duration for the screen to stay on, in seconds       
    public var showSecond: Int
    /// Whether there is a time range
    /// 1: Yes
    /// 0: No 
    public var hasTimeRange: Int
    /// Starting hour of the time range                      
    public var startHour: Int
    /// Starting minute of the time range                    
    public var startMinute: Int
    /// Ending hour of the time range                        
    public var endHour: Int
    /// Ending minute of the time range                      
    public var endMinute: Int
    
    enum CodingKeys: String, CodingKey {
        case onOff = "on_off"
        case showSecond = "show_second"
        case hasTimeRange = "has_time_range"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
    }
    
    public init(onOff: Int,showSecond: Int,hasTimeRange: Int,startHour: Int,startMinute: Int,endHour: Int,endMinute: Int) {
        self.onOff = onOff
        self.showSecond = showSecond
        self.hasTimeRange = hasTimeRange
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

