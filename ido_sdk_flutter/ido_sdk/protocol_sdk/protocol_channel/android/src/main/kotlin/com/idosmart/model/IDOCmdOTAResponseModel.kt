//
//  IDOBleVoiceParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// // MARK: - IDOCmdOTAResponseModel

open class IDOCmdOTAResponseModel(errFlag: Int) : IDOBaseModel {
    /// 0: 进入OTA成功
    /// 1: 失败：电量过低
    /// 2: 失败：设备不支持
    /// 3: 失败：参数不正确
    ///
    /// 0: Enter OTA successfully
    /// 1: Failure: Battery is too low
    /// 2: Failure: Device not supported
    /// 3: Failure: Incorrect parameters
    @SerializedName("err_flag")
    var errFlag: Int = errFlag

    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

}
    