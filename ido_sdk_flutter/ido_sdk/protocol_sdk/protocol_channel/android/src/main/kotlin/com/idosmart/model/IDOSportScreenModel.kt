package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.TypeAdapter
import com.google.gson.annotations.JsonAdapter
import com.google.gson.annotations.SerializedName
import com.google.gson.stream.JsonReader
import com.google.gson.stream.JsonToken
import com.google.gson.stream.JsonWriter
import java.io.Serializable

open class IDOSportScreenParamModel(operate: Int, sportItems: List<IDOSportScreenSportItemModel>?): IDOBaseModel {
    private var version: Int = 4
    /**
     * 0x01查询基础信息--支持的所有运动类型,支持的屏幕布局配置信息
     * 0x02查询基础信息--运动类型支持的数据项和数据子项，最多支持同时查询23个
     * 0x03查询详情信息, 最多支持2个同时查询
     * 0x04编辑, 最多支持2个同时编辑
     */
    var operate: Int = operate
    @SerializedName("sport_num")
    private var sportNum: Int = sportItems?.size ?: 0
    @SerializedName("sport_item")
    var sportItems: List<IDOSportScreenSportItemModel>? = sportItems

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

    override fun toString(): String {
        return "IDOSportScreenParamModel(version=$version, operate=$operate, sportNum=$sportNum, sportItems=$sportItems)"
    }


}

open class IDOSportScreenSportItemModel(sportType: Int, screenItems: List<IDOSportScreenItemModel>? = null): IDOBaseModel {
    /**
     * 运动类型
     */
    @SerializedName("sport_type")
    var sportType: Int = sportType
    @SerializedName("screen_num")
    private var screenNum: Int = screenItems?.size ?: 0
    @SerializedName("screen_item")
    var screenItems: List<IDOSportScreenItemModel>? = screenItems

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

    override fun toString(): String {
        return "IDOSportScreenSportItemModel(sportType=$sportType, screenNum=$screenNum, screenItems=$screenItems)"
    }


}

open class IDOSportScreenItemModel(dataItem: List<IDOSportScreenDataItemModel>?) : IDOBaseModel{
    /**
     * 已配置的数据项数量，已配置的数据项最大个数15
     */
    @SerializedName("data_item_count")
    var dataItemCount: Int = dataItem?.size ?: 0
    @SerializedName("data_item")
    var dataItem: List<IDOSportScreenDataItemModel>? = dataItem

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

    override fun toString(): String {
        return "IDOSportScreenItemModel(dataItemCount=$dataItemCount, dataItem=$dataItem)"
    }


}

open class IDOSportScreenDataItemModel(dataType: IDODataType, dataSubType: IDODataSubType): IDOBaseModel {

    @SerializedName("data_type")
    @JsonAdapter(DataTypeAdapter::class)
    var dataType = dataType

    var subType = dataSubType
        get() {
            return IDODataSubType.combineBytes(dataType.rawValue, (0x01 shl dataSubTypeRaw)) ?: field
        }
        set(value) {
            val bitValue = value.rawValue and 0xFF
            val leftShiftBit = findLeftShiftBits(bitValue) ?: 0
            dataSubTypeRaw = leftShiftBit
            field = value
        }

    @SerializedName("data_sub_type")
    internal var dataSubTypeRaw: Int = 0

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

    private fun findLeftShiftBits(n: Int): Int? {
        // 检查是否为合法输入（正整数且是2的幂次）
        if (n <= 0 || (n and (n - 1)) != 0) {
            return null
        }
        // 计算二进制尾随零的数量（即左移位数）
        return Integer.numberOfTrailingZeros(n)
    }

    override fun toString(): String {
        return "IDOSportScreenDataItemModel(dataType=$dataType, dataSubTypeRaw=$dataSubTypeRaw, subType=$subType)"
    }


}

