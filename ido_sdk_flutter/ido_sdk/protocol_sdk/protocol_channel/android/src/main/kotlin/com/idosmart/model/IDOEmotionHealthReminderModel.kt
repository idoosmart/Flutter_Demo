//
//  IDOEmotionHealthReminderModel.kt
//  protocol_channel
//
//  Created by hc on 2025/12/04.
//

package com.idosmart.model

import com.google.gson.*
import com.google.gson.annotations.SerializedName
import java.io.Serializable
import java.lang.reflect.Type

/**
 * V3 Emotion Health Reminder Param Model
 */
open class IDOEmotionHealthReminderParamModel(
    operate: Int,
    notifyType: Int = 0,
    emotionalHealthSwitch: Int,
    pressureRemind: IDOPressureRemindConfig? = null,
    unpleasantRemind: IDOUnpleasantRemindConfig? = null
) : IDOBaseAdapterModel<IDOEmotionHealthReminderParamModel> {
    /** Protocol version number */
    @SerializedName("version")
    private val version: Int = 4

    /** Operation type: 0:Invalid 1:Set 2:Query */
    @SerializedName("operate")
    var operate: Int = operate

    /** Notification type: 0:Invalid 1:Allow notification 2:Silent notification 3:Close notification */
    @SerializedName("notify_type")
    var notifyType: Int = notifyType

    /** Emotional health master switch: 1:On 0:Off */
    @SerializedName("emotional_health_switch")
    var emotionalHealthSwitch: Int = emotionalHealthSwitch

    /** Pressure reminder configuration */
    @SerializedName("pressure_remind")
    var pressureRemind: IDOPressureRemindConfig? = pressureRemind

    /** Unpleasant reminder configuration */
    @SerializedName("unpleasant_remind")
    var unpleasantRemind: IDOUnpleasantRemindConfig? = unpleasantRemind

    override fun getDeSerializer(): IDOBaseModelDeSerializer<IDOEmotionHealthReminderParamModel>? {
        return EmotionHealthReminderParamModelSerializer()
    }
}

internal class EmotionHealthReminderParamModelSerializer : IDOBaseModelDeSerializer<IDOEmotionHealthReminderParamModel> {
    override fun serialize(src: IDOEmotionHealthReminderParamModel, typeOfSrc: Type, context: JsonSerializationContext): JsonElement {
        val jsonObject = JsonObject()
        jsonObject.addProperty("version", 4)
        jsonObject.addProperty("operate", src.operate)
        jsonObject.addProperty("notify_type", src.notifyType)
        jsonObject.addProperty("emotional_health_switch", src.emotionalHealthSwitch)

        if (src.pressureRemind != null) {
            val pressureSerializer = PressureRemindConfigSerializer()
            jsonObject.add("pressure_remind", pressureSerializer.serialize(src.pressureRemind!!, IDOPressureRemindConfig::class.java, context))
        }

        if (src.unpleasantRemind != null) {
            jsonObject.add("unpleasant_remind", context.serialize(src.unpleasantRemind))
        }

        return jsonObject
    }

    override fun deserialize(json: JsonElement?, typeOfT: Type?, context: JsonDeserializationContext?): IDOEmotionHealthReminderParamModel {
        json?.let {
            val obj = it.asJsonObject
            val operate = obj.get("operate")?.asInt ?: 0
            val notifyType = obj.get("notify_type")?.asInt ?: 0
            val emotionalHealthSwitch = obj.get("emotional_health_switch")?.asInt ?: 0

            var pressureRemind: IDOPressureRemindConfig? = null
            if (obj.has("pressure_remind")) {
                val pressureSerializer = PressureRemindConfigSerializer()
                pressureRemind = pressureSerializer.deserialize(obj.get("pressure_remind"), IDOPressureRemindConfig::class.java, context)
            }

            var unpleasantRemind: IDOUnpleasantRemindConfig? = null
            if (obj.has("unpleasant_remind")) {
                unpleasantRemind = context!!.deserialize(obj.get("unpleasant_remind"), IDOUnpleasantRemindConfig::class.java)
            }

            return IDOEmotionHealthReminderParamModel(operate, notifyType, emotionalHealthSwitch, pressureRemind, unpleasantRemind)
        }
        return IDOEmotionHealthReminderParamModel(0, 0, 0)
    }
}

