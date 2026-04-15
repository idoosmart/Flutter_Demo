//
//  IDOActivitySwitchModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Get event number for activity switch

open class IDOActivitySwitchModel(
    errCode: Int,
    autoIdentifySportWalk: Int,
    autoIdentifySportRun: Int,
    autoIdentifySportBicycle: Int,
    autoPauseOnOff: Int,
    autoEndRemindOnOffOnOff: Int,
    autoIdentifySportElliptical: Int,
    autoIdentifySportRowing: Int,
    autoIdentifySportSwim: Int,
    autoIdentifySportSmartRope: Int
) : IDOBaseModel {

    /// 0 for success
    /// non-zero for error
    @SerializedName("err_code")
    var errCode: Int = errCode

    /// Auto identify walking switch: 0 for off, 1 for on, -1 for not supported
    @SerializedName("auto_identify_sport_walk")
    var autoIdentifySportWalk: Int = autoIdentifySportWalk

    /// Auto identify running switch: 0 for off, 1 for on, -1 for not supported
    @SerializedName("auto_identify_sport_run")
    var autoIdentifySportRun: Int = autoIdentifySportRun

    /// Auto identify cycling switch: 0 for off, 1 for on, -1 for not supported
    @SerializedName("auto_identify_sport_bicycle")
    var autoIdentifySportBicycle: Int = autoIdentifySportBicycle

    /// Auto pause switch: 0 for off, 1 for on, -1 for not supported
    @SerializedName("auto_pause_on_off")
    var autoPauseOnOff: Int = autoPauseOnOff

    /// End reminder switch: 0 for off, 1 for on, -1 for not supported
    @SerializedName("auto_end_remind_on_off_on_off")
    var autoEndRemindOnOffOnOff: Int = autoEndRemindOnOffOnOff

    /// Auto identify elliptical switch: 0 for off, 1 for on, -1 for not supported
    @SerializedName("auto_identify_sport_elliptical")
    var autoIdentifySportElliptical: Int = autoIdentifySportElliptical

    /// Auto identify rowing switch: 0 for off, 1 for on, -1 for not supported
    @SerializedName("auto_identify_sport_rowing")
    var autoIdentifySportRowing: Int = autoIdentifySportRowing

    /// Auto identify swimming switch: 0 for off, 1 for on, -1 for not supported
    @SerializedName("auto_identify_sport_swim")
    var autoIdentifySportSwim: Int = autoIdentifySportSwim

    /// Auto identify smart rope switch: 0 for off, 1 for on, -1 for not supported
    @SerializedName("auto_identify_sport_smart_rope")
    var autoIdentifySportSmartRope: Int = autoIdentifySportSmartRope




    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

open class IDOActivitySwitchParamModel(
    /// Automatic recognition of walking switch 0 off 1 on
    /// Function table: getAutoActivitySetGetUseNewStructExchange
    autoIdentifySportWalk: Int,
    /// Automatic recognition of running switch 0 off 1 on
    /// Function table: getAutoActivitySetGetUseNewStructExchange
    autoIdentifySportRun: Int,
    /// Automatically identify bicycle switch 0 off 1 on
    /// Function table: getAutoActivitySetGetUseNewStructExchange
    autoIdentifySportBicycle: Int,
    /// Motion auto-pause 0 off 1 on
    /// Function table: getAutoActivitySetGetUseNewStructExchange
    autoPauseOnOff: Int,
    /// End reminder 0 off 1 on
    /// Function table: getAutoActivitySetGetUseNewStructExchange
    autoEndRemindOnOffOnOff: Int,
    /// Automatically identify the elliptical machine switch 0 off 1 on
    /// Function table: getAutoActivitySetGetUseNewStructExchange
    autoIdentifySportElliptical: Int,
    /// Automatically identify rowing machine switch 0 off 1 on
    /// Function table: getAutoActivitySetGetUseNewStructExchange
    autoIdentifySportRowing: Int,
    /// Automatic recognition of swimming switch 0 off 1 on
    /// Function table: getAutoActivitySetGetUseNewStructExchange
    autoIdentifySportSwim: Int,
    /// Automatically identify smart rope skipping switch 0 off 1 on
    /// Function table: getAutoActivitySetGetUseNewStructExchange
    autoIdentifySportSmartRope: Int
) : IDOBaseModel {

    @SerializedName("auto_identify_sport_walk")
    var autoIdentifySportWalk: Int = autoIdentifySportWalk
    @SerializedName("auto_identify_sport_run")
    var autoIdentifySportRun: Int = autoIdentifySportRun
    @SerializedName("auto_identify_sport_bicycle")
    var autoIdentifySportBicycle: Int = autoIdentifySportBicycle
    @SerializedName("auto_pause_on_off")
    var autoPauseOnOff: Int = autoPauseOnOff
    @SerializedName("auto_end_remind_on_off_on_off")
    var autoEndRemindOnOffOnOff: Int = autoEndRemindOnOffOnOff
    @SerializedName("auto_identify_sport_elliptical")
    var autoIdentifySportElliptical: Int = autoIdentifySportElliptical
    @SerializedName("auto_identify_sport_rowing")
    var autoIdentifySportRowing: Int = autoIdentifySportRowing
    @SerializedName("auto_identify_sport_swim")
    var autoIdentifySportSwim: Int = autoIdentifySportSwim
    @SerializedName("auto_identify_sport_smart_rope")
    var autoIdentifySportSmartRope: Int = autoIdentifySportSmartRope



    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    