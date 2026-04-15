//
//  IDOSimpleHeartRateZoneSettingModel.kt
//  protocol_channel
//
//  Created by tw on 2025/05/06.
package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

open class IDOSimpleHeartRateZoneSettingModel(@SerializedName("max_hr_value") val maxHrValue: Int) : IDOBaseModel {
    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}