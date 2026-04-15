//
//  IDOSupportMaxSetItemsNumModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get maximum number of settings supported by firmware event number

open class IDOSupportMaxSetItemsNumModel(
    contactMaxSetNum: Int,
    reminderMaxSetNum: Int,
    msgMaxBuffSize: Int
) : IDOBaseModel {

    /// Maximum number of frequently contacted persons that firmware supports for app to set (default is 10)
    @SerializedName("contact_max_set_num")
    var contactMaxSetNum: Int = contactMaxSetNum

    /// Maximum number of schedule reminders that firmware supports for app to set(default is 30)
    @SerializedName("reminder_max_set_num")
    var reminderMaxSetNum: Int = reminderMaxSetNum

    /// Maximum sending buffer size of message reminders (default is 250 bytes)
    @SerializedName("msg_max_buff_size")
    var msgMaxBuffSize: Int = msgMaxBuffSize


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    