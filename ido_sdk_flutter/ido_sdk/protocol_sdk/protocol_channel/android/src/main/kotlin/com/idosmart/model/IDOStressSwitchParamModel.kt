package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.JsonDeserializationContext
import com.google.gson.JsonElement
import com.google.gson.JsonObject
import com.google.gson.JsonSerializationContext
import com.google.gson.annotations.SerializedName
import java.lang.reflect.Type

open class IDOStressSwitchParamModel(
    onOff: Int,
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int,

    remindOnOff: Int,
    interval: Int,
    highThreshold: Int,
    stressThreshold: Int?,

    notifyFlag: Int,
    repeats: HashSet<IDOWeek>,
) : IDOBaseAdapterModel<IDOStressSwitchParamModel> {


    /// Overall switch 1: On 0: Off
    var onOff = onOff

    /// Start time - hour
    var startHour = startHour

    /// Start time - minute
    var startMinute = startMinute

    /// End time - hour
    var endHour = endHour

    /// End time - minute
    var endMinute = endMinute

    /// Stress reminder switch 1: On 0: Off
    /// Doesn't work if on_off is off
    var remindOnOff = remindOnOff

    /// Reminder interval in minutes, default is 60 minutes
    var interval = interval

    /// High pressure threshold
    var highThreshold = highThreshold

    /// Pressure calibration threshold, default is 80
    /// Requires firmware support for setSendCalibrationThreshold
    var stressThreshold = stressThreshold

    /** Notification type
     * 0: Invalid
     * 1: Allow notification
     * 2: Silent notification
     * 3: Disable notification
     * Requires firmware support for getPressureNotifyFlagMode
     */
    var notifyFlag = notifyFlag

    /// Repeat
    var repeats: HashSet<IDOWeek> = repeats


    override fun getDeSerializer(): IDOBaseModelDeSerializer<IDOStressSwitchParamModel>? {
        return StressSwitchParamModelSerializer()
    }

    override fun toString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


internal class StressSwitchParamModelSerializer : IDOBaseModelDeSerializer<IDOStressSwitchParamModel> {
    override fun serialize(src: IDOStressSwitchParamModel, typeOfSrc: Type, context: JsonSerializationContext): JsonElement {
        val jsonObject = JsonObject()
        jsonObject.addProperty("on_off", src.onOff)
        jsonObject.addProperty("start_hour", src.startHour)
        jsonObject.addProperty("start_minute", src.startMinute)
        jsonObject.addProperty("end_hour", src.endHour)
        jsonObject.addProperty("end_minute", src.endMinute)
        jsonObject.addProperty("interval", src.interval)
        jsonObject.addProperty("notify_flag", src.notifyFlag)
        jsonObject.addProperty("remind_on_off", src.remindOnOff)
        jsonObject.addProperty("high_threshold", src.highThreshold)
        jsonObject.addProperty("stress_threshold", src.stressThreshold)

        var num = 0
        src.repeats.forEach { week ->
            num = num or (1 shl week.rawValue + 1)
        }
        jsonObject.addProperty("repeat", num)
        return jsonObject
    }

    override fun deserialize(
        json: JsonElement?,
        typeOfT: Type?,
        context: JsonDeserializationContext?
    ): IDOStressSwitchParamModel? {
        json?.let {
            val jsonObject = it.asJsonObject
            val onOff = jsonObject.get("on_off").asInt
            val startHour = jsonObject.get("start_hour").asInt
            val startMinute = jsonObject.get("start_minute").asInt
            val endHour = jsonObject.get("end_hour").asInt
            val endMinute = jsonObject.get("end_minute").asInt
            val notifyFlag = jsonObject.get("notify_flag").asInt
            val interval = jsonObject.get("interval").asInt
            val remindOnOff = jsonObject.get("remind_on_off").asInt
            val highThreshold = jsonObject.get("high_threshold").asInt
            val stressThreshold = jsonObject.get("stress_threshold").asInt

            val repeat = jsonObject.get("repeat").asInt
            val items = HashSet<IDOWeek>()
            for (i in 0..6) {
                if (repeat and (1 shl (i + 1)) != 0) {
                    items.add(IDOWeek.fromRawValue(i))
                }
            }

            return IDOStressSwitchParamModel(onOff, startHour, startMinute, endHour, endMinute, remindOnOff, interval, highThreshold, stressThreshold, notifyFlag, items)
        }
        return null
    }
}


open class IDOStressSwitchModel(
    onOff: Int,
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int,

    remindOnOff: Int,
    interval: Int,
    highThreshold: Int,
    stressThreshold: Int?,

    notifyFlag: Int,
    repeats: HashSet<IDOWeek>,
) : IDOBaseAdapterModel<IDOStressSwitchModel> {


    /// Overall switch 1: On 0: Off
    var onOff = onOff

    /// Start time - hour
    var startHour = startHour

    /// Start time - minute
    var startMinute = startMinute

    /// End time - hour
    var endHour = endHour

    /// End time - minute
    var endMinute = endMinute

    /// Stress reminder switch 1: On 0: Off
    /// Doesn't work if on_off is off
    var remindOnOff = remindOnOff

    /// Reminder interval in minutes, default is 60 minutes
    var interval = interval

    /// High pressure threshold
    var highThreshold = highThreshold

    /// Pressure calibration threshold, default is 80
    /// Requires firmware support for setSendCalibrationThreshold
    var stressThreshold = stressThreshold

    /** Notification type
     * 0: Invalid
     * 1: Allow notification
     * 2: Silent notification
     * 3: Disable notification
     * Requires firmware support for getPressureNotifyFlagMode
     */
    var notifyFlag = notifyFlag

    /// Repeat
    var repeats: HashSet<IDOWeek> = repeats


    override fun getDeSerializer(): IDOBaseModelDeSerializer<IDOStressSwitchModel>? {
        return StressSwitchModelSerializer()
    }

    override fun toString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


internal class StressSwitchModelSerializer : IDOBaseModelDeSerializer<IDOStressSwitchModel> {
    override fun serialize(src: IDOStressSwitchModel, typeOfSrc: Type, context: JsonSerializationContext): JsonElement {
        val jsonObject = JsonObject()
        jsonObject.addProperty("on_off", src.onOff)
        jsonObject.addProperty("start_hour", src.startHour)
        jsonObject.addProperty("start_minute", src.startMinute)
        jsonObject.addProperty("end_hour", src.endHour)
        jsonObject.addProperty("end_minute", src.endMinute)
        jsonObject.addProperty("interval", src.interval)
        jsonObject.addProperty("notify_flag", src.notifyFlag)
        jsonObject.addProperty("remind_on_off", src.remindOnOff)
        jsonObject.addProperty("high_threshold", src.highThreshold)
        jsonObject.addProperty("stress_threshold", src.stressThreshold)

        var num = 0
        src.repeats.forEach { week ->
            num = num or (1 shl week.rawValue + 1)
        }
        jsonObject.addProperty("repeat", num)
        return jsonObject
    }

    override fun deserialize(
        json: JsonElement?,
        typeOfT: Type?,
        context: JsonDeserializationContext?
    ): IDOStressSwitchModel? {
        json?.let {
            val jsonObject = it.asJsonObject
            val onOff = jsonObject.get("on_off").asInt
            val startHour = jsonObject.get("start_hour").asInt
            val startMinute = jsonObject.get("start_minute").asInt
            val endHour = jsonObject.get("end_hour").asInt
            val endMinute = jsonObject.get("end_minute").asInt
            val notifyFlag = jsonObject.get("notify_flag").asInt
            val interval = jsonObject.get("interval").asInt
            val remindOnOff = jsonObject.get("remind_on_off").asInt
            val highThreshold = jsonObject.get("high_threshold").asInt
            val stressThreshold = jsonObject.get("stress_threshold").asInt

            val repeat = jsonObject.get("repeat").asInt
            val items = HashSet<IDOWeek>()
            for (i in 0..6) {
                if (repeat and (1 shl (i + 1)) != 0) {
                    items.add(IDOWeek.fromRawValue(i))
                }
            }

            return IDOStressSwitchModel(onOff, startHour, startMinute, endHour, endMinute, remindOnOff, interval, highThreshold, stressThreshold, notifyFlag, items)
        }
        return null
    }
}