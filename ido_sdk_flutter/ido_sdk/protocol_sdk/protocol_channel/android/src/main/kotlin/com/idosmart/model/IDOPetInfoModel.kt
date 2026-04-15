package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

/// 获取宠物信息返回
open class IDOPetInfoModel(
    petType: Int,
    weight: Int,
    gender: Int,
    year: Int,
    month: Int,
    day: Int,
) : IDOBaseModel {

    /// 0x00无效 0x01猫 0x02狗
    @SerializedName("pet_type")
    var petType: Int = petType

    /// 体重x100，单位kg
    @SerializedName("weight")
    var weight: Int = weight

    /// 性别 0x0 公 0x1 母
    @SerializedName("gender")
    var gender: Int = gender

    /// 生日年
    @SerializedName("year")
    var year: Int = year

    /// 生日月
    @SerializedName("month")
    var month: Int = month

    /// 生日日
    @SerializedName("day")
    var day: Int = day

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

