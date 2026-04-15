package com.idosmart.pigeon_implement

import com.idosmart.pigeongen.api_alexa.*
import com.idosmart.protocol_sdk.*
import com.idosmart.enums.*

internal class AlexaDelegateImpl: AlexaDataSource {

    companion object {
        @Volatile
        private var instance: AlexaDelegateImpl? = null
        fun instance(): AlexaDelegateImpl {
            return instance ?: synchronized(this) {
                instance ?: AlexaDelegateImpl().also { instance = it }
            }
        }
    }

    var delegate: IDOAlexaDelegate? = null

    override fun getHealthValue(valueType: ApiGetValueType, callback: (Result<Long>) -> Unit) {
        val healthValue = IDOGetValueType.ofRaw(valueType.raw)?.let {
                   it1 -> delegate?.getHealthValue(it1) } ?:0
        callback(Result.success(healthValue.toLong()))
    }


    override fun getHrValue(dataType: Long, timeType: Long, callback: (Result<Long>) -> Unit) {
        val hrValue = delegate?.getHrValue(dataType.toInt(),timeType.toInt()) ?:0
        callback(Result.success(hrValue.toLong()))
    }

    override fun functionControl(funType: Long) {
        delegate?.functionControl(funType.toInt())
    }
}

internal class  AlexaAuthDelegateImpl: AlexaAuthDelegate {

    companion object {
        @Volatile
        private var instance: AlexaAuthDelegateImpl? = null
        fun instance(): AlexaAuthDelegateImpl {
            return instance ?: synchronized(this) {
                instance ?: AlexaAuthDelegateImpl().also { instance = it }
            }
        }
    }

    var delegate: IDOAlexaAuthDelegate? = null

    override fun callbackPairCode(userCode: String, verificationUri: String) {
        delegate?.callbackPairCode(userCode,verificationUri)
    }

    override fun loginStateChanged(state: ApiLoginState) {
        IDOAlexaLoginState.ofRaw(state.raw)?.let {
          delegate?.loginStateChanged(it)
        }
    }

    override fun voiceStateChanged(state: ApiVoiceState) {

    }

}