//
//  IDONoticeMesaageParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.FieldNamingPolicy
import com.google.gson.GsonBuilder
import java.io.Serializable
import com.google.gson.annotations.SerializedName

open class IDONoticeMesaageParamModel(
    osPlatform: Int,
    evtType: Int,
    notifyType: Int,
    msgID: Int,
    appItemsLen: Int,
    contact: String,
    phoneNumber: String,
    msgData: String,
    items: List<IDONoticeMesaageParamItem>
) : IDOBaseModel {

    /// Protocol library version number
    @SerializedName("verison")
    private var verison: Int = 1

    /// System 0: Invalid, 1: Android, 2: iOS
    @SerializedName("os_platform")
    var osPlatform: Int = osPlatform

    /// Current mode 0: Invalid, 1: Message reminder
    @SerializedName("evt_type")
    var evtType: Int = evtType

    /// Enumeration type of message Max value: 20000
    @SerializedName("notify_type")
    var notifyType: Int = notifyType

    /// Message ID Valid only if evt_type is message reminder and msg_ID is not 0
    @SerializedName("msg_ID")
    var msgID: Int = msgID

    /// Number of country and language details
    @SerializedName("app_items_len")
    var appItemsLen: Int = appItemsLen

    /// Contact name (maximum 63 bytes)
    @SerializedName("contact")
    var contact: String = contact

    /// Phone number (maximum 31 bytes)
    @SerializedName("phone_number")
    var phoneNumber: String = phoneNumber

    /// Message content (maximum 249 bytes)
    @SerializedName("msg_data")
    var msgData: String = msgData

    @SerializedName("item")
    var items: List<IDONoticeMesaageParamItem> = items


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

// MARK: - IDOItem
open class IDONoticeMesaageParamItem(language: Int, name: String) : Serializable {
    /// Language type
    @SerializedName("language")
    var language: Int = language

    /// App name corresponding to the country (maximum 49 bytes)
    @SerializedName("name")
    var name: String = name

}