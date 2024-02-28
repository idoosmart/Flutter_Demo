package com.idosmart.native_channel.alexa

import com.idosmart.native_channel.alexa.utils.AlexaLogUtil
import com.idosmart.native_channel.alexa.callbacks.DownStream
import com.idosmart.native_channel.alexa.callbacks.DownStreamResultCallback
import com.idosmart.native_channel.alexa.callbacks.ImplUpstreamResultCallback
import com.idosmart.native_channel.alexa.callbacks.UpStream
import com.idosmart.native_channel.alexa.callbacks.UpstreamResultCallback
import com.idosmart.native_channel.alexa.downstream.AlexaDownChannelService
import com.idosmart.native_channel.alexa.upstream.AlexaAudioEventManger

/**
 * @author tianwei
 * @date 2023/9/23
 * @time 13:24
 * 用途: alexa主管
 */
class AlexaManager : UpStream, DownStream {
    private var mToken: String? = null
    private var mPingUrl: String? = null
    private var mDirectiveUrl: String? = null
    private var mEventUrl: String? = null

    companion object {
        private const val TAG = "AlexaManager"
        private var mInstance: AlexaManager? = null

        @JvmStatic
        fun getInstance(): AlexaManager {
            if (mInstance == null) {
                synchronized(AlexaManager::class.java) {
                    if (mInstance == null) {
                        mInstance = AlexaManager()
                    }
                }
            }
            return mInstance!!
        }
    }

    fun hasLogin() = !mToken.isNullOrEmpty()

    fun getToken() = mToken

    fun getPingUrl() = mPingUrl

    fun getDirectiveUrl() = mDirectiveUrl

    fun getEventUrl() = mEventUrl

    fun setToken(token: String?) {
        if (!token.isNullOrEmpty()){
            this.mToken = "Bearer $token"
            return
        }
        this.mToken = token
    }

    fun setPingUrl(url: String?) {
        mPingUrl = url
    }

    fun setDirectiveUrl(url: String?) {
        //https://alexa.na.gateway.devices.a2z.com/v20160207/directives
        mDirectiveUrl = url
    }

    fun setEventUrl(mEventUrl: String?) {
        this.mEventUrl = mEventUrl
    }

    fun parseParams(params: Map<String, Any?>?) {
        mEventUrl = params?.get("url") as String?
        mToken = params?.get("token") as String?
        mDirectiveUrl = params?.get("directiveUrl") as String?
        mPingUrl = params?.get("pingUrl") as String?
    }

    override fun startRecord(url: String, requestId: String, event: String, callback: UpstreamResultCallback<ByteArray, Throwable>) {
        AlexaLogUtil.p("startRecord, event = $event, url = $url", TAG)
        AlexaAudioEventManger.getInstance().startRecord(url, requestId, event, MyUpstreamResultCallback(callback))
        startDownChannel()
    }

    private fun startDownChannel() {
//        var bundle: Bundle? = null
//        AlexaLogUtil.printAndSave("startDownChannel , recordFailedCount = $recordFailedCount")
//        if (recordFailedCount > 2) {
//            recordFailedCount = 0
//            bundle = Bundle()
//            bundle.putBoolean(AlexaDownChannelService.NEED_CREATE_DOWNCHANNEL, true)
//            AlexaLogUtil.printAndSave("recordFailedCount > 2 ")
//        }
//        AlexaDownChannelService.getInstance().onStartCommand(bundle)
    }

    override fun addVoiceData(data: ByteArray) {
        if (data.isNotEmpty()) {
            AlexaAudioEventManger.getInstance().addVoiceData(data)
        }
    }

    override fun endRecord() {
        AlexaLogUtil.p("endRecord", TAG)
        AlexaAudioEventManger.getInstance().endRecord()
    }

    override fun createDownStream(callback:DownStreamResultCallback) {
        AlexaDownChannelService.getInstance().createDownStream(callback)
    }

    override fun closeDownStream() {
        AlexaDownChannelService.getInstance().closeDownStream()
    }

    private inner class MyUpstreamResultCallback(val out: UpstreamResultCallback<ByteArray, Throwable>?) :
        ImplUpstreamResultCallback<ByteArray, Throwable>() {
        override fun start(mSpeechRecognizerEventRequestId: String) {
            AlexaLogUtil.printAndSave("sendRecord start, mSpeechRecognizerEventRequestId = $mSpeechRecognizerEventRequestId", TAG)
            out?.start(mSpeechRecognizerEventRequestId)
        }

        override fun startParse() {
            AlexaLogUtil.printAndSave("sendRecord startParse", TAG)
            out?.startParse()
        }

        override fun success(requestId: String?, result: ByteArray) {
            super.success(requestId, result)
            reset()
            AlexaLogUtil.printAndSave("sendRecord success, requestId = $requestId", TAG)
            out?.success(requestId, result)
        }

        override fun failure(error: Throwable) {
            AlexaLogUtil.printAndSave("sendRecord failure : " + error.message, TAG)
            reset()
            out?.failure(error)
        }

        override fun authorize() {
            reset()
            AlexaLogUtil.printAndSave("authorize", TAG)
            out?.authorize()
        }
    }

    private fun reset() {
        AlexaLogUtil.printAndSave("<<reset>>", TAG)
    }


}