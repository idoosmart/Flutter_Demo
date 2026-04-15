//
//  IDOWatchDialSortParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import java.io.Serializable
import com.google.gson.annotations.SerializedName

///

open class IDOWatchDialSortParamModel(sortItemNumb: Int, pSortItem: List<IDOWatchDialSortItem>) :
    IDOBaseModel {

    /// Number of items in the watch dial sort list
    @SerializedName("sort_item_numb")
    var sortItemNumb: Int = sortItemNumb

    /// Array of watch dial sort items type, sort_number, and name
    @SerializedName("p_sort_item")
    var pSortItem: List<IDOWatchDialSortItem> = pSortItem

    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

// MARK: - IDOWatchDialSortItem
open class IDOWatchDialSortItem(type: Int, sortNumber: Int, name: String) : Serializable {
    /// Watch dial type 1: Normal Dial, 2: Wallpaper Dial, 3: Cloud Dial
    @SerializedName("type")
    var type: Int = type

    /// Serial number, starting from 0, not exceeding the total number of supported watch dials
    @SerializedName("sort_number")
    var sortNumber: Int = sortNumber

    /// Watch dial ID, maximum 29 bytes
    @SerializedName("name")
    var name: String = name
}