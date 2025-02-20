package com.idosmart.native_channel.siche

import com.idosmart.native_channel.pigeon_generate.api_sifli.ApiSifliHost
import com.idosmart.native_channel.pigeon_generate.api_sifli.IDOSFBoardType
import com.idosmart.native_channel.siche.ota.SicheDFUManager
import com.sifli.ezipaidu.sifliEzipUtil

class SicheApiHostImpl : ApiSifliHost {
    /**
     * 思澈升级 deviceUUID ,android 端 传mac
     */
    override fun startOTA(files: List<Any?>, deviceUUID: String) {
        SicheDFUManager.getManager().start(files as MutableList<String>?,deviceUUID)
    }

    override fun startOTANor(
        files: List<Any?>,
        deviceUUID: String,
        platform: Long,
        isIndfu: Boolean
    ) {
        SicheDFUManager.getManager().start(files as MutableList<String>?,deviceUUID,
            platform.toInt(),isIndfu)
    }

    override fun stop() {
        SicheDFUManager.getManager().stop()
    }


    override fun sifliEBinFromPng(
        pngDatas: ByteArray,
        eColor: String,
        type: Long,
        binType: Long,
        boardType: IDOSFBoardType
    ): ByteArray? {
        return sifliEzipUtil.pngToEzip(pngDatas, eColor, type.toInt(), binType.toInt(), boardType.raw)
    }
}