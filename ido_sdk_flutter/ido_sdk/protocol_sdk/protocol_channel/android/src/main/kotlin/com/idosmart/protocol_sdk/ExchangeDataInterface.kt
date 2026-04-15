package com.idosmart.protocol_sdk

import com.idosmart.enums.*
import com.idosmart.model.*

interface IDOExchangeDataDelegate {
    /**
     * ble发起运动 app监听ble
     * @param type 监听ble执行数据实体
     */
    fun appListenBleExec(type: IDOBleExecType)

    /**
     * app执行响应
     * @param type 监听app执行Ble响应实体
     */
    fun appListenAppExec(type: IDOBleReplyType)

    /**
     * 交换v2数据
     * @param model 监听v2数据交换实体
     */
    fun exchangeV2Data(model: IDOExchangeV2Model)

    /**
     * 交换v3数据
     * @param model 监听v3数据交换实体
     */
    fun exchangeV3Data(model: IDOExchangeV3Model)

}

interface ExchangeDataInterface {

    /**
     * 获取是否支持v3运动数据交换
     */
    val supportV3ActivityExchange: Boolean

    /**
     * 交换数据状态
     */
    val status: IDOExchangeStatus

    /**
     * 设置监听代理
     */
    fun addExchange(delegate: IDOExchangeDataDelegate?)

    /**
     * app执行数据交换
     * @param type app执行数据交换实体
     */
    fun appExec(type: IDOAppExecType)

    /**
     * ble发起运动 ble执行数据交换 app回复
     * @param type app回复数据实体
     */
    fun appReplyExec(type: IDOAppReplyType)

    /**
     * 获取多运动数据最后一次数据
     */
    fun getLastActivityData()

    /**
     * 获取多运动一分钟心率数据
     */
    fun getActivityHrData()

    /**
     * 获取多运动一段时间的gps数据
     */
    fun getActivityGpsData()
}
