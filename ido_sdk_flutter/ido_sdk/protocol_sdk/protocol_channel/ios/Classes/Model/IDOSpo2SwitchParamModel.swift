//
//  IDOSpo2SwitchParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation


/// Set SpO2 switch event
@objcMembers
public class IDOSpo2SwitchParamModel: NSObject, IDOBaseModel {
    /// SpO2 all-day switch
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
    /// Low SpO2 switch
    /// 1 On
    /// 0 Off
    /// Requires support from the menu `setSpo2AllDayOnOff`
    public var lowSpo2OnOff: Int
    /// Low SpO2 threshold
    /// Requires support from the menu `v3SupportSetSpo2LowValueRemind`
    public var lowSpo2Value: Int
    /// Notification type
    /// 0: Invalid
    /// 1: Allow notifications
    /// 2: Silent notifications
    /// 3: Disable notifications
    /// Requires support from the menu `getSpo2NotifyFlag`
    public var notifyFlag: Int
    
    enum CodingKeys: String, CodingKey {
        case onOff = "on_off"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case lowSpo2OnOff = "low_spo2_on_off"
        case lowSpo2Value = "low_spo2_value"
        case notifyFlag = "notify_flag"
    }
    
    public init(onOff: Int,startHour: Int,startMinute: Int,endHour: Int,endMinute: Int,lowSpo2OnOff: Int = 0,lowSpo2Value: Int = 0,notifyFlag: Int = 0) {
        self.onOff = onOff
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.lowSpo2OnOff = lowSpo2OnOff
        self.lowSpo2Value = lowSpo2Value
        self.notifyFlag = notifyFlag
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}



@objcMembers
public class IDOSpo2SwitchModel: NSObject, IDOBaseModel {
    /// SpO2 all-day switch
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
    /// Low SpO2 switch
    /// 1 On
    /// 0 Off
    /// Requires support from the menu `setSpo2AllDayOnOff`
    public var lowSpo2OnOff: Int
    /// Low SpO2 threshold
    /// Requires support from the menu `v3SupportSetSpo2LowValueRemind`
    public var lowSpo2Value: Int
    /// Notification type
    /// 0: Invalid
    /// 1: Allow notifications
    /// 2: Silent notifications
    /// 3: Disable notifications
    /// Requires support from the menu `getSpo2NotifyFlag`
    public var notifyFlag: Int
    
    enum CodingKeys: String, CodingKey {
        case onOff = "on_off"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case lowSpo2OnOff = "low_spo2_on_off"
        case lowSpo2Value = "low_spo2_value"
        case notifyFlag = "notify_flag"
    }
    
    public init(onOff: Int,startHour: Int,startMinute: Int,endHour: Int,endMinute: Int,lowSpo2OnOff: Int = 0,lowSpo2Value: Int = 0,notifyFlag: Int = 0) {
        self.onOff = onOff
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.lowSpo2OnOff = lowSpo2OnOff
        self.lowSpo2Value = lowSpo2Value
        self.notifyFlag = notifyFlag
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
