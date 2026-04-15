//
//  IDOStressCalibrationModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///


open class IDOStressCalibrationModel(retCode: Int) : IDOBaseModel {

    /// 0: Success
    /// 1: Failed - Calibration in progress
    /// 2: Failed - Charging
    /// 3: Failed - Not wearing
    /// 4: Failed - In a sports scene
    @SerializedName("ret_code")
    var retCode: Int = retCode


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    