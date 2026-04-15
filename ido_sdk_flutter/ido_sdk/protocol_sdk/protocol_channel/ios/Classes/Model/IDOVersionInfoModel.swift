//
//  IDOVersionInfoModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Get version information event number
@objcMembers
public class IDOVersionInfoModel: NSObject, IDOBaseModel {
    /// SDK version
    public var sdkVersion: Int
    /// Heart rate algorithm version
    public var hrAlgorithmVersion: Int
    /// Sleep algorithm version
    public var sleepAlgorithmVersion: Int
    /// Step counter algorithm version
    public var stepAlgorithmVersion: Int
    /// Gesture recognition algorithm version
    public var gestureRecognitionVersion: Int
    /// PCB version (multiplied by 10, e.g., 11 for version 1.1)
    public var pcbVersion: Int
    /// Wearable version
    public var spo2Version: Int
    /// SpO2 algorithm version
    public var wearVersion: Int
    /// Stress level algorithm version
    public var stressVersion: Int
    /// Calorie algorithm version
    public var kcalVersion: Int
    /// Distance algorithm version
    public var disVersion: Int
    /// 3-axis sensor swimming algorithm version
    public var axle3SwimVersion: Int
    /// 6-axis sensor swimming algorithm version
    public var axle6SwimVersion: Int
    /// Activity mode recognition algorithm version
    public var actModeTypeVersion: Int
    /// All-day heart rate algorithm version
    public var allDayHrVersion: Int
    /// GPS algorithm version
    public var gpsVersion: Int
    /// Peripheral version for 206 customized projects
    public var peripheralsVersion: Int

    enum CodingKeys: String, CodingKey {
        case sdkVersion = "sdk_version"
        case hrAlgorithmVersion = "hr_algorithm_version"
        case sleepAlgorithmVersion = "sleep_algorithm_version"
        case stepAlgorithmVersion = "step_algorithm_version"
        case gestureRecognitionVersion = "gesture_recognition_version"
        case pcbVersion = "pcb_version"
        case spo2Version = "spo2_version"
        case wearVersion = "wear_version"
        case stressVersion = "stress_version"
        case kcalVersion = "kcal_version"
        case disVersion = "dis_version"
        case axle3SwimVersion = "axle3_swim_version"
        case axle6SwimVersion = "axle6_swim_version"
        case actModeTypeVersion = "act_mode_type_version"
        case allDayHrVersion = "all_day_hr_version"
        case gpsVersion = "gps_version"
        case peripheralsVersion = "peripherals_version"
    }

    public init(sdkVersion: Int, hrAlgorithmVersion: Int, sleepAlgorithmVersion: Int, stepAlgorithmVersion: Int, gestureRecognitionVersion: Int, pcbVersion: Int, spo2Version: Int, wearVersion: Int, stressVersion: Int, kcalVersion: Int, disVersion: Int, axle3SwimVersion: Int, axle6SwimVersion: Int, actModeTypeVersion: Int, allDayHrVersion: Int, gpsVersion: Int, peripheralsVersion: Int) {
        self.sdkVersion = sdkVersion
        self.hrAlgorithmVersion = hrAlgorithmVersion
        self.sleepAlgorithmVersion = sleepAlgorithmVersion
        self.stepAlgorithmVersion = stepAlgorithmVersion
        self.gestureRecognitionVersion = gestureRecognitionVersion
        self.pcbVersion = pcbVersion
        self.spo2Version = spo2Version
        self.wearVersion = wearVersion
        self.stressVersion = stressVersion
        self.kcalVersion = kcalVersion
        self.disVersion = disVersion
        self.axle3SwimVersion = axle3SwimVersion
        self.axle6SwimVersion = axle6SwimVersion
        self.actModeTypeVersion = actModeTypeVersion
        self.allDayHrVersion = allDayHrVersion
        self.gpsVersion = gpsVersion
        self.peripheralsVersion = peripheralsVersion
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
