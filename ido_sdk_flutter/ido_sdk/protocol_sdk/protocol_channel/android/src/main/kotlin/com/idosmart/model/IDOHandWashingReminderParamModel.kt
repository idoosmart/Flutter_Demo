//
//  IDOHandWashingReminderParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.*
import java.lang.reflect.Type

///
/// Set Hand Washing Reminder Event

open class IDOHandWashingReminderParamModel(
    onOff: Int,
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int,
    repeats: HashSet<IDOWeek>,
    interval: Int
) : IDOBaseAdapterModel<IDOHandWashingReminderParamModel> {

    /// 0: Off
    /// 1: On
    /// Default is off
    var onOff: Int = onOff

    /// Start hour of the reminder
    var startHour: Int = startHour

    /// Start minute of the reminder
    var startMinute: Int = startMinute

    /// End hour of the reminder
    var endHour: Int = endHour

    /// End minute of the reminder
    var endMinute: Int = endMinute

    /// Repeat
    var repeats: HashSet<IDOWeek> = repeats

    /// Reminder interval in minutes
    /// Default is 60 minutes
    var interval: Int = interval
    override fun getDeSerializer(): IDOBaseModelDeSerializer<IDOHandWashingReminderParamModel>? {
        return HandWashingReminderParamModelSerializer()
    }

    override fun toString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


internal class HandWashingReminderParamModelSerializer : IDOBaseModelDeSerializer<IDOHandWashingReminderParamModel> {
    override fun serialize(src: IDOHandWashingReminderParamModel, typeOfSrc: Type, context: JsonSerializationContext): JsonElement {
        val jsonObject = JsonObject()
        jsonObject.addProperty("on_off", src.onOff)
        jsonObject.addProperty("start_hour", src.startHour)
        jsonObject.addProperty("start_minute", src.startMinute)
        jsonObject.addProperty("end_hour", src.endHour)
        jsonObject.addProperty("end_minute", src.endMinute)
        jsonObject.addProperty("interval", src.interval)

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
    ): IDOHandWashingReminderParamModel? {
        json?.let {
            val jsonObject = it.asJsonObject
            val onOff = jsonObject.get("on_off").asInt
            val startHour = jsonObject.get("start_hour").asInt
            val startMinute = jsonObject.get("start_minute").asInt
            val endHour = jsonObject.get("end_hour").asInt
            val endMinute = jsonObject.get("end_minute").asInt
            val interval = jsonObject.get("interval").asInt

            val repeat = jsonObject.get("repeat").asInt
            val items = HashSet<IDOWeek>()
            for (i in 0..6) {
                if (repeat and (1 shl (i + 1)) != 0) {
                    items.add(IDOWeek.fromRawValue(i))
                }
            }

            return IDOHandWashingReminderParamModel(
                onOff,
                startHour,
                startMinute,
                endHour,
                endMinute,
                items,
                interval
            )
        }
        return null
    }
}