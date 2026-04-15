//
//  IDOAllHealthSwitchStateModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.FieldNamingPolicy
import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get event number for all health monitoring switches

open class IDOAllHealthSwitchStateModel(
    heartMode: Int,
    pressureMode: Int,
    spo2Mode: Int,
    scienceMode: Int,
    temperatureMode: Int,
    noiseMode: Int,
    menstrualMode: Int,
    walkMode: Int,
    handwashingMode: Int,
    respirRateState: Int,
    bodyPowerState: Int,
    drinkwaterMode: Int,
    heartmodeNotifyFlag: Int,
    pressureNotifyFlag: Int,
    spo2NotifyFlag: Int,
    menstrualNotifyFlag: Int,
    guidanceNotifyFlag: Int,
    reminderNotifyFlag: Int
) : IDOBaseModel {

    /// Continuous heart rate measurement switch:
    /// 1:On
    /// 0:Off
    /// -1:Not Support
    @SerializedName("heart_mode")
    var heartMode: Int = heartMode

    /// Automatic blood pressure measurement switch
    /// 1:On
    /// 0:Off
    /// -1:Not Support
    @SerializedName("pressure_mode")
    var pressureMode: Int = pressureMode

    /// Automatic blood oxygen measurement switch
    /// 1:On
    /// 0:Off
    /// -1:Not Support
    @SerializedName("spo2_mode")
    var spo2Mode: Int = spo2Mode

    /// Scientific sleep switch
    /// 2:scientific sleep mode
    /// 1:normal sleep mode
    /// -1:Not Support
    @SerializedName("science_mode")
    var scienceMode: Int = scienceMode

    /// Nighttime temperature switch
    /// 1:On
    /// 0:Off
    /// -1:Not Support
    @SerializedName("temperature_mode")
    var temperatureMode: Int = temperatureMode

    /// Noise switch
    /// 1:On
    /// 0:Off
    /// -1:Not Support
    @SerializedName("noise_mode")
    var noiseMode: Int = noiseMode

    /// Menstrual cycle switch
    /// 1:On
    /// 0:Off
    /// -1:Not Support
    @SerializedName("menstrual_mode")
    var menstrualMode: Int = menstrualMode

    /// Walking reminder switch
    /// 1:On
    /// 0:Off
    /// -1:Not Support
    @SerializedName("walk_mode")
    var walkMode: Int = walkMode

    /// Handwashing reminder switch
    /// 1:On
    /// 0:Off
    /// -1:Not Support
    @SerializedName("handwashing_mode")
    var handwashingMode: Int = handwashingMode

    /// Respiration rate switch
    /// 1:On
    /// 0:Off
    /// -1:Not Support
    @SerializedName("respir_rate_state")
    var respirRateState: Int = respirRateState

    /// Body battery switch
    /// 1:On
    /// 0:Off
    /// -1:Not Support
    @SerializedName("body_power_state")
    var bodyPowerState: Int = bodyPowerState

    /// Drink water reminder switch
    /// 1:On
    /// 0:Off
    /// -1:Not Support
    @SerializedName("drinkwater_mode")
    var drinkwaterMode: Int = drinkwaterMode

    /// Heart rate notification status:
    /// 0 for invalid
    /// 1 for allow notification
    /// 2 for silent notification
    /// 3 for disable notification
    @SerializedName("heartmode_notify_flag")
    var heartmodeNotifyFlag: Int = heartmodeNotifyFlag

    /// Blood pressure notification status:
    /// 0 for invalid
    /// 1 for allow notification
    /// 2 for silent notification
    /// 3 for disable notification
    @SerializedName("pressure_notify_flag")
    var pressureNotifyFlag: Int = pressureNotifyFlag

    /// Blood oxygen notification status:
    /// 0 for invalid
    /// 1 for allow notification
    /// 2 for silent notification
    /// 3 for disable notification
    @SerializedName("spo2_notify_flag")
    var spo2NotifyFlag: Int = spo2NotifyFlag

    /// Menstrual cycle notification status:
    /// 0 for invalid
    /// 1 for allow notification
    /// 2 for silent notification
    /// 3 for disable notification
    @SerializedName("menstrual_notify_flag")
    var menstrualNotifyFlag: Int = menstrualNotifyFlag

    /// Fitness guidance notification status:
    /// 0 for invalid
    /// 1 for allow notification
    /// 2 for silent notification
    /// 3 for disable notification
    @SerializedName("guidance_notify_flag")
    var guidanceNotifyFlag: Int = guidanceNotifyFlag

    /// Reminder notification status:
    /// 0 for invalid
    /// 1 for allow notification
    /// 2 for silent notification
    /// 3 for disable notification
    @SerializedName("reminder_notify_flag")
    var reminderNotifyFlag: Int = reminderNotifyFlag




    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    