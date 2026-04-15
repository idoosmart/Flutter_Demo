//
//  IDOAppListStyleModel.kt
//  protocol_channel
//
//  Created by hc on 2025/12/04.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName
import java.io.Serializable

/**
 * Application list style parameter model (App sends to device)
 */
open class IDOAppListStyleParamModel(
    operate: Int,
    fontColor: Int = 0,
    name: String = "",
    wallpaperVersion: Int = 0
) : IDOBaseModel {
    /** Protocol version number */
    @SerializedName("version")
    private val version: Int = 0

    /** Operation type: 1:Set 2:Query 3:Delete */
    @SerializedName("operate")
    var operate: Int = operate

    /** Font color */
    @SerializedName("font_color")
    var fontColor: Int = fontColor

    /** Wallpaper name */
    @SerializedName("name")
    var name: String = name

    /** Wallpaper version */
    @SerializedName("wallpaper_version")
    var wallpaperVersion: Int = wallpaperVersion

    /** Reserved data (6 bytes) */
    @SerializedName("data")
    private val data: List<Int> = emptyList()

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this)
    }
}

/**
 * Application list wallpaper item
 */
open class IDOApplicationListItem(
    sortNumber: Int = 0,
    fontColor: Int = 0,
    size: Int = 0,
    name: String = "",
    wallpaperVersion: Int = 0
) : Serializable {
    /** Application list wallpaper sort number, starting from 0 */
    @SerializedName("sort_number")
    var sortNumber: Int = sortNumber

    /** Font color */
    @SerializedName("font_color")
    var fontColor: Int = fontColor

    /** Current application list wallpaper space usage, unit: byte */
    @SerializedName("size")
    var size: Int = size

    /** Wallpaper name */
    @SerializedName("name")
    var name: String = name

    /** Wallpaper version */
    @SerializedName("wallpaper_version")
    var wallpaperVersion: Int = wallpaperVersion

    /** Reserved data (5 bytes) */
    @SerializedName("data")
    private val data: List<Int> = emptyList()
}

/**
 * Application list style reply model (BLE device replies to app)
 */
open class IDOAppListStyleReplyModel(
    operate: Int = 0,
    errorCode: Int = 0,
    applicationListTotalNum: Int = 0,
    userApplicationListItemNum: Int = 0,
    applicationListCapacitySize: Int = 0,
    userApplicationListCapacitySize: Int = 0,
    listItems: List<IDOApplicationListItem>? = null
) : IDOBaseModel {
    /** Protocol version number */
    @SerializedName("version")
    private val version: Int = 4

    /** Operation type: 1:Set 2:Query 3:Delete */
    @SerializedName("operate")
    var operate: Int = operate

    /** Error code: 0:Success 1:Failure */
    @SerializedName("error_code")
    var errorCode: Int = errorCode

    /** Total number of application list wallpapers */
    @SerializedName("application_list_total_num")
    var applicationListTotalNum: Int = applicationListTotalNum

    /** Number of application list wallpapers already used, max 20 */
    @SerializedName("user_application_list_item_num")
    var userApplicationListItemNum: Int = userApplicationListItemNum

    /** Total capacity of application list wallpapers, unit: Byte */
    @SerializedName("application_list_capacity_size")
    var applicationListCapacitySize: Int = applicationListCapacitySize

    /** Used capacity of application list wallpapers, unit: Byte */
    @SerializedName("user_application_list_capacity_size")
    var userApplicationListCapacitySize: Int = userApplicationListCapacitySize

    /** Application list wallpaper items, controlled by used count, valid for query operation */
    @SerializedName("list_items")
    var listItems: List<IDOApplicationListItem>? = listItems

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this)
    }
}
