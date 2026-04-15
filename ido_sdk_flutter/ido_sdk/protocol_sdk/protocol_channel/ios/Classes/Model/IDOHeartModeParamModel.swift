//
//  IDOHeartModeParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/20.
//

import Foundation

// MARK: - IDOHeartModeParamModel
@objcMembers
public class IDOHeartModeParamModel: NSObject, IDOBaseModel {
    /// Update time as a Unix timestamp in seconds. If equal to 0, it means to get the current UTC timestamp.
    public var updateTime: Int
    /// Mode
    /// ```
    /// 0: Off
    /// 1: Auto (5 minutes)
    /// 2: Continuous monitoring (5 seconds)
    /// 3: Manual mode (disables auto)
    /// 4: Default type, firmware automatically sets to default mode after setting
    /// 5: Set the corresponding measurement interval
    /// 6: Intelligent Heart Rate Mode (ID206)
    /// Note:
    /// 1. If the function setSetV3HeartInterval is configured, Mode 0, Mode 1, and Mode 2 will be ineffective.
    /// 2. When configuring with fast settings, setting setSetV3HeartInterval will activate Mode 5
    /// 3. When setting continuous heart rate, if the function setSetV3HeartInterval is configured, the corresponding mode is Mode 5.
    /// ```
    public var mode: Int
    /// Whether there is a time range. 0: No, 1: Yes
    public var hasTimeRange: Int
    public var startHour: Int
    public var startMinute: Int
    public var endHour: Int
    public var endMinute: Int
    /// Measurement interval in seconds
    public var measurementInterval: Int
    /// Notification type:
    /// ```
    /// 0: Invalid
    /// 1: Allow notifications
    /// 2: Silent notifications
    /// 3: Close notifications
    /// Note: This is ineffective if the firmware does not enable v3HeartSetRateModeCustom
    /// ```
    public var notifyFlag: Int
    /// 1: Enable smart high heart rate reminder
    /// 0: Off
    /// Note: This is ineffective if the firmware does not enable v3HeartSetRateModeCustom
    public var highHeartMode: Int
    /// 1: Enable smart low heart rate reminder
    /// 0: Off
    /// Note: This is ineffective if the firmware does not enable v3HeartSetRateModeCustom
    public var lowHeartMode: Int
    /// Smart high heart rate reminder threshold
    /// Note: This is ineffective if the firmware does not enable v3HeartSetRateModeCustom
    public var highHeartValue: Int
    /// Smart low heart rate reminder threshold
    /// Note: This is ineffective if the firmware does not enable v3HeartSetRateModeCustom
    public var lowHeartValue: Int
    
    enum CodingKeys: String, CodingKey {
        case updateTime = "update_time"
        case mode = "mode"
        case hasTimeRange = "has_time_range"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case measurementInterval = "measurement_interval"
        case notifyFlag = "notify_flag"
        case highHeartMode = "high_heart_mode"
        case lowHeartMode = "low_heart_mode"
        case highHeartValue = "high_heart_value"
        case lowHeartValue = "low_heart_value"
    }
    
    public init(updateTime: Int, 
                mode: Int = 0,
                hasTimeRange: Int = 0,
                startHour: Int = 0,
                startMinute: Int = 0, 
                endHour: Int = 0,
                endMinute: Int = 0, 
                measurementInterval: Int = 0,
                notifyFlag: Int = 0, 
                highHeartMode: Int = 0,
                lowHeartMode: Int = 0,
                highHeartValue: Int = 0,
                lowHeartValue: Int = 0) {
        self.updateTime = updateTime
        self.mode = mode
        self.hasTimeRange = hasTimeRange
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.measurementInterval = measurementInterval
        self.notifyFlag = notifyFlag
        self.highHeartMode = highHeartMode
        self.lowHeartMode = lowHeartMode
        self.highHeartValue = highHeartValue
        self.lowHeartValue = lowHeartValue
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}


// MARK: - IDOHeartModeModel
@objcMembers
public class IDOHeartModeModel: NSObject, IDOBaseModel {
    /// Update time as a Unix timestamp in seconds. If equal to 0, it means to get the current UTC timestamp.
    public var updateTime: Int
    /// Mode
    /// ```
    /// 0: Off
    /// 1: Auto (5 minutes)
    /// 2: Continuous monitoring (5 seconds)
    /// 3: Manual mode (disables auto)
    /// 4: Default type, firmware automatically sets to default mode after setting
    /// 5: Set the corresponding measurement interval
    /// 6: Intelligent Heart Rate Mode (ID206)
    /// Note:
    /// 1. If the function setSetV3HeartInterval is configured, Mode 0, Mode 1, and Mode 2 will be ineffective.
    /// 2. When configuring with fast settings, setting setSetV3HeartInterval will activate Mode 5
    /// 3. When setting continuous heart rate, if the function setSetV3HeartInterval is configured, the corresponding mode is Mode 5.
    /// ```
    public var mode: Int
    /// Whether there is a time range. 0: No, 1: Yes
    public var hasTimeRange: Int
    public var startHour: Int
    public var startMinute: Int
    public var endHour: Int
    public var endMinute: Int
    /// Measurement interval in seconds
    public var measurementInterval: Int
    
