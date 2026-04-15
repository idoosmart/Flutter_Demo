//
//  IDODataTranConfigModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get data transfer configuration event number

open class IDODataTranConfigModel(
    errCode: Int,
    type: Int,
    evtType: Int,
    sportType: Int,
    iconWidth: Int,
    iconHeight: Int,
    format: Int,
    blockSize: Int,
    bigSportsNum: Int,
    msgNum: Int,
    smallSportsAndAnimationNum: Int,
    mediumNum: Int
) : IDOBaseModel {

    /// Error code
    /// 0: Normal
    /// Non-zero: Error
    @SerializedName("err_code")
    var errCode: Int = errCode

    /// Icon type corresponding to the activity type
    /// 0: Invalid
    /// 1: Small icon for activity
    /// 2: Large icon for activity
    /// 3: Animated icon for activity
    /// 4: Medium-sized icons for activity
    @SerializedName("type")
    var type: Int = type

    /// Event type
    /// 0: Invalid
    /// For example, 1: SMS, 2: Email, 3: WeChat, etc.
    @SerializedName("evt_type")
    var evtType: Int = evtType

    /// Activity type
    /// 0: Invalid
    /// Activity mode type, 1: Walking, 2: Running, etc.
    @SerializedName("sport_type")
    var sportType: Int = sportType

    /// Width required by the firmware icon (determined by type and evt_type/sport_type)
    @SerializedName("icon_width")
    var iconWidth: Int = iconWidth

    /// Height required by the firmware icon (determined by type and evt_type/sport_type)
    @SerializedName("icon_height")
    var iconHeight: Int = iconHeight

    /// Color format
    @SerializedName("format")
    var format: Int = format

    /// Compression block size
    @SerializedName("block_size")
    var blockSize: Int = blockSize

    /// Number of big sports icons
    @SerializedName("big_sports_num")
    var bigSportsNum: Int = bigSportsNum

    /// Number of message icons
    @SerializedName("msg_num")
    var msgNum: Int = msgNum

    /// Number of small sports and animation icons
    @SerializedName("small_sports_and_animation_num")
    var smallSportsAndAnimationNum: Int = smallSportsAndAnimationNum

    /// Number of medium-sized icons
    @SerializedName("medium_num")
    var mediumNum: Int = mediumNum


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    