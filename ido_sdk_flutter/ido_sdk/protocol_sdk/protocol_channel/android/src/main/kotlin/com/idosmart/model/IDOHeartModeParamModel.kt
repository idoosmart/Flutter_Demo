//
//  IDOHeartModeParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///

// MARK: - IDOHeartModeParamModel

open class IDOHeartModeParamModel(
    updateTime: Int,
    mode: Int = 0,
    hasTimeRange: Int = 0,
    startHour: Int = 0,
    startMinute: Int = 0,
    endHour: Int = 0,
    endMinute: Int = 0,
    measurementInterval: Int = 0,
    notifyFlag: Int = 0,
    highHeartMode: Int = 0,
    lowHeartMode: Int = 0,
    highHeartValue: Int = 0,
    lowHeartValue: Int = 0
) : IDOBaseModel {

    /// Update time as a Unix timestamp in seconds. If equal to 0, it means to get the current UTC timestamp.
    @SerializedName("update_time")
    var updateTime: Int = updateTime

    /// Mode
    /// ```
    /// 0: Off
    /// 1: Auto (5 minutes)
    /// 2: Continuous monitoring (5 seconds)
    /// 3: Manual mode (disables auto)
    /// 4: Default type, firmware automatically sets to default mode after setting
    /// 5: Set the corresponding measurement interval
    /// 6: Intelligent Heart Rate Mode (ID206)
    /// Note:
    /// 1. If the function setSetV3HeartInterval is configured, Mode 0, Mode 1, and Mode 2 will be ineffective.
    /// 2. When configuring with fast settings, setting setSetV3HeartInterval will activate Mode 5
    /// 3. When setting continuous heart rate, if the function setSetV3HeartInterval is configured, the corresponding mode is Mode 5.
    /// ```
    @SerializedName("mode")
    var mode: Int = mode

    /// Whether there is a time range. 0: No, 1: Yes
    @SerializedName("has_time_range")
    var hasTimeRange: Int = hasTimeRange

    @SerializedName("start_hour")
    var startHour: Int = startHour

    @SerializedName("start_minute")
    var startMinute: Int = startMinute

    @SerializedName("end_hour")
    var endHour: Int = endHour

    @SerializedName("end_minute")
    var endMinute: Int = endMinute

    /// Measurement interval in seconds
    @SerializedName("measurement_interval")
    var measurementInterval: Int = measurementInterval

    /// Notification type:
    /// ```
    /// 0: Invalid
    /// 1: Allow notifications
    /// 2: Silent notifications
    /// 3: Close notifications
    /// Note: This is ineffective if the firmware does not enable v3HeartSetRateModeCustom
    /// ```
    @SerializedName("notify_flag")
    var notifyFlag: Int = notifyFlag

    /// 1: Enable smart high heart rate reminder
    /// 0: Off
    /// Note: This is ineffective if the firmware does not enable v3HeartSetRateModeCustom
    @SerializedName("high_heart_mode")
    var highHeartMode: Int = highHeartMode

    /// 1: Enable smart low heart rate reminder
    /// 0: Off
    /// Note: This is ineffective if the firmware does not enable v3HeartSetRateModeCustom
    @SerializedName("low_heart_mode")
    var lowHeartMode: Int = lowHeartMode

    /// Smart high heart rate reminder threshold
    /// Note: This is ineffective if the firmware does not enable v3HeartSetRateModeCustom
    @SerializedName("high_heart_value")
    var highHeartValue: Int = highHeartValue

    /// Smart low heart rate reminder threshold
    /// Note: This is ineffective if the firmware does not enable v3HeartSetRateModeCustom
    @SerializedName("low_heart_value")
    var lowHeartValue: Int = lowHeartValue


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

open class IDOHeartModeModel(
    updateTime: Int,
    mode: Int,
    hasTimeRange: Int,
    getMinMode: Int,
    getSECMode: Int,
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int,
    measurementInterval: Int,
    notifyFlag: Int,
    highHeartMode: Int,
    lowHeartMode: Int,
    highHeartValue: Int,
    lowHeartValue: Int
) : IDOBaseModel {

    /// Update time as a Unix timestamp in seconds. If equal to 0, it means to get the current UTC timestamp.
    @SerializedName("update_time")
    var updateTime: Int = updateTime

    /// Mode
    /// ```
    /// 0: Off
    /// 1: Auto (5 minutes)
    /// 2: Continuous monitoring (5 seconds)
    /// 3: Manual mode (disables auto)
    /// 4: Default type, firmware automatically sets to default mode after setting
    /// 5: Set the corresponding measurement interval
    /// 6: Intelligent Heart Rate Mode (ID206)
    /// Note:
    /// 1. If the function setSetV3HeartInterval is configured, Mode 0, Mode 1, and Mode 2 will be ineffective.
    /// 2. When configuring with fast settings, setting setSetV3HeartInterval will activate Mode 5
    /// 3. When setting continuous heart rate, if the function setSetV3HeartInterval is configured, the corresponding mode is Mode 5.
    /// ```
    @SerializedName("mode")
    var mode: Int = mode

    /// Currently supported heart rate types by the watch
    /// ```
    /// all 0 invalid values
    /// Bit0: 5s mode
    /// Note: This is returned as 0 if setSetV3HeartInterval is not enabled in the firmware
    /// ```
    @SerializedName("get_secmode")
    var getSECMode: Int = getSECMode

    @SerializedName("sec_mode_array")
    var secModeArray: List<Int> = listOf()

    /// Currently supported heart rate types by the watch,
    /// ```
    /// all 0:invalid values
    /// Bit0: 1 minute
    /// bit1: 3 minutes
    /// bit2: 5 minutes
    /// bit3: 10 minutes
    /// bit4: 30 minutes
    /// bit5: 285 mode,
    /// bit6: 15 minute mode
    /// Note: This is returned as 0 if setSetV3HeartInterval is not enabled in the firmware
    /// ```
    @SerializedName("get_min_mode")
    var getMinMode: Int = getMinMode

    @SerializedName("min_mode_array")
    var minModeArray: List<Int> = listOf()

    /// Whether there is a time range. 0: No, 1: Yes
    @SerializedName("has_time_range")
    var hasTimeRange: Int = hasTimeRange

    @SerializedName("start_hour")
    var startHour: Int = startHour

    @SerializedName("start_minute")
    var startMinute: Int = startMinute

    @SerializedName("end_hour")
    var endHour: Int = endHour

    @SerializedName("end_minute")
    var endMinute: Int = endMinute

    /// Measurement interval in seconds
    @SerializedName("measurement_interval")
    var measurementInterval: Int = measurementInterval

    /// Notification type:
    /// ```
    /// 0: Invalid
    /// 1: Allow notifications
    /// 2: Silent notifications
    /// 3: Close notifications
    /// Note: This is ineffective if the firmware does not enable v3HeartSetRateModeCustom
    /// ```
    @SerializedName("notify_flag")
    var notifyFlag: Int = notifyFlag

    /// 1: Enable smart high heart rate reminder
    /// 0: Off
    /// Note: This is ineffective if the firmware does not enable v3HeartSetRateModeCustom
    @SerializedName("high_heart_mode")
    var highHeartMode: Int = highHeartMode

    /// 1: Enable smart low heart rate reminder
    /// 0: Off
    /// Note: This is ineffective if the firmware does not enable v3HeartSetRateModeCustom
    @SerializedName("low_heart_mode")
    var lowHeartMode: Int = lowHeartMode

    /// Smart high heart rate reminder threshold
    /// Note: This is ineffective if the firmware does not enable v3HeartSetRateModeCustom
    @SerializedName("high_heart_value")
    var highHeartValue: Int = highHeartValue

    /// Smart low heart rate reminder threshold
    /// Note: This is ineffective if the firmware does not enable v3HeartSetRateModeCustom
    @SerializedName("low_heart_value")
    var lowHeartValue: Int = lowHeartValue

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

}
    