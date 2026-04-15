//
//  IDOBpMeasurementParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Blood pressure measurement event number

open class IDOBpMeasurementParamModel(flag: Int) : IDOBaseModel {

    /// 1: Start measurement
    /// 2: End measurement
    /// 3: Get blood pressure data 
    @SerializedName("flag")
    var flag: Int = flag


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    