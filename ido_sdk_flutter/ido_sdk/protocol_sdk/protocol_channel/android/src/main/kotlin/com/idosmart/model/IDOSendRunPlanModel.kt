//
//  IDOSendRunPlanModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// App issued running plan (exercise plan) event number

open class IDOSendRunPlanModel(
    errCode: Int,
    version: Int,
    operate: Int,
    type: Int,
    year: Int,
    month: Int,
    day: Int,
    hour: Int,
    min: Int,
    sec: Int
) : IDOBaseModel {

    /// 00: Success, 01: Failed, 02: Another running plan is already enabled
    @SerializedName("err_code")
    var errCode: Int = errCode

    /// Protocol library version number
    @SerializedName("version")
    var version: Int = version

    /// Operation:
    /// 1: Start plan
    /// 2: Plan data sent
    /// 3: End plan
    /// 4: Query running plan
    @SerializedName("operate")
    var operate: Int = operate

    /// Plan type:
    /// 1: 3km running plan
    /// 2: 5km running plan
    /// 3: 10km running plan
    /// 4: Half marathon training (Phase 2)
    /// 5: Marathon training (Phase 2)
    @SerializedName("type")
    var type: Int = type

    /// Plan implementation start time year
    @SerializedName("year")
    var year: Int = year

    /// Plan implementation start time month
    @SerializedName("month")
    var month: Int = month

    /// Plan implementation start time day
    @SerializedName("day")
    var day: Int = day

    /// Plan implementation start time hour
    @SerializedName("hour")
    var hour: Int = hour

    /// Plan implementation start time minute
    @SerializedName("min")
    var min: Int = min

    /// Plan implementation start time second
    @SerializedName("sec")
    var sec: Int = sec


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    