    /// Currently supported heart rate types by the watch
    /// ```
    /// all 0 invalid values
    /// Bit0: 5s mode
    /// Note: This is returned as 0 if setSetV3HeartInterval is not enabled in the firmware
    /// ```
    public var getSECMode: Int
    
    public var secModeArray: [Int] = []
    
    /// Currently supported heart rate types by the watch,
    /// ```
    /// all 0:invalid values
    /// Bit0: 1 minute
    /// bit1: 3 minutes
    /// bit2: 5 minutes
    /// bit3: 10 minutes
    /// bit4: 30 minutes
    /// bit5: 285 mode,
    /// bit6: 15 minute mode
    /// Note: This is returned as 0 if setSetV3HeartInterval is not enabled in the firmware
    /// ```
    public var getMinMode: Int
    
    public var minModeArray: [Int] = []
    
    /// Notification type:
    /// ```
    /// 0: Invalid
    /// 1: Allow notifications
    /// 2: Silent notifications
    /// 3: Close notifications
    /// Note: This is ineffective if the firmware does not enable v3HeartSetRateModeCustom
    /// ```
    public var notifyFlag: Int
    /// 1: Enable smart high heart rate reminder
    /// 0: Off
    /// Note: This is ineffective if the firmware does not enable v3HeartSetRateModeCustom
    public var highHeartMode: Int
    /// 1: Enable smart low heart rate reminder
    /// 0: Off
    /// Note: This is ineffective if the firmware does not enable v3HeartSetRateModeCustom
    public var lowHeartMode: Int
    /// Smart high heart rate reminder threshold
    /// Note: This is ineffective if the firmware does not enable v3HeartSetRateModeCustom
    public var highHeartValue: Int
    /// Smart low heart rate reminder threshold
    /// Note: This is ineffective if the firmware does not enable v3HeartSetRateModeCustom
    public var lowHeartValue: Int
    
    enum CodingKeys: String, CodingKey {
        case updateTime = "update_time"
        case mode = "mode"
        case hasTimeRange = "has_time_range"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case measurementInterval = "measurement_interval"
        case getSECMode = "get_sec_mode"
        case getMinMode = "get_min_mode"
        case notifyFlag = "notify_flag"
        case highHeartMode = "high_heart_mode"
        case lowHeartMode = "low_heart_mode"
        case highHeartValue = "high_heart_value"
        case lowHeartValue = "low_heart_value"
        case secModeArray = "sec_mode_array"
        case minModeArray = "min_mode_array"
    }
    
    public init(updateTime: Int, mode: Int, hasTimeRange: Int, getMinMode: Int, getSECMode: Int, startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, measurementInterval: Int, notifyFlag: Int, highHeartMode: Int, lowHeartMode: Int, highHeartValue: Int, lowHeartValue: Int) {
        self.updateTime = updateTime
        self.mode = mode
        self.hasTimeRange = hasTimeRange
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.measurementInterval = measurementInterval
        self.notifyFlag = notifyFlag
        self.highHeartMode = highHeartMode
        self.lowHeartMode = lowHeartMode
        self.highHeartValue = highHeartValue
        self.lowHeartValue = lowHeartValue
        self.getMinMode = getMinMode
        self.getSECMode = getSECMode
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
