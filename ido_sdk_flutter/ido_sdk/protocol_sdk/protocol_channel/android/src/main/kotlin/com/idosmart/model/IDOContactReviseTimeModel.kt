//
//  IDOContactReviseTimeModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get firmware local contact file modification time event number

open class IDOContactReviseTimeModel(result: Int) : IDOBaseModel {

    /// 0: No need to send contact file
    /// 1: Need to send contact data
    @SerializedName("result")
    var result: Int = result


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    