package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

/**
 * IDOBloodGlucoseV1Model
 */
internal class IDOBloodGlucoseV1Model(
    operate: Int,
    sendInfo: IDOBloodGlucoseSendInfo? = null,
    getInfo: IDOBloodGlucoseGetInfo? = null
) : IDOBaseModel {

    @SerializedName("version")
    private var version: Int = 1

    /**
     * 操作码 1:发送 2:获取 3:设备结束监测
     */
    @SerializedName("operate")
    var operate: Int = operate

    /**
     * 操作码 1有效
     */
    @SerializedName("send_info")
    var sendInfo: IDOBloodGlucoseSendInfo? = sendInfo

    /**
     * 操作码 2有效
     */
    @SerializedName("get_info")
    var getInfo: IDOBloodGlucoseGetInfo? = getInfo

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

/**
 * IDOBloodGlucoseSendInfo
 */
open class IDOBloodGlucoseSendInfo(
    dataType: Int,
    currentInfo: IDOBloodGlucoseCurrentInfoV1? = null,
    statisticsInfo: IDOBloodGlucoseStatisticsInfoV1? = null,
    historyInfo: IDOBloodGlucoseHistoryDataInfoV1? = null,
    sensorInfo: IDOBloodGlucoseSensorInfoV1? = null,
    settingInfo: IDOBloodGlucoseSettingInfoV1? = null
) : IDOBaseModel {

    /**
     * 数据类型
     * 1:app下发当前血糖数据
     * 2:app下发血糖统计数据
     * 3:app下发血糖CGM历史数据
     * 4:app下发绑定设置血糖仪信息
     * 5:app设置单位、目标范围
     */
    @SerializedName("data_type")
    var dataType: Int = dataType

    @SerializedName("current_info_count")
    private var currentInfoCount: Int = if (currentInfo != null) 1 else 0

    @SerializedName("statistics_info_count")
    private var statisticsInfoCount: Int = if (statisticsInfo != null) 1 else 0

    @SerializedName("history_info_count")
    private var historyInfoCount: Int = if (historyInfo != null) 1 else 0

    @SerializedName("sensor_info_count")
    private var sensorInfoCount: Int = if (sensorInfo != null) 1 else 0

    @SerializedName("setting_info_count")
    private var settingInfoCount: Int = if (settingInfo != null) 1 else 0

    /**
     * data_type 1有效
     */
    @SerializedName("current_info")
    var currentInfo: IDOBloodGlucoseCurrentInfoV1? = currentInfo

    /**
     * data_type 2有效
     */
    @SerializedName("statistics_info")
    var statisticsInfo: IDOBloodGlucoseStatisticsInfoV1? = statisticsInfo

    /**
     * data_type 3有效
     */
    @SerializedName("history_info")
    var historyInfo: IDOBloodGlucoseHistoryDataInfoV1? = historyInfo

    /**
     * data_type 4有效
     */
    @SerializedName("sensor_info")
    var sensorInfo: IDOBloodGlucoseSensorInfoV1? = sensorInfo

    /**
     * data_type 5有效
     */
    @SerializedName("setting_info")
    var settingInfo: IDOBloodGlucoseSettingInfoV1? = settingInfo

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

/**
 * IDOBloodGlucoseCurrentInfoV1
 */
open class IDOBloodGlucoseCurrentInfoV1(
    lastUtcDate: Long,
    lastGlucoseVal: Int = 0xFFFF,
    targetUnit: Int,
    trendVal: Int,
    sensorStatus: Int,
    sensorWarmUpTime: Int,
    normalGlucoseValMax: Int,
    normalGlucoseValMin: Int,
    serialNumber: Int
) : IDOBaseModel {

    /**
     * 最近一次测量的时间戳
     */
    @SerializedName("last_utc_date")
    var lastUtcDate: Long = lastUtcDate

    /**
     * 最近一次测量的值 100倍 0xffff为无效值
     */
    @SerializedName("last_glucose_val")
    var lastGlucoseVal: Int = lastGlucoseVal

    /**
     * 血糖单位 1: mmol/L  2: mg/DL
     */
    @SerializedName("targetUnit")
    var targetUnit: Int = targetUnit

    /**
     * 血糖趋势
     * 0：无效
     * 1：rapidlyfalling
     * 2：falling
     * 3：slowlyfalling
     * 4：steady
     * 5：slowlyrising
     * 6：rising
     * 7：rapidlyrising
     */
    @SerializedName("trend_val")
    var trendVal: Int = trendVal

    /**
     * 传感器状态
     * 0:无效值
     * 1:正常，在这个状态 血糖数值
     * 2:sensor蓝牙连接中
     * 3:sensor蓝牙断开
     */
    @SerializedName("sensor_status")
    var sensorStatus: Int = sensorStatus

    /**
     * 传感器预热剩余时间(单位：分钟)
     */
    @SerializedName("sensor_warm_up_time")
    var sensorWarmUpTime: Int = sensorWarmUpTime

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

    /**
     * 序列号
     */
    @SerializedName("serial_number")
    var serialNumber: Int = serialNumber

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

/**
 * IDOBloodGlucoseStatisticsInfoV1
 */
open class IDOBloodGlucoseStatisticsInfoV1(
    targetUnit: Int,
    insulinDose: Int,
    todayItem: IDOBloodGlucoseStatisticsItem? = null,
    weekItem: IDOBloodGlucoseStatisticsItem? = null,
    monthItem: IDOBloodGlucoseStatisticsItem? = null
) : IDOBaseModel {

    /**
     * 血糖单位 1: mmol/L  2: mg/DL
     */
    @SerializedName("targetUnit")
    var targetUnit: Int = targetUnit

    /**
     * 胰岛素注射量 四位小数扩大10000倍
     */
    @SerializedName("insulin_dose")
    var insulinDose: Int = insulinDose

    @SerializedName("today_count")
    private var todayCount: Int = if (todayItem != null) 1 else 0

    @SerializedName("week_count")
    private var weekCount: Int = if (weekItem != null) 1 else 0

    @SerializedName("month_count")
    private var monthCount: Int = if (monthItem != null) 1 else 0

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

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

/**
 * IDOBloodGlucoseHistoryDataInfoV1
 */
open class IDOBloodGlucoseHistoryDataInfoV1(
    dataInfos: List<IDOBloodGlucoseHistoryDataItemV1>?
) : IDOBaseModel {

    /**
     * 总item个数
     */
    @SerializedName("all_items_num")
    var allItemsNum: Int = dataInfos?.size ?: 0

    @SerializedName("data_infos")
    var dataInfos: List<IDOBloodGlucoseHistoryDataItemV1>? = dataInfos

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

/**
 * IDOBloodGlucoseHistoryDataItemV1
 */
open class IDOBloodGlucoseHistoryDataItemV1(
    date: Long, 
    glucoseVal: Int,
    targetUnit: Int,
    serialNumber: Int
) : IDOBaseModel {

    /**
     * 时间
     */
    @SerializedName("date")
    var date: Long = date

    /**
     * 血糖值
     */
    @SerializedName("glucose_val")
    var glucoseVal: Int = glucoseVal

    /**
     * 血糖单位 1: mmol/L  2: mg/DL
     */
    @SerializedName("targetUnit")
    var targetUnit: Int = targetUnit

    /**
     * 序列号
     */
    @SerializedName("serial_number")
    var serialNumber: Int = serialNumber

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

/**
 * IDOBloodGlucoseSensorInfoV1
 */
open class IDOBloodGlucoseSensorInfoV1(
    sn: String,
    mac: String,
    intactSn: String,
    connectId: String,
    startTime: Long,
    endTime: Long,
    isTesting: Int,
    monitoringDays: Int,
    gluIntervals: Int,
    initTime: Long,
    deviceType: Int,
    deviceRunTime: Long
) : IDOBaseModel {

    /**
     * 设备编码（仅搜索设备时用） len: 9
     */
    @SerializedName("sn")
    var sn: String = sn

    /**
     * mac地址 len: 13
     */
    @SerializedName("mac")
    var mac: String = mac

    /**
     * 完整设备编码sn号（唯一） len: 14
     */
    @SerializedName("intact_sn")
    var intactSn: String = intactSn

    /**
     * 连接鉴权ID len: 13
     */
    @SerializedName("connect_id")
    var connectId: String = connectId

    /**
     * 开始监测时间
     */
    @SerializedName("start_time")
    var startTime: Long = startTime

    /**
     * 结束监测时间
     */
    @SerializedName("end_time")
    var endTime: Long = endTime

    /**
     * 监测状态
     */
    @SerializedName("is_testing")
    var isTesting: Int = isTesting

    /**
     * 可使用天数
     */
    @SerializedName("monitoring_days")
    var monitoringDays: Int = monitoringDays

    /**
     * 血糖出值间隔（单位：秒）
     */
    @SerializedName("glu_intervals")
    var gluIntervals: Int = gluIntervals

    /**
     * 初始化时间（单位：分钟）
     */
    @SerializedName("init_time")
    var initTime: Long = initTime

    /**
     * 设备类型
     */
    @SerializedName("device_type")
    var deviceType: Int = deviceType

    /**
     * 设备运行时间（单位：秒）
     */
    @SerializedName("device_run_time")
    var deviceRunTime: Long = deviceRunTime

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

/**
 * IDOBloodGlucoseSettingInfoV1
 */
open class IDOBloodGlucoseSettingInfoV1(
    targetUnit: Int,
    rangeMax: Int,
    rangeMin: Int,
    targetRangeMax: Int,
    targetRangeMin: Int,
    deviceConnectSwitch: Int
) : IDOBaseModel {

    /**
     * 血糖单位 1: mmol/L  2: mg/DL
     */
    @SerializedName("targetUnit")
    var targetUnit: Int = targetUnit

    /**
     * 量程上限
     */
    @SerializedName("range_max")
    var rangeMax: Int = rangeMax

    /**
     * 量程下限
     */
    @SerializedName("range_min")
    var rangeMin: Int = rangeMin

    /**
     * 目标范围上限
     */
    @SerializedName("target_range_max")
    var targetRangeMax: Int = targetRangeMax

    /**
     * 目标范围下限
     */
    @SerializedName("target_range_min")
    var targetRangeMin: Int = targetRangeMin

    /**
     * 手表直连发射器开关
     */
    @SerializedName("device_connect_switch")
    var deviceConnectSwitch: Int = deviceConnectSwitch

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

/**
 * IDOBloodGlucoseGetInfo
 */
internal class IDOBloodGlucoseGetInfo(
    localSerialNumber: Int
) : IDOBaseModel {

    /**
     * 总item个数(首次请求为0，后续使用固件返回的值)
     */
    @SerializedName("all_items_num")
    internal var allItemsNum: Int = 0

    /**
     * 已发送/接收的item个数(首次为0)
     */
    @SerializedName("finish_items_num")
    internal var finishItemsNum: Int = 0

    /**
     * 当前包item个数(请求时为0)
     */
    @SerializedName("cur_items_num")
    internal var curItemsNum: Int = 0

    /**
     * App本地最后一条血糖数据序列号 (app需要获取血糖数据时生效)(0表示获取全部)
     */
    @SerializedName("local_serial_number")
    var localSerialNumber: Int = localSerialNumber

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


/**
 * IDOBloodGlucoseInfoReplyV1
 */
open class IDOBloodGlucoseInfoReplyV1(
    errCode: Int,
    operate: Int,
    replyInfo: IDOBloodGlucoseReplyInfoV1? = null,
    dataInfo: IDOBloodGlucoseDataInfoV1? = null
) : IDOBaseModel {

    @SerializedName("version")
    private var version: Int = 1

    /**
     * 操作码 1:发送  2:获取 3:设备结束监测
     */
    @SerializedName("operate")
    var operate: Int = operate

    /**
     * 错误码 0成功，非0失败
     */
    @SerializedName("err_code")
    var errCode: Int = errCode

    /**
     * 操作码 1有效 3有效
     */
    @SerializedName("reply_info")
    var replyInfo: IDOBloodGlucoseReplyInfoV1? = replyInfo

    /**
     * 操作码 2有效
     */
    @SerializedName("data_info")
    var dataInfo: IDOBloodGlucoseDataInfoV1? = dataInfo

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

/**
 * IDOBloodGlucoseReplyInfoV1
 */
open class IDOBloodGlucoseReplyInfoV1(
    allItemsNum: Int,
    finishItemsNum: Int,
    curItemsNum: Int
) : IDOBaseModel {

    /**
     * 总item个数
     */
    @SerializedName("all_items_num")
    var allItemsNum: Int = allItemsNum

    /**
     * 已发送/接收的item个数
     */
    @SerializedName("finish_items_num")
    var finishItemsNum: Int = finishItemsNum

    /**
     * 当前包item个数
     */
    @SerializedName("cur_items_num")
    var curItemsNum: Int = curItemsNum

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

/**
 * IDOBloodGlucoseDataInfoV1
 */
open class IDOBloodGlucoseDataInfoV1(
    dataType: Int,
    historyInfo: IDOBloodGlucoseHistoryDataInfoV1? = null
) : IDOBaseModel {

    /**
     * 数据类型
     * 1:固件上报历史血糖数据
     * 2:设备结束监测
     */
    @SerializedName("data_type")
    var dataType: Int = dataType

    @SerializedName("history_info_count")
    private var historyInfoCount: Int = if (historyInfo != null) 1 else 0

    /**
     * 血糖CGM历史数据count 有数据传1，没数据传0
     */
    @SerializedName("history_info")
    var historyInfo: IDOBloodGlucoseHistoryDataInfoV1? = historyInfo

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
