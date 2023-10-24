package com.idosmart.alexa_channel

import android.os.Handler
import android.os.Looper
import com.idosmart.alexa.utils.AlexaLogUtil
import com.idosmart.alexa.AlexaManager
import com.idosmart.alexa.callbacks.ImplUpstreamResultCallback
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import com.idosmart.alexa.callbacks.DownStreamResultCallback
import com.idosmart.pigeon.api_channel.ApiAlexaError
import com.idosmart.pigeon.api_channel.ApiAlexaFlutter
import com.idosmart.pigeon.api_channel.ApiAlexaHost

/**
 * @author tianwei
 * @date 2023/9/22
 * @time 20:09
 * 用途:
 */
class AlexaChannelPlugin : FlutterPlugin, ApiAlexaHost {

    val handler = Handler(Looper.getMainLooper())

    companion object {
        const val TAG = "AlexaChannelPlugin"
    }

    private var apiAlexaFlutter: ApiAlexaFlutter? = null

    private fun runOnUiThread(callback: () -> Unit) {
        handler.post {
            callback()
        }
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        AlexaLogUtil.p("onAttachedToEngine")
        setup(flutterPluginBinding.binaryMessenger)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        AlexaLogUtil.p("onDetachedFromEngine")
        tearDown()
    }

    private fun setup(
        messenger: BinaryMessenger,
    ) {
        ApiAlexaHost.setUp(messenger, this)
        apiAlexaFlutter = ApiAlexaFlutter(messenger)
        AlexaLogUtil.setApiAlexaFlutter(apiAlexaFlutter, handler)
    }

    private fun tearDown() {
        AlexaLogUtil.p("tearDown")
    }

    override fun onTokenChanged(token: String?) {
        AlexaManager.getInstance().setToken(token)
    }

    override fun createDownStream(url: String, callback: (Result<Boolean>) -> Unit) {
        AlexaManager.getInstance().setDirectiveUrl(url)
        AlexaManager.getInstance().createDownStream(object : DownStreamResultCallback {
            override fun onDownStreamError(error: ApiAlexaError) {
                AlexaLogUtil.p("onDownStreamError end, error = $error", TAG)
                runOnUiThread {
                    apiAlexaFlutter?.onDownStreamError(error) {
                        AlexaLogUtil.p("onDownStreamError reply end!", TAG)
                    }
                }
            }

            override fun onDownStreamData(bytes: ByteArray) {
                runOnUiThread {
                    apiAlexaFlutter?.downStreamData(bytes) {
                        AlexaLogUtil.p("onDownStreamData reply end", TAG)
                    }
                }
            }

        })
    }

    override fun closeDownStream(callback: (Result<Boolean>) -> Unit) {
        AlexaManager.getInstance().closeDownStream()
        callback.invoke(Result.success(true))
    }

    override fun createUploadStream(url: String, jsonBody: ByteArray, callback: (Result<Boolean>) -> Unit) {
//        createDownStream("https://alexa.na.gateway.devices.a2z.com/v20160207/directives"){
//            AlexaLogUtil.p("createUploadStream end", TAG)
//        }
        AlexaManager.getInstance().startRecord(url, "", String(jsonBody), OutImplUpstreamResultCallback(callback))
        callback.invoke(Result.success(true))
    }

    override fun closeUploadStream(callback: (Result<Boolean>) -> Unit) {
        AlexaManager.getInstance().endRecord()
        callback.invoke(Result.success(true))
    }

    override fun askAudioData(data: ByteArray, isEnd: Boolean) {
        AlexaManager.getInstance().addVoiceData(data)
    }

    private inner class OutImplUpstreamResultCallback(val callback: (Result<Boolean>) -> Unit) :
        ImplUpstreamResultCallback<ByteArray, Throwable>() {
        override fun start(mSpeechRecognizerEventRequestId: String) {
        }

        override fun startParse() {
        }

        override fun success(requestId: String, res: ByteArray) {
            runOnUiThread {
                apiAlexaFlutter?.replyAudioData(requestId, res, true) {
                    AlexaLogUtil.p("replyAudioData reply end", TAG)
                }
            }

        }

        override fun failure(error: Throwable) {
            AlexaLogUtil.p("onDownStreamError end, error = $error", TAG)
            runOnUiThread {
                apiAlexaFlutter?.onUploadStreamError(ApiAlexaError(-1, error.message, null)) {
                    AlexaLogUtil.p("onDownStreamError reply end", TAG)
                }
            }

        }

        override fun authorize() {
        }
    }
}
