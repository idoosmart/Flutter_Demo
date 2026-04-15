package com.idosmart.model


import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

open class IDOFastMsgUpdateParamModel(isSuccess: Int, msgID: Int, msgType: Int, msgNotice: Int) : IDOBaseModel {

    /**
     * 0app发送信息失败，1app发送信息成功
     * */
    @SerializedName("is_success")
    var isSuccess: Int = isSuccess

    /**
     * 回复的ID :每个消息对应一个ID
     */
    @SerializedName("msg_ID")
    var msgID: Int = msgID

    /**
     * 消息类型
     */
    @SerializedName("msg_type")
    var msgType: Int = msgType

    /**
     * 0是没有对应的短信回复，对应回复列表
     */
    @SerializedName("msg_notice")
    var msgNotice: Int = msgNotice

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

}



open class IDOFastMsgUpdateModel(msgID: Int, msgType: Int, msgNotice: Int) : IDOBaseModel {

    /**
     * 回复的ID :每个消息对应一个ID
     */
    @SerializedName("msg_ID")
    var msgID: Int = msgID

    /**
     * 消息类型
     */
    @SerializedName("msg_type")
    var msgType: Int = msgType

    /**
     * 0是没有对应的短信回复，对应回复列表
     */
    @SerializedName("msg_notice")
    var msgNotice: Int = msgNotice

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

}