/**
 * Pressure reminder configuration
 */
open class IDOPressureRemindConfig(
    pressureSwitch: Int = 0,
    startHour: Int = 0,
    startMinute: Int = 0,
    endHour: Int = 0,
    endMinute: Int = 0,
    repeats: HashSet<IDOWeek> = HashSet(),
    reminderInterval: Int = 0
) : Serializable {
    /** Pressure reminder switch: 1:On 0:Off */
    var pressureSwitch: Int = pressureSwitch

    /** Reminder start time (hour) */
    var startHour: Int = startHour

    /** Reminder start time (minute) */
    var startMinute: Int = startMinute

    /** Reminder end time (hour) */
    var endHour: Int = endHour

    /** Reminder end time (minute) */
    var endMinute: Int = endMinute


    /**
     * Repeat cycle (week days)
     * Using IDOWeek enum: MONDAY(0), TUESDAY(1), ..., SUNDAY(6)
     */
    var repeats: HashSet<IDOWeek> = repeats

    /** Reminder interval, unit: minutes */
    var reminderInterval: Int = reminderInterval
}

/**
 * Serializer & Deserializer for IDOPressureRemindConfig
 */
internal class PressureRemindConfigSerializer : JsonSerializer<IDOPressureRemindConfig>, JsonDeserializer<IDOPressureRemindConfig> {
    override fun serialize(src: IDOPressureRemindConfig, typeOfSrc: Type, context: JsonSerializationContext): JsonElement {
        val jsonObject = JsonObject()
        jsonObject.addProperty("pressure_switch", src.pressureSwitch)
        jsonObject.addProperty("start_hour", src.startHour)
        jsonObject.addProperty("start_minute", src.startMinute)
        jsonObject.addProperty("end_hour", src.endHour)
        jsonObject.addProperty("end_minute", src.endMinute)
        jsonObject.addProperty("reminder_interval", src.reminderInterval)

        // Encode repetitions: bit0 is master switch, bit1~bit7 are Monday to Sunday
        var repetitions = 0
        // repetitions = repetitions or ((if (src.isOpenRepeat) 1 else 0) shl 0) // bit0 reserved/not used in this version

        src.repeats.forEach { week ->
            repetitions = repetitions or (1 shl (week.rawValue + 1))
        }
        jsonObject.addProperty("repetitions", repetitions)

        return jsonObject
    }

    override fun deserialize(json: JsonElement?, typeOfT: Type?, context: JsonDeserializationContext?): IDOPressureRemindConfig {
        json?.let {
            val jsonObject = it.asJsonObject
            val pressureSwitch = jsonObject.get("pressure_switch")?.asInt ?: 0
            val startHour = jsonObject.get("start_hour")?.asInt ?: 0
            val startMinute = jsonObject.get("start_minute")?.asInt ?: 0
            val endHour = jsonObject.get("end_hour")?.asInt ?: 0
            val endMinute = jsonObject.get("end_minute")?.asInt ?: 0
            val reminderInterval = jsonObject.get("reminder_interval")?.asInt ?: 0

            // Decode repetitions: bit0 is master switch, bit1~bit7 are Monday to Sunday
            val repetitions = jsonObject.get("repetitions")?.asInt ?: 0
            // val isOpenRepeat = (repetitions and (1 shl 0)) != 0
            val repeats = HashSet<IDOWeek>()
            for (i in 0..6) {
                if ((repetitions and (1 shl (i + 1))) != 0) {
                    repeats.add(IDOWeek.fromRawValue(i))
                }
            }

            return IDOPressureRemindConfig(
                pressureSwitch,
                startHour,
                startMinute,
                endHour,
                endMinute,
                repeats,
                reminderInterval
            )
        }
        return IDOPressureRemindConfig()
    }
}

/**
 * Unpleasant reminder configuration
 */
open class IDOUnpleasantRemindConfig(
    unpleasantSwitch: Int = 0,
    unhappyReminderNum: Int = 0
) : Serializable {
    /** Unpleasant reminder switch: 1:On 0:Off */
    @SerializedName("unpleasant_switch")
    var unpleasantSwitch: Int = unpleasantSwitch

    /** Unhappy reminder threshold, 0 is invalid */
    @SerializedName("unhappy_reminder_num")
    var unhappyReminderNum: Int = unhappyReminderNum
}

