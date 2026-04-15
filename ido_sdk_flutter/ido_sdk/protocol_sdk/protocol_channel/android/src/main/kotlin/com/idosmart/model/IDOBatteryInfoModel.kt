//
//  IDOBatteryInfoModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.FieldNamingPolicy
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get battery information event number

open class IDOBatteryInfoModel(
    type: Int,
    voltage: Int,
    status: Int,
    level: Int,
    lastChargingYear: Int,
    lastChargingMonth: Int,
    lastChargingDay: Int,
    lastChargingHour: Int,
    lastChargingMinute: Int,
    lastChargingSecond: Int,
    mode: Int
) : IDOBaseModel {

    /// Battery type: 0: Rechargeable lithium battery, 1: Button battery
    @SerializedName("type")
    var type: Int = type

    /// Voltage
    @SerializedName("voltage")
    var voltage: Int = voltage

    /// Battery status
    /// 0: Normal
    /// 1: Charging
    /// 2: Charging complete
    /// 3: Low battery
    @SerializedName("status")
    var status: Int = status

    /// Level
    @SerializedName("level")
    var level: Int = level

    /// Last charging time, year
    @SerializedName("last_charging_year")
    var lastChargingYear: Int = lastChargingYear

    /// Last charging time, month
    @SerializedName("last_charging_month")
    var lastChargingMonth: Int = lastChargingMonth

    /// Last charging time, day
    @SerializedName("last_charging_day")
    var lastChargingDay: Int = lastChargingDay

    /// Last charging time, hour
    @SerializedName("last_charging_hour")
    var lastChargingHour: Int = lastChargingHour

    /// Last charging time, minute
    @SerializedName("last_charging_minute")
    var lastChargingMinute: Int = lastChargingMinute

    /// Last charging time, second
    @SerializedName("last_charging_second")
    var lastChargingSecond: Int = lastChargingSecond

    /// 0: Invalid
    /// 1: Normal mode (non-power saving mode)
    /// 2: Power saving mode
    @SerializedName("mode")
    var mode: Int = mode




    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    