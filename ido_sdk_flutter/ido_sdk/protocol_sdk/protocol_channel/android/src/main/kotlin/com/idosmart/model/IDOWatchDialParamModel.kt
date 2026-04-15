//
//  IDOWatchDialParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Set watch face event number

open class IDOWatchDialParamModel(dialId: Int) : IDOBaseModel {

    /// ID of the watch face to be set
    /// Dial id
    /// 0 invalid,currently supports1~4 
    @SerializedName("dial_id")
    var dialId: Int = dialId

    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    