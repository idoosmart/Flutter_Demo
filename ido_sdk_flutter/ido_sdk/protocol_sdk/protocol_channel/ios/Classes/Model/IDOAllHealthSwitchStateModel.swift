//
//  IDOAllHealthSwitchStateModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Get event number for all health monitoring switches
@objcMembers
public class IDOAllHealthSwitchStateModel: NSObject, IDOBaseModel {
    /// Continuous heart rate measurement switch:
    /// 1:On
    /// 0:Off
    /// -1:Not Support
    public var heartMode: Int
    /// Automatic blood pressure measurement switch
    /// 1:On
    /// 0:Off
    /// -1:Not Support
    public var pressureMode: Int
    /// Automatic blood oxygen measurement switch
    /// 1:On
    /// 0:Off
    /// -1:Not Support
    public var spo2Mode: Int
    /// Scientific sleep switch
    /// 2:scientific sleep mode
    /// 1:normal sleep mode
    /// -1:Not Support
    public var scienceMode: Int
    /// Nighttime temperature switch
    /// 1:On
    /// 0:Off
    /// -1:Not Support
    public var temperatureMode: Int
    /// Noise switch
    /// 1:On
    /// 0:Off
    /// -1:Not Support
    public var noiseMode: Int
    /// Menstrual cycle switch
    /// 1:On
    /// 0:Off
    /// -1:Not Support
    public var menstrualMode: Int
    /// Walking reminder switch
    /// 1:On
    /// 0:Off
    /// -1:Not Support
    public var walkMode: Int
    /// Handwashing reminder switch
    /// 1:On
    /// 0:Off
    /// -1:Not Support
    public var handwashingMode: Int
    /// Respiration rate switch
    /// 1:On
    /// 0:Off
    /// -1:Not Support
    public var respirRateState: Int
    /// Body battery switch
    /// 1:On
    /// 0:Off
    /// -1:Not Support
    public var bodyPowerState: Int
    /// Drink water reminder switch
    /// 1:On
    /// 0:Off
    /// -1:Not Support
    public var drinkwaterMode: Int
    /// Heart rate notification status:
    /// 0 for invalid
    /// 1 for allow notification
    /// 2 for silent notification
    /// 3 for disable notification
    public var heartmodeNotifyFlag: Int
    /// Blood pressure notification status:
    /// 0 for invalid
    /// 1 for allow notification
    /// 2 for silent notification
    /// 3 for disable notification
    public var pressureNotifyFlag: Int
    /// Blood oxygen notification status:
    /// 0 for invalid
    /// 1 for allow notification
    /// 2 for silent notification
    /// 3 for disable notification
    public var spo2NotifyFlag: Int
    /// Menstrual cycle notification status:
    /// 0 for invalid
    /// 1 for allow notification
    /// 2 for silent notification
    /// 3 for disable notification
    public var menstrualNotifyFlag: Int
    /// Fitness guidance notification status:
    /// 0 for invalid
    /// 1 for allow notification
    /// 2 for silent notification
    /// 3 for disable notification
    public var guidanceNotifyFlag: Int
    /// Reminder notification status:
    /// 0 for invalid
    /// 1 for allow notification
    /// 2 for silent notification
    /// 3 for disable notification
    public var reminderNotifyFlag: Int

    enum CodingKeys: String, CodingKey {
        case heartMode = "heart_mode"
        case pressureMode = "pressure_mode"
        case spo2Mode = "spo2_mode"
        case scienceMode = "science_mode"
        case temperatureMode = "temperature_mode"
        case noiseMode = "noise_mode"
        case menstrualMode = "menstrual_mode"
        case walkMode = "walk_mode"
        case handwashingMode = "handwashing_mode"
        case respirRateState = "respir_rate_state"
        case bodyPowerState = "body_power_state"
        case drinkwaterMode = "drinkwater_mode"
        case heartmodeNotifyFlag = "heartmode_notify_flag"
        case pressureNotifyFlag = "pressure_notify_flag"
        case spo2NotifyFlag = "spo2_notify_flag"
        case menstrualNotifyFlag = "menstrual_notify_flag"
        case guidanceNotifyFlag = "guidance_notify_flag"
        case reminderNotifyFlag = "reminder_notify_flag" 
    }

    public init(heartMode: Int, pressureMode: Int, spo2Mode: Int, scienceMode: Int, temperatureMode: Int, noiseMode: Int, menstrualMode: Int, walkMode: Int, handwashingMode: Int, respirRateState: Int, bodyPowerState: Int, drinkwaterMode: Int, heartmodeNotifyFlag: Int, pressureNotifyFlag: Int, spo2NotifyFlag: Int, menstrualNotifyFlag: Int, guidanceNotifyFlag: Int, reminderNotifyFlag: Int) {
        self.heartMode = heartMode
        self.pressureMode = pressureMode
        self.spo2Mode = spo2Mode
        self.scienceMode = scienceMode
        self.temperatureMode = temperatureMode
        self.noiseMode = noiseMode
        self.menstrualMode = menstrualMode
        self.walkMode = walkMode
        self.handwashingMode = handwashingMode
        self.respirRateState = respirRateState
        self.bodyPowerState = bodyPowerState
        self.drinkwaterMode = drinkwaterMode
        self.heartmodeNotifyFlag = heartmodeNotifyFlag
        self.pressureNotifyFlag = pressureNotifyFlag
        self.spo2NotifyFlag = spo2NotifyFlag
        self.menstrualNotifyFlag = menstrualNotifyFlag
        self.guidanceNotifyFlag = guidanceNotifyFlag
        self.reminderNotifyFlag = reminderNotifyFlag
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
