//
//  IDOWatchDialInfoModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///

// MARK: - IDOWatchDialInfoModel

open class IDOWatchDialInfoModel(
    blockSize: Int,
    familyName: String,
    format: Int,
    height: Int,
    sizex100: Int,
    width: Int
) : IDOBaseModel {

    /// Compression block size
    @SerializedName("block_size")
    var blockSize: Int = blockSize

    /// Family name (maximum 10 bytes)
    @SerializedName("family_name")
    var familyName: String = familyName

    /// Color format
    @SerializedName("format")
    var format: Int = format

    /// Screen height (pixel size)
    @SerializedName("height")
    var height: Int = height

    /// Size in 100x increments
    @SerializedName("sizex100")
    var sizex100: Int = sizex100

    /// Screen width (pixel size)
    @SerializedName("width")
    var width: Int = width

    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    