//
//  IDOWalkRemindTimesParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.FieldNamingPolicy
import com.google.gson.GsonBuilder
import java.io.Serializable
import com.google.gson.annotations.SerializedName

///


open class IDOWalkRemindTimesParamModel(onOff: Int, items: List<IDOWalkRemindTimesItem>) :
    IDOBaseModel {

    @SerializedName("version")
    private var version: Int = 0

    /// Switch: 1:On 0:Off
    @SerializedName("on_off")
    var onOff: Int = onOff

    @SerializedName("num")
    private var num: Int = items.size

    @SerializedName("items")
    var items: List<IDOWalkRemindTimesItem> = items

    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

// MARK: - IDOWalkRemindTimesItem
open class IDOWalkRemindTimesItem(hour: Int, min: Int) : Serializable {
    /// Walk reminder time: Hour
    @SerializedName("hour")
    var hour: Int = hour

    /// Walk reminder time: Minute
    @SerializedName("min")
    var min: Int = min

}