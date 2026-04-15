package com.idosmart.pigeon_implement

import com.idosmart.pigeon_implement.IDOEpoManagerDelegate
import com.idosmart.pigeon_implement.IDOEpoUpgradeStatus
import com.idosmart.pigeongen.api_epo.ApiEpoManagerDelegate
import com.idosmart.pigeongen.api_epo.ApiEpoUpgradeStatus
import com.idosmart.pigeongen.api_epo.ApiOTAGpsInfo


internal class EpoManagerDelegateImpl : ApiEpoManagerDelegate {

    companion object {
        @Volatile
        private var instance: EpoManagerDelegateImpl? = null
        fun instance(): EpoManagerDelegateImpl {
            return instance ?: synchronized(this) {
                instance ?: EpoManagerDelegateImpl().also { instance = it }
            }
        }
    }

    private constructor()

    var delegateGps: IDOEpoManagerDelegate? = null
    var upgradeStatus: IDOEpoUpgradeStatus = IDOEpoUpgradeStatus.IDLE

    var callbackUpgradeStatus: ((IDOEpoUpgradeStatus) -> Unit)? = null
    var callbackDownProgress: ((Float) -> Unit)? = null
    var callbackSendProgress: ((Float) -> Unit)? = null
    var callbackComplete: ((Int) -> Unit)? = null

    override fun onEpoStatusChanged(status: ApiEpoUpgradeStatus) {
        upgradeStatus = IDOEpoUpgradeStatus.ofRaw(status.raw)!!
        callbackUpgradeStatus?.invoke(upgradeStatus)
    }

    override fun onEpoDownloadProgress(progress: Double) {
        callbackDownProgress?.invoke(progress.toFloat())
    }

    override fun onEpoSendProgress(progress: Double) {
        callbackSendProgress?.invoke(progress.toFloat())
    }

    override fun onEpoComplete(errorCode: Long) {
        callbackComplete?.invoke(errorCode.toInt())
    }

    override fun onGetGps(callback: (Result<ApiOTAGpsInfo?>) -> Unit) {
        val gpsInfo = delegateGps?.getAppGpsInfo()
        if (gpsInfo != null) {
            val rs = ApiOTAGpsInfo(
                tcxoOffset = 0,
                longitude = gpsInfo.longitude.toDouble(),
                latitude = gpsInfo.latitude.toDouble(),
                altitude = gpsInfo.altitude.toDouble()
            )
            callback(Result.success(rs))
        } else {
            callback(Result.success(null))
        }
    }


}

