//
//  IDOLostFindParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Set Lost Find Event

open class IDOLostFindParamModel(mode: Int) : IDOBaseModel {

    /// Mode
    /// 0: No anti-lost
    /// 1: Close-range anti-lost
    /// 2: Medium-range anti-lost
    /// 3: Long-range anti-lost 
    @SerializedName("mode")
    var mode: Int = mode


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    