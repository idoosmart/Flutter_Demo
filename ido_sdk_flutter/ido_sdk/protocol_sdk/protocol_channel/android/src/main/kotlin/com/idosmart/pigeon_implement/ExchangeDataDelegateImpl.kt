package com.idosmart.pigeon_implement

import com.google.gson.Gson
import com.idosmart.enums.IDOExchangeStatus
import com.idosmart.model.*
import com.idosmart.pigeongen.api_data_exchange.*
import com.idosmart.protocol_sdk.IDOExchangeDataDelegate

internal class ExchangeDataDelegateImpl: ApiExchangeDataDelegate {

    companion object {
        @Volatile
        private var instance: ExchangeDataDelegateImpl? = null
        fun instance(): ExchangeDataDelegateImpl {
            return instance ?: synchronized(this) {
                instance ?: ExchangeDataDelegateImpl().also { instance = it }
            }
        }
    }

    private var delegate: IDOExchangeDataDelegate? = null

    fun addDelegate(api: IDOExchangeDataDelegate?) {
        delegate = api
    }

    var exchangeStatus: IDOExchangeStatus = IDOExchangeStatus.INITIAL

    override fun listenExchangeState(status: ApiExchangeStatus) {
        exchangeStatus = IDOExchangeStatus.ofRaw(status.raw) ?: IDOExchangeStatus.INITIAL
    }

    override fun listenBleResponse(response: Any) {
        val gosn = Gson()
        val json = gosn.toJson(response).toString()
        if (response is BleStartExchangeModel) {
            val model = gosn.fromJson(json, IDOBleStartExchangeModel::class.java)
            delegate?.appListenBleExec(IDOBleExecType.bleStart(model))
        }else if (response is BleIngExchangeModel) {
            val model = gosn.fromJson(json, IDOBleIngExchangeModel::class.java)
            delegate?.appListenBleExec(IDOBleExecType.bleIng(model))
        }else if (response is BleEndExchangeModel) {
            val model = gosn.fromJson(json, IDOBleEndExchangeModel::class.java)
            delegate?.appListenBleExec(IDOBleExecType.bleEnd(model))
        }else if (response is BlePauseExchangeModel) {
            val model = gosn.fromJson(json, IDOBlePauseExchangeModel::class.java)
            delegate?.appListenBleExec(IDOBleExecType.blePause(model))
        }else if (response is BleRestoreExchangeModel) {
            val model = gosn.fromJson(json, IDOBleRestoreExchangeModel::class.java)
            delegate?.appListenBleExec(IDOBleExecType.bleRestore(model))
        }else if (response is BleOperatePlanExchangeModel) {
            val model = gosn.fromJson(json, IDOBleOperatePlanExchangeModel::class.java)
            delegate?.appListenBleExec(IDOBleExecType.bleOperatePlan(model))
        }else if (response is AppBlePauseExchangeModel) {
            val model = gosn.fromJson(json, IDOAppBlePauseExchangeModel::class.java)
            delegate?.appListenBleExec(IDOBleExecType.appBlePause(model))
        }else if (response is AppBleRestoreExchangeModel) {
            val model = gosn.fromJson(json, IDOAppBleRestoreExchangeModel::class.java)
            delegate?.appListenBleExec(IDOBleExecType.appBleRestore(model))
        }else if (response is AppBleEndExchangeModel) {
            val model = gosn.fromJson(json, IDOAppBleEndExchangeModel::class.java)
            delegate?.appListenBleExec(IDOBleExecType.appBleEnd(model))
        }else if (response is AppStartReplyExchangeModel) {
            val model = gosn.fromJson(json,IDOAppStartReplyExchangeModel::class.java)
            delegate?.appListenAppExec(IDOBleReplyType.appStartReply(model))
        }else if (response is AppEndReplyExchangeModel) {
            val model = gosn.fromJson(json,IDOAppEndReplyExchangeModel::class.java)
            delegate?.appListenAppExec(IDOBleReplyType.appEndReply(model))
        }else if (response is AppIngReplyExchangeModel) {
            val model = gosn.fromJson(json,IDOAppIngReplyExchangeModel::class.java)
            delegate?.appListenAppExec(IDOBleReplyType.appIngReply(model))
        }else if (response is AppPauseReplyExchangeModel) {
            val model = gosn.fromJson(json,IDOAppPauseReplyExchangeModel::class.java)
            delegate?.appListenAppExec(IDOBleReplyType.appPauseReply(model))
        }else if (response is AppRestoreReplyExchangeModel) {
            val model = gosn.fromJson(json,IDOAppRestoreReplyExchangeModel::class.java)
            delegate?.appListenAppExec(IDOBleReplyType.appRestoreReply(model))
        }else if (response is AppIngV3ReplyExchangeModel) {
            val model = gosn.fromJson(json,IDOAppIngV3ReplyExchangeModel::class.java)
            delegate?.appListenAppExec(IDOBleReplyType.appIngV3Reply(model))
        }else if (response is AppOperatePlanReplyExchangeModel) {
            val model = gosn.fromJson(json,IDOAppOperatePlanReplyExchangeModel::class.java)
            delegate?.appListenAppExec(IDOBleReplyType.appOperatePlanReply(model))
        }else if (response is ApiAppGpsDataExchangeModel) {
            val model = gosn.fromJson(json,IDOAppGpsDataExchangeModel::class.java)
            delegate?.appListenAppExec(IDOBleReplyType.appActivityGpsReply(model))
        }else if (response is AppActivityDataV3ExchangeModel) {
            val model = gosn.fromJson(json,IDOAppActivityDataV3ExchangeModel::class.java)
            delegate?.appListenAppExec(IDOBleReplyType.appActivityDataReply(model))
        }else if (response is ApiAppHrDataExchangeModel) {
            val model = gosn.fromJson(json,IDOAppHrDataExchangeModel::class.java)
            delegate?.appListenAppExec(IDOBleReplyType.appActivityHrReply(model))
        }
    }

    override fun exchangeV2Data(model: ApiExchangeV2Model) {
        val gosn = Gson()
        val json = gosn.toJson(model).toString()
        val v2Model = gosn.fromJson(json, IDOExchangeV2Model::class.java)
        delegate?.exchangeV2Data(v2Model)
    }

    override fun exchangeV3Data(model: ApiExchangeV3Model) {
        val gosn = Gson()
        val json = gosn.toJson(model).toString()
        val v3Model = gosn.fromJson(json, IDOExchangeV3Model::class.java)
        delegate?.exchangeV3Data(v3Model)
    }


}