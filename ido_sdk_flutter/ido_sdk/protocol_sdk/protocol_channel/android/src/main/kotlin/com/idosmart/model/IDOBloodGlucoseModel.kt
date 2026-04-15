package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

/**
 * IDOBloodGlucoseModel
 */
internal class IDOBloodGlucoseModel(
    operate: Int,
    currentInfoItem: IDOBloodGlucoseCurrentInfo? = null,
    statisticsInfoItem: IDOBloodGlucoseStatisticsInfo? = null,
    historyInfoItem: IDOBloodGlucoseHistoryDataInfo? = null

) : IDOBaseModel {
    @SerializedName("version")
    private var version: Int = 0 // 默认值 0

    @SerializedName("operate")
    var operate: Int = operate

    @SerializedName("current_info_count")
    private var currentInfoCount: Int = if (currentInfoItem != null) 1 else 0

    /**
     * 血糖统计数据count 通常为1
     */
    @SerializedName("statistics_info_count")
    private var statisticsInfoCount: Int = if (statisticsInfoItem != null) 1 else 0

    /**
     * 血糖CGM历史数据count 通常为1
     */
    @SerializedName("history_info_count")
    private var historyInfoCount: Int = if (historyInfoItem != null) 1 else 0

    @SerializedName("current_info")
    var currentInfoItem: IDOBloodGlucoseCurrentInfo? = currentInfoItem

    @SerializedName("statistics_info")
    var statisticsInfoItem: IDOBloodGlucoseStatisticsInfo? = statisticsInfoItem

    @SerializedName("history_info")
    var historyInfoItem: IDOBloodGlucoseHistoryDataInfo? = historyInfoItem

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


/**
 * IDOBloodGlucoseCurrentInfo
 */
open class IDOBloodGlucoseCurrentInfo(
    lastUtcDate: Long,
    lastGlucoseVal: Int = 0xFFFF,
    targetUnit: Int,
    trendVal: Int,
    sensorWarmUpTime: Int,
    sensorStatus: Int,
    normalGlucoseValMax: Int,
    normalGlucoseValMin: Int
) : IDOBaseModel {
    /**
     * 最近一次测量的时间戳
     */
    @SerializedName("last_utc_date")
    var lastUtcDate: Long = lastUtcDate

    /**
     * 最近一次测量的值 100倍
     */
    @SerializedName("last_glucose_val")
    var lastGlucoseVal: Int = lastGlucoseVal

    /**
     * 血糖单位 1: mmol/L 2: mg/DL
     */
    @SerializedName("targetUnit")
    var targetUnit: Int = targetUnit

    /**
     * 血糖趋势
     * 0：无效
     * 1: rapidlyfalling
     * 2: falling
     * 3: slowlyfalling
     * 4: steady
     * 5: slowlyrising
     * 6: rising
     * 7: rapidlyrising
     */
    @SerializedName("trend_val")
    var trendVal: Int = trendVal

    /**
     * 传感器预热时间（单位：分钟）
     */
    @SerializedName("sensor_warm_up_time")
    var sensorWarmUpTime: Int = sensorWarmUpTime

    /**
     * 传感器状态
     * 0：无效
     * 1:正常，在这个状态 血糖数值，trend才有用
     * 2:sensor稳定中
     * 3:sensor错误
     * 4:sensor替换
     * 5:确认新 sensor
     * 6:预热中
     * 7:sensor 过期
     * 8:数据无效
     * 9:sensor低电量
     */
    @SerializedName("sensor_status")
    var sensorStatus: Int = sensorStatus

    /**
     * 血糖正常值范围最大值(100倍)
     */
    @SerializedName("normal_glucose_val_max")
    var normalGlucoseValMax: Int = normalGlucoseValMax

    /**
     * 血糖正常值范围最小值(100倍)
     */
    @SerializedName("normal_glucose_val_min")
    var normalGlucoseValMin: Int = normalGlucoseValMin

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


/**
 * IDOBloodGlucoseStatisticsItem
 */
open class IDOBloodGlucoseStatisticsItem(
    glucoseMax: Int = 0xFFFF,
    glucoseMin: Int = 0xFFFF,
    maxFlu: Int = 0xFFFF,
    ehba1c: Int = 0xFFFF,
    mbg: Int = 0xFFFF,
    sdbg: Int = 0xFFFF,
    cv: Int = 0xFFFF,
    mage: Int = 0xFFFF
) : IDOBaseModel {
    /**
     * 血糖最大值 扩大一百倍
     */
    @SerializedName("glucose_max")
    var glucoseMax: Int = glucoseMax

    /**
     * 血糖最小值 扩大一百倍
     */
    @SerializedName("glucose_min")
    var glucoseMin: Int = glucoseMin

    /**
     * 扩大一百倍
     */
    @SerializedName("maxflu")
    var maxFlu: Int = maxFlu

    /**
     * 扩大一百倍
     */
    @SerializedName("ehba1c")
    var ehba1c: Int = ehba1c

    /**
     * 扩大一百倍
     */
    @SerializedName("mbg")
    var mbg: Int = mbg

    /**
     * 扩大一百倍
     */
    @SerializedName("sdbg")
    var sdbg: Int = sdbg

    /**
     * 扩大一百倍
     */
    @SerializedName("cv")
    var cv: Int = cv

    /**
     * 扩大一百倍
     */
    @SerializedName("mage")
    var mage: Int = mage

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


/**
 * IDOBloodGlucoseStatisticsInfo
 */
open class IDOBloodGlucoseStatisticsInfo(
    targetUnit: Int,
    insulinDose: Int,
    todayItem: IDOBloodGlucoseStatisticsItem? = null,
    weekItem: IDOBloodGlucoseStatisticsItem? = null,
    monthItem: IDOBloodGlucoseStatisticsItem?= null
) : IDOBaseModel {
    /**
     * 血糖单位 1: mmol/L  2: mg/DL
     */
    @SerializedName("targetUnit")
    var targetUnit: Int = targetUnit

    /**
     * 胰岛素注射量 四位小数扩大10000倍
     */
    @SerializedName("insulin_count")
    var insulinDose: Int = insulinDose

    /**
     * 当日统计数据
     */
    @SerializedName("today_item")
    var todayItem: IDOBloodGlucoseStatisticsItem? = todayItem

    /**
     * 本周统计数据
     */
    @SerializedName("week_item")
    var weekItem: IDOBloodGlucoseStatisticsItem? = weekItem

    /**
     * 本月统计数据
     */
    @SerializedName("month_item")
    var monthItem: IDOBloodGlucoseStatisticsItem? = monthItem

    @SerializedName("today_count")
    var todayCount: Int = if (todayItem != null) 1 else 0

    @SerializedName("week_count")
    var weekCount: Int = if (weekItem != null) 1 else 0

    @SerializedName("month_count")
    var monthCount: Int = if (monthItem != null) 1 else 0

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


/**
 * IDOBloodGlucoseHistoryDataInfo
 */
open class IDOBloodGlucoseHistoryDataInfo(
    // 构造函数只接收 dataInfo，其他参数在属性初始化时计算
    dataInfos: List<IDOBloodGlucoseHistoryDataItem>?
) : IDOBaseModel {

    // Swift 构造函数中的计算逻辑被转移到属性初始化中
    /**
     * 总item个数
     */
    @SerializedName("all_items_num")
    var allItemsNum: Int = dataInfos?.size ?: 0 // 对应 self.allItemsNum = dataInfo?.count ?? 0

//    @SerializedName("finish_items_num")
//    var finishItemsNum: Int = 0 // 对应 self.finishItemsNum = 0
//
//    @SerializedName("cur_items_num")
//    var curItemsNum: Int = 1 // 对应 self.curItemsNum = 1
//
//    @SerializedName("history_data_count")
//    var historyDataCount: Int = dataInfo?.size ?: 0 // 对应 self.historyDataCount = dataInfo?.count ?? 0

    /**
     * 历史数据项列表
     */
    @SerializedName("data_infos")
    var dataInfos: List<IDOBloodGlucoseHistoryDataItem>? = dataInfos

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


/**
 * IDOBloodGlucoseHistoryDataItem
 */
open class IDOBloodGlucoseHistoryDataItem(
    date: Long, // 对应 Swift 的 UInt32，使用 Long 以确保无符号 32 位值的安全存储
    glucoseVal: Int,
    targetUnit: Int
) : IDOBaseModel {
    /**
     * 时间
     */
    @SerializedName("date")
    var date: Long = date

    /**
     * 血糖值 扩大一百倍
     */
    @SerializedName("glucose_val")
    var glucoseVal: Int = glucoseVal

    /**
     * 血糖单位 1: mmol/L  2: mg/DL
     */
    @SerializedName("targetUnit")
    var targetUnit: Int = targetUnit

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
