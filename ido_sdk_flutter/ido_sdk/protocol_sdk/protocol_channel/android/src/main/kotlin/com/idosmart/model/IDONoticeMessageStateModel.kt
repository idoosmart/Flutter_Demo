//
//  IDONoticeMessageStateModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.FieldNamingPolicy
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
open class IDONoticeMessageStateModel(
    errCode: Int,
    operat: Int,
    allOnOff: Int,
    allNotifyState: Int,
    items: List<IDONoticeMessageStateItemItem>
) : IDOBaseModel {

    @SerializedName("version")
    private var version: Int = 0

    /// Error code: 0 for success, non-zero for failure
    @SerializedName("err_code")
    var errCode: Int = errCode

    /// Operation
    /// 1: Add
    /// 2: Modify
    /// 3: Get and Query
    @SerializedName("operat")
    var operat: Int = operat

    /// Valid for querying
    /// Reply with overall notification switch status
    /// 1: Enable all notifications,
    /// 0: Disable all notifications
    /// -1:Invalid
    @SerializedName("all_on_off")
    var allOnOff: Int = allOnOff

    @SerializedName("all_notify_state")
    var allNotifyState: Int = allNotifyState
    
    @SerializedName("items_num")
    private var itemsNum: Int = items.size



    /// Message details content, valid for querying
    @SerializedName("items")
    var items: List<IDONoticeMessageStateItemItem> = items


    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    