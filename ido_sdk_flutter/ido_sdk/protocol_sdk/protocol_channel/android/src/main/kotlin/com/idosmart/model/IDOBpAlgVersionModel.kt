//
//  IDOBpAlgVersionModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get blood pressure algorithm version information event number

open class IDOBpAlgVersionModel(bpVersion1: Int, bpVersion2: Int, bpVersion3: Int) : IDOBaseModel {

    /// Firmware blood pressure algorithm version1
    @SerializedName("bp_version1")
    var bpVersion1: Int = bpVersion1

    /// Firmware blood pressure algorithm version2
    @SerializedName("bp_version2")
    var bpVersion2: Int = bpVersion2

    /// Firmware blood pressure algorithm version3
    @SerializedName("bp_version3")
    var bpVersion3: Int = bpVersion3



    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    