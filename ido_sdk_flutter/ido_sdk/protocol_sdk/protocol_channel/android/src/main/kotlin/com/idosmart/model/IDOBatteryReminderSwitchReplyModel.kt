package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

/// 设备电量提醒开关设置返回
open class IDOBatteryReminderSwitchReplyModel(retCode: Int) : IDOBaseModel {

    /// 0：成功；其他：失败
    @SerializedName("ret_code")
    var retCode: Int = retCode

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

