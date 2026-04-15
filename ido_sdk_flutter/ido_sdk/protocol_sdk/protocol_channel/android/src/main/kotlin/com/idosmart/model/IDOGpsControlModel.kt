//
//  IDOGpsControlModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Control GPS event number

open class IDOGpsControlModel(type: Int, status: Int, errorCode: Int) : IDOBaseModel {

    /// 1: Enable log 
    /// 2: Disable log 
    /// 3: Write AGPS data 
    /// 4: Erase AGPS data 
    /// 5: Write GPS firmware 
    @SerializedName("type")
    var type: Int = type

    /// 0: Invalid
    /// 1: Command in progress 
    /// 2: Completed    
    @SerializedName("status")
    var status: Int = status

    /// 0 for success, non-zero for failure
    @SerializedName("error_code")
    var errorCode: Int = errorCode


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    