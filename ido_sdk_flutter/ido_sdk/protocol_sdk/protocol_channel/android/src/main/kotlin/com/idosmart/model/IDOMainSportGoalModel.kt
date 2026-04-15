//
//  IDOMainSportGoalModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get Set Calorie/Distance/Mid-High Sport Time Goal event number

open class IDOMainSportGoalModel(
    calorie: Int,
    distance: Int,
    calorieMin: Int,
    calorieMax: Int,
    midHighTimeGoal: Int,
    walkGoalTime: Int,
    timeGoalType: Int
) : IDOBaseModel {

    /// Activity calorie goal (in kilocalories)
    /// Requires firmware to enable function table `setCalorieGoal`
    @SerializedName("calorie")
    var calorie: Int = calorie

    /// Distance goal (in meters)
    @SerializedName("distance")
    var distance: Int = distance

    /// Minimum activity calorie value
    @SerializedName("calorie_min")
    var calorieMin: Int = calorieMin

    /// Maximum activity calorie value
    @SerializedName("calorie_max")
    var calorieMax: Int = calorieMax

    /// Mid-high sport time goal (in seconds)
    /// Requires firmware to enable function table `setMidHighTimeGoal`
    @SerializedName("mid_high_time_goal")
    var midHighTimeGoal: Int = midHighTimeGoal

    /// Goal time(in hour)
    @SerializedName("walk_goal_time")
    var walkGoalTime: Int = walkGoalTime

    /// 0: Invalid
    /// 1: Daily goal
    /// 2: Weekly goal
    /// Requires firmware to enable function table `getSupportSetGetTimeGoalTypeV2`
    @SerializedName("time_goal_type")
    var timeGoalType: Int = timeGoalType


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

}
    