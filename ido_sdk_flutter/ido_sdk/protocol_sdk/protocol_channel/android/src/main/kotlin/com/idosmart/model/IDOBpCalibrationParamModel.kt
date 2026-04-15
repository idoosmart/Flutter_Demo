//
//  IDOBpCalibrationParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Blood pressure calibration event number

open class IDOBpCalibrationParamModel(flag: Int, diastolic: Int, systolic: Int) : IDOBaseModel {

    /// 1: Blood pressure calibration settings
    /// 2: Blood pressure calibration query result
    @SerializedName("flag")
    var flag: Int = flag

    /// Systolic pressure
    @SerializedName("diastolic")
    var diastolic: Int = diastolic

    /// Diastolic pressure
    @SerializedName("systolic")
    var systolic: Int = systolic


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    