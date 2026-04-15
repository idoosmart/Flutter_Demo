//
//  IDOSportGoalParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Set exercise goal event
@objcMembers
public class IDOSportGoalParamModel: NSObject, IDOBaseModel {
    /// Number of steps for the exercise goal                        
    public var sportStep: Int
    /// Walk goal steps per hour setting                             
    public var walkGoalSteps: Int
    /// Target type setting
    /// 0: Invalid
    /// 1: Daily Goal 
    /// 2: Weekly Goal
    /// Requires support from the menu `getStepDataTypeV2`
    public var targetType: Int
    
    enum CodingKeys: String, CodingKey {
        case sportStep = "sport_step"
        case walkGoalSteps = "walk_goal_steps"
        case targetType = "target_type"
    }
    
    public init(sportStep: Int,walkGoalSteps: Int,targetType: Int = 0) {
        self.sportStep = sportStep
        self.walkGoalSteps = walkGoalSteps
        self.targetType = targetType
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

