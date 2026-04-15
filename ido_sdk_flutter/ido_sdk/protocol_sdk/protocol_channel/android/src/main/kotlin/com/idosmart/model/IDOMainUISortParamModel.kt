//
//  IDOMainUISortParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.FieldNamingPolicy
import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

// MARK: - IDOMainUISortParamModel

open class IDOMainUISortParamModel(
    operate: Int,
    items: List<Int>,
    locationX: Int,
    locationY: Int,
    sizeType: Int,
    widgetsType: Int
) : IDOBaseModel {

    @SerializedName("version")
    private var version: Int = 0

    /// Operation
    /// 0: Invalid 1: Query 2: Set
    @SerializedName("operate")
    var operate: Int = operate
    @SerializedName("all_num")
    private var allNum: Int = items.size

    @SerializedName("items")
    var items: List<Int> = items

    /// Coordinate x-axis, starting from 1
    @SerializedName("location_x")
    var locationX: Int = locationX

    /// Coordinate y-axis, starting from 1
    /// One y-axis represents a horizontal grid
    @SerializedName("location_y")
    var locationY: Int = locationY

    /// 0: Invalid 1: Large icon 2: Small icon
    @SerializedName("size_type")
    var sizeType: Int = sizeType

    /// Types of controls
    /// 0: Invalid
    /// 1: Week/Date
    /// 2: Steps
    /// 3: Distance
    /// 4: Calories
    /// 5: Heart Rate
    /// 6: Battery
    @SerializedName("widgets_type")
    var widgetsType: Int = widgetsType


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


open class IDOMainUISortModel(
    errCode: Int, operate: Int, allNum: Int,
    supportItems: List<IDOMainUISortSupportItem>,
    items: List<IDOMainUISortItem>, locationX: Int,
    locationY: Int, sizeType: Int, widgetsType: Int
) : IDOBaseModel {

    @SerializedName("version")
    private var version: Int = 0

    /// 0: Success, Non-zero: Failure
    @SerializedName("err_code")
    var errCode: Int = errCode

    /// Operation
    /// 0: Invalid 1: Query 2: Set
    @SerializedName("operate")
    var operate: Int = operate

    /// Number of currently displayed list in firmware
    @SerializedName("all_num")
    var allNum: Int = allNum

    @SerializedName("support_items")
    var supportItems: List<IDOMainUISortSupportItem> = supportItems

    @SerializedName("items")
    var items: List<IDOMainUISortItem> = items;

    @SerializedName("location_x")
    var locationX: Int = locationX

    @SerializedName("location_y")
    var locationY: Int = locationY

    @SerializedName("size_type")
    var sizeType: Int = sizeType

    @SerializedName("widgets_type")
    var widgetsType: Int = widgetsType
    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }


}

// MARK: - IDOMainUISortItem
open class IDOMainUISortItem(
    locationX: Int, locationY: Int,
    sizeType: Int, widgetsType: Int, supportSizeType: Int
) {
    /// Coordinate x-axis, starting from 1
    @SerializedName("location_x")
    var locationX: Int = locationX

    /// Coordinate y-axis, starting from 1
    /// One y-axis represents a horizontal grid
    @SerializedName("location_y")
    var locationY: Int = locationY

    /// 0: Invalid 1: Large icon 2: Small icon
    @SerializedName("size_type")
    var sizeType: Int = sizeType

    /// Types of controls
    /// ```
    /// 0: Invalid
    /// 1: Week/Date
    /// 2: Steps
    /// 3: Distance
    /// 4: Calories
    /// 5: Heart Rate
    /// 6: Battery
    /// ```
    @SerializedName("widgets_type")
    var widgetsType: Int = widgetsType

    /// Editable icon types supported by the firmware
    /// ```
    /// 0: Invalid
    /// 1: Large icon
    /// 2: Small icon
    /// 3: Large icon + Small icon
    /// ```
    @SerializedName("support_size_type")
    var supportSizeType: Int = supportSizeType

}

// MARK: - IDOMainUISortSupportItem
open class IDOMainUISortSupportItem(supportSizeType: Int, widgetsType: Int) {
    /// Types of controls
    /// ```
    /// 0: Invalid
    /// 1: Week/Date
    /// 2: Steps
    /// 3: Distance
    /// 4: Calories
    /// 5: Heart Rate
    /// 6: Battery
    /// ```
    @SerializedName("widgets_type")
    var widgetsType: Int = widgetsType

    /// Editable icon types supported by the firmware
    /// ```
    /// 0: Invalid
    /// 1: Large icon
    /// 2: Small icon
    /// 3: Large icon + Small icon
    /// ```
    @SerializedName("support_size_type")
    var supportSizeType: Int = supportSizeType

}
