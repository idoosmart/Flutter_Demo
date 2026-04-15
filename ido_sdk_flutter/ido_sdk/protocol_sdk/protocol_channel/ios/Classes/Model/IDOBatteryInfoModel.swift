//
//  IDOBatteryInfoModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Get battery information event number
@objcMembers
public class IDOBatteryInfoModel: NSObject, IDOBaseModel {
    /// Battery type: 0: Rechargeable lithium battery, 1: Button battery
    public var type: Int
    /// Voltage
    public var voltage: Int
    /// Battery status
    /// 0: Normal
    /// 1: Charging
    /// 2: Charging complete
    /// 3: Low battery
    public var status: Int
    /// Level
    public var level: Int
    /// Last charging time, year
    public var lastChargingYear: Int
    /// Last charging time, month
    public var lastChargingMonth: Int
    /// Last charging time, day
    public var lastChargingDay: Int
    /// Last charging time, hour
    public var lastChargingHour: Int
    /// Last charging time, minute
    public var lastChargingMinute: Int
    /// Last charging time, second
    public var lastChargingSecond: Int
    /// 0: Invalid
    /// 1: Normal mode (non-power saving mode)
    /// 2: Power saving mode
    public var mode: Int
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case voltage = "voltage"
        case status = "status"
        case level = "level"
        case lastChargingYear = "last_charging_year"
        case lastChargingMonth = "last_charging_month"
        case lastChargingDay = "last_charging_day"
        case lastChargingHour = "last_charging_hour"
        case lastChargingMinute = "last_charging_minute"
        case lastChargingSecond = "last_charging_second"
        case mode = "mode"
    }
    
    public init(type: Int,voltage: Int,status: Int,level: Int,lastChargingYear: Int,lastChargingMonth: Int,lastChargingDay: Int,lastChargingHour: Int,lastChargingMinute: Int,lastChargingSecond: Int,mode: Int) {
        self.type = type
        self.voltage = voltage
        self.status = status
        self.level = level
        self.lastChargingYear = lastChargingYear
        self.lastChargingMonth = lastChargingMonth
        self.lastChargingDay = lastChargingDay
        self.lastChargingHour = lastChargingHour
        self.lastChargingMinute = lastChargingMinute
        self.lastChargingSecond = lastChargingSecond
        self.mode = mode
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

