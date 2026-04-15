//
//  IDOWatchDialIdModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get watch ID event number

open class IDOWatchDialIdModel(watchId: Int) : IDOBaseModel {

    /// Watch ID
    @SerializedName("watch_id")
    var watchId: Int = watchId


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    