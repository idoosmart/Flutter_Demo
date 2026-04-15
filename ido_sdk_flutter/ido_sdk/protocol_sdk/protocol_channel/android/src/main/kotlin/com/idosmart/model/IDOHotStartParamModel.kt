//
//  IDOHotStartParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get Hot Start Parameters event number

open class IDOHotStartParamModel(tcxoOffset: Int, longitude: Int, latitude: Int, altitude: Int) :
    IDOBaseModel {

    /// TCXO offset
    @SerializedName("tcxo_offset")
    var tcxoOffset: Int = tcxoOffset

    /// Longitude (multiplied by 10^6)
    @SerializedName("longitude")
    var longitude: Int = longitude

    /// Latitude (multiplied by 10^6)
    @SerializedName("latitude")
    var latitude: Int = latitude

    /// Altitude (multiplied by 10)
    @SerializedName("altitude")
    var altitude: Int = altitude


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    