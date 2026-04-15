//
//  IDOMeasurementModel.swift
//  protocol_channel
//
//  Created by hc on 2026/03/17.
//

import Foundation

/// 测量类型 | Measurement Type
@objc
public enum IDOMeasurementType: Int {
    /// 血压 | Blood Pressure
    case bloodPressure
    /// 血氧 | SpO2
    case spo2
    /// 心率 | Heart Rate
    case heartRate
    /// 体成分 | Body Composition
    case bodyComposition
    /// 压力 | Stress
    case stress
    /// 一键测量 | One-click Measurement
    case oneClick
    /// 体温 | Temperature
    case temperature
    
    internal var jsonKey: String {
        switch self {
        case .bloodPressure: return "flag"
        case .spo2: return "spo2_flag"
        case .heartRate: return "hr_flag"
        case .bodyComposition: return "body_composition_flag"
        case .stress: return "stress_flag"
        case .oneClick: return "one_click_measure_flag"
        case .temperature: return "temperature_flag"
        }
    }
}

/// 测量操作 | Measurement Action
@objc
public enum IDOMeasurementAction: Int {
    /// 开始 | Start
    case start = 1
    /// 停止 | Stop
    case stop = 2
    /// 获取数据 | Get Data
    case getData = 3
}

/// 通用测量结果模型 | General Measurement Model
@objcMembers
public class IDOMeasurementModel: NSObject, IDOBaseModel {
    /// 0:不支持 1:进行中 2:成功 3:失败 4:设备在运动模式 | 0:Not support 1:In progress 2:Success 3:Fail 4:Exercise mode
    public var status: Int = 0
    /// 高压（收缩压），`bloodPressure`类型获取有效 | Systolic blood pressure, valid for `bloodPressure`
    public var systolicBp: Int = 0
    /// 低压（舒张压），`bloodPressure`类型获取有效 | Diastolic blood pressure, valid for `bloodPressure`
    public var diastolicBp: Int = 0
    /// 心率/血氧值/压力值，对应`heartRate` / `spo2` / `stress`类型获取有效 | Value (HR/SpO2/Stress), valid for `heartRate`/`spo2`/`stress`
    public var value: Int = 0
    /// 心率，`oneClick`一键测量类型获取有效 | Heart rate, valid for `oneClick`
    public var oneClickHr: Int = 0
    /// 压力，`oneClick`一键测量类型获取有效 | Stress, valid for `oneClick`
    public var oneClickStress: Int = 0
    /// 血氧，`oneClick`一键测量类型获取有效 | SpO2, valid for `oneClick`
    public var oneClickSpo2: Int = 0
    /// 体温值，`temperature`类型获取有效（乘以10倍的整数值）| Temperature, valid for `temperature` (multiplied by 10)
    public var temperature: Float = 0
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case systolicBp = "systolic_bp"
        case diastolicBp = "diastolic_bp"
        case value = "value"
        case oneClickHr = "one_click_measure_hr"
        case oneClickStress = "one_click_measure_stress"
        case oneClickSpo2 = "one_click_measure_spo2"
        case temperature = "temperature_value"
    }
    
    public init(status: Int = 0,
                systolicBp: Int = 0,
                diastolicBp: Int = 0,
                value: Int = 0,
                oneClickHr: Int = 0,
                oneClickStress: Int = 0,
                oneClickSpo2: Int = 0,
                temperature: Float = 0) {
        self.status = status
        self.systolicBp = systolicBp
        self.diastolicBp = diastolicBp
        self.value = value
        self.oneClickHr = oneClickHr
        self.oneClickStress = oneClickStress
        self.oneClickSpo2 = oneClickSpo2
        self.temperature = temperature
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
