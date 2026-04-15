//
//  IDOBpMeasurementModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Blood pressure measurement event number
@objcMembers
public class IDOBpMeasurementModel: NSObject, IDOBaseModel {
    /// 0: Not supported
    /// 1: Measurement in progress
    /// 2: Measurement successful
    /// 3: Measurement failed
    /// 4: Device in exercise mode 
    public var status: Int
    /// Systolic blood pressure                                      
    public var systolicBp: Int
    /// Diastolic blood pressure                                     
    public var diastolicBp: Int
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case systolicBp = "systolic_bp"
        case diastolicBp = "diastolic_bp"
    }
    
    public init(status: Int,systolicBp: Int,diastolicBp: Int) {
        self.status = status
        self.systolicBp = systolicBp
        self.diastolicBp = diastolicBp
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

