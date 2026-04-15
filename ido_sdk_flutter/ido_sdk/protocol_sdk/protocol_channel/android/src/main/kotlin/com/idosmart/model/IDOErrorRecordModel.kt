//
//  IDOErrorRecordModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get Error Records event number

open class IDOErrorRecordModel(type: Int, resetFlag: Int, hwError: Int) : IDOBaseModel {

    /// 0 Query
    /// 1 Clear Log
    @SerializedName("type")
    var type: Int = type

    /// 0 Normal
    /// 1 Hard Faul
    /// 2 Watchdog service
    /// 3 Assertion reset
    /// 4 Power-off service
    /// 5 Other exceptions
    @SerializedName("reset_flag")
    var resetFlag: Int = resetFlag

    /// Hardware error code
    /// 0 Normal
    /// 1 Accelerometer error
    /// 2 Heart rate error
    /// 3 TP error
    /// 4 Flash error
    @SerializedName("hw_error")
    var hwError: Int = hwError


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    