open class IDOSportScreenInfoReplyModel(
    private var version: Int = 4,
    @SerializedName("err_code")
    var errCode: Int = 0,
    /**
     * 0x01查询基础信息--支持的所有运动类型,支持的屏幕布局配置信息
     * 0x02查询基础信息--运动类型支持的数据项和数据子项，最多支持同时查询23个
     * 0x03查询详情信息, 最多支持2个同时查询
     * 0x04编辑, 最多支持2个同时编辑
     */
    var operate: Int = 0,
    /**
     * 最小数据项显示个数
     */
    @SerializedName("min_data_num")
    var minDataNum: Int = 0,
    /**
     * 最大数据项显示个数
     */
    @SerializedName("max_data_num")
    var maxDataNum: Int = 0,
    /**
     * 最小屏幕显示个数
     */
    @SerializedName("min_screen_num")
    var minScreenNum: Int = 0,
    /**
     * 最大屏幕显示个数
     */
    @SerializedName("max_screen_num")
    var maxScreenNum: Int = 0,
    @SerializedName("sport_num")
    internal var sportNum: Int = 0,
    @SerializedName("screen_conf_num")
    internal var screenConfNum: Int = 0,
    @SerializedName("sport_item")
    var sportItems: List<IDOSportScreenItemReply>? = null,
    /**
     * 获取屏幕信息，查基础使用，查详情返回NULL
     */
    @SerializedName("screen_conf")
    var screenConfItems: ArrayList<IDOSportScreenLayoutType>? = null,
    /**
     * 屏幕增加特殊配置项
     */
    @SerializedName("speical_data_item")
    var specialDataItems: List<IDOSportScreenDataItemModel>? = null,
    @SerializedName("special_data_item_count")
    internal var specialDataItemCount: Int = 0

) : IDOBaseModel {
    constructor(
        errCode: Int,
        operate: Int,
        minDataNum: Int,
        maxDataNum: Int,
        minScreenNum: Int,
        maxScreenNum: Int,
        sportItems: List<IDOSportScreenItemReply>? = null,
        screenConfItems: ArrayList<IDOSportScreenLayoutType>? = null,
        specialDataItems: List<IDOSportScreenDataItemModel>? = null,
    ) : this() {
        this.version = 4
        this.errCode = errCode
        this.operate = operate
        this.minDataNum = minDataNum
        this.maxDataNum = maxDataNum
        this.minScreenNum = minScreenNum
        this.maxScreenNum = maxScreenNum
        this.sportNum = sportItems?.size ?: 0
        this.screenConfNum = screenConfItems?.size ?: 0
        this.sportItems = sportItems
        this.screenConfItems = screenConfItems
        this.specialDataItems = specialDataItems
        this.specialDataItemCount = specialDataItems?.size ?: 0
    }

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

    override fun toString(): String {
        return "IDOSportScreenInfoReplyModel(version=$version, errCode=$errCode, operate=$operate, minDataNum=$minDataNum, maxDataNum=$maxDataNum, minScreenNum=$minScreenNum, maxScreenNum=$maxScreenNum, sportNum=$sportNum, screenConfNum=$screenConfNum, sportItems=$sportItems, screenConfItems=$screenConfItems)"
    }


}

open class IDOSportScreenItemReply(
    @SerializedName("sport_type")
    var sportType: Int = 0,
    @SerializedName("screen_num")
    var screenNum: Int = 0,
    @SerializedName("support_data_type_num")
    var supportDataTypeNum: Int = 0,
    @SerializedName("screen_item")
    var screenItems: List<IDOSportScreenItemModel>? = null,
    @SerializedName("support_data_type")
    var supportDataTypes: List<IDOSportScreenDataType>? = null
): Serializable {
    constructor(
        sportType: Int,
        screenItems: List<IDOSportScreenItemModel>? = null,
        supportDataTypes: List<IDOSportScreenDataType>? = null
    ) : this() {
        this.sportType = sportType
        this.screenNum = screenItems?.size ?: 0
        this.supportDataTypeNum = supportDataTypes?.size ?: 0
        this.screenItems = screenItems
        this.supportDataTypes = supportDataTypes
    }

    override fun toString(): String {
        return "IDOSportScreenItemReply(sportType=$sportType, screenNum=$screenNum, supportDataTypeNum=$supportDataTypeNum, screenItems=$screenItems, supportDataTypes=$supportDataTypes)"
    }


}

open class IDOSportScreenDataType: IDOBaseModel {

    @SerializedName("data_type")
    @JsonAdapter(DataTypeAdapter::class)
    var dataType: IDODataType = IDODataType.NONE

    val dataValue: List<IDODataSubType>
        get() {
            val items = mutableListOf<IDODataSubType>()
            for (i in 0..7) {
                val bit = (dataValueRaw shr i) and 1
                if (bit == 1) {
                    IDODataSubType.combineBytes(
                        highByte = dataType.rawValue,
                        lowByte = (1 shl i)
                    )?.let { items.add(it) }
                }
            }
            return items
        }

