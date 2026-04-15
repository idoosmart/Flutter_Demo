//
//  IDOUpdateStatusModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get device update status event number

open class IDOUpdateStatusModel(devVesion: Int, state: Int) : IDOBaseModel {

    /// Firmware version number
    @SerializedName("dev_vesion")
    var devVesion: Int = devVesion

    /// 0 for normal state
    /// 1 for upgrade state
    @SerializedName("state")
    var state: Int = state


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    