//
//  IDOActivitySwitchModel.kt
//  protocol_channel
//
//  Created by hc on 2024/07/10.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

open class IDOAppletControlModel(
    operate: Int,
    appName: String?,
) : IDOBaseModel {
    /// 0:无效 1:启动小程序 2:删除小程序 3:获取已安装的小程序列表
    @SerializedName("operate")
    var operate: Int = operate

    /// 小程序名称 operate=0/operate=3无效,获取操作不需要下发名称，最大29个字节
    @SerializedName("mini_program_name")
    var appName: String? = appName

    @SerializedName("version")
    private var version = 1;
    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

open class IDOAppletInfoModel(
    errorCode: Int,
    infoItem: List<IDOAppletInfoItem>,
    appletNum: Int?,
    operate: Int,
    residualSpace: Int,
    totalSpace: Int
) :IDOBaseModel{
    /// 0:成功 非0失败
    @SerializedName("error_code")
    var errorCode: Int = errorCode

    /// 小程序列表 operate=3有效
    @SerializedName("info_item")
    var infoItem: List<IDOAppletInfoItem> = infoItem

    /// 小程序个数 最多50个，operate=3有效
    @SerializedName("mini_program_num")
    var appletNum: Int? = appletNum

    /// 0:无效 1:启动小程序 2:删除小程序 3:获取已安装的小程序列表
    @SerializedName("operate")
    var operate: Int = operate

    /// 剩余空间 单位Byte
    @SerializedName("residual_space")
    var residualSpace: Int = residualSpace

    /// 总空间 单位Byte
    @SerializedName("total_space")
    var totalSpace: Int = totalSpace
    @SerializedName("version")
    private var version: Int = 1
    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

open class IDOAppletInfoItem(appName: String,size: Int,version:String):IDOBaseModel {
    /// 小程序名称 最大值29个字节
    @SerializedName("mini_program_name")
    public var appName: String=appName
    /// 小程序大小 单位Byte
    @SerializedName("mini_program_size")
    public var size: Int=size
    /// 小程序版本号
    @SerializedName("mini_program_version")
    public var version: String=version
    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}