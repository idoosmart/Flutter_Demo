//
//  IDOCmdSetResponseModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Unread message reminder switch event number

open class IDOCmdSetResponseModel(isSuccess: Int) : IDOBaseModel {

    /// 0: Failed
    /// 1: Success
    @SerializedName("is_success")
    var isSuccess: Int = isSuccess

    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    