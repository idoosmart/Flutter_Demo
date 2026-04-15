//
//  IDONoticeStatusModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get notification center status event number

open class IDONoticeStatusModel(
    notifySwitch: Int,
    callSwitch: Int,
    notifyItem1: Int,
    notifyItem2: Int,
    callDelay: Int,
    notifyItem3: Int,
    notifyItem4: Int,
    notifyItem5: Int,
    notifyItem6: Int,
    notifyItem7: Int,
    notifyItem8: Int,
    notifyItem9: Int,
    notifyItem10: Int,
    msgAllSwitch: Int,
    notifyItem11: Int,
    notifyItem12: Int
) : IDOBaseModel {

    /// Notification reminder switch
    /// 0: BLE switch off(Reserved,invalid function)
    /// 1: BLE switch on(Initiate pairing for IOS only)
    /// 2: Setting sub-switch
    /// 3: BT only (switch)
    /// 4: BLE and BT on (switch)
    /// -1: Invalid(Not Support)
    @SerializedName("notify_switch")
    var notifySwitch: Int = notifySwitch

    /// Incoming call reminder switch
    /// 1: On
    /// 0: Off
    /// -1: Invalid(Not Support)
    @SerializedName("call_switch")
    var callSwitch: Int = callSwitch

    /// Sub-app switch 1, each bit represents an app
    @SerializedName("notify_item1")
    var notifyItem1: Int = notifyItem1

    /// Sub-app switch 2, each bit represents an app
    @SerializedName("notify_item2")
    var notifyItem2: Int = notifyItem2

    /// Incoming call reminder delay in seconds
    @SerializedName("call_delay")
    var callDelay: Int = callDelay

    /// Sub-app switch 3, each bit represents an app
    @SerializedName("notify_item3")
    var notifyItem3: Int = notifyItem3

    /// Sub-app switch 4, each bit represents an app
    @SerializedName("notify_item4")
    var notifyItem4: Int = notifyItem4

    /// Sub-app switch 5, each bit represents an app
    @SerializedName("notify_item5")
    var notifyItem5: Int = notifyItem5

    /// Sub-app switch 6, each bit represents an app
    @SerializedName("notify_item6")
    var notifyItem6: Int = notifyItem6

    /// Sub-app switch 7, each bit represents an app
    @SerializedName("notify_item7")
    var notifyItem7: Int = notifyItem7

    /// Sub-app switch 8, each bit represents an app
    @SerializedName("notify_item8")
    var notifyItem8: Int = notifyItem8

    /// Sub-app switch 9, each bit represents an app
    @SerializedName("notify_item9")
    var notifyItem9: Int = notifyItem9

    /// Sub-app switch 10, each bit represents an app
    @SerializedName("notify_item10")
    var notifyItem10: Int = notifyItem10

    /// Message app total switch
    /// 1: On
    /// 0: Off
    /// -1: Invalid(Not Support)
    @SerializedName("msg_all_switch")
    var msgAllSwitch: Int = msgAllSwitch

    /// Sub-app switch 11, each bit represents an app
    @SerializedName("notify_item11")
    var notifyItem11: Int = notifyItem11

    /// Sub-app switch 12, each bit represents an app
    @SerializedName("notify_item12")
    var notifyItem12: Int = notifyItem12


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }

}
    