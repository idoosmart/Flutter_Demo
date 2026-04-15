//
//  IDOMainSportGoalModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Get Set Calorie/Distance/Mid-High Sport Time Goal event number
@objcMembers
public class IDOMainSportGoalModel: NSObject, IDOBaseModel {
    /// Activity calorie goal (in kilocalories)
    /// Requires firmware to enable function table `setCalorieGoal`
    public var calorie: Int
    /// Distance goal (in meters)
    public var distance: Int
    /// Minimum activity calorie value
    public var calorieMin: Int
    /// Maximum activity calorie value
    public var calorieMax: Int
    /// Mid-high sport time goal (in seconds)
    /// Requires firmware to enable function table `setMidHighTimeGoal`
    public var midHighTimeGoal: Int?
    /// Goal time(in hour)
    public var walkGoalTime: Int
    /// 0: Invalid
    /// 1: Daily goal
    /// 2: Weekly goal
    /// Requires firmware to enable function table `getSupportSetGetTimeGoalTypeV2`
    public var timeGoalType: Int?

    enum CodingKeys: String, CodingKey {
        case calorie = "calorie"
        case distance = "distance"
        case calorieMin = "calorie_min"
        case calorieMax = "calorie_max"
        case midHighTimeGoal = "mid_high_time_goal"
        case walkGoalTime = "walk_goal_time"
        case timeGoalType = "time_goal_type"
    }

    public init(calorie: Int = 0, distance: Int, calorieMin: Int, calorieMax: Int, midHighTimeGoal: Int = 0, walkGoalTime: Int, timeGoalType: Int = 0) {
        self.calorie = calorie
        self.distance = distance
        self.calorieMin = calorieMin
        self.calorieMax = calorieMax
        self.midHighTimeGoal = midHighTimeGoal
        self.walkGoalTime = walkGoalTime
        self.timeGoalType = timeGoalType
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
