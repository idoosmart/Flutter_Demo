//
//  IDODeviceLogStateModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get device log state event number

open class IDODeviceLogStateModel(type: Int, errCode: Int) : IDOBaseModel {

    /// 0: No corresponding log 
    /// 1: Firmware restart log 
    /// 2: Firmware exception 
    @SerializedName("type")
    var type: Int = type

    /// Error code of firmware restart log, 0 is normal
    @SerializedName("err_code")
    var errCode: Int = errCode


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    