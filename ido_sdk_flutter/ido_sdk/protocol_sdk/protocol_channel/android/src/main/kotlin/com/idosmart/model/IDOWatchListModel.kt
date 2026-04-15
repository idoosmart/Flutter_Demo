//
//  IDOWatchListModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///

// MARK: - IDOWatchListModel

open class IDOWatchListModel(
    localWatchNum: Int,
    cloudWatchNum: Int,
    wallpaperWatchNum: Int,
    userCloudWatchNum: Int,
    userWallpaperWatchNum: Int,
    nowShowWatchName: String,
    watchFrameMainVersion: Int,
    fileMaxSize: Int,
    watchCapacitySize: Int,
    userWatchCapacitySize: Int,
    usableMaxDownloadSpaceSize: Int,
    items: List<IDOWatchItem>
) : IDOBaseAdapterModel<IDOWatchListModel> {

    /// Total number of local watch faces
    @SerializedName("local_watch_num")
    var localWatchNum: Int = localWatchNum

    /// Total number of cloud watch faces
    @SerializedName("cloud_watch_num")
    var cloudWatchNum: Int = cloudWatchNum

    /// Total number of wallpaper watch faces
    @SerializedName("wallpaper_watch_num")
    var wallpaperWatchNum: Int = wallpaperWatchNum

    /// Number of cloud watch faces used
    @SerializedName("user_cloud_watch_num")
    var userCloudWatchNum: Int = userCloudWatchNum

    /// Number of wallpaper watch faces used
    @SerializedName("user_wallpaper_watch_num")
    var userWallpaperWatchNum: Int = userWallpaperWatchNum

    /// ID of the currently displayed watch face, maximum 30 bytes
    @SerializedName("now_show_watch_name")
    var nowShowWatchName: String = nowShowWatchName

    /// Framework version number, starting from 1
    @SerializedName("watch_frame_main_version")
    var watchFrameMainVersion: Int = watchFrameMainVersion

    /// Maximum size of a single file, in kilobytes(reserve)
    @SerializedName("file_max_size")
    var fileMaxSize: Int = fileMaxSize
    @SerializedName("list_item_numb")
    private var listItemNumb: Int = items.size

    /// Total capacity of watch faces
    /// Uint:Byte
    /// Set to 0 if the firmware enables `setWatchCapacitySizeDisplay`
    @SerializedName("watch_capacity_size")
    var watchCapacitySize: Int = watchCapacitySize

    /// Used capacity of watch faces
    /// Uint:Byte
    /// Set to 0 if the firmware enables `setWatchCapacitySizeDisplay`
    @SerializedName("user_watch_capacity_size")
    var userWatchCapacitySize: Int = userWatchCapacitySize

    /// Maximum continuous space available for downloading watch faces
    /// Uint:Byte
    /// Set to 0 if the firmware enables `setWatchCapacitySizeDisplay`
    @SerializedName("usable_max_download_space_size")
    var usableMaxDownloadSpaceSize: Int = usableMaxDownloadSpaceSize

    @SerializedName("item")
    var items: List<IDOWatchItem> = items


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

// MARK: - IDOWatchItem
open class IDOWatchItem(type: Int, watchVersion: Int, sortNumber: Int, name: String, size: Int) {
    /// Watch face type
    /// 1: Normal watch face
    /// 2: Wallpaper watch face
    /// 3: Cloud watch face
    @SerializedName("type")
    var type: Int = type

    /// Current version number of the watch face (applies to cloud watch faces)
    @SerializedName("watch_version")
    var watchVersion: Int = watchVersion

    /// Watch face order number
    /// Start at 0
    @SerializedName("sort_number")
    var sortNumber: Int = sortNumber

    /// Watch face name
    @SerializedName("name")
    var name: String = name

    /// Size of the watch face, in bytes
    /// Applies only if the firmware enables `v3SupportGetWatchSize`, otherwise the field is invalid
    @SerializedName("size")
    var size: Int = size

}

// MARK: - IDOWatchListV2Model
open class IDOWatchListV2Model(
    availableCount: Int,
    fileMaxSize: Int,
    items: List<IDOWatchListV2Item>
) : IDOBaseAdapterModel<IDOWatchListV2Model> {
    @SerializedName("version")
    private var version: Int = 0

    /// Number of remaining available files
    @SerializedName("available_count")
    var availableCount: Int = availableCount

    /// Maximum size of a single file (in KB)
    @SerializedName("file_max_size")
    var fileMaxSize: Int = fileMaxSize

    @SerializedName("item")
    var items: List<IDOWatchListV2Item> = items

    
}

// MARK: - IDOWatchListV2Item
open class IDOWatchListV2Item(fileName: String) {
    @SerializedName("file_name")
    var fileName: String = fileName

}
