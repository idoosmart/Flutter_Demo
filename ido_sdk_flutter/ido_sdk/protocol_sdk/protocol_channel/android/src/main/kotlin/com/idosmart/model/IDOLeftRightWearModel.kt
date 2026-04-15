//
//  IDOWearHandModel.kt
//  protocol_channel
//
//  Created by tw on 2025/05/06.
package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

open class IDOLeftRightWearModel(@SerializedName("hand_type") val handType: Int) : IDOBaseModel {

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

    override fun toString(): String {
        return "IDOLeftRightWearModel(handType=$handType)"
    }


}