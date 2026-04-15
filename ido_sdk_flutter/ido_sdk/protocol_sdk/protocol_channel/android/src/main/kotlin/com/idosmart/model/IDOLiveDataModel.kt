//
//  IDOLiveDataModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get Real-time Data event number

open class IDOLiveDataModel(
    totalStep: Int,
    totalCalories: Int,
    totalDistances: Int,
    totalActiveTime: Int,
    heartRate: Int
) : IDOBaseModel {

    /// Total steps
    @SerializedName("total_step")
    var totalStep: Int = totalStep

    /// Total calories (in kilocalories)
    @SerializedName("total_calories")
    var totalCalories: Int = totalCalories

    /// Total distance (in meters)
    @SerializedName("total_distances")
    var totalDistances: Int = totalDistances

    /// Total active time (in seconds)
    @SerializedName("total_active_time")
    var totalActiveTime: Int = totalActiveTime

    /// Heart rate data (in beats per minute)
    @SerializedName("heart_rate")
    var heartRate: Int = heartRate


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    