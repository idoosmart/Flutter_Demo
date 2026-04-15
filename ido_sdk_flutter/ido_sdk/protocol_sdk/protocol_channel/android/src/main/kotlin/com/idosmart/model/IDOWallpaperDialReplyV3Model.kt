//
//  IDOWallpaperDialReplyV3Model.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Set wallpaper dial list event number

open class IDOWallpaperDialReplyV3Model(
    errCode: Int,
    operate: Int,
    location: Int,
    hideType: Int,
    timeColor: Int,
    widgetType: Int,
    widgetIconColor: Int,
    widgetNumColor: Int
) : IDOBaseModel {

    /// 0 for success, non-zero for failure
    @SerializedName("err_code")
    var errCode: Int = errCode

    /// Operation: 0 for query, 1 for setting, 2 for deleting the wallpaper dial
    @SerializedName("operate")
    var operate: Int = operate

    /// Set location information
    @SerializedName("location")
    var location: Int = location

    /// Hide type
    @SerializedName("hide_type")
    var hideType: Int = hideType

    /// Color of time control
    @SerializedName("time_color")
    var timeColor: Int = timeColor

    /// Control type
    @SerializedName("widget_type")
    var widgetType: Int = widgetType

    /// Color of widget icons (1 byte reserved + R (1 byte) + G (1 byte) + B (1 byte))
    @SerializedName("widget_icon_color")
    var widgetIconColor: Int = widgetIconColor

    /// Color of widget numbers (1 byte reserved + R (1 byte) + G (1 byte) + B (1 byte))
    @SerializedName("widget_num_color")
    var widgetNumColor: Int = widgetNumColor


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    