//
//  IDOScreenBrightnessModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get screen brightness event number

open class IDOScreenBrightnessModel(
    level: Int,
    opera: Int,
    mode: Int,
    autoAdjustNight: Int,
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int,
    nightLevel: Int,
    showInterval: Int
) : IDOBaseModel {

    /// Brightness level
    /// (0-100)
    @SerializedName("level")
    var level: Int = level

    /// 0 Auto
    /// 1 Manual
    /// If it is automatic synchronization configuration, please send 00; if it is user adjustment, please send 01
    @SerializedName("opera")
    var opera: Int = opera

    /// 0 Specify level
    /// 1 Use ambient light sensor
    /// 2 level does not matter
    @SerializedName("mode")
    var mode: Int = mode

    /// Night auto brightness adjustment
    /// 0 Invalid, defined by firmware
    /// 1 Off
    /// 2 Night auto brightness adjustment
    /// 3 Night brightness reduction uses the set time
    @SerializedName("auto_adjust_night")
    var autoAdjustNight: Int = autoAdjustNight

    /// Start time hour
    @SerializedName("start_hour")
    var startHour: Int = startHour

    /// Start time minute
    @SerializedName("start_minute")
    var startMinute: Int = startMinute

    /// End time hour
    @SerializedName("end_hour")
    var endHour: Int = endHour

    /// End time minute
    @SerializedName("end_minute")
    var endMinute: Int = endMinute

    /// Night brightness
    @SerializedName("night_level")
    var nightLevel: Int = nightLevel

    /// Display interval
    @SerializedName("show_interval")
    var showInterval: Int = showInterval


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    