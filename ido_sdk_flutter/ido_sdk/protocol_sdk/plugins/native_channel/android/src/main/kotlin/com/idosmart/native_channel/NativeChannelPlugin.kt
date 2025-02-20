package com.idosmart.native_channel

import android.app.Application
import android.os.Handler
import android.os.Looper
import com.idosmart.native_channel.alexa.utils.AlexaLogUtil
import com.idosmart.native_channel.alexa.AlexaManager
import com.idosmart.native_channel.alexa.callbacks.*
import io.flutter.plugin.common.BinaryMessenger
import com.idosmart.native_channel.alexa.callbacks.DownStreamResultCallback

import com.idosmart.native_channel.pigeon_generate.api_alexa.ApiAlexaError
import com.idosmart.native_channel.pigeon_generate.api_alexa.ApiAlexaFlutter
import com.idosmart.native_channel.pigeon_generate.api_alexa.ApiAlexaHost
import com.idosmart.native_channel.pigeon_generate.api_get_app_info.ApiGetAppInfo
import com.idosmart.native_channel.pigeon_generate.api_get_file_info.ApiGetFileInfo
import com.idosmart.native_channel.pigeon_generate.api_sifli.*
import com.idosmart.native_channel.pigeon_generate.api_tools.ApiTools
import com.idosmart.native_channel.pigeon_generate.api_tools.ToolsDelegate
import com.idosmart.native_channel.siche.Config
import com.idosmart.native_channel.siche.SicheApiHostImpl
import io.flutter.embedding.engine.plugins.FlutterPlugin

class NativeChannelPlugin : FlutterPlugin, ApiAlexaHost {

    val handler = Handler(Looper.getMainLooper())

    companion object {
        const val TAG = "NativeChannelPlugin"

        @Volatile
        private var instance: NativeChannelPlugin? = null
        fun instance(): NativeChannelPlugin {
            return instance ?: synchronized(this) {
                instance ?: NativeChannelPlugin().also { instance = it }
            }
        }
    }

    private var apiAlexaFlutter: ApiAlexaFlutter? = null
    internal var tools: ToolsDelegate? = null

    private var application: Application? = null
    var apiSifliFlutter: ApiSifliFlutter? = null


    internal fun androidLog(msgArg: String) {
        Handler(Looper.getMainLooper()).post {
            NativeChannelPlugin.instance().tools?.getNativeLog(msgArg) {}
        }
    }

    private fun runOnUiThread(callback: () -> Unit) {
        handler.post {
            callback()
        }
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        AlexaLogUtil.p("onAttachedToEngine")
        this.application = flutterPluginBinding.applicationContext as Application
        NativeChannelPlugin.instance().tools = ToolsDelegate(flutterPluginBinding.binaryMessenger)
        ApiGetAppInfo.setUp(flutterPluginBinding.binaryMessenger,GetAppInfoImpl.instance(flutterPluginBinding))
        ApiGetFileInfo.setUp(flutterPluginBinding.binaryMessenger,GetFileInfoImpl.instance())
        ApiTools.setUp(flutterPluginBinding.binaryMessenger,ApiToolsImpl.instance(flutterPluginBinding))
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
        NativeChannelPlugin.instance().apiSifliFlutter = ApiSifliFlutter(messenger)
        Config.init(this.application)
        ApiSifliHost.setUp(messenger, SicheApiHostImpl())
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
