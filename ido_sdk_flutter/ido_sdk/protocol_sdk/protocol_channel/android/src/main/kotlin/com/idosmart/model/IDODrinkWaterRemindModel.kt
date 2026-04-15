package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.JsonDeserializationContext
import com.google.gson.JsonElement
import com.google.gson.JsonObject
import com.google.gson.JsonSerializationContext
import java.lang.reflect.Type

open class IDODrinkWaterRemindModel(
    onOff: Int,
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int,
    repeats: HashSet<IDOWeek>,
    interval: Int,
    notifyFlag: Int?,
    doNotDisturbOnOff: Int?,
    noDisturbStartHour: Int?,
    noDisturbStartMinute: Int?,
    noDisturbEndHour: Int?,
    noDisturbEndMinute: Int?
) : IDOBaseAdapterModel<IDODrinkWaterRemindModel> {
    // Switch 0: Off 1: On
    var onOff = onOff

    // Start time Hour
    var startHour = startHour

    // Start time Minute
    var startMinute = startMinute

    // End time Hour
    var endHour = endHour

    // End time Minute
    var endMinute = endMinute

    // Repeat
    var repeats: HashSet<IDOWeek> = repeats

    // Reminder interval in minutes
    var interval = interval

    // Notification type
    // 0: Invalid
    // 1: Allow notification
    // 2: Silent notification
    // 3: Notification off
    // Need to open firmware table support setDrinkWaterAddNotifyFlag
    var notifyFlag = notifyFlag

    // Do not disturb switch
    // 00: Off
    // 01: On
    // Need to open firmware table support setNoReminderOnDrinkReminder
    var doNotDisturbOnOff = doNotDisturbOnOff

    // Do not disturb start time Hour
    // Need to open firmware table support setNoReminderOnDrinkReminder
    var noDisturbStartHour = noDisturbStartHour

    // Do not disturb start time Minute
    // Need to open firmware table support setNoReminderOnDrinkReminder
    var noDisturbStartMinute = noDisturbStartMinute

    // Do not disturb end time Hour
    // Need to open firmware table support setNoReminderOnDrinkReminder
    var noDisturbEndHour = noDisturbEndHour

    // Do not disturb end time Minute
    // Need to open firmware table support setNoReminderOnDrinkReminder
    var noDisturbEndMinute = noDisturbEndMinute


    override fun getDeSerializer(): IDOBaseModelDeSerializer<IDODrinkWaterRemindModel>? {
        return IDODrinkWaterRemindModelSerializer()
    }

    override fun toString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }


}

internal class IDODrinkWaterRemindModelSerializer :
    IDOBaseModelDeSerializer<IDODrinkWaterRemindModel> {
    override fun serialize(
        src: IDODrinkWaterRemindModel,
        typeOfSrc: Type?,
        context: JsonSerializationContext?
    ): JsonElement {
        val jsonObject = JsonObject()
        jsonObject.addProperty("on_off", src.onOff)
        jsonObject.addProperty("start_hour", src.startHour)
        jsonObject.addProperty("start_minute", src.startMinute)
        jsonObject.addProperty("end_hour", src.endHour)
        jsonObject.addProperty("end_minute", src.endMinute)
        jsonObject.addProperty("interval", src.interval)
        jsonObject.addProperty("notify_flag", src.notifyFlag)
        jsonObject.addProperty("do_not_disturb_on_off", src.doNotDisturbOnOff)
        jsonObject.addProperty("no_disturb_start_hour", src.noDisturbStartHour)
        jsonObject.addProperty("no_disturb_start_minute", src.noDisturbStartMinute)
        jsonObject.addProperty("no_disturb_end_hour", src.noDisturbEndHour)
        jsonObject.addProperty("no_disturb_end_minute", src.noDisturbEndMinute)

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
    ): IDODrinkWaterRemindModel? {
        json?.let {
            val jsonObject = it.asJsonObject
            val onOff = jsonObject.get("on_off").asInt
            val startHour = jsonObject.get("start_hour").asInt
            val startMinute = jsonObject.get("start_minute").asInt
            val endHour = jsonObject.get("end_hour").asInt
            val endMinute = jsonObject.get("end_minute").asInt
            val interval = jsonObject.get("interval").asInt
            val notifyFlag = jsonObject.get("notify_flag").asInt
            val doNotDisturbOnOff = jsonObject.get("do_not_disturb_on_off").asInt
            val noDisturbStartHour = jsonObject.get("no_disturb_start_hour").asInt
            val noDisturbStartMinute = jsonObject.get("no_disturb_start_minute").asInt
            val noDisturbEndHour = jsonObject.get("no_disturb_end_hour").asInt
            val noDisturbEndMinute = jsonObject.get("no_disturb_end_minute").asInt

            val repeat = jsonObject.get("repeat").asInt
            val items = HashSet<IDOWeek>()
            for (i in 0..6) {
                if (repeat and (1 shl (i + 1)) != 0) {
                    items.add(IDOWeek.fromRawValue(i))
                }
            }

            return IDODrinkWaterRemindModel(
                onOff,
                startHour,
                startMinute,
                endHour,
                endMinute,
                items,
                interval,
                notifyFlag,
                doNotDisturbOnOff,
                noDisturbStartHour,
                noDisturbStartMinute,
                noDisturbEndHour,
                noDisturbEndMinute
            )
        }
        return null

    }
}