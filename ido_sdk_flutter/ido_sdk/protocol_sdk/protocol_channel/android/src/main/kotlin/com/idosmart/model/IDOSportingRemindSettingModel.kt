package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

data class IDOSportingRemindSettingParamModel(
    val version: Int = 0,
    /**
     * 操作
     * 0：无效
     * 1：设置
     * 2：查询
     */
    val operate: Int?,
    @SerializedName("setting_item") val settingItems: List<IDOSportingRemindSettingModel?>? = null,
    @SerializedName("setting_item_num") val settingItemCount: Int? = settingItems?.size ?: 0,
    @SerializedName("sport_type") val sportTypes: List<Int>? = null,
    @SerializedName("sport_type_num") val sportTypeCount: Int? = sportTypes?.size ?: 0,
) : IDOBaseModel {
    companion object {
        const val SET = 1
        const val QUERY = 2
    }

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

    override fun toString(): String {
        return "IDOSportingRemindSettingParamModel(version=$version, operate=$operate, settingItems=$settingItems, settingItemCount=$settingItemCount, sportTypeCount=$sportTypeCount, sportType=$sportTypes)"
    }

}

open class IDOSportingRemindSettingReplyModel(
    @SerializedName("err_code") var errCode: Int = 0,
    @SerializedName("setting_item") val settingItems: List<IDOSportingRemindSettingModel?>? = null,
) : IDOBaseModel {

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

    override fun toString(): String {
        return "IDOSportingRemindSettingReplyModel(errCode=$errCode, settingItems=$settingItems)"
    }

}

open class IDOSportingRemindSettingModel(
    @SerializedName("sport_type") val sportType: Int?,
    @SerializedName("dis_remind") val distanceRemind: DistanceRemind?,
    @SerializedName("hr_remind") val heartRateRemind: CommonRangeRemind?,
    @SerializedName("pace_remind") val paceRemind: PaceRemind?,
    @SerializedName("step_freq_remind") val stepFreqRemind: CommonRangeRemind?
) : IDOBaseModel {
    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

    override fun toString(): String {
        return "IDOSportingRemindSettingModel(sportType=$sportType, distanceRemind=$distanceRemind, heartRateRemind=$heartRateRemind, paceRemind=$paceRemind, stepFreqRemind=$stepFreqRemind)"
    }

}

open class DistanceRemind(
    @SerializedName("is_on") val isOpen: Boolean = false,
    @SerializedName("is_metric") val isMetric: Boolean = false,
    @SerializedName("goal_val_org") val goalValOrg: Int?
) : IDOBaseModel {
    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

    override fun toString(): String {
        return "DistanceRemind(isOpen=$isOpen, isMetric=$isMetric, goalValOrg=$goalValOrg)"
    }


}

open class CommonRangeRemind(
    @SerializedName("is_on") val isOpen: Boolean = false,
    @SerializedName("max_threshold") val maxThreshold: Int?,
    @SerializedName("min_threshold") val minThreshold: Int?
) : IDOBaseModel {
    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

    override fun toString(): String {
        return "CommonRangeRemind(isOpen=$isOpen, maxThreshold=$maxThreshold, minThreshold=$minThreshold)"
    }


}

open class PaceRemind(
    @SerializedName("is_on") val isOpen: Boolean = false,
    @SerializedName("is_metric") val isMetric: Boolean = false,
    @SerializedName("fast_threshold_org") val fastThresholdOrg: Int?,
    @SerializedName("slow_threshold_org") val slowThresholdOrg: Int?
) : IDOBaseModel {
    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

    override fun toString(): String {
        return "PaceRemind(isOpen=$isOpen, isMetric=$isMetric, fastThresholdOrg=$fastThresholdOrg, slowThresholdOrg=$slowThresholdOrg)"
    }


}