    @SerializedName("data_value")
    internal var dataValueRaw: Int = 0
    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

    override fun toString(): String {
        return "IDOSportScreenDataType(dataType=$dataType, dataValueRaw=$dataValueRaw, dataValue=$dataValue)"
    }


}


open class IDOSportScreenLayoutType(
    @SerializedName("layout_type")
    var layoutType: Int = 0,
    var style: Int = 0
): IDOBaseModel {
    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

    override fun toString(): String {
        return "IDOSportScreenLayoutType(layoutType=$layoutType, style=$style)"
    }


}

/**
 * 数据项类型
 */
enum class IDODataType(val rawValue: Int): java.io.Serializable {
    NONE(0x00),
    /** 总响应时间 */
    OVERALL_RESPONSE_TIME(0x01),
    /** 距离类 */
    DISTANCE(0x02),
    /** 海拔类 */
    ELEVATION(0x03),
    /** 配速类 */
    PACE(0x04),
    /** 速度类 */
    SPEED(0x05),
    /** 心率类 */
    HEART_RATE(0x06),
    /** 功率类 */
    POWER(0x07),
    /** 步频类 */
    CADENCE(0x08),
    /** 跑步类 */
    RUNNING_ECONOMY(0x09),
    /** 跑步健身类 */
    RUNNING_FITNESS(0x0A),
    /** 时间类 */
    TIME(0x0B),
    /** 其他类 */
    OTHER(0x0C);

    companion object {
        fun fromRawValue(value: Int): IDODataType {
            return IDODataType.values().find { it.rawValue == value } ?: throw IllegalArgumentException("Invalid IDODataType value: $value")
        }
    }
}

enum class IDODataSubType(val rawValue: Int): java.io.Serializable {
    NONE(0x0000),           // none = 0x0000

    // region 总响应时间 (0x01)
    OVERALL_RESPONSE_TIME_OVERALL(0x0101), // 总响应时间
    // endregion

    // region 距离类 (0x02)
    DISTANCE_TOTAL_DISTANCE(0x0201),       // 距离
    DISTANCE_CURRENT_LAP_DISTANCE(0x0202), // 圈距
    DISTANCE_LAST_LAP_DISTANCE(0x0204),    // 最后一圈距离
    // endregion

    // region 海拔类 (0x03)
    ELEVATION_ELEVATION(0x0301),           // 海拔
    ELEVATION_TOTAL_ASCENT(0x0302),        // 总上升高度
    ELEVATION_LAP_ASCENT(0x0304),          // 上升圈数
    ELEVATION_LAST_LAP_ASCENT(0x0308),     // 最后一圈爬升
    ELEVATION_TOTAL_DESCENT(0x0310),       // 总下降
    ELEVATION_LAP_DESCENT(0x0320),         // 下降圈数
    ELEVATION_LAST_LAP_DESCENT(0x0340),    // 最后一圈下降
    ELEVATION_GRADE(0x0380),               // 级别
    // endregion

    // region 配速类 (0x04)
    PACE_PACE(0x0401),                     // 当前配速
    PACE_AVERAGE_PACE(0x0402),             // 平均配速
    PACE_LAP_PACE(0x0404),                 // 单圈配速
    PACE_LAST_LAP_PACE(0x0408),            // 最后一圈配速
    PACE_EFFORT_PACE(0x0410),              // 努力配速
    PACE_AVERAGE_EFFORT_PACE(0x0420),      // 平均努力配速
    PACE_LAP_EFFORT_PACE(0x0440),          // 单圈努力配速
    // endregion

    // region 速度类 (0x05)
    SPEED_CURRENT_SPEED(0x0501),           // 当前速度
    SPEED_AVERAGE_SPEED(0x0502),           // 平均速度
    SPEED_MAXIMUM_SPEED(0x0504),           // 最大速度
    SPEED_LAP_SPEED(0x0508),               // 单圈速度
    SPEED_LAST_LAP_SPEED(0x0510),          // 最后一圈速度
    SPEED_VERTICAL_SPEED(0x0520),          // 垂直速度
    SPEED_AVERAGE_VERTICAL_SPEED(0x0540),  // 平均垂直速度
    SPEED_LAP_VERTICAL_SPEED(0x0580),      // 单圈垂直速度
    // endregion

