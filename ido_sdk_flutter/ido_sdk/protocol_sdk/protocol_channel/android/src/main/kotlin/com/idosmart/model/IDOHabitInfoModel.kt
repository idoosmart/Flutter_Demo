//
//  IDOHabitInfoModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///

open class IDOHabitInfoModel(
    browseCount: Int,
    implementCount: Int,
    broItems: List<IDOHabitBroItem>,
    impItems: List<IDOHabitImpItem>
) : IDOBaseModel {

    @SerializedName("browse_count")
    var browseCount: Int = browseCount

    @SerializedName("implement_count")
    var implementCount: Int = implementCount

    @SerializedName("bro_items")
    var broItems: List<IDOHabitBroItem> = broItems

    @SerializedName("imp_items")
    var impItems: List<IDOHabitImpItem> = impItems


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


// MARK: - IDOBroItem
open class IDOHabitBroItem(
    type: Int,
    evt: Int,
    year: Int,
    month: Int,
    day: Int,
    hour: Int,
    min: Int,
    sec: Int,
    count: Int
) {
    @SerializedName("type")
    var type: Int = type

    @SerializedName("evt")
    var evt: Int = evt

    @SerializedName("year")
    var year: Int = year

    @SerializedName("month")
    var month: Int = month

    @SerializedName("day")
    var day: Int = day

    @SerializedName("hour")
    var hour: Int = hour

    @SerializedName("min")
    var min: Int = min

    @SerializedName("sec")
    var sec: Int = sec

    @SerializedName("count")
    var count: Int = count

}

// MARK: - IDOImpItem
open class IDOHabitImpItem(
    type: Int,
    evt: Int,
    startYear: Int,
    startMonth: Int,
    startDay: Int,
    startHour: Int,
    startMin: Int,
    startSEC: Int,
    endYear: Int,
    endMonth: Int,
    endDay: Int,
    endHour: Int,
    endMin: Int,
    endSEC: Int,
    completionRate: Int
) {
    @SerializedName("type")
    var type: Int = type

    @SerializedName("evt")
    var evt: Int = evt

    @SerializedName("start_year")
    var startYear: Int = startYear

    @SerializedName("start_month")
    var startMonth: Int = startMonth

    @SerializedName("start_day")
    var startDay: Int = startDay

    @SerializedName("start_hour")
    var startHour: Int = startHour

    @SerializedName("start_min")
    var startMin: Int = startMin

    @SerializedName("start_sec")
    var startSEC: Int = startSEC

    @SerializedName("end_year")
    var endYear: Int = endYear

    @SerializedName("end_month")
    var endMonth: Int = endMonth

    @SerializedName("end_day")
    var endDay: Int = endDay

    @SerializedName("end_hour")
    var endHour: Int = endHour

    @SerializedName("end_min")
    var endMin: Int = endMin

    @SerializedName("end_sec")
    var endSEC: Int = endSEC

    @SerializedName("completion_rate")
    var completionRate: Int = completionRate

}