//
//  IDOHistoricalMenstruationParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.annotations.SerializedName

import com.google.gson.Gson
import com.google.gson.GsonBuilder

///


open class IDOHistoricalMenstruationParamModel(
    avgMenstrualDay: Int,
    avgCycleDay: Int,
    items: List<IDOHistoricalMenstruationParamItem>
) : IDOBaseModel {
    @SerializedName("version")
    private var version: Int = 0

    /// Average length of menstrual cycle Uint:day
    @SerializedName("avg_menstrual_day")
    var avgMenstrualDay: Int = avgMenstrualDay

    /// Average length of menstrual cycle Uint:day
    @SerializedName("avg_cycle_day")
    var avgCycleDay: Int = avgCycleDay

    @SerializedName("items_len")
    private var itemsLen: Int = items.size

    @SerializedName("items")
    var items: List<IDOHistoricalMenstruationParamItem> = items


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


// MARK: - IDOHistoricalMenstruationParamItem
open class IDOHistoricalMenstruationParamItem(
    year: Int,
    mon: Int,
    day: Int,
    menstrualDay: Int,
    cycleDay: Int,
    ovulationIntervalDay: Int,
    ovulationBeforeDay: Int,
    ovulationAfterDay: Int
) : IDOBaseModel {
    @SerializedName("year")
    var year: Int = year

    @SerializedName("mon")
    var mon: Int = mon

    @SerializedName("day")
    var day: Int = day

    /// Length of menstrual cycle (days)
    @SerializedName("menstrual_day")
    var menstrualDay: Int = menstrualDay

    @SerializedName("cycle_day")
    var cycleDay: Int = cycleDay

    /// The interval from the start of the next menstrual period to the ovulation day is usually 14 days when the Function
    @SerializedName("ovulation_interval_day")
    var ovulationIntervalDay: Int = ovulationIntervalDay

    /// The number of days of fertility before the ovulation day is usually 5 when the Function
    @SerializedName("ovulation_before_day")
    var ovulationBeforeDay: Int = ovulationBeforeDay

    /// The number of days of fertility after the ovulation day is usually 5 when the Function
    @SerializedName("ovulation_after_day")
    var ovulationAfterDay: Int = ovulationAfterDay
    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

}
