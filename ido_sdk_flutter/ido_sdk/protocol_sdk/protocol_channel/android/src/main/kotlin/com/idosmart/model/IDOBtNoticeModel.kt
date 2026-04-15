//
//  IDOBtNoticeModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Query BT pairing switch, connection, A2DP connection, HFP connection status (Only Supported on devices with BT Bluetooth) event number

open class IDOBtNoticeModel(
    btConnectStates: Int,
    btPairStates: Int,
    a2dpConnectStates: Int,
    hfpConnectStates: Int
) : IDOBaseModel {

    /// 1: BT connection status on
    /// 0: BT connection status off
    /// -1: Invalid
    @SerializedName("bt_connect_states")
    var btConnectStates: Int = btConnectStates

    /// 1: BT pairing status on
    /// 0: BT pairing status off
    /// -1: Invalid
    @SerializedName("bt_pair_states")
    var btPairStates: Int = btPairStates

    /// 1: A2DP connection status on
    /// 0: A2DP connection status off
    /// -1: Invalid
    @SerializedName("a2dp_connect_states")
    var a2dpConnectStates: Int = a2dpConnectStates

    /// 1: HFP connection status on
    /// 0: HFP connection status off
    /// -1: Invalid
    @SerializedName("hfp_connect_states")
    var hfpConnectStates: Int = hfpConnectStates


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    