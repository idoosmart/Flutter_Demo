//
//  IDOGpsControlParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Control GPS event number

open class IDOGpsControlParamModel(operate: Int, type: Int) : IDOBaseModel {

    /// 1: Control 
    /// 2: Query                                
    @SerializedName("operate")
    var operate: Int = operate

    /// 1: Enable log
    /// 2: Disable log 
    /// 3: Write AGPS data 
    /// 4: Erase AGPS data 
    /// 5: Write GPS firmware 
    @SerializedName("type")
    var type: Int = type


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    