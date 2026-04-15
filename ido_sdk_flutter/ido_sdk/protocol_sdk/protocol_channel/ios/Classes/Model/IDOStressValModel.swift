//
//  IDOStressValModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Get stress value event number
@objcMembers
public class IDOStressValModel: NSObject, IDOBaseModel {
    /// Stress value
    public var stressVal: Int
    /// Threshold
    public var threshold: Int

    enum CodingKeys: String, CodingKey {
        case stressVal = "stress_val"
        case threshold = "threshold"
    }

    public init(stressVal: Int, threshold: Int) {
        self.stressVal = stressVal
        self.threshold = threshold
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
