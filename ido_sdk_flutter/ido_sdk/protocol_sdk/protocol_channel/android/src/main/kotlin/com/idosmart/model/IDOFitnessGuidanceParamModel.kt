//
//  IDOFitnessGuidanceParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.*
import java.lang.reflect.Type

///
/// Fitness Guidance Event

open class IDOFitnessGuidanceParamModel(
    mode: Int,
    startHour: Int,
    startMinute: Int,
    endHour: Int,
    endMinute: Int,
    notifyFlag: Int,
    goMode: Int,
    repeats: HashSet<IDOWeek>,
    targetSteps: Int
) : IDOBaseAdapterModel<IDOFitnessGuidanceParamModel> {

    /// Fitness guidance mode switch
    /// 1: On
    /// 0: Off
    var mode: Int = mode

    /// Start hour
    var startHour: Int = startHour

    /// Start minute
    var startMinute: Int = startMinute

    /// End hour
    var endHour: Int = endHour

    /// End minute
    var endMinute: Int = endMinute

    /// Notification type
    /// 0: Invalid
    /// 1: Allow
    /// 2: Silent
    /// 3: Disable
    var notifyFlag: Int = notifyFlag

    /// Reminders to move switch
    /// 1: On
    /// 0: Off
    var goMode: Int = goMode

    /// Repeat
    var repeats: HashSet<IDOWeek> = repeats

    /// Target steps
    var targetSteps: Int = targetSteps
    override fun getDeSerializer(): IDOBaseModelDeSerializer<IDOFitnessGuidanceParamModel>? {
        return FitnessGuidanceParamModelSerializer()
    }

    override fun toString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


internal class FitnessGuidanceParamModelSerializer : IDOBaseModelDeSerializer<IDOFitnessGuidanceParamModel> {
    override fun serialize(src: IDOFitnessGuidanceParamModel, typeOfSrc: Type, context: JsonSerializationContext): JsonElement {
        val jsonObject = JsonObject()
        jsonObject.addProperty("mode", src.mode)
        jsonObject.addProperty("start_hour", src.startHour)
        jsonObject.addProperty("start_minute", src.startMinute)
        jsonObject.addProperty("end_hour", src.endHour)
        jsonObject.addProperty("end_minute", src.endMinute)
        jsonObject.addProperty("notify_flag", src.notifyFlag)
        jsonObject.addProperty("go_mode", src.goMode)
        jsonObject.addProperty("target_steps", src.targetSteps)

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
    ): IDOFitnessGuidanceParamModel? {
        json?.let {
            val jsonObject = it.asJsonObject
            val mode = jsonObject.get("mode").asInt
            val startHour = jsonObject.get("start_hour").asInt
            val startMinute = jsonObject.get("start_minute").asInt
            val endHour = jsonObject.get("end_hour").asInt
            val endMinute = jsonObject.get("end_minute").asInt
            val notifyFlag = jsonObject.get("notify_flag").asInt
            val goMode = jsonObject.get("go_mode").asInt
            val targetSteps = jsonObject.get("target_steps").asInt

            val repeat = jsonObject.get("repeat").asInt
            val items = HashSet<IDOWeek>()
            for (i in 0..6) {
                if (repeat and (1 shl (i + 1)) != 0) {
                    items.add(IDOWeek.fromRawValue(i))
                }
            }
            return IDOFitnessGuidanceParamModel(
                mode,
                startHour,
                startMinute,
                endHour,
                endMinute,
                notifyFlag,
                goMode,
                items,
                targetSteps
            )
        }
        return null
    }
}