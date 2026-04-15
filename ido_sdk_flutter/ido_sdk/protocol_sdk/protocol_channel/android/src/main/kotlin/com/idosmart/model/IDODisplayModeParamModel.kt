//
//  IDODisplayModeParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Display mode event number

open class IDODisplayModeParamModel(mode: Int) : IDOBaseModel {

    /// Mode 
    /// 0: Default 
    /// 1: Landscape 
    /// 2: Portrait 
    /// 3: Flipped (180 degrees) 
    @SerializedName("mode")
    var mode: Int = mode


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    