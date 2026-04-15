//
//  IDOHeartRateModeSmartParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Set Smart Heart Rate Mode Event

open class IDOHeartRateModeSmartParamModel(
    mode: Int,
    notifyFlag: Int,
    highHeartMode: Int,
    lowHeartMode: Int,
    highHeartValue: Int,
    lowHeartValue: Int,
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int
) : IDOBaseModel {

    /// Switch
    /// 0:Off
    /// 1:On
    @SerializedName("mode")
    var mode: Int = mode

    /// Notification Type
    /// 0: Invalid
    /// 1: Allow Notifications
    /// 2: Silent Notifications
    /// 3: Disable Notifications
    @SerializedName("notify_flag")
    var notifyFlag: Int = notifyFlag

    /// 1: Enable Smart High Heart Rate Alert
    /// 0: Disable
    @SerializedName("high_heart_mode")
    var highHeartMode: Int = highHeartMode

    /// 1: Enable Smart Low Heart Rate Alert
    /// 0: Disable
    @SerializedName("low_heart_mode")
    var lowHeartMode: Int = lowHeartMode

    /// Smart High Heart Rate Alert Threshold
    @SerializedName("high_heart_value")
    var highHeartValue: Int = highHeartValue

    /// Smart Low Heart Rate Alert Threshold
    @SerializedName("low_heart_value")
    var lowHeartValue: Int = lowHeartValue

    /// Start Time of Heart Rate Monitoring (hour)
    @SerializedName("start_hour")
    var startHour: Int = startHour

    /// Start Time of Heart Rate Monitoring (minute)
    @SerializedName("start_minute")
    var startMinute: Int = startMinute

    /// End Time of Heart Rate Monitoring (hour)
    @SerializedName("end_hour")
    var endHour: Int = endHour

    /// End Time of Heart Rate Monitoring (minute)
    @SerializedName("end_minute")
    var endMinute: Int = endMinute


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}



open class IDOHeartRateModeSmartModel(
    mode: Int,
    notifyFlag: Int,
    highHeartMode: Int,
    lowHeartMode: Int,
    highHeartValue: Int,
    lowHeartValue: Int,
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int
) : IDOBaseModel {

    /// Switch
    /// 0:Off
    /// 1:On
    @SerializedName("mode")
    var mode: Int = mode

    /// Notification Type
    /// 0: Invalid
    /// 1: Allow Notifications
    /// 2: Silent Notifications
    /// 3: Disable Notifications
    @SerializedName("notify_flag")
    var notifyFlag: Int = notifyFlag

    /// 1: Enable Smart High Heart Rate Alert
    /// 0: Disable
    @SerializedName("high_heart_mode")
    var highHeartMode: Int = highHeartMode

    /// 1: Enable Smart Low Heart Rate Alert
    /// 0: Disable
    @SerializedName("low_heart_mode")
    var lowHeartMode: Int = lowHeartMode

    /// Smart High Heart Rate Alert Threshold
    @SerializedName("high_heart_value")
    var highHeartValue: Int = highHeartValue

    /// Smart Low Heart Rate Alert Threshold
    @SerializedName("low_heart_value")
    var lowHeartValue: Int = lowHeartValue

    /// Start Time of Heart Rate Monitoring (hour)
    @SerializedName("start_hour")
    var startHour: Int = startHour

    /// Start Time of Heart Rate Monitoring (minute)
    @SerializedName("start_minute")
    var startMinute: Int = startMinute

    /// End Time of Heart Rate Monitoring (hour)
    @SerializedName("end_hour")
    var endHour: Int = endHour

    /// End Time of Heart Rate Monitoring (minute)
    @SerializedName("end_minute")
    var endMinute: Int = endMinute




    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
