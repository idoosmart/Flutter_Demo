//
//  IDOAlarmModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model
import com.google.gson.*
import java.io.Serializable
import java.lang.reflect.Type


//private object GsonTester {
//    @JvmStatic
//    fun main(args: Array<String>) {
//        val builder = GsonBuilder()
//        builder.registerTypeAdapter(IDOAlarmModel::class.java, AlarmModelSerializer())
//        builder.setPrettyPrinting()
//        val gson: Gson = builder.create()
//        var jsonString = "{\"item\":[{\"alarm_id\":0,\"delay_min\":0,\"hour\":0,\"minute\":0,\"name\":\"\",\"repeat\":254,\"repeat_times\":0,\"shock_on_off\":0,\"status\":0,\"tsnooze_duration\":0,\"type\":0},{\"alarm_id\":2,\"delay_min\":0,\"hour\":0,\"minute\":0,\"name\":\"\",\"repeat\":255,\"repeat_times\":0,\"shock_on_off\":0,\"status\":0,\"tsnooze_duration\":0,\"type\":0}],\"num\":2,\"version\":3}"
//        val student: IDOAlarmModel = gson.fromJson(jsonString, IDOAlarmModel::class.java)
//        println(student)
//        jsonString = gson.toJson(student)
//        println(jsonString)
//    }
//}

open class IDOAlarmModel(items: List<IDOAlarmItem>? = null) : IDOBaseAdapterModel<IDOAlarmModel> {

    var items: List<IDOAlarmItem>? = items
    internal var num: Int = items?.size ?: 0
    internal var version: Int = 0
    override fun getDeSerializer(): IDOBaseModelDeSerializer<IDOAlarmModel>? {
        return AlarmModelSerializer()
    }
}


// MARK: - IDOItem
open class IDOAlarmItem(alarmID: Int, delayMin: Int, hour: Int, minute: Int, name: String,isOpen:Boolean,
                        repeats: HashSet<IDOWeek>, repeatTimes: Int, shockOnOff: Int, status: IDOAlarmStatus,
                        tsnoozeDuration: Int, type: IDOAlarmType):Serializable {
    /// Alarm ID, starting from 1, 1~maximum supported number of alarms
    var alarmId: Int = alarmID
    /// Delay in minutes
    var delayMin: Int = delayMin
    var hour: Int = hour
    var minute: Int = minute
    /// Alarm name, maximum 23 bytes
    var name: String = name
    // on/off
    var isOpen: Boolean = isOpen
    /// Week Repeat
    var repeats: HashSet<IDOWeek> = repeats
    /// Number of repeated alarms
    /// Number of times the alarm is repeated, delay switch, set to 0 to turn off, set to a number to repeat that many times
    var repeatTimes: Int = repeatTimes
    var shockOnOff: Int = shockOnOff
    /// Status
    var status: IDOAlarmStatus = status
    var tsnoozeDuration: Int = tsnoozeDuration
    /// Alarm type
    var type: IDOAlarmType = type

}

enum class IDOAlarmType(val rawValue: Int) :Serializable{
    WAKEUP(0x00),
    SLEEP(0x01),
    EXERCISE(0x02),
    MEDICATION(0x03),
    DATE(0x04),
    GATHERING(0x05),
    MEETING(0x06),
    OTHER(0x07);

    companion object {
        fun fromRawValue(value: Int): IDOAlarmType {
            return IDOAlarmType.values().find { it.rawValue == value } ?: OTHER
        }
    }
}

enum class IDOWeek(val rawValue: Int):Serializable {
    MONDAY(0),
    TUESDAY(1),
    WEDNESDAY(2),
    THURSDAY(3),
    FRIDAY(4),
    SATURDAY(5),
    SUNDAY(6);

    companion object {
        fun fromRawValue(value: Int): IDOWeek {
            return values().find { it.rawValue == value } ?: throw IllegalArgumentException("Invalid IDOWeek value: $value")
        }
    }
}

enum class IDOAlarmStatus(val rawValue: Int) :Serializable{
    INVALID(-1),
    HIDDEN(0),
    DISPLAYED(1);

