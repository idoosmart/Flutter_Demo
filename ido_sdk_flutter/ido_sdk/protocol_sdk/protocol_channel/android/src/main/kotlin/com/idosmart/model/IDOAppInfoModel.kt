//
//  IDOAppInfoModel.kt
//  protocol_channel
//
//  Created by hc on 2025/03/17.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

open class IDOAppInfoModel(
    @SerializedName("operate")
    var operate: Int = 1,

    /**
     * user name
     * */
    @SerializedName("user_name")
    var userName: String,
) : IDOBaseModel {

    @SerializedName("version")
    private var version: Int = 0
    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
