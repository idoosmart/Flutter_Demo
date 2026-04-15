//
//  IDOVersionInfoModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get version information event number

open class IDOVersionInfoModel(
    sdkVersion: Int,
    hrAlgorithmVersion: Int,
    sleepAlgorithmVersion: Int,
    stepAlgorithmVersion: Int,
    gestureRecognitionVersion: Int,
    pcbVersion: Int,
    spo2Version: Int,
    wearVersion: Int,
    stressVersion: Int,
    kcalVersion: Int,
    disVersion: Int,
    axle3SwimVersion: Int,
    axle6SwimVersion: Int,
    actModeTypeVersion: Int,
    allDayHrVersion: Int,
    gpsVersion: Int,
    peripheralsVersion: Int
) : IDOBaseModel {

    /// SDK version
    @SerializedName("sdk_version")
    var sdkVersion: Int = sdkVersion

    /// Heart rate algorithm version
    @SerializedName("hr_algorithm_version")
    var hrAlgorithmVersion: Int = hrAlgorithmVersion

    /// Sleep algorithm version
    @SerializedName("sleep_algorithm_version")
    var sleepAlgorithmVersion: Int = sleepAlgorithmVersion

    /// Step counter algorithm version
    @SerializedName("step_algorithm_version")
    var stepAlgorithmVersion: Int = stepAlgorithmVersion

    /// Gesture recognition algorithm version
    @SerializedName("gesture_recognition_version")
    var gestureRecognitionVersion: Int = gestureRecognitionVersion

    /// PCB version (multiplied by 10, e.g., 11 for version 1.1)
    @SerializedName("pcb_version")
    var pcbVersion: Int = pcbVersion

    /// Wearable version
    @SerializedName("spo2_version")
    var spo2Version: Int = spo2Version

    /// SpO2 algorithm version
    @SerializedName("wear_version")
    var wearVersion: Int = wearVersion

    /// Stress level algorithm version
    @SerializedName("stress_version")
    var stressVersion: Int = stressVersion

    /// Calorie algorithm version
    @SerializedName("kcal_version")
    var kcalVersion: Int = kcalVersion

    /// Distance algorithm version
    @SerializedName("dis_version")
    var disVersion: Int = disVersion

    /// 3-axis sensor swimming algorithm version
    @SerializedName("axle3_swim_version")
    var axle3SwimVersion: Int = axle3SwimVersion

    /// 6-axis sensor swimming algorithm version
    @SerializedName("axle6_swim_version")
    var axle6SwimVersion: Int = axle6SwimVersion

    /// Activity mode recognition algorithm version
    @SerializedName("act_mode_type_version")
    var actModeTypeVersion: Int = actModeTypeVersion

    /// All-day heart rate algorithm version
    @SerializedName("all_day_hr_version")
    var allDayHrVersion: Int = allDayHrVersion

    /// GPS algorithm version
    @SerializedName("gps_version")
    var gpsVersion: Int = gpsVersion

    /// Peripheral version for 206 customized projects
    @SerializedName("peripherals_version")
    var peripheralsVersion: Int = peripheralsVersion


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    