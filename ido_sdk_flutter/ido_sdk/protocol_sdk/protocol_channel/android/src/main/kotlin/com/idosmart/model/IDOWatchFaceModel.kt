//
//  IDOWatchFaceModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///

// MARK: - IDOWatchFaceModel

open class IDOWatchFaceModel(errCode: Int, operate: Int?, fileName: List<String>?, fileCount: Int?) :
    IDOBaseModel {

    /// Error code, 0 for success, non-zero for error
    @SerializedName("err_code")
    var errCode: Int = errCode

    /// Operation:<br />0 - Query the currently used watch face<br />1 - Set watch face<br />2 - Delete watch face<br />3 - Dynamic request space to set the corresponding space size
    @SerializedName("operate")
    var operate: Int? = operate

    @SerializedName("file_name")
    /// Watch face name, maximum 29 bytes
    private var fileName: List<String>? = fileName

    /// Number of files<br /><br />Requires the firmware to enable the function table `v3WatchDailSetAddSize`
    /// If operate!=3, this data is the same as before, which is 1 and is saved as before
    /// If operate=3: dynamic request space to set the corresponding space size, this corresponds to a deleted file name column
    /// If `v3WatchDailSetAddSize` is not enabled, this field defaults to 1
    @SerializedName("file_count")
    var fileCount: Int? = fileCount

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

// MARK: - IDOWatchFaceParamModel
open class IDOWatchFaceParamModel(operate: Int, fileName: String, watchFileSize: Int) :
    IDOBaseModel {
    /// Operation:
    /// ```
    /// 0 - Query the currently used watch face
    /// 1 - Set watch face
    /// 2 - Delete watch face
    /// 3 - Dynamic request space to set the corresponding space size
    /// ```
    @SerializedName("operate")
    var operate: Int = operate

    /// Watch face name, maximum 29 bytes
    @SerializedName("file_name")
    var fileNames: String = fileName

    /// Uncompressed file length
    /// After the firmware opens the function table `v3WatchDailSetAddSize`, the app needs to send this field
    /// Before the watch face is transmitted, the firmware needs to allocate corresponding space to save it, and the uncompressed file length needs to be transmitted
    @SerializedName("watch_file_size")
    var watchFileSize: Int = watchFileSize
    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }


}
