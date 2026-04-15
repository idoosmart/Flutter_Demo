//
//  IDOBpCalibrationModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Blood pressure calibration event number
@objcMembers
public class IDOBpCalibrationModel: NSObject, IDOBaseModel {
    /// 0: Success
    /// 1: Successfully entered calibration mode, calibration in progress
    /// 2: In exercise mode
    /// 3: Device busy
    /// 4: Invalid status
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

