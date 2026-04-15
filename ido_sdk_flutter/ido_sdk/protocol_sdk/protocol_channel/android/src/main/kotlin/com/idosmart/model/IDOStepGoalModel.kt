//
//  IDOStepGoalModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get daily step goal event number

open class IDOStepGoalModel(step: Int, stepWeek: Int) : IDOBaseModel {

    /// Daily step goal
    @SerializedName("step")
    var step: Int = step

    /// Weekly step goal
    /// Valid when v2_support_set_step_data_type_03_03 is enabled
    @SerializedName("step_week")
    var stepWeek: Int = stepWeek


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    