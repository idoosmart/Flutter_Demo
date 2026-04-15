//
//  IDOMtuInfoModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
///IDOUserInfoPramModel

open class IDOUserInfoPramModel(
    year: Int,
    monuth: Int,
    day: Int,
    heigh: Int,
    weigh: Int,
    gender: Int,
    setTime: Long = 0
) :
    IDOBaseModel {

    @SerializedName("year")
    var year: Int = year

    @SerializedName("month")
    var monuth: Int = monuth

    @SerializedName("day")
    var day: Int = day

    /// 身高 单位厘米
    /// Height in centimeters
    @SerializedName("height")
    var heigh: Int = heigh

    /// 体重 单位千克 值需要x100
    /// Weight in kilograms Value needs x100
    @SerializedName("weight")
    var weigh: Int = weigh

    /// 性别 1：女  0：男
    /// Gender 1: Female 0: Male
    @SerializedName("gender")
    var gender: Int = gender

    /// 性别 1：女  0：男
    /// Gender 1: Female 0: Male
    @SerializedName("set_time")
    var setTime: Long = setTime

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    