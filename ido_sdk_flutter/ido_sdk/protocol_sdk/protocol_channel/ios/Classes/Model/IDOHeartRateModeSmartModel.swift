//
//  IDOHeartRateModeSmartModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Smart Heart Rate Mode
@objcMembers
public class IDOHeartRateModeSmartModel: NSObject, IDOBaseModel {
    /// Switch
    /// 0:Off
    /// 1:On
    public var mode: Int
    /// Notification Type
    /// 0: Invalid
    /// 1: Allow Notifications
    /// 2: Silent Notifications
    /// 3: Disable Notifications
    public var notifyFlag: Int
    /// 1: Enable Smart High Heart Rate Alert
    /// 0: Disable
    public var highHeartMode: Int
    /// 1: Enable Smart Low Heart Rate Alert
    /// 0: Disable
    public var lowHeartMode: Int
    /// Smart High Heart Rate Alert Threshold
    public var highHeartValue: Int
    /// Smart Low Heart Rate Alert Threshold
    public var lowHeartValue: Int
    /// Start Time of Heart Rate Monitoring (hour)
    public var startHour: Int
    /// Start Time of Heart Rate Monitoring (minute)
    public var startMinute: Int
    /// End Time of Heart Rate Monitoring (hour)
    public var endHour: Int
    /// End Time of Heart Rate Monitoring (minute)
    public var endMinute: Int
    
    enum CodingKeys: String, CodingKey {
        case mode = "mode"
        case notifyFlag = "notify_flag"
        case highHeartMode = "high_heart_mode"
        case lowHeartMode = "low_heart_mode"
        case highHeartValue = "high_heart_value"
        case lowHeartValue = "low_heart_value"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
    }
    
    public init(mode: Int,notifyFlag: Int,highHeartMode: Int,lowHeartMode: Int,highHeartValue: Int,lowHeartValue: Int,startHour: Int,startMinute: Int,endHour: Int,endMinute: Int) {
        self.mode = mode
        self.notifyFlag = notifyFlag
        self.highHeartMode = highHeartMode
        self.lowHeartMode = lowHeartMode
        self.highHeartValue = highHeartValue
        self.lowHeartValue = lowHeartValue
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

