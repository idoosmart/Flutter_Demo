//
//  IDOBpMeasurementParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Blood pressure measurement event number
@objcMembers
public class IDOBpMeasurementParamModel: NSObject, IDOBaseModel {
    /// 1: Start measurement
    /// 2: End measurement
    /// 3: Get blood pressure data 
    public var flag: Int
    
    enum CodingKeys: String, CodingKey {
        case flag
    }
    
    public init(flag: Int) {
        self.flag = flag
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

