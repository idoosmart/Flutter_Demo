//
//  IDOMenuListV3Model.kt
//  protocol_channel
//
//  Created by hc on 2025/12/04.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

/**
 * 协议V3菜单列表参数模型（App发送给设备）
 */
internal class IDOMenuListV3ParamModel(
    operate: Int,
    itemList: List<Int>? = null
) : IDOBaseModel {
    /** 版本号，默认为0 */
    @SerializedName("version")
    private val version: Int = 0

    /**
     * 操作类型
     * - 1: 设置
     * - 2: 查询
     */
    @SerializedName("operate")
    var operate: Int = operate

    /** 菜单项个数，设置操作时有效 */
    @SerializedName("item_list_num")
    private val itemListNum: Int = itemList?.size ?: 0

    /**
     * 菜单项列表，自带排序，最大100个，设置操作时有效
     * - 无排序情况：有值则显示，无值则不显示
     * - 有排序情况：需要按照数组从0开始依次显示
     * 
     * 0x00 无效
     * 0x01 步数
     * 0x02 心率
     * 0x03 睡眠
     * 0x04 拍照
     * 0x05 闹钟
     * 0x06 音乐
     * 0x07 秒表
     * 0x08 计时器
     * 0x09 运动模式
     * 0x0A 天气
     * 0x0B 呼吸锻炼
     * 0x0C 查找手机
     * 0x0D 压力
     * 0x0E 数据三环
     * 0x0F 时间界面
     * 0x10 最近一次活动
     * 0x11 健康数据
     * 0x12 血氧
     * 0x13 菜单设置
     * 0x14 Alexa语音依次显示
     * 0x15 X屏（gt01pro-X新增）
     * 0x16 卡路里（Doro Watch新增）
     * 0x17 距离（Doro Watch新增）
     * 0x18 一键测量（IDW05新增）
     * 0x19 Renpho Health润丰健康（IDW12新增）
     * 0x1A 指南针（mp01新增）
     * 0x1B 气压高度计（mp01新增）
     * 0x1C 通话列表/蓝牙通话（IDW13新增）
     * 0x1D 事项提醒
     * 0x1E ICE紧急联系人咨询
     * 0x1F 最大摄氧量
     * 0x20 恢复时间
     * 0x21 有氧训练效果
     * 0x22 海拔高度
     * 0x23 身体电量
     * 0x24 世界时钟
     * 0x25 语音助手
     * 0x26 AI语音助手
     * 0x27 支付宝
     */
    @SerializedName("item_list")
    var itemList: List<Int>? = itemList

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this)
    }
}

/**
 * 协议V3菜单列表回复模型（BLE设备回复给App）
 */
open class IDOMenuListV3Model(
    operate: Int = 0,
    errorCode: Int = 0,
    minShowNum: Int = 0,
    maxShowNum: Int = 0,
    currentShowNum: Int = 0,
    supportMaxNum: Int = 0,
    itemList: List<Int>? = null
) : IDOBaseModel {
    /** 版本号，默认为0 */
    @SerializedName("version")
    private val version: Int = 0

    /**
     * 操作类型
     * - 1: 设置
     * - 2: 查询
     */
    @SerializedName("operate")
    var operate: Int = operate

    /**
     * 错误码
     * - 0: 成功
     * - 1: 失败
     */
    @SerializedName("error_code")
    var errorCode: Int = errorCode

    /** 最小显示个数，查询操作时有效 */
    @SerializedName("min_show_num")
    var minShowNum: Int = minShowNum

    /** 最大显示个数，查询操作时有效 */
    @SerializedName("max_show_num")
    var maxShowNum: Int = maxShowNum

    /** 设备当前显示的列表个数，查询操作时有效 */
    @SerializedName("current_show_num")
    var currentShowNum: Int = currentShowNum

    /** 支持显示个数，查询操作时有效 */
    @SerializedName("support_max_num")
    var supportMaxNum: Int = supportMaxNum

    /**
     * 菜单项列表，自带排序，最大100个，查询操作时有效
     */
    @SerializedName("item_list")
    var itemList: List<Int>? = itemList

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this)
    }
}
