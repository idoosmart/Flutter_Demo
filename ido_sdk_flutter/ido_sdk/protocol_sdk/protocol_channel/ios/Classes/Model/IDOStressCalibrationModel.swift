//
//  IDOStressCalibrationModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/18.
//

import Foundation

@objcMembers
public class IDOStressCalibrationModel: NSObject, IDOBaseModel {
    /// 0: Success
    /// 1: Failed - Calibration in progress
    /// 2: Failed - Charging
    /// 3: Failed - Not wearing
    /// 4: Failed - In a sports scene
    public var retCode: Int

    enum CodingKeys: String, CodingKey {
        case retCode = "ret_code"
    }

    public init(retCode: Int) {
        self.retCode = retCode
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
