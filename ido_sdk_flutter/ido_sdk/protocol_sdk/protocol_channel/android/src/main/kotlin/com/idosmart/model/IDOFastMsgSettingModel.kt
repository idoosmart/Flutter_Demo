package com.idosmart.model


import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

open class IDOFastMsgSettingModel(type: Int, fastItems: List<IDOFastMsgItem>) : IDOBaseModel{
    @SerializedName("version")
    var type: Int = type
    @SerializedName("num")
    private var num: Int = fastItems.size
    @SerializedName("fast_items")
    var fastItems: List<IDOFastMsgItem> = fastItems

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

open class IDOFastMsgItem(msgId: Int, msgData: String): IDOBaseModel {
    @SerializedName("msg_id")
    var msgId: Int = msgId

    @SerializedName("msg_data")
    var msgData: String = msgData

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}