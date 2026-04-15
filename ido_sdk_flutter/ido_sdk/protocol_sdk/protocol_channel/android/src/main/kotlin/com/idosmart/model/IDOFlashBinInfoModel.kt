//
//  IDOFlashBinInfoModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get Font Library Information event number

open class IDOFlashBinInfoModel(status: Int, matchVersion: Int, checkCode: Int) : IDOBaseModel {

    /// Status: 0 - Normal, 1 - Invalid font, checksum error, 2 - Version mismatch
    @SerializedName("status")
    var status: Int = status

    /// Font library version
    @SerializedName("version")
    private var version: Int = 0

    /// Matching version required by the firmware
    @SerializedName("match_version")
    var matchVersion: Int = matchVersion

    /// Font library checksum code
    @SerializedName("check_code")
    var checkCode: Int = checkCode


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    