    // region 心率类 (0x06)
    HEART_RATE_HEART_RATE(0x0601),         // 心率
    HEART_RATE_HEART_RATE_ZONE(0x0602),    // 心率区
    HEART_RATE_AVERAGE_HEART_RATE(0x0604), // 平均心率
    HEART_RATE_MAX_HEART_RATE(0x0608),     // 最大心率
    HEART_RATE_LAP_HEART_RATE(0x0610),     // 单圈心率
    HEART_RATE_LAST_LAP_HEART_RATE(0x0620),// 最后一圈心率
    HEART_RATE_HEART_RATE_RESERVE(0x0640), // 心率储备
    // endregion

    // region 功率类 (0x07)
    POWER_POWER(0x0701),                   // 功率
    POWER_AVERAGE_POWER(0x0702),           // 平均功率
    POWER_LAP_POWER(0x0704),               // 单圈功率
    POWER_3S_AVERAGE_POWER(0x0708),        // 3 秒平均功率
    POWER_10S_AVERAGE_POWER(0x0710),       // 10s 平均功率
    POWER_30S_AVERAGE_POWER(0x0720),       // 30 秒平均功率
    // endregion

    // region 步频类 (0x08)
    CADENCE_CADENCE(0x0801),               // 步频
    CADENCE_AVERAGE_CADENCE(0x0802),       // 平均步频
    CADENCE_LAP_CADENCE(0x0804),           // 圈步频
    CADENCE_LAST_LAP_CADENCE(0x0808),      // 最后一圈节奏
    // endregion

    // region 跑步类 (0x09)
    RUNNING_ECONOMY_STRIDE_LENGTH(0x0901),          // 步幅
    RUNNING_ECONOMY_AVERAGE_STRIDE_LENGTH(0x0902),  // 平均步幅
    RUNNING_ECONOMY_LAP_STRIDO_LENGTH(0x0904),      // 单圈歩幅 (注意原拼写)
    // endregion

    // region 跑步健身类 (0x0A)
    RUNNING_FITNESS_TRAINING_LOAD(0x0A01),           // 训练负荷
    RUNNING_FITNESS_AEROBIC_TRAINING_EFFECT(0x0A02),// 有氧训练效果
    RUNNING_FITNESS_ANAEROBIC_TRAINING_EFECT(0x0A04),// 无氧训练效果 (注意原拼写)
    RUNNING_FITNESS_CALORIE(0x0A08),                // 卡路里
    // endregion

    // region 时间类 (0x0B)
    TIME_ACTIVITY_TIME(0x0B01),            // 活动时间
    TIME_TOTAL_TIME(0x0B02),               // 总时间
    TIME_CURRENT_TIME(0x0B04),             // 当前本地时间
    TIME_TIME_TO_SUNRISE_SUNSET(0x0B08),   // 日出 / 日落时间
    TIME_LAP_TIME(0x0B10),                 // 单圈时间
    TIME_LAST_LAP_TIME(0x0B20),            // 最后一圈时间
    // endregion

    // region 其他类 (0x0C)
    OTHER_VO2MAX(0x0C01),                  // 最大摄氧量
    OTHER_BATTERY_LEVEL(0x0C02),           // 电池电量
    OTHER_BATTERY_LIFE_BASED_ON_SOC(0x0C04); // 基于剩余电量的电池寿命
    // endregion

    companion object {
        fun fromRawValue(value: Int): IDODataSubType {
            return IDODataSubType.values().find { it.rawValue == value } ?: throw IllegalArgumentException("Invalid IDODataSubType value: $value")
        }

        fun combineBytes(highByte: Int, lowByte: Int): IDODataSubType? {
            val combinedValue = (highByte shl 8) or lowByte
            return IDODataSubType.values().find { it.rawValue == combinedValue }
        }
    }
}

// MARK: - private method


private class DataTypeAdapter : TypeAdapter<IDODataType>() {
    override fun write(out: JsonWriter, value: IDODataType?) {
        if (value == null) {
            out.nullValue()
            return
        }
        out.value(value.rawValue)
    }

    override fun read(reader: JsonReader): IDODataType {
        return when (reader.peek()) {
            JsonToken.NUMBER -> {
                IDODataType.fromRawValue(reader.nextInt())
            }
            JsonToken.NULL -> {
                reader.nextNull()
                IDODataType.NONE
            }
            else -> {
                reader.skipValue()
                IDODataType.NONE
            }
        }
    }
}