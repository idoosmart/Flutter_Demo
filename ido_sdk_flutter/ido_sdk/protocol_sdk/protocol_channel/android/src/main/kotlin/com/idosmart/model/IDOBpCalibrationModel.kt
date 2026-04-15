//
//  IDOBpCalibrationModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Blood pressure calibration event number

open class IDOBpCalibrationModel(retCode: Int) : IDOBaseModel {

    /// 0: Success
    /// 1: Successfully entered calibration mode, calibration in progress
    /// 2: In exercise mode
    /// 3: Device busy
    /// 4: Invalid status
    @SerializedName("ret_code")
    var retCode: Int = retCode

    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    