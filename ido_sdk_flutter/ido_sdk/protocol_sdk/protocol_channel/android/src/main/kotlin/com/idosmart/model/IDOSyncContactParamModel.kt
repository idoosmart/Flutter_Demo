//
//  IDOSyncContactParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.annotations.SerializedName

import com.google.gson.FieldNamingPolicy
import com.google.gson.GsonBuilder
import java.io.Serializable

///

// MARK: - IDOSyncContactParamModel

open class IDOSyncContactParamModel(operat: Int, items: List<IDOContactItem>) : IDOBaseModel {

    @SerializedName("version")
    private var version: Int = 0

    /// Operation
    /// 0: invalid
    /// 1: set contacts
    /// 2: query contacts
    /// 3: set emergency contacts (requires support for `getSupportSetGetEmergencyContactV3` in the menu)
    /// 4: query emergency contacts (requires support for `getSupportSetGetEmergencyContactV3` in the menu)
    @SerializedName("operat")
    var operat: Int = operat

    @SerializedName("items_num")
    private var itemsNum: Int = items.size

    @SerializedName("items")
    var items: List<IDOContactItem> = items

    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

// MARK: - IDOSyncContactModel
open class IDOSyncContactModel(errCode: Int, operat: Int?, items: List<IDOContactItem>?) :
    IDOBaseModel {
    @SerializedName("version")
    private var version: Int? = 2

    /// Error code, 0 for success, non-zero for error code
    @SerializedName("err_code")
    var errCode: Int = errCode

    /// Operation
    /// 0: invalid
    /// 1: set
    /// 2: query
    /// 3: set emergency contacts (requires support for `getSupportSetGetEmergencyContactV3` in the menu)
    /// 4: query emergency contacts (requires support for `getSupportSetGetEmergencyContactV3` in the menu)
    @SerializedName("operat")
    var operat: Int? = operat

    @SerializedName("items_num")
    private var itemsNum: Int? = items?.size

    @SerializedName("items")
    var items: List<IDOContactItem>? = items
    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }


}

// MARK: - IDOContactItem
open class IDOContactItem(phone: String, name: String) : Serializable {
    /// Contact phone number content, maximum of 14 bytes + '\0' line break
    @SerializedName("phone")
    var phone: String = phone

    /// Contact name content, maximum of 31 bytes + '\0' line break
    @SerializedName("name")
    var name: String = name

}
