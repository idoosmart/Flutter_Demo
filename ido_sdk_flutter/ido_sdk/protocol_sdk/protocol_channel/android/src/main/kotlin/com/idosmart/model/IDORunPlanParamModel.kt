//
//  IDORunPlanParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import java.io.Serializable
import com.google.gson.annotations.SerializedName

///


open class IDORunPlanParamModel(
    operate: Int,
    type: Int,
    year: Int,
    month: Int,
    day: Int,
    hour: Int,
    min: Int,
    sec: Int,
    dayNum: Int,
    items: List<IDOGpsInfoModelItem>
) : IDOBaseModel {

    /// Protocol library version number
    @SerializedName("verison")
    var verison: Int = 1

    /// Operation
    /// 1: Start plan
    /// 2: Plan data sent
    /// 3: End plan
    /// 4: Query running plan
    @SerializedName("operate")
    var operate: Int = operate

    /// Plan type
    /// 1: 3km running plan
    /// 2: 5km running plan
    /// 3: 10km running plan
    /// 4: Half marathon training (Phase 2)
    /// 5: Marathon training (Phase 2)
    @SerializedName("type")
    var type: Int = type

    @SerializedName("year")
    var year: Int = year

    @SerializedName("month")
    var month: Int = month

    @SerializedName("day")
    var day: Int = day

    @SerializedName("hour")
    var hour: Int = hour

    @SerializedName("min")
    var min: Int = min

    @SerializedName("sec")
    var sec: Int = sec

    /// Number of plan days
    /// Applicable when operate is 2
    @SerializedName("day_num")
    var dayNum: Int = dayNum

    @SerializedName("items")
    var items: List<IDOGpsInfoModelItem> = items


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

// MARK: - IDOGpsInfoModelItem

open class IDOGpsInfoModelItem(type: Int, num: Int, items: List<IDOItemItem>) : Serializable {
    /// Training type
    /// 186: Rest plan
    /// 187: Outdoor running plan
    /// 188: Indoor running plan
    /// 189: Indoor fitness plan
    @SerializedName("type")
    var type: Int = type

    /// Number of actions
    /// Note: The number of actions is zero when resting, and non-zero for other actions
    @SerializedName("num")
    var num: Int = num

    @SerializedName("item")
    var items: List<IDOItemItem> = items
}

// MARK: - IDOItemItem

open class IDOItemItem(type: Int, time: Int, heightHeart: Int, lowHeart: Int) : Serializable {
    /// Action type
    /// 1: Fast walk
    /// 2: Jog
    /// 3: Moderate run
    /// 4: Fast run
    @SerializedName("type")
    var type: Int = type

    /// Target time Unit: seconds
    @SerializedName("time")
    var time: Int = time

    /// Low heart rate range
    @SerializedName("height_heart")
    var heightHeart: Int = heightHeart

    /// High heart rate range
    @SerializedName("low_heart")
    var lowHeart: Int = lowHeart

}
