//
//  IDOSleepPeriodParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Set sleep period event
@objcMembers
public class IDOSleepPeriodParamModel: NSObject, IDOBaseModel {
    /// Switch
    /// 1 On
    /// 0 Off 
    public var onOff: Int
    /// Start time (hour)                     
    public var startHour: Int
    /// Start time (minute)                   
    public var startMinute: Int
    /// End time (hour)                       
    public var endHour: Int
    /// End time (minute)                     
    public var endMinute: Int
    
    enum CodingKeys: String, CodingKey {
        case onOff = "on_off"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
    }
    
    public init(onOff: Int,startHour: Int,startMinute: Int,endHour: Int,endMinute: Int) {
        self.onOff = onOff
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

