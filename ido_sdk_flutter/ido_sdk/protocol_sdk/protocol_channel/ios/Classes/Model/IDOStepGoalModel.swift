//
//  IDOStepGoalModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Get daily step goal event number
@objcMembers
public class IDOStepGoalModel: NSObject, IDOBaseModel {
    /// Daily step goal
    public var step: Int
    /// Weekly step goal
    /// Valid when v2_support_set_step_data_type_03_03 is enabled
    public var stepWeek: Int

    enum CodingKeys: String, CodingKey {
        case step = "step"
        case stepWeek = "step_week"
    }

    public init(step: Int, stepWeek: Int) {
        self.step = step
        self.stepWeek = stepWeek
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
