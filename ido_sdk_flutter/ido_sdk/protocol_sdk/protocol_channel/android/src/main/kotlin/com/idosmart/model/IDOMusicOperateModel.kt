//
//  IDOMusicOperateModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Operation for songs or folders event

open class IDOMusicOperateModel(operateType: Int, version: Int, errCode: Int, musicId: Int?) :
    IDOBaseModel {

    /// Operation type:
    /// 0: Invalid operation
    /// 1: Delete music
    /// 2: Add music
    /// 3: Delete folder
    /// 4: Add folder
    /// 5: Modify playlist
    /// 6: Import playlist
    /// 7: Delete music in playlist
    @SerializedName("operate_type")
    var operateType: Int = operateType

    /// Firmware SDK card information
    /// Total space
    @SerializedName("version")
    var version: Int = version

    /// 0: Successful; non-zero: Failed
    @SerializedName("err_code")
    var errCode: Int = errCode

    /// Music id returned when adding music successfully
    @SerializedName("music_id")
    var musicId: Int? = musicId

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    