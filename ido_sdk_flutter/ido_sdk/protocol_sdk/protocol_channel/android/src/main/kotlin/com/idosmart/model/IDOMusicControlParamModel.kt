//
//  IDOMusicControlParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

open class IDOMusicControlParamModel(
    status: Int,
    curTimeSecond: Int,
    totalTimeSecond: Int,
    musicName: String,
    singerName: String
) : IDOBaseModel {

    /// Status: 0: Invalid 1: Play 2: Pause 3: Stop
    @SerializedName("status")
    var status: Int = status

    /// Current play time Unit:second
    @SerializedName("cur_time_second")
    var curTimeSecond: Int = curTimeSecond

    /// Total play time Unit:second
    @SerializedName("total_time_second")
    var totalTimeSecond: Int = totalTimeSecond

    /// Music name (maximum 63 bytes)
    @SerializedName("music_name")
    var musicName: String = musicName

    /// Singer name (maximum 63 bytes)
    /// This value is not applicable if v3MusicControl02AddSingerName is not enabled on the firmware
    @SerializedName("singer_name")
    var singerName: String = singerName


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    