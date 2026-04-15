//
//  IDOGpsStatusModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get GPS Status event number

open class IDOGpsStatusModel(gpsRunStatus: Int, agpsIsValid: Int) : IDOBaseModel {

    /// GPS running status
    /// 0 - Not running
    /// 1 - Searching for satellites
    /// 2 - Tracking
    @SerializedName("gps_run_status")
    var gpsRunStatus: Int = gpsRunStatus

    /// Validity of AGPS (Assisted GPS) in hours
    /// Non-zero values indicate validity
    @SerializedName("agps_is_valid")
    var agpsIsValid: Int = agpsIsValid


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    