/**
 * V3 Emotion Health Reminder Reply Model
 */
open class IDOEmotionHealthReminderReplyModel(
    operate: Int = 0,
    errorCode: Int = 0,
    notifyType: Int = 0,
    emotionalHealthSwitch: Int = 0,
    pressureRemind: IDOPressureRemindConfig? = null,
    unpleasantRemind: IDOUnpleasantRemindConfig? = null
) : IDOBaseAdapterModel<IDOEmotionHealthReminderReplyModel> {
    /** Protocol version number */
    @SerializedName("version")
    private val version: Int = 0

    /** Operation type: 0:Invalid 1:Set 2:Query */
    @SerializedName("operate")
    var operate: Int = operate

    /** Error code: 0:Success, non-zero is error code */
    @SerializedName("error_code")
    var errorCode: Int = errorCode

    /** Notification type: 0:Invalid 1:Allow notification 2:Silent notification 3:Close notification */
    @SerializedName("notify_type")
    var notifyType: Int = notifyType

    /** Emotional health master switch: 1:On 0:Off */
    @SerializedName("emotional_health_switch")
    var emotionalHealthSwitch: Int = emotionalHealthSwitch

    /** Pressure reminder configuration */
    @SerializedName("pressure_remind")
    var pressureRemind: IDOPressureRemindConfig? = pressureRemind

    /** Unpleasant reminder configuration */
    @SerializedName("unpleasant_remind")
    var unpleasantRemind: IDOUnpleasantRemindConfig? = unpleasantRemind

    override fun getDeSerializer(): IDOBaseModelDeSerializer<IDOEmotionHealthReminderReplyModel>? {
        return EmotionHealthReminderReplyModelSerializer()
    }
}

internal class EmotionHealthReminderReplyModelSerializer : IDOBaseModelDeSerializer<IDOEmotionHealthReminderReplyModel> {
    override fun serialize(src: IDOEmotionHealthReminderReplyModel, typeOfSrc: Type, context: JsonSerializationContext): JsonElement {
        val jsonObject = JsonObject()
        jsonObject.addProperty("version", 0)
        jsonObject.addProperty("operate", src.operate)
        jsonObject.addProperty("error_code", src.errorCode)
        jsonObject.addProperty("notify_type", src.notifyType)
        jsonObject.addProperty("emotional_health_switch", src.emotionalHealthSwitch)

        if (src.pressureRemind != null) {
            val pressureSerializer = PressureRemindConfigSerializer()
            jsonObject.add("pressure_remind", pressureSerializer.serialize(src.pressureRemind!!, IDOPressureRemindConfig::class.java, context))
        }

        if (src.unpleasantRemind != null) {
            jsonObject.add("unpleasant_remind", context.serialize(src.unpleasantRemind))
        }

        return jsonObject
    }

    override fun deserialize(json: JsonElement?, typeOfT: Type?, context: JsonDeserializationContext?): IDOEmotionHealthReminderReplyModel {
        json?.let {
            val obj = it.asJsonObject
            val operate = obj.get("operate")?.asInt ?: 0
            val errorCode = obj.get("error_code")?.asInt ?: 0
            val notifyType = obj.get("notify_type")?.asInt ?: 0
            val emotionalHealthSwitch = obj.get("emotional_health_switch")?.asInt ?: 0

            var pressureRemind: IDOPressureRemindConfig? = null
            if (obj.has("pressure_remind")) {
                val pressureSerializer = PressureRemindConfigSerializer()
                pressureRemind = pressureSerializer.deserialize(obj.get("pressure_remind"), IDOPressureRemindConfig::class.java, context)
            }

            var unpleasantRemind: IDOUnpleasantRemindConfig? = null
            if (obj.has("unpleasant_remind")) {
                unpleasantRemind = context!!.deserialize(obj.get("unpleasant_remind"), IDOUnpleasantRemindConfig::class.java)
            }

            return IDOEmotionHealthReminderReplyModel(operate, errorCode, notifyType, emotionalHealthSwitch, pressureRemind, unpleasantRemind)
        }
        return IDOEmotionHealthReminderReplyModel()
    }
}
