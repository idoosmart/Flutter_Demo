//
//  IDONotificationCenterModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Set Notification Center Event

open class IDONotificationCenterModel(notifySwitch: Int, statusCode: Int, errCode: Int) :
    IDOBaseModel {

    /// Notification reminder switch
    @SerializedName("notify_switch")
    var notifySwitch: Int = notifySwitch

    /// Status
    /// 0: Unknown timeout
    /// 1: Success
    /// 2: Failed (canceled)
    /// 3: Firmware pairing timeout
    @SerializedName("status_code")
    var statusCode: Int = statusCode

    /// 0: Success
    /// Non-zero: Failure
    @SerializedName("err_code")
    var errCode: Int = errCode


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    