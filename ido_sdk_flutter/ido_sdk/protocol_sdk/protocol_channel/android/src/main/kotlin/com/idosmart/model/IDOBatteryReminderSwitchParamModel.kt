package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

/// 设备电量提醒开关设置入参
open class IDOBatteryReminderSwitchParamModel(lowBatteryOnOff: Int) : IDOBaseModel {

    /// 1：开启；0：关闭；0xFF：无效（标准化对外值）
    @SerializedName("low_battery_on_off")
    var lowBatteryOnOff: Int = lowBatteryOnOff

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

