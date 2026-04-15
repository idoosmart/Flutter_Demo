//
//  IDODateTimeParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.annotations.SerializedName

import com.google.gson.Gson
import com.google.gson.GsonBuilder

///

/// 设置时间

open class IDODateTimeParamModel(
    year: Int,
    monuth: Int,
    day: Int,
    hour: Int,
    minute: Int,
    second: Int,
    week: Int,
    timeZone: Int
) : IDOBaseModel {


    @SerializedName("year")
    var year: Int = year

    @SerializedName("monuth")
    var monuth: Int = monuth

    @SerializedName("day")
    var day: Int = day

    @SerializedName("hour")
    var hour: Int = hour

    @SerializedName("minute")
    var minute: Int = minute

    @SerializedName("second")
    var second: Int = second

    /// Week: 0-6 for Monday to Sunday
    @SerializedName("week")
    var week: Int = week

    /// Timezone in a 24-hour format: 0-12 for East ,13-24 for West
    @SerializedName("time_zone")
    var timeZone: Int = timeZone


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    