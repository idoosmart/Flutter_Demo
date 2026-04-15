//
//  IDOMtuInfoModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get MTU Information event number

open class IDOMtuInfoModel(status: Int, rxMtu: Int, txMtu: Int, phySpeed: Int, dleLength: Int) :
    IDOBaseModel {

    /// 0: Data is valid
    /// 1: Data is invalid, wait a while and try again. In case of invalid data, MTU is 20.
    @SerializedName("status")
    var status: Int = status

    /// MTU for app receiving data
    @SerializedName("rx_mtu")
    var rxMtu: Int = rxMtu

    /// MTU for app sending data
    @SerializedName("tx_mtu")
    var txMtu: Int = txMtu

    /// Physical layer speed
    /// 0: Invalid
    /// 1000: 1M
    /// 2000: 2M
    /// 512: 512K
    @SerializedName("phy_speed")
    var phySpeed: Int = phySpeed

    /// DLE length
    /// 0: Not supported
    @SerializedName("dle_length")
    var dleLength: Int = dleLength

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}



open class IDOSppMtuModel(errCode: Int, mtu: Int, checkCode: Int = 0) :
    IDOBaseModel {

    @SerializedName("err_code")
    var errCode: Int = errCode

    /// 获取固件mtu值，回复的数据如果是非0 ，那么就使用固件的prn数据传输
    @SerializedName("mtu")
    var mtu: Int = mtu

    /// 预留
    @SerializedName("check_code")
    var checkCode: Int = checkCode

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