    companion object {
        fun fromRawValue(value: Int): IDOAlarmStatus {
            return IDOAlarmStatus.values().find { it.rawValue == value } ?: throw IllegalArgumentException("Invalid IDOAlarmStatus value: $value")
        }
    }
}

// Serializer & Deserializer
internal class AlarmModelSerializer : IDOBaseModelDeSerializer<IDOAlarmModel> {
    override fun serialize(src: IDOAlarmModel, typeOfSrc: Type, context: JsonSerializationContext): JsonElement {
        val jsonObject = JsonObject()
        val mAlarmItemSerializer = AlarmItemSerializer()
        val items = JsonArray()
        src.items?.forEach {
            items.add(mAlarmItemSerializer.serialize(it, IDOAlarmItem::class.java, context))
        }
        jsonObject.add("item", items)
        jsonObject.addProperty("num",src.num)
        jsonObject.addProperty("version",src.version)
        return jsonObject
    }

    override fun deserialize(
        json: JsonElement?,
        typeOfT: Type?,
        context: JsonDeserializationContext?
    ): IDOAlarmModel {
        json?.let {
            val jsonObject = it.asJsonObject
            val itemsJson = jsonObject.getAsJsonArray("item")
            val mAlarmItemSerializer = AlarmItemSerializer()
            val items= mutableListOf<IDOAlarmItem>()
            for (jsonElement in itemsJson) {
                val item = mAlarmItemSerializer.deserialize(jsonElement, IDOAlarmItem::class.java, context) ?: continue
                items.add(item)
            }
            return IDOAlarmModel(items)
        }
        return IDOAlarmModel()
    }
}

internal class AlarmItemSerializer : JsonSerializer<IDOAlarmItem>, JsonDeserializer<IDOAlarmItem> {
    override fun serialize(src: IDOAlarmItem, typeOfSrc: Type, context: JsonSerializationContext): JsonElement {
        val jsonObject = JsonObject()
        jsonObject.addProperty("alarm_id", src.alarmId)
        jsonObject.addProperty("delay_min", src.delayMin)
        jsonObject.addProperty("hour", src.hour)
        jsonObject.addProperty("minute", src.minute)
        jsonObject.addProperty("name", src.name)
        jsonObject.addProperty("shock_on_off", src.shockOnOff)
        jsonObject.addProperty("repeat_times", src.repeatTimes)
        jsonObject.addProperty("tsnooze_duration", src.tsnoozeDuration)
        jsonObject.addProperty("type", src.type.rawValue)
        jsonObject.addProperty("status", src.status.rawValue)

        var num = 0
        num = num or ((if (src.isOpen) 1 else 0) shl 0)
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
    ): IDOAlarmItem? {
        json?.let {
            val jsonObject = it.asJsonObject
            val alarmID = jsonObject.get("alarm_id").asInt
            val delayMin = jsonObject.get("delay_min").asInt
            val hour = jsonObject.get("hour").asInt
            val minute = jsonObject.get("minute").asInt
            val name = jsonObject.get("name").asString
            val shockOnOff = jsonObject.get("shock_on_off").asInt
            val repeatTimes = jsonObject.get("repeat_times").asInt
            val tsnoozeDuration = jsonObject.get("tsnooze_duration").asInt

            val type = IDOAlarmType.fromRawValue(jsonObject.get("type").asInt)
            val status = IDOAlarmStatus.fromRawValue(jsonObject.get("status").asInt)

            val repeat = jsonObject.get("repeat").asInt
            val isOpenRepeat = (repeat and (1 shl 0) != 0)
            val items = HashSet<IDOWeek>()
            for (i in 0..6) {
                if (repeat and (1 shl (i + 1)) != 0) {
                    items.add(IDOWeek.fromRawValue(i))
                }
            }
            return IDOAlarmItem(alarmID,
                delayMin,
                hour,
                minute,
                name,
                isOpenRepeat,
                items,
                repeatTimes,
                shockOnOff,
                status,
                tsnoozeDuration,
                type)
        }
        return null
    }
}