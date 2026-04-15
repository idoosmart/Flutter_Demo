//
//  IDOTakingMedicineReminderParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.*
import java.lang.reflect.Type

///
/// Set Taking Medicine Reminder Event Code
open class IDOTakingMedicineReminderParamModel(
    takingMedicineId: Int,
    onOff: Int,
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int,
    repeats: HashSet<IDOWeek>,
    interval: Int,
    doNotDisturbOnOff: Int,
    doNotDisturbStartHour: Int,
    doNotDisturbStartMinute: Int,
    doNotDisturbEndHour: Int,
    doNotDisturbEndMinute: Int
) : IDOBaseAdapterModel<IDOTakingMedicineReminderParamModel> {

    /// ID ranging from 1 to 5
    var takingMedicineId: Int = takingMedicineId

    /// 0 for off
    /// 1 for on
    var onOff: Int = onOff

    /// Starting hour of the reminder
    var startHour: Int = startHour

    /// Starting minute of the reminder
    var startMinute: Int = startMinute

    /// Ending hour of the reminder
    var endHour: Int = endHour

    /// Ending minute of the reminder
    var endMinute: Int = endMinute

    /// Repeat
    var repeats: HashSet<IDOWeek> = repeats

    /// Reminder interval in minutes
    /// Default is 60 minutes
    var interval: Int = interval

    /// Do not disturb time period switch
    /// 0 for off
    /// 1 for on
    /// Default is off
    var doNotDisturbOnOff: Int = doNotDisturbOnOff

    /// Do not disturb start hour
    var doNotDisturbStartHour: Int = doNotDisturbStartHour

    /// Do not disturb start minute
    var doNotDisturbStartMinute: Int = doNotDisturbStartMinute

    /// Do not disturb end hour
    var doNotDisturbEndHour: Int = doNotDisturbEndHour

    /// Do not disturb end minute
    var doNotDisturbEndMinute: Int = doNotDisturbEndMinute
    override fun getDeSerializer(): IDOBaseModelDeSerializer<IDOTakingMedicineReminderParamModel>? {
        return TakingMedicineReminderParamModelSerializer()
    }

    override fun toString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


internal class TakingMedicineReminderParamModelSerializer : IDOBaseModelDeSerializer<IDOTakingMedicineReminderParamModel> {
    override fun serialize(src: IDOTakingMedicineReminderParamModel, typeOfSrc: Type, context: JsonSerializationContext): JsonElement {
        val jsonObject = JsonObject()
        jsonObject.addProperty("taking_medicine_id", src.takingMedicineId)
        jsonObject.addProperty("on_off", src.onOff)
        jsonObject.addProperty("start_hour", src.startHour)
        jsonObject.addProperty("start_minute", src.startMinute)
        jsonObject.addProperty("end_hour", src.endHour)
        jsonObject.addProperty("end_minute", src.endMinute)
        jsonObject.addProperty("interval", src.interval)
        jsonObject.addProperty("do_not_disturb_on_off", src.doNotDisturbOnOff)
        jsonObject.addProperty("do_not_disturb_start_hour", src.doNotDisturbStartHour)
        jsonObject.addProperty("do_not_disturb_start_minute", src.doNotDisturbStartMinute)
        jsonObject.addProperty("do_not_disturb_end_hour", src.doNotDisturbEndHour)
        jsonObject.addProperty("do_not_disturb_end_minute", src.doNotDisturbEndMinute)

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
    ): IDOTakingMedicineReminderParamModel? {
        json?.let {
            val jsonObject = it.asJsonObject
            val takingMedicineId = jsonObject.get("taking_medicine_id").asInt
            val onOff = jsonObject.get("on_off").asInt
            val startHour = jsonObject.get("start_hour").asInt
            val startMinute = jsonObject.get("start_minute").asInt
            val endHour = jsonObject.get("end_hour").asInt
            val endMinute = jsonObject.get("end_minute").asInt
            val interval = jsonObject.get("interval").asInt
            val doNotDisturbOnOff = jsonObject.get("do_not_disturb_on_off").asInt
            val doNotDisturbStartHour = jsonObject.get("do_not_disturb_start_hour").asInt
            val doNotDisturbStartMinute = jsonObject.get("do_not_disturb_start_minute").asInt
            val doNotDisturbEndHour = jsonObject.get("do_not_disturb_end_hour").asInt
            val doNotDisturbEndMinute = jsonObject.get("do_not_disturb_end_minute").asInt

            val repeat = jsonObject.get("repeat").asInt
            val items = HashSet<IDOWeek>()
            for (i in 0..6) {
                if (repeat and (1 shl (i + 1)) != 0) {
                    items.add(IDOWeek.fromRawValue(i))
                }
            }

            return IDOTakingMedicineReminderParamModel(
                takingMedicineId,
                onOff,
                startHour,
                startMinute,
                endHour,
                endMinute,
                items,
                interval,
                doNotDisturbOnOff,
                doNotDisturbStartHour,
                doNotDisturbStartMinute,
                doNotDisturbEndHour,
                doNotDisturbEndMinute
            )
        }
        return null
    }
}
    