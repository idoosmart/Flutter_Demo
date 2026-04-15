package com.idosmart.pigeon_implement

import com.idosmart.pigeongen.api_data_exchange.*
import com.idosmart.protocol_channel.plugin
import com.idosmart.protocol_sdk.*
import com.idosmart.enums.*
import com.idosmart.model.*
import com.idosmart.protocol_channel.innerRunOnMainThread

internal class ExchangeDataImpl: ExchangeDataInterface {

    private fun exchange(): ApiExchangeData? {
        return plugin.exchnage()
    }

    override val supportV3ActivityExchange: Boolean
        get() = IDOFuncTable().syncV3ActivityExchangeData
    override val status: IDOExchangeStatus
        get() = ExchangeDataDelegateImpl.instance().exchangeStatus

    override fun addExchange(delegate: IDOExchangeDataDelegate?) {
        ExchangeDataDelegateImpl.instance().addDelegate(delegate)
    }

    override fun appExec(type: IDOAppExecType) {

        var obj: Any? = null

        if (type is IDOAppExecType.appStart) {
           obj = type.model.toInnerModel()
        }else if (type is IDOAppExecType.appEnd) {
            obj = type.model.toInnerModel()
        }else if (type is IDOAppExecType.appIng) {
            obj = type.model.toInnerModel()
        }else if (type is IDOAppExecType.appPause) {
            obj = type.model.toInnerModel()
        }else if (type is IDOAppExecType.appRestore) {
            obj = type.model.toInnerModel()
        }else if (type is IDOAppExecType.appIngV3) {
            obj = type.model.toInnerModel()
        }else if (type is IDOAppExecType.appOperatePlan) {
            obj = type.model.toInnerModel()
        }
        innerRunOnMainThread {
            exchange()?.appExec(obj) {}
        }
    }

    override fun appReplyExec(type: IDOAppReplyType) {
        var obj: Any? = null
        if (type is IDOAppReplyType.bleStartReply) {
            obj = type.model.toInnerModel()
        }else if (type is IDOAppReplyType.bleIngReply) {
            obj = type.model.toInnerModel()
        }else if (type is IDOAppReplyType.bleEndReply) {
            obj = type.model.toInnerModel()
        }else if (type is IDOAppReplyType.blePauseReply) {
            obj = type.model.toInnerModel()
        }else if (type is IDOAppReplyType.bleRestoreReply) {
            obj = type.model.toInnerModel()
        }else if (type is IDOAppReplyType.bleOperatePlanReply) {
            obj = type.model.toInnerModel()
        }else if (type is IDOAppReplyType.appBlePauseReply) {
            obj = type.model.toInnerModel()
        }else if (type is IDOAppReplyType.appBleRestoreReply) {
            obj = type.model.toInnerModel()
        }else if (type is IDOAppReplyType.appBleEndReply) {
            obj = type.model.toInnerModel()
        }
        innerRunOnMainThread {
            exchange()?.appReplyExec(obj) {}
        }
    }

    override fun getLastActivityData() {
        innerRunOnMainThread {
            exchange()?.getLastActivityData {}
        }
    }

    override fun getActivityHrData() {
        innerRunOnMainThread {
            exchange()?.getActivityHrData {}
        }
    }

    override fun getActivityGpsData() {
        innerRunOnMainThread {
            exchange()?.getActivityGpsData {}
        }
    }

}