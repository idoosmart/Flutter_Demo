//
//  IDOUnerasableMeunListModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get non-deletable menu list in firmware event number

open class IDOUnerasableMeunListModel(itemList: List<Int>) : IDOBaseModel {

    /// Number of items in the list, maximum is 10
    @SerializedName("num")
    private var num: Int = itemList.size

    @SerializedName("item_list")
    var itemList: List<Int> = itemList


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    