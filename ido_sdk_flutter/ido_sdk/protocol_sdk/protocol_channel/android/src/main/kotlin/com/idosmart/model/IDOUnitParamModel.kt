//
//  IDOUnitParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Set Unit event number

open class IDOUnitParamModel(
    distUnit: Int,
    weightUnit: Int,
    temp: Int,
    stride: Int,
    language: Int,
    is12HourFormat: Int,
    strideRun: Int,
    strideGpsCal: Int,
    weekStartDate: Int,
    calorieUnit: Int,
    swimPoolUnit: Int,
    cyclingUnit: Int,
    walkingRunningUnit: Int?
) : IDOBaseModel {

    /// Distance Unit:
    /// 0: Invalid
    /// 1: km (metric)
    /// 2: mi (imperial)
    @SerializedName("dist_unit")
    var distUnit: Int = distUnit

    /// Weight Unit:
    /// 0: Invalid
    /// 1: kg
    /// 2: lb
    @SerializedName("weight_unit")
    var weightUnit: Int = weightUnit

    /// Temperature Unit:
    /// 0: Invalid<br/>1: ℃
    /// 2: ℉
    @SerializedName("temp")
    var temp: Int = temp

    /// Walking Stride:
    /// 0: Invalid
    /// 0: cm
    @SerializedName("stride")
    var stride: Int = stride

    /**
     * ## Language
     * | 代码 | 语言 | 功能表 |
     * | ---- | ------------ | --------------------------- |
     * | -1 | 无效 | - |
     * | 1 | 中文 | languageCh |
     * | 2 | 英文 | languageEnglish |
     * | 3 | 法语 | languageFrench |
     * | 4 | 德语 | languageGerman |
     * | 5 | 意大利语 | languageItalian |
     * | 6 | 西班牙语 | languageSpanish |
     * | 7 | 日语 | languageJapanese |
     * | 8 | 波兰语 | languagePolish |
     * | 9 | 捷克语 | languageCzech |
     * | 10 | 罗马尼亚 | languageRomanian |
     * | 11 | 立陶宛语 | languageLithuanian |
     * | 12 | 荷兰语 | languageDutch |
     * | 13 | 斯洛文尼亚语 | languageSlovenian |
     * | 14 | 匈牙利语 | languageHungarian |
     * | 15 | 俄罗斯语 | languageRussian |
     * | 16 | 乌克兰语 | languageUkrainian |
     * | 17 | 斯洛伐克语 | languageSlovak |
     * | 18 | 丹麦语 | languageDanish |
     * | 19 | 克罗地亚语 | languageCroatian |
     * | 20 | 印尼语 | languageIndonesian |
     * | 21 | 韩语 | languageKorean |
     * | 22 | 印地语 | languageHindi |
     * | 23 | 葡萄牙语 | languagePortuguese |
     * | 24 | 土耳其语 | languageTurkish |
     * | 25 | 泰国语 | languageThai |
     * | 26 | 越南语 | languageVietnamese |
     * | 27 | 缅甸语 | languageBurmese |
     * | 28 | 菲律宾语 | languageFilipino |
     * | 29 | 繁体中文 | languageTraditionalChinese |
     * | 30 | 希腊语 | languageGreek |
     * | 31 | 阿拉伯语 | languageArabic |
     * | 32 | 瑞典语 | languageSweden |
     * | 33 | 芬兰语 | languageFinland |
     * | 34 | 波斯语 | languagePersia |
     * | 35 | 挪威语 | languageNorwegian |
     * | 36 | 马来语 | languageMalay |
     * | 37 | 巴西葡语 | languageBrazilianPortuguese |
     * | 38 | 孟加拉语 | languageBengali |
     * | 39 | 高棉语 | languageKhmer |
     */
    @SerializedName("language")
    var language: Int = language

    /// Time Format:
    /// 0: Invalid<br/>1: 24-hour format
    /// 2: 12-hour format
    @SerializedName("is_12hour_format")
    var is12HourFormat: Int = is12HourFormat

    /// Running Stride:
    /// 0: Invalid
    /// 1: cm
    /// Default value for males: 90cm
    @SerializedName("stride_run")
    var strideRun: Int = strideRun

    /// Stride Calibration via GPS on/off:<br/>0: Invalid
    /// 1: On
    /// 2: Off
    @SerializedName("stride_gps_cal")
    var strideGpsCal: Int = strideGpsCal

    /// Start day of the week:
    /// 0: Monday
    /// 1: Sunday
    /// 3: Saturday
    @SerializedName("week_start_date")
    var weekStartDate: Int = weekStartDate

    /// Calorie unit setting:
    /// 0: Invalid
    /// 1: Default kCal
    /// 2: Cal
    /// 3: kJ
    @SerializedName("calorie_unit")
    var calorieUnit: Int = calorieUnit

    /// Swim pool unit setting:
    /// 0: Invalid
    /// 1: Default meters
    /// 2: yards
    @SerializedName("swim_pool_unit")
    var swimPoolUnit: Int = swimPoolUnit

    /// Cycling unit:
    /// 0: Invalid
    /// 1: km
    /// 2: miles
    @SerializedName("cycling_unit")
    var cyclingUnit: Int = cyclingUnit

    /// Unit for walking or running (km/miles) setting:<br/>0: Invalid
    /// 1: km
    /// 2: miles
    /// Requires support from the device firmware (setSupportWalkRunUnit)
    @SerializedName("walking_running_unit")
    var walkingRunningUnit: Int? = walkingRunningUnit

    ////身高单位 0：无效，1：cm，2：inch 英寸；功能表：support_height_unit_03_11
    @SerializedName("height_unit")
    var heightUnit: Int = 0
    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}



