//
//  IDOSportGoalParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.Gson
import com.google.gson.GsonBuilder

///
/// Set exercise goal event
import com.google.gson.annotations.SerializedName

open class IDOSportGoalParamModel(sportStep: Int, walkGoalSteps: Int, targetType: Int?) :
    IDOBaseModel {

    /// Number of steps for the exercise goal                        
    @SerializedName("sport_step")
    var sportStep: Int = sportStep

    /// Walk goal steps per hour setting
    @SerializedName("walk_goal_steps")
    var walkGoalSteps: Int = walkGoalSteps

    /// Target type setting
    /// 0: Invalid
    /// 1: Daily Goal 
    /// 2: Weekly Goal
    /// Requires support from the menu getStepDataTypeV2
    @SerializedName("target_type")
    var targetType: Int? = targetType


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    