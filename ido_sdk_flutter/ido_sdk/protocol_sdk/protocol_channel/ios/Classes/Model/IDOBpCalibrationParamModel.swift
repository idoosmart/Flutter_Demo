//
//  IDOBpCalibrationParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Blood pressure calibration event number
@objcMembers
public class IDOBpCalibrationParamModel: NSObject, IDOBaseModel {
    /// 1: Blood pressure calibration settings
    /// 2: Blood pressure calibration query result
    public var flag: Int
    /// Systolic pressure
    public var diastolic: Int
    /// Diastolic pressure
    public var systolic: Int
    
    enum CodingKeys: String, CodingKey {
        case flag = "flag"
        case diastolic = "diastolic"
        case systolic = "systolic"
    }
    
    public init(flag: Int,diastolic: Int,systolic: Int) {
        self.flag = flag
        self.diastolic = diastolic
        self.systolic = systolic
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

