//
//  IDONoticeMessageStateParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.FieldNamingPolicy
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import java.io.Serializable
import com.google.gson.annotations.SerializedName

///


open class IDONoticeMessageStateParamModel(
    itemsNum: Int,
    operat: Int,
    allOnOff: Int,
    allSendNum: Int,
    allNotifyState: Int,
    nowSendIndex: Int,
    items: List<IDONoticeMessageStateItemItem>
) : IDOBaseModel {

    @SerializedName("version")
    private var version: Int = 1

    @SerializedName("items_num")
    var itemsNum: Int = itemsNum

    /// Operation 1: Add  2: Modify 3: Get and Query
    @SerializedName("operat")
    var operat: Int = operat

    /// Add and modify only
    /// Overall notification switch
    /// 1: Enable all notifications
    /// 0: Disable all notifications
    @SerializedName("all_on_off")
    var allOnOff: Int = allOnOff

    @SerializedName("all_notify_state")
    var allNotifyState: Int = allNotifyState

    /// Total number of packets sent
    /// For sending more than 100 packets in multiple parts
    /// all_send_num = now_send_index for completion of sending
    @SerializedName("all_send_num")
    var allSendNum: Int = allSendNum

    /// Current sequence of sending
    @SerializedName("now_send_index")
    var nowSendIndex: Int = nowSendIndex

    /// Message details
    /// Collection of evt_type, notify_state, and pic_flag
    @SerializedName("items")
    var items: List<IDONoticeMessageStateItemItem> = items

    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


// MARK: - IDONoticeMessageStateItemItem
open class IDONoticeMessageStateItemItem(evtType: Int, notifyState: Int, picFlag: Int) :
    Serializable {
    /// Event type
    @SerializedName("evt_type")
    var evtType: Int = evtType

    /// Notification status
    /// 1: Allow notifications
    /// 2: Silent notifications
    /// 3: Close notifications
    @SerializedName("notify_state")
    var notifyState: Int = notifyState

    /// Applies when replying, set this parameter to 0
    /// 0: Invalid
    /// 1: Download corresponding image
    /// 2: No corresponding image
    @SerializedName("pic_flag")
    var picFlag: Int = picFlag

}
