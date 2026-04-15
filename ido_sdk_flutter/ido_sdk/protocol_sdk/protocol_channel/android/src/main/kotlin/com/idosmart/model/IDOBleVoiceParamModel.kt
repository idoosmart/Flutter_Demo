//
//  IDOBleVoiceParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Set phone volume for device event number

open class IDOBleVoiceParamModel(totalVolume: Int, currentVolume: Int) : IDOBaseModel {

    /// Total volume
    @SerializedName("total_voice")
    var totalVolume: Int = totalVolume

    /// Current volume
    @SerializedName("now_voice")
    var currentVolume: Int = currentVolume



    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

}
    