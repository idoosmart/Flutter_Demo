package com.idosmart.native_channel.siche

import com.idosmart.native_channel.NativeChannelPlugin
import com.idosmart.native_channel.pigeon_generate.api_sifli.ApiSifliFlutter
import com.idosmart.native_channel.pigeon_generate.api_sifli.OTAUpdateState
import com.idosmart.native_channel.siche.siche_interface.SicheToFlutterInterface

object SicheToFlutterImpl : SicheToFlutterInterface {

    private fun apiSifliFlutter(): ApiSifliFlutter? {
        return NativeChannelPlugin.instance().apiSifliFlutter
    }

    override fun updateManageState(
        stateArg: OTAUpdateState,
        descArg: String,
    ) {
        apiSifliFlutter()?.updateManageState(stateArg,descArg){
        }
    }

    override fun updateManagerProgress(
        progressArg: Double
    ) {
        apiSifliFlutter()?.updateManagerProgress(progressArg, ""){
        }
    }

    override fun log(logMsgArg: String) {
        apiSifliFlutter()?.log(logMsgArg){

        }
    }
}