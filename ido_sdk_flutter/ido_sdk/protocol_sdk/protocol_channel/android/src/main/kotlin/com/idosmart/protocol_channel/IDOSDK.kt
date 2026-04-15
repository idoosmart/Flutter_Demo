package com.idosmart.protocol_channel

import android.content.Context
import android.os.Looper
import com.idosmart.pigeon_implement.*
import com.idosmart.model.*
import com.idosmart.protocol_sdk.*

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import kotlinx.coroutines.*

val sdk: IDOSDK = IDOSDK.instance()

class IDOSDK private constructor() {

    companion object {
        @Volatile
        private var instance: IDOSDK? = null
        @JvmStatic
        fun instance(): IDOSDK {
            return instance ?: synchronized(this) {
                instance ?: IDOSDK().also { instance = it }
            }
        }
    }

    fun init(context: Context) {
        val engine = FlutterEngine(context)
        engine.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
    }


    /**
     * 当前协议库操作状态
     */
    @Deprecated("Use sdk.state")
    val protocolDevice: IDOProtocolState
        get() {
            return BridgeDelegateImpl.instance().protocolDevice
        }

    /**
     * 当前协议库操作状态
     */
    val state: IDOProtocolState
        get() {
            return BridgeDelegateImpl.instance().protocolDevice
        }

    //==============do not edit directly begin==============
    /**
     * 蓝牙接口
     */
    val ble: BleInterface by lazy {
        BluetoothImpl()
    }
    //==============do not edit directly end==============

    /**
     * 桥接接口
     */
    val bridge: BridgeInterface by lazy {
        BridgeImpl()
    }

    /**
     * alexa
     */
    val alexa: AlexaInterface by lazy {
        AlexaImpl()
    }

    /**
     * 设备信息
     */
    val device: DeviceInterface by lazy {
        IDODevice()
    }

    /**
     * 功能表
     */
    val funcTable: FuncTableInterface by lazy {
        IDOFuncTable()
    }

    /**
     * 基础指令
     */
    val cmd: CmdInterface by lazy {
        CmdImpl()
    }

    /**
     * 设备日志
     */
    val deviceLog: DeviceLogInterface by lazy {
        DeviceLogImpl()
    }

    /**
     * 消息图标
     */
    val messageIcon: MessageIconInterface by lazy {
        MessageIconImpl()
    }

    /**
     * 数据同步
     */
    val syncData: SyncDataInterface by lazy {
        SyncDataImpl()
    }

    /**
     * 数据交换
     */
    val dataExchange: ExchangeDataInterface by lazy {
        ExchangeDataImpl()
    }

    /**
     * 工具
     */
    val tool: ToolsInterface by lazy {
        ToolImpl()
    }

    /**
     * 文件传输
     */
    val transfer: FileTransferInterface by lazy {
        FileTransferImpl()
    }

    /**
     * sdk info
     */
    val info: IDOSdkInfo
        get() {
            val verInfo = plugin.verInfo
            if (verInfo != null) {
                _sdkInfo.versionLib = verInfo.verMain!!
                _sdkInfo.versionAlexa = verInfo.verAlexa!!
                _sdkInfo.versionClib = verInfo.verClib!!
            }
            return _sdkInfo
        }
    private val _sdkInfo: IDOSdkInfo = IDOSdkInfo()
}

class IDOSdkInfo {
    /**
     * SDK版本
     */
    val versionSdk = "4.5.1"


    /**
     *  SDK更新时间
     */
    val updateTime = "2026-03-26 11:37:52"

    /**
     * Lib库版本
     */
    var versionLib: String = "4.0.16"
        internal set

    /**
     * Alexa库版本
     */
    var versionAlexa: String = "2.0.9"
        internal set

    /**
     * c库版本
     */
    var versionClib: String = "3.7.12"
        internal set
}

internal fun innerRunOnMainThread(closure: () -> Unit) {
    val context = if (isMainThread()) {
        Dispatchers.Main.immediate
    } else {
        Dispatchers.Main
    }

    // 使用协程作用域启动协程，在主线程上运行 closure 而不阻塞线程
    CoroutineScope(context).launch {
        closure()
    }
}

private fun isMainThread(): Boolean {
    return Thread.currentThread() == Looper.getMainLooper().thread
}