open class IDOUnitModel(
    distUnit: Int,
    temp: Int,
    language: Int,
    swimPoolUnit: Int,
) : IDOBaseModel {

    /// Distance Unit:
    /// 0: Invalid
    /// 1: km (metric)
    /// 2: mi (imperial)
    @SerializedName("dist_unit")
    var distUnit: Int = distUnit

    /// Temperature Unit:
    /// 0: Invalid<br/>1: ℃
    /// 2: ℉
    @SerializedName("temp")
    var temp: Int = temp


    /**
     * ## Language
     * | 代码 | 语言 | 功能表 |
     * | ---- | ------------ | --------------------------- |
     * | -1 | 无效 | - |
     * | 1 | 中文 | languageCh |
     * | 2 | 英文 | languageEnglish |
     * | 3 | 法语 | languageFrench |
     * | 4 | 德语 | languageGerman |
     * | 5 | 意大利语 | languageItalian |
     * | 6 | 西班牙语 | languageSpanish |
     * | 7 | 日语 | languageJapanese |
     * | 8 | 波兰语 | languagePolish |
     * | 9 | 捷克语 | languageCzech |
     * | 10 | 罗马尼亚 | languageRomanian |
     * | 11 | 立陶宛语 | languageLithuanian |
     * | 12 | 荷兰语 | languageDutch |
     * | 13 | 斯洛文尼亚语 | languageSlovenian |
     * | 14 | 匈牙利语 | languageHungarian |
     * | 15 | 俄罗斯语 | languageRussian |
     * | 16 | 乌克兰语 | languageUkrainian |
     * | 17 | 斯洛伐克语 | languageSlovak |
     * | 18 | 丹麦语 | languageDanish |
     * | 19 | 克罗地亚语 | languageCroatian |
     * | 20 | 印尼语 | languageIndonesian |
     * | 21 | 韩语 | languageKorean |
     * | 22 | 印地语 | languageHindi |
     * | 23 | 葡萄牙语 | languagePortuguese |
     * | 24 | 土耳其语 | languageTurkish |
     * | 25 | 泰国语 | languageThai |
     * | 26 | 越南语 | languageVietnamese |
     * | 27 | 缅甸语 | languageBurmese |
     * | 28 | 菲律宾语 | languageFilipino |
     * | 29 | 繁体中文 | languageTraditionalChinese |
     * | 30 | 希腊语 | languageGreek |
     * | 31 | 阿拉伯语 | languageArabic |
     * | 32 | 瑞典语 | languageSweden |
     * | 33 | 芬兰语 | languageFinland |
     * | 34 | 波斯语 | languagePersia |
     * | 35 | 挪威语 | languageNorwegian |
     * | 36 | 马来语 | languageMalay |
     * | 37 | 巴西葡语 | languageBrazilianPortuguese |
     * | 38 | 孟加拉语 | languageBengali |
     * | 39 | 高棉语 | languageKhmer |
     */
    @SerializedName("language")
    var language: Int = language


    /// Swim pool unit setting:
    /// 0: Invalid
    /// 1: Default meters
    /// 2: yards
    @SerializedName("swim_pool_unit")
    var swimPoolUnit: Int = swimPoolUnit

    ////身高单位 0：无效，1：cm，2：inch 英寸；功能表：support_height_unit_03_11
    @SerializedName("height_unit")
    var heightUnit: Int = 0

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
