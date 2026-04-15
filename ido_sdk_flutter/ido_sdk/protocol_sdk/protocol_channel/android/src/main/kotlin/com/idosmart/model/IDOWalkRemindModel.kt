//
//  IDOWalkRemindModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import android.util.Log
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.JsonDeserializationContext
import com.google.gson.JsonDeserializer
import com.google.gson.JsonElement
import com.google.gson.JsonObject
import com.google.gson.JsonSerializationContext
import com.google.gson.JsonSerializer
import java.lang.reflect.Type

///
/// Get walk reminder event number

open class IDOWalkRemindModel(
    onOff: Int,
    goalStep: Int,
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int,
    repeats: HashSet<IDOWeek>,
    goalTime: Int,
    notifyFlag: Int,
    doNotDisturbOnOff: Int,
    noDisturbStartHour: Int,
    noDisturbStartMinute: Int,
    noDisturbEndHour: Int,
    noDisturbEndMinute: Int
) : IDOBaseAdapterModel<IDOWalkRemindModel> {

    /// 0 Off，1 On
    var onOff: Int = onOff

    /// Goal step (deprecated)
    var goalStep: Int = goalStep

    /// Start time (hour)
    var startHour: Int = startHour

    /// Start time (minute)
    var startMinute: Int = startMinute

    /// End time (hour)
    var endHour: Int = endHour

    /// End time (minute)
    var endMinute: Int = endMinute

    /// Repeat
    var repeats: HashSet<IDOWeek> = repeats

    /// Goal time (deprecated)
    var goalTime: Int = goalTime

    /// Notification type
    /// 0: Invalid
    /// 1: Allow notification
    /// 2: Silent notification
    /// 3: Close notification
    /// Requires firmware to enable `setWalkReminderAddNotify`
    var notifyFlag: Int = notifyFlag

    /// Do not disturb switch
    /// 0 Off
    /// 1 On
    /// Requires firmware to enable `getSupportSetGetNoReminderOnWalkReminderV2`
    var doNotDisturbOnOff: Int = doNotDisturbOnOff

    /// Do not disturb start time (hour)
    /// Requires firmware to enable `getSupportSetGetNoReminderOnWalkReminderV2`
    var noDisturbStartHour: Int = noDisturbStartHour

    /// Do not disturb start time (minute)
    /// Requires firmware to enable `getSupportSetGetNoReminderOnWalkReminderV2`
    var noDisturbStartMinute: Int = noDisturbStartMinute

    /// Do not disturb end time (hour)
    /// Requires firmware to enable `getSupportSetGetNoReminderOnWalkReminderV2`
    var noDisturbEndHour: Int = noDisturbEndHour

    /// Do not disturb end time (minute)
    /// Requires firmware to enable `getSupportSetGetNoReminderOnWalkReminderV2`
    var noDisturbEndMinute: Int = noDisturbEndMinute
    override fun getDeSerializer(): IDOBaseModelDeSerializer<IDOWalkRemindModel>? {
        return WalkRemindModelSerializer()
    }

    override fun toString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


internal class WalkRemindModelSerializer : IDOBaseModelDeSerializer<IDOWalkRemindModel> {
    override fun serialize(src: IDOWalkRemindModel, typeOfSrc: Type, context: JsonSerializationContext): JsonElement {
        val jsonObject = JsonObject()
        jsonObject.addProperty("goal_time", src.goalTime)
        jsonObject.addProperty("on_off", src.onOff)
        jsonObject.addProperty("start_hour", src.startHour)
        jsonObject.addProperty("start_minute", src.startMinute)
        jsonObject.addProperty("end_hour", src.endHour)
        jsonObject.addProperty("end_minute", src.endMinute)
        jsonObject.addProperty("goal_step", src.goalStep)
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
    ): IDOWalkRemindModel? {
        json?.let {
            val jsonObject = it.asJsonObject
            val goalTime = jsonObject.get("goal_time").asInt
            val goalStep = jsonObject.get("goal_step").asInt
            val onOff = jsonObject.get("on_off").asInt
            val startHour = jsonObject.get("start_hour").asInt
            val startMinute = jsonObject.get("start_minute").asInt
            val endHour = jsonObject.get("end_hour").asInt
            val endMinute = jsonObject.get("end_minute").asInt
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

            return IDOWalkRemindModel(
                onOff,
                goalStep,
                startHour,
                startMinute,
                endHour,
                endMinute,
                items,
                goalTime,
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
    