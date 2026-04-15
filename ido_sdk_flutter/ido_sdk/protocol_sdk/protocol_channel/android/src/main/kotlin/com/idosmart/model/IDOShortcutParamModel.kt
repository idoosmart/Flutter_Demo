//
//  IDOShortcutParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Set shortcut

open class IDOShortcutParamModel(mode: Int) : IDOBaseModel {

    /// Function of Shortcut 1
    /// 0: Invalid
    /// 1: Quick access to camera control
    /// 2: Quick access to motion mode
    /// 3: Quick access to do not disturb 
    @SerializedName("mode")
    var mode: Int = mode


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    