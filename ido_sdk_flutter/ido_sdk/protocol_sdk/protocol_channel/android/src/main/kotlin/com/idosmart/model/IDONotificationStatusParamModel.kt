//
//  IDONotificationStatusParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Notification app status setting event

open class IDONotificationStatusParamModel(notifyFlag: Int) : IDOBaseModel {

    /// Notification type:
    /// 1: Allow notification
    /// 2: Silent notification
    /// 3: Disable notification
    @SerializedName("notify_flag")
    var notifyFlag: Int = notifyFlag

    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    