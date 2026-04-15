package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

/// 设备电量提醒开关获取返回
open class IDOBatteryReminderSwitchModel(lowBatteryOnOff: Int) : IDOBaseModel {

    /// 1：开启；0：关闭；0xFF：无效/未知
    @SerializedName("low_battery_on_off")
    var lowBatteryOnOff: Int = lowBatteryOnOff

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

