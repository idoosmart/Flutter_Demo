//
//  IDOBpCalControlModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///

// MARK: - IDOBpCalControlModel

open class IDOBpCalControlModel(
    errorCode: Int,
    operate: Int,
    sbpPpgFeatureNum: Int,
    dbpPpgFeatureNum: Int,
    sbpPpgFeatureItems: List<Int>,
    dbpPpgFeatureItems: List<Int>
) : IDOBaseModel {

    /// Error code: 0 for success, non-zero for failure
    @SerializedName("error_code")
    var errorCode: Int = errorCode

    /// Operation
    /// ```
    /// 0: Invalid
    /// 1: Start blood pressure calibration
    /// 2: Stop blood pressure calibration
    /// 3: Get feature vector
    /// ```
    @SerializedName("operate")
    var operate: Int = operate

    /// Number of high blood pressure PPG feature vectors
    /// Valid when operate=3
    @SerializedName("sbp_ppg_feature_num")
    var sbpPpgFeatureNum: Int = sbpPpgFeatureNum

    /// Number of low blood pressure PPG feature vectors
    /// Valid when operate=3
    @SerializedName("dbp_ppg_feature_num")
    var dbpPpgFeatureNum: Int = dbpPpgFeatureNum

    /// Array of high blood pressure PPG feature vectors
    /// Valid when operate=3
    @SerializedName("sbp_ppg_feature_items")
    var sbpPpgFeatureItems: List<Int> = sbpPpgFeatureItems

    /// Array of low blood pressure PPG feature vectors
    /// Valid when operate=3
    @SerializedName("dbp_ppg_feature_items")
    var dbpPpgFeatureItems: List<Int> = dbpPpgFeatureItems




    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    