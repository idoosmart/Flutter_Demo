package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.JsonDeserializationContext
import com.google.gson.JsonDeserializer
import com.google.gson.JsonElement
import com.google.gson.JsonParseException
import com.google.gson.JsonPrimitive
import com.google.gson.JsonSerializationContext
import com.google.gson.JsonSerializer
import com.google.gson.annotations.JsonAdapter
import com.google.gson.annotations.SerializedName
import java.lang.reflect.Type

/**
 * IDOAccDataItem - 加速度计数据项
 */
open class IDOAccDataItem(
    x: Short, // acc x轴(int16) 对应 Kotlin 的 Short
    y: Short, // acc y轴(int16) 对应 Kotlin 的 Short
    z: Short  // acc z轴(int16) 对应 Kotlin 的 Short
) : IDOBaseModel {
    @SerializedName("x")
    var x: Short = x

    @SerializedName("y")
    var y: Short = y

    @SerializedName("z")
    var z: Short = z

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


/**
 * IDOPpgDataItem - 光电容积图数据项
 */
open class IDOPpgDataItem(
    green: Long, // ppg绿光(uint32) 对应 Kotlin 的 Long (UInt32至少需要 Int/Long)
    infrared: Long, // ppg红外光(uint32) 对应 Kotlin 的 Long
    red: Long // ppg红光(uint32) 对应 Kotlin 的 Long
) : IDOBaseModel {
    @SerializedName("green")
    var green: Long = green

    @SerializedName("infrared")
    var infrared: Long = infrared

    @SerializedName("red")
    var red: Long = red

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


/**
 * IDORawDataSensorInfoReply
 */
open class IDORawDataSensorInfoReply(
    year: Int,
    month: Int,
    day: Int,
    hour: Int,
    min: Int,
    sec: Int,
    dataType: Int,
    frequency: Int,
    accDataCount: Int,
    ppgDataCount: Int,
    accDataItems: List<IDOAccDataItem>?,
    ppgDataItems: List<IDOPpgDataItem>?
) : IDOBaseModel {
    @SerializedName("year")
    var year: Int = year

    @SerializedName("month")
    var month: Int = month

    @SerializedName("day")
    var day: Int = day

    @SerializedName("hour")
    var hour: Int = hour

    @SerializedName("min")
    var min: Int = min

    @SerializedName("sec")
    var sec: Int = sec

    @SerializedName("data_type")
    var dataType: Int = dataType

    @SerializedName("frequency")
    var frequency: Int = frequency

    @SerializedName("acc_data_count")
    var accDataCount: Int = accDataCount

    @SerializedName("ppg_data_count")
    var ppgDataCount: Int = ppgDataCount

    @SerializedName("acc_data_items")
    var accDataItems: List<IDOAccDataItem>? = accDataItems

    @SerializedName("ppg_data_items")
    var ppgDataItems: List<IDOPpgDataItem>? = ppgDataItems

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


/**
 * IDOSensorConfig
 */
open class IDOSensorConfig(
    ppgSwitch: IDOAlgorithmSensorSwitch,
    accSwitch: IDOAlgorithmSensorSwitch
) : IDOBaseModel {
    @SerializedName("ppg_switch")
    var ppgSwitch: IDOAlgorithmSensorSwitch = ppgSwitch

    @SerializedName("acc_switch")
    var accSwitch: IDOAlgorithmSensorSwitch = accSwitch

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


/**
 * IDORawDataSensorConfigReply
 */
open class IDORawDataSensorConfigReply(
    errCode: Int,
    operate: Int,
    configItem: IDOSensorConfig?
) : IDOBaseModel {
    @SerializedName("version")
    private var version: Int = 0 // 默认值 0

    @SerializedName("error_code")
    var errCode: Int = errCode

    @SerializedName("operate")
    internal var operate: Int = operate

    @SerializedName("config_count")
    internal var configCount: Int = 1

    @SerializedName("config_items")
    var configItem: IDOSensorConfig? = configItem

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


/**
 * IDOAlgorithmRawDataParam
 */
internal class IDOAlgorithmRawDataParam(
    operate: Int,
    ppgSwitch: Int,
    accSwitch: Int
) : IDOBaseModel {
    @SerializedName("operate")
    var operate: Int = operate

    @SerializedName("ppg_switch")
    var ppgSwitch: Int = ppgSwitch

    @SerializedName("acc_switch")
    var accSwitch: Int = accSwitch

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

/**
 * 算法传感器开关状态
 */
@JsonAdapter(IDOAlgorithmSensorSwitchAdapter::class)
enum class IDOAlgorithmSensorSwitch(val rawValue: Int) {
    /** 无效 */
    INVALID(-1),
    /** 开启 */
    OPEN(1),
    /** 关闭 */
    CLOSE(0);

    companion object {
        fun fromRawValue(rawValue: Int) = values().firstOrNull { it.rawValue == rawValue }
    }
}

/**
 * 将 IDOAlgorithmSensorSwitch 与 Gson 之间做兼容转换：
 * - 反序列化支持 number(0/1/-1)、boolean(true/false)、string("OPEN"/"CLOSE"/"-1"/"0"/"1")
 * - 序列化输出为对应的 raw 整数值
 */
class IDOAlgorithmSensorSwitchAdapter : JsonSerializer<IDOAlgorithmSensorSwitch>,
    JsonDeserializer<IDOAlgorithmSensorSwitch> {
    override fun serialize(
        src: IDOAlgorithmSensorSwitch?,
        typeOfSrc: Type?,
        context: JsonSerializationContext?
    ): JsonElement {
        val value = src?.rawValue ?: IDOAlgorithmSensorSwitch.INVALID.rawValue
        return JsonPrimitive(value)
    }

    override fun deserialize(
        json: JsonElement?,
        typeOfT: Type?,
        context: JsonDeserializationContext?
    ): IDOAlgorithmSensorSwitch {
        if (json == null || json.isJsonNull) return IDOAlgorithmSensorSwitch.INVALID

        val primitive = json.asJsonPrimitive
        return try {
            when {
                primitive.isNumber -> {
                    val num = try { primitive.asInt } catch (_: NumberFormatException) { 0 }
                    IDOAlgorithmSensorSwitch.fromRawValue(num) ?: when (num) {
                        0 -> IDOAlgorithmSensorSwitch.CLOSE
                        1 -> IDOAlgorithmSensorSwitch.OPEN
                        -1 -> IDOAlgorithmSensorSwitch.INVALID
                        else -> IDOAlgorithmSensorSwitch.INVALID
                    }
                }
                primitive.isBoolean -> {
                    if (primitive.asBoolean) IDOAlgorithmSensorSwitch.OPEN else IDOAlgorithmSensorSwitch.CLOSE
                }
                primitive.isString -> {
                    val str = primitive.asString?.trim()?.uppercase()
                    when (str) {
                        "OPEN" -> IDOAlgorithmSensorSwitch.OPEN
                        "CLOSE" -> IDOAlgorithmSensorSwitch.CLOSE
                        "INVALID", "-1" -> IDOAlgorithmSensorSwitch.INVALID
                        "1" -> IDOAlgorithmSensorSwitch.OPEN
                        "0" -> IDOAlgorithmSensorSwitch.CLOSE
                        else -> {
                            // 尝试按数字解析
                            val asNum = str?.toIntOrNull()
                            if (asNum != null) {
                                IDOAlgorithmSensorSwitch.fromRawValue(asNum)
                                    ?: when (asNum) {
                                        0 -> IDOAlgorithmSensorSwitch.CLOSE
                                        1 -> IDOAlgorithmSensorSwitch.OPEN
                                        -1 -> IDOAlgorithmSensorSwitch.INVALID
                                        else -> IDOAlgorithmSensorSwitch.INVALID
                                    }
                            } else {
                                // 尝试按枚举名
                                runCatching { IDOAlgorithmSensorSwitch.valueOf(str ?: "") }.getOrNull()
                                    ?: IDOAlgorithmSensorSwitch.INVALID
                            }
                        }
                    }
                }
                else -> IDOAlgorithmSensorSwitch.INVALID
            }
        } catch (e: Exception) {
            throw JsonParseException("Failed to parse IDOAlgorithmSensorSwitch: ${e.message}", e)
        }
    }
}