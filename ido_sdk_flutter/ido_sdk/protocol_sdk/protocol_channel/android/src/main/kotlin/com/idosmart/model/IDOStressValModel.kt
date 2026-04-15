//
//  IDOStressValModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get stress value event number

open class IDOStressValModel(stressVal: Int, threshold: Int) : IDOBaseModel {

    /// Stress value
    @SerializedName("stress_val")
    var stressVal: Int = stressVal

    /// Threshold
    @SerializedName("threshold")
    var threshold: Int = threshold


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    