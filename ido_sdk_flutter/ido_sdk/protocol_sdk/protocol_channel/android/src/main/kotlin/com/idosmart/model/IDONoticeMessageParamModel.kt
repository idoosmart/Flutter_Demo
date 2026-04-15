//
//  IDONoticeMessageParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
open class IDONoticeMessageParamModel(
    evtType: Int,
    msgID: Int,
    supportAnswering: Boolean,
    supportMute: Boolean,
    supportHangUp: Boolean,
    contact: String,
    phoneNumber: String,
    dataText: String
) : IDOBaseModel {

    /// Protocol library version number
    /// Default version=1
    /// Version=2 is the sent format with msg_id
    @SerializedName("verison")
    private var verison: Int = 1

    /// Message application type
    @SerializedName("evt_type")
    var evtType: Int = evtType

    /// Message ID
    /// If evt_type is message reminder, mesg_ID is valid
    @SerializedName("msg_id")
    var msgID: Int = msgID

    /// Support answering: 1
    /// Do not support answering: 0
    @SerializedName("support_answering")
    var supportAnswering: Boolean = supportAnswering

    /// Support mute: 1
    /// Do not support mute: 0
    @SerializedName("support_mute")
    var supportMute: Boolean = supportMute

    /// Support hang up: 1
    /// Do not support hang up: 0
    @SerializedName("support_hang_up")
    var supportHangUp: Boolean = supportHangUp

    /// Contact name (maximum 63 bytes)
    @SerializedName("contact")
    var contact: String = contact

    /// Phone number (maximum 31 bytes)
    @SerializedName("phone_number")
    var phoneNumber: String = phoneNumber

    /// Message content (maximum 249 bytes)
    @SerializedName("data_text")
    var dataText: String = dataText


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    