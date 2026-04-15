//
//  IDOBpMeasurementModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Blood pressure measurement event number

open class IDOBpMeasurementModel(status: Int, systolicBp: Int, diastolicBp: Int) : IDOBaseModel {

    /// 0: Not supported
    /// 1: Measurement in progress
    /// 2: Measurement successful
    /// 3: Measurement failed
    /// 4: Device in exercise mode 
    @SerializedName("status")
    var status: Int = status

    /// Systolic blood pressure
    @SerializedName("systolic_bp")
    var systolicBp: Int = systolicBp

    /// Diastolic blood pressure
    @SerializedName("diastolic_bp")
    var diastolicBp: Int = diastolicBp


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    