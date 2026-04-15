//
//  IDOScreenBrightnessModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Get screen brightness event number
@objcMembers
public class IDOScreenBrightnessModel: NSObject, IDOBaseModel {
    /// Brightness level
    /// (0-100)
    public var level: Int
    /// 0 Auto
    /// 1 Manual
    /// If it is automatic synchronization configuration, please send 00; if it is user adjustment, please send 01
    public var opera: Int
    /// 0 Specify level
    /// 1 Use ambient light sensor
    /// 2 level does not matter
    public var mode: Int
    /// Night auto brightness adjustment
    /// 0 Invalid, defined by firmware
    /// 1 Off
    /// 2 Night auto brightness adjustment
    /// 3 Night brightness reduction uses the set time
    public var autoAdjustNight: Int
    /// Start time hour
    public var startHour: Int
    /// Start time minute
    public var startMinute: Int
    /// End time hour
    public var endHour: Int
    /// End time minute
    public var endMinute: Int
    /// Night brightness
    public var nightLevel: Int
    /// Display interval
    public var showInterval: Int

    enum CodingKeys: String, CodingKey {
        case level = "level"
        case opera = "opera"
        case mode = "mode"
        case autoAdjustNight = "auto_adjust_night"
        case startHour = "start_hour"
        case startMinute = "start_minute"
        case endHour = "end_hour"
        case endMinute = "end_minute"
        case nightLevel = "night_level"
        case showInterval = "show_interval"
    }

    public init(level: Int, opera: Int, mode: Int, autoAdjustNight: Int, startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, nightLevel: Int, showInterval: Int) {
        self.level = level
        self.opera = opera
        self.mode = mode
        self.autoAdjustNight = autoAdjustNight
        self.startHour = startHour
        self.startMinute = startMinute
        self.endHour = endHour
        self.endMinute = endMinute
        self.nightLevel = nightLevel
        self.showInterval = showInterval
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
