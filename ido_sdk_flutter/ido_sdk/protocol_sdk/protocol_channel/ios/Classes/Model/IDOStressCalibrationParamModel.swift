//
//  IDOStressCalibrationParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Set Stress Calibration Event Code
@objcMembers
public class IDOStressCalibrationParamModel: NSObject, IDOBaseModel {
    /// Stress score, ranging from 1 to 10
    public var stressScore: Int
    /// 0: Start calibration setting
    /// 1: Cancel calibration setting
    public var status: Int
    
    enum CodingKeys: String, CodingKey {
        case stressScore = "stress_score"
        case status = "status"
    }
    
    public init(stressScore: Int,status: Int) {
        self.stressScore = stressScore
        self.status = status
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

