//
//  IDOMusicOnOffParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Set Music On/Off Event

open class IDOMusicOnOffParamModel(onOff: Int, showInfoStatus: Int) : IDOBaseModel {

    /// 1: On
    /// 0: Off                                            
    @SerializedName("on_off")
    var onOff: Int = onOff

    /// Show song information switch
    /// 1: On
    /// 0: Off
    /// Requires firmware support for menu: supportV2SetShowMusicInfoSwitch 
    @SerializedName("show_info_status")
    var showInfoStatus: Int = showInfoStatus


    override fun toJsonString(): String {

        return GsonBuilder().create().toJson(this).toString()
    }
}
    