//
//  IDOMusicOpearteParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import java.io.Serializable
import com.google.gson.annotations.SerializedName

///

// MARK: - IDOMusicOpearteParamModel

open class IDOMusicOpearteParamModel(
    musicOperate: Int,
    folderOperate: Int,
    folderItems: IDOMusicFolderItem?,
    musicItems: IDOMusicItem?,
) : IDOBaseModel {

    @SerializedName("version")
    private var version: Int = 1

    /// Music operation
    /// 0: Invalid operation
    /// 1: Delete music
    /// 2: Add music
    @SerializedName("music_operate")
    var musicOperate: Int = musicOperate

    /// Folder (playlist) operation
    /// 0: Invalid operation
    /// 1: Delete folder
    /// 2: Add folder
    /// 3: Modify playlist
    /// 4: Import playlist
    /// 5: Delete music
    @SerializedName("folder_operate")
    var folderOperate: Int = folderOperate

    /// Folder (playlist) details
    @SerializedName("folder_items")
    var folderItems: IDOMusicFolderItem? = folderItems

    /// Music details
    @SerializedName("music_items")
    var musicItems: IDOMusicItem? = musicItems

    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

// MARK: - IDOMusicInfoModel
open class IDOMusicInfoModel(
    allMemory: Int,
    folderItems: List<IDOMusicFolderItem>?,
    musicItems: List<IDOMusicItem>?,
    usedMemory: Int,
    usefulMemory: Int
) : IDOBaseModel {
    /// Firmware SDK card information<br />Total space<br />Uint:Byte
    @SerializedName("all_memory")
    var allMemory: Int = allMemory

    @SerializedName("folder_items")
    var folderItems: List<IDOMusicFolderItem>? = folderItems

    @SerializedName("folder_num")
    private var folderNum: Int = folderItems?.size ?: 0

    @SerializedName("music_items")
    var musicItems: List<IDOMusicItem>? = musicItems

    @SerializedName("music_num")
    private var musicNum: Int = musicItems?.size ?: 0

    /// Firmware SDK card information<br />Current used space in bytes<br />Uint:Byte
    @SerializedName("used_memory")
    var usedMemory: Int = usedMemory

    /// Firmware SDK card information<br />Available space<br />Uint:Byte
    @SerializedName("useful_memory")
    var usefulMemory: Int = usefulMemory

    @SerializedName("version")
    private var version: Int = 0
    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }


}


// MARK: - IDOMusicOpearteFolderItem
open class IDOMusicFolderItem(
    folderId: Int,
    musicNum: Int,
    folderName: String,
    musicIndex: List<Int>
) : Serializable {
    /// Playlist (folder) id, ranging from 1 to 10
    @SerializedName("folder_id")
    var folderId: Int = folderId

    /// Number of songs in the playlist, maximum of 100
    @SerializedName("music_num")
    var musicNum: Int = musicNum

    /// Playlist (folder) name, maximum of 19 bytes
    @SerializedName("folder_name")
    var folderName: String = folderName

    /// Corresponding song ids in the playlist, arranged in order of addition
    @SerializedName("music_index")
    var musicIndex: List<Int> = musicIndex

}

// MARK: - IDOMusicOpearteMusicItem
open class IDOMusicItem(musicId: Int, musicMemory: Int, musicName: String, singerName: String) :
    Serializable {
    /// Music id, starting from 1
    @SerializedName("music_id")
    var musicId: Int = musicId

    /// Space occupied by the music
    @SerializedName("music_memory")
    var musicMemory: Int = musicMemory

    /// Music name, maximum of 44 bytes
    @SerializedName("music_name")
    var musicName: String = musicName

    /// Singer name, maximum of 29 bytes
    @SerializedName("singer_name")
    var singerName: String = singerName

}
