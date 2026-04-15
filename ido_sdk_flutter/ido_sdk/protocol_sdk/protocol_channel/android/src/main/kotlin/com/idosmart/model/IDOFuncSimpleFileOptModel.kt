//
//  IDOFuncSimpleFileOptModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Simple file operations event

open class IDOFuncSimpleFileOptModel(error: Int, operate: Int, index: Int) : IDOBaseModel {

    /// Error code
    /// 0 for success, others for errors 
    @SerializedName("error")
    var error: Int = error

    /// Operation type
    /// 0: Get
    /// 1: Overwrite
    /// 2: Delete 
    @SerializedName("operate")
    var operate: Int = operate

    /// Index number
    @SerializedName("index")
    var index: Int = index


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    