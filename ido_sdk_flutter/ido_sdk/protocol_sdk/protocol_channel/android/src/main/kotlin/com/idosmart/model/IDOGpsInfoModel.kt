//
//  IDOGpsInfoModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get GPS Information event number

open class IDOGpsInfoModel(
    errCode: Int,
    fwVersion: Int,
    agpsInfo: Int,
    agpsErrCode: Int,
    utcYear: Int,
    utcMonth: Int,
    utcDay: Int,
    utcHour: Int,
    utcMinute: Int,
    startMode: Int,
    gns: Int,
    fixStartBit: Int,
    fwVersionString: String
) : IDOBaseModel {

    /// GPS error code
    /// 0 - Normal, non-zero - Exceptional
    @SerializedName("err_code")
    var errCode: Int = errCode

    /// GPS firmware version
    @SerializedName("fw_version")
    var fwVersion: Int = fwVersion

    /// Validity period of AGPS (Assisted GPS)
    @SerializedName("agps_info")
    var agpsInfo: Int = agpsInfo

    /// AGPS error code
    @SerializedName("agps_err_code")
    var agpsErrCode: Int = agpsErrCode

    /// UTC year
    @SerializedName("utc_year")
    var utcYear: Int = utcYear

    /// UTC month
    @SerializedName("utc_month")
    var utcMonth: Int = utcMonth

    /// UTC day
    @SerializedName("utc_day")
    var utcDay: Int = utcDay

    /// UTC hour
    @SerializedName("utc_hour")
    var utcHour: Int = utcHour

    /// UTC minute
    @SerializedName("utc_minute")
    var utcMinute: Int = utcMinute

    /// Start mode
    /// 1 - Cold start
    /// 2 - Hot start
    @SerializedName("start_mode")
    var startMode: Int = startMode

    /// Positioning satellite selection
    /// 1 - GPS
    /// 2 - GLONASS
    /// 3 - GPS + GLONASS
    @SerializedName("gns")
    var gns: Int = gns

    /// Fix start bit
    /// Default 0, used for debugging
    @SerializedName("fix_start_bit")
    var fixStartBit: Int = fixStartBit

    @SerializedName("fw_version_str")
    var fwVersionString: String = fwVersionString


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}



open class IDOGpsHotStartParamModel(longitude: Int,
                                    latitude:Int,
                                    altitude: Int,
                                    tcxoOffset: Int) : IDOBaseModel {
    /**
     * 经度
     * 乘以1000,000传输
     */
    @SerializedName("longitude")
    var longitude: Int = longitude

    /**
     * 纬度
     * 乘以1000,000传输
     */
    @SerializedName("latitude")
    var latitude: Int = latitude


    /**
     * 高度
     * 乘以10传输
     */
    @SerializedName("altitude")
    var altitude: Int = altitude


    /**
     * 晶振偏移
     */
    @SerializedName("tcxo_offset")
    var tcxoOffset: Int = tcxoOffset

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    