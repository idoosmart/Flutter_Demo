package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

/**
 * IDOBikeLockModel
 */
internal class IDOBikeLockModel(
    operate: Int,
    items: List<IDOBikeLockInfo>? = null
) : IDOBaseModel {
    @SerializedName("version")
    private var version: Int = 0

    /**
     * 操作类型 1:设置 2:查询
     */
    @SerializedName("operate")
    var operate: Int = operate

    /**
     * 车锁总item个数，最大10 个，operate=1设置有效
     */
    @SerializedName("all_items_num")
    private var itemNum: Int = items?.size ?: 0

    /**
     * 车锁信息，operate=1设置有效
     */
    @SerializedName("items")
    var items: List<IDOBikeLockInfo>? = items

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

/**
 * IDOBikeLockInfo
 */
open class IDOBikeLockInfo(
    mac: List<Int>,
    secret: String,
    name: String? = null
) : IDOBaseModel {

    /**
     * 车锁的mac地址,按照大端排序 mac0 mac1 mac2 mac3 mac4 mac5
     */
    @SerializedName("mac")
    var mac: List<Int> = mac

    /**
     * 车锁与手表交互需要的密钥
     */
    @SerializedName("secret")
    var secret: String = secret

    /**
     * 车锁名称
     */
    @SerializedName("name")
    var name: String? = name

    /**
     * mac的字符串形式，形如：AA:BB:CC:DD:EE:FF
     */
    val macStr: String
        get() = mac.joinToString(":") { "%02X".format(it) }

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

/**
 * IDOBikeLockReplyModel
 */
open class IDOBikeLockReplyModel(
    operate: Int,
    errorCode: Int,
    items: List<IDOBikeLockInfo>? = null
) : IDOBaseModel {

    @SerializedName("version")
    private var version: Int = 0

    /**
     * 操作类型 1:设置 2:查询
     */
    @SerializedName("operate")
    var operate: Int = operate

    /**
     * 错误码 0:成功 1:失败
     */
    @SerializedName("error_code")
    var errorCode: Int = errorCode

    /**
     * 车锁总item个数，最大10 个，operate=2查询有效
     */
    @SerializedName("all_items_num")
    private var itemNum: Int = items?.size ?: 0

    /**
     * 车锁信息，operate=2查询有效
     */
    @SerializedName("items")
    var items: List<IDOBikeLockInfo>? = items

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
