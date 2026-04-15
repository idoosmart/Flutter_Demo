//
//  IDOfuncSimpleFileOptParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Simple file operations event

open class IDOFuncSimpleFileOptParamModel(operate: Int, index: Int, destIndex: Int) : IDOBaseModel {

    /// Operation type
    /// 0: Get
    /// 1: Overwrite
    /// 2: Delete
    /// 3: Copy
    @SerializedName("operate")
    var operate: Int = operate

    /// Index number
    @SerializedName("index")
    var index: Int = index

    /// Destination index, only used for copying, invalid for other cases
    @SerializedName("dest_index")
    var destIndex: Int = destIndex


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    