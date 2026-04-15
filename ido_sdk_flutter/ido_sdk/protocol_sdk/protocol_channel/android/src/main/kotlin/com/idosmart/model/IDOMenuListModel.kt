//
//  IDOMenuListModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.FieldNamingPolicy
import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///


open class IDOMenuListModel(
    currentShowNum: Int,
    items: List<IDOMenuItem>?,
    maxNum: Int,
    maxShowNum: Int,
    minShowNum: Int
) : IDOBaseModel {

    @SerializedName("current_show_num")
    var currentShowNum: Int = currentShowNum

    @SerializedName("items")
    var items: List<IDOMenuItem>? = items

    @SerializedName("max_num")
    var maxNum: Int = maxNum

    @SerializedName("max_show_num")
    var maxShowNum: Int = maxShowNum

    @SerializedName("min_show_num")
    var minShowNum: Int = minShowNum

    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

}

// MARK: - IDOMenuItem
open class IDOMenuItem(index: Int, value: Int) {
    @SerializedName("index")
    var index: Int = index

    @SerializedName("value")
    var value: Int = value

}