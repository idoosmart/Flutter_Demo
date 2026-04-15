//
//  IDOBleBeepModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///

// MARK: - IDOBleBeepModel

open class IDOBleBeepModel(errCode: Int, items: List<IDOBleBeepItem>) :
    IDOBaseAdapterModel<IDOBleBeepModel> {
    @SerializedName("version")
    private var version: Int = 0
    @SerializedName("item_count")
    private var itemCount: Int = items.size

    /// Error code, 0 for success, non-zero for failure
    @SerializedName("err_code")
    var errCode: Int = errCode
    @SerializedName("item")
    var items: List<IDOBleBeepItem> = items


    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

// MARK: - IDOItem
open class IDOBleBeepItem(name: String) {
    @SerializedName("name")
    var name: String = name
}
