package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

open class IDOCmdGetResponseModel(onOff: Int) : IDOBaseModel {
    /// Switch status
    /// 1: On
    /// 0: Off
    /// -1:Not Support
    @SerializedName("on_off")
    var onOff: Int = onOff

    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

}
