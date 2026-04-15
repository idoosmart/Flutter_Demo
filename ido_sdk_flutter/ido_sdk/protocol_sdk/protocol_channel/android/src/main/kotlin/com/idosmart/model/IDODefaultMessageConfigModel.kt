//
//  IDODefaultMessageConfigParamModel.kt
//  protocol_channel
//
//  Created by hc on 2024/05/22.
//

package com.idosmart.model

import com.google.gson.annotations.SerializedName

import com.google.gson.GsonBuilder



open class IDODefaultMessageConfigParamModel(
    operate: Int,
    items: List<IDODefaultMessageItem>?
) : IDOBaseModel {

    /**
     * 操作类型 0:无效 1:设置 2:查询
     */
    @SerializedName("operate")
    var operate: Int = operate

    private var itemsNum: Int = (items?.size ?: 0)
    /**
     * 包列表
     * 包名详情个数 最多设置50个详情
     * operate = 1 时有效
      */
    var items: List<IDODefaultMessageItem>? = items

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

open class IDODefaultMessageConfigModel(
    operate: Int,
    errorCode: Int,
    supportMaxAllItemsNum: Int?,
    supportMaxPackNameLen: Int?,
    items: List<IDODefaultMessageItem>?
) : IDOBaseModel {

    /**
     * 操作类型 0:无效 1:设置 2:查询
     */
    @SerializedName("operate")
    var operate: Int = operate

    /**
     * 错误码 0:成功 非0失败
     */
    @SerializedName("error_code")
    var errorCode: Int = errorCode

    /**
     * 支持总items的个数 默认最多50个 操作查询有效
     */
    @SerializedName("support_max_all_items_num")
    var supportMaxAllItemsNum: Int? = supportMaxAllItemsNum

    /**
     * 支持每个详情的包名长度 默认50个字节 操作查询有效
     */
    @SerializedName("support_max_pack_name_len")
    var supportMaxPackNameLen: Int? = supportMaxPackNameLen

    /**
     * 包列表
     * 包名详情个数 最多设置50个详情
     * operate = 1 时有效
     */
    var items: List<IDODefaultMessageItem>? = items

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


open class IDODefaultMessageItem(packageName: String) : IDOBaseModel {

    @SerializedName("package_name")
    var packageName: String = packageName

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    