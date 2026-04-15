//
//  IDOSpo2SwitchParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Set SpO2 switch event

open class IDOSpo2SwitchParamModel(
    onOff: Int,
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int,
    lowSpo2OnOff: Int?,
    lowSpo2Value: Int?,
    notifyFlag: Int?
) : IDOBaseModel {

    /// SpO2 all-day switch
    /// 1 On
    /// 0 Off                     
    @SerializedName("on_off")
    var onOff: Int = onOff

    /// Start time (hour)
    @SerializedName("start_hour")
    var startHour: Int = startHour

    /// Start time (minute)
    @SerializedName("start_minute")
    var startMinute: Int = startMinute

    /// End time (hour)
    @SerializedName("end_hour")
    var endHour: Int = endHour

    /// End time (minute)
    @SerializedName("end_minute")
    var endMinute: Int = endMinute

    /// Low SpO2 switch
    /// 1 On
    /// 0 Off
    /// Requires support from the menu setSpo2AllDayOnOff
    @SerializedName("low_spo2_on_off")
    var lowSpo2OnOff: Int? = lowSpo2OnOff

    /// Low SpO2 threshold
    /// Requires support from the menu v3SupportSetSpo2LowValueRemind
    @SerializedName("low_spo2_value")
    var lowSpo2Value: Int? = lowSpo2Value

    /// Notification type
    /// 0: Invalid
    /// 1: Allow notifications
    /// 2: Silent notifications
    /// 3: Disable notifications
    /// Requires support from the menu getSpo2NotifyFlag
    @SerializedName("notify_flag")
    var notifyFlag: Int? = notifyFlag


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}



open class IDOSpo2SwitchModel(
    onOff: Int,
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int,
    lowSpo2OnOff: Int?,
    lowSpo2Value: Int?,
    notifyFlag: Int?
) : IDOBaseModel {

    /// SpO2 all-day switch
    /// 1 On
    /// 0 Off
    @SerializedName("on_off")
    var onOff: Int = onOff

    /// Start time (hour)
    @SerializedName("start_hour")
    var startHour: Int = startHour

    /// Start time (minute)
    @SerializedName("start_minute")
    var startMinute: Int = startMinute

    /// End time (hour)
    @SerializedName("end_hour")
    var endHour: Int = endHour

    /// End time (minute)
    @SerializedName("end_minute")
    var endMinute: Int = endMinute

    /// Low SpO2 switch
    /// 1 On
    /// 0 Off
    /// Requires support from the menu setSpo2AllDayOnOff
    @SerializedName("low_spo2_on_off")
    var lowSpo2OnOff: Int? = lowSpo2OnOff

    /// Low SpO2 threshold
    /// Requires support from the menu v3SupportSetSpo2LowValueRemind
    @SerializedName("low_spo2_value")
    var lowSpo2Value: Int? = lowSpo2Value

    /// Notification type
    /// 0: Invalid
    /// 1: Allow notifications
    /// 2: Silent notifications
    /// 3: Disable notifications
    /// Requires support from the menu getSpo2NotifyFlag
    @SerializedName("notify_flag")
    var notifyFlag: Int? = notifyFlag




    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}