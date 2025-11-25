package com.idosmart.native_channel.siche

import android.os.Handler
import android.os.Looper
import com.idosmart.native_channel.pigeon_generate.api_sifli.ApiSifliHost
import com.idosmart.native_channel.pigeon_generate.api_sifli.IDOSFBoardType
import com.idosmart.native_channel.siche.ota.SicheDFUManager
import com.sifli.ezipaidu.sifliEzipUtil
import java.util.ArrayList

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

    override fun sifliEBinFromPngs(
        pngDatas: List<ByteArray>,
        eColor: String,
        type: Long,
        binType: Long,
        boardType: IDOSFBoardType
    ): ByteArray? {
        return sifliEzipUtil.pngToEzipSequence(pngDatas as ArrayList<ByteArray>?, eColor, type.toInt(), binType.toInt(), boardType.raw)
    }

    override fun asyncSifliEBinFromPngs(
        pngDatas: List<ByteArray>,
        eColor: String,
        type: Long,
        binType: Long,
        boardType: IDOSFBoardType,
        isGif: Boolean,
        callback: (Result<ByteArray?>) -> Unit
    ) {
        val thread = Thread {
            var rs: ByteArray? = null
            rs = if (isGif) {
                sifliEzipUtil.pngToEzipSequence(
                    pngDatas as ArrayList<ByteArray>?,
                    eColor,
                    type.toInt(),
                    binType.toInt(),
                    boardType.raw
                )
            } else {
                sifliEzipUtil.pngToEzip(pngDatas.first(), eColor, type.toInt(), binType.toInt(), boardType.raw)
            }

            Handler(Looper.getMainLooper()).post {
                callback(Result.success(rs))
            }
        }
        thread.start()
    }


    override fun checkOtaDoing(callback: (Result<Boolean>) -> Unit) {
        callback(Result.success(SicheDFUManager.getManager().isUpdate))
    }

}