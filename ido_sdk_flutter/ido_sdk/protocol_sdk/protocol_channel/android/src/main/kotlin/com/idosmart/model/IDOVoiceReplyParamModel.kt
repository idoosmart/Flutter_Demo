//
//  IDOVoiceReplyParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///


open class IDOVoiceReplyParamModel(flagIsContinue: Int, title: String, textContent: String) :
    IDOBaseModel {

    @SerializedName("version")
    private var version: Int = 0

    /// Flag for continuing recording
    /// 0: Stop recording, 1: Continue recording
    @SerializedName("flag_is_continue")
    var flagIsContinue: Int = flagIsContinue

    /// Title data, maximum 31 bytes
    @SerializedName("title")
    var title: String = title

    /// Content data, maximum 511 bytes
    @SerializedName("text_content")
    var textContent: String = textContent


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    