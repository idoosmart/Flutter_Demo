//
//  IDOScientificSleepSwitchParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Scientific sleep switch setting event
@objcMembers
public class IDOScientificSleepSwitchParamModel: NSObject, IDOBaseModel {
    /// Mode
    /// 2: Scientific sleep
    /// 1: Normal sleep
    public var mode: Int
    /// Start time - hour
    public var startHour: Int
    /// Start time - minute
    public var startMinute: Int
    /// End time - hour                                    
    public var endHour: Int
    /// End time - minute
    public var endMinute: Int
    
    enum CodingKeys: String, CodingKey {
        case mode = "mode"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
    }
    
    public init(mode: Int,startHour: Int,startMinute: Int,endHour: Int,endMinute: Int) {
        self.mode = mode
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

