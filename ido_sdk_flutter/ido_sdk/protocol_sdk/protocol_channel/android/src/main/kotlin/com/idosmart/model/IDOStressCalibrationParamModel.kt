//
//  IDOStressCalibrationParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Set Stress Calibration Event Code

open class IDOStressCalibrationParamModel(stressScore: Int, status: Int) : IDOBaseModel {

    /// Stress score, ranging from 1 to 10
    @SerializedName("stress_score")
    var stressScore: Int = stressScore

    /// 0: Start calibration setting
    /// 1: Cancel calibration setting
    @SerializedName("status")
    var status: Int = status


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    