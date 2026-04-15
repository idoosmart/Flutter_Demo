package com.idosmart.pigeon_implement

import com.idosmart.pigeongen.api_bridge.Bridge
import com.idosmart.protocol_channel.plugin
import com.idosmart.protocol_sdk.*
import com.idosmart.model.*
import com.idosmart.enums.*
import com.idosmart.protocol_channel.innerRunOnMainThread
import com.idosmart.protocol_channel.sdk

private var _flagSetupBridge = false
internal class BridgeImpl: BridgeInterface {

    private fun bridge(): Bridge? {
        return plugin.bridge()
    }

    /// 协议状态
    val protocolState: IDOProtocolState = IDOProtocolState()

    override fun setupBridge(delegate: IDOBridgeDelegate, logType: IDOLogType) {
        if(_flagSetupBridge) {
            BridgeDelegateImpl.instance().addDelegate(delegate)
            innerRunOnMainThread {
                plugin.tool()?.logNative("重复调用setupBridge(...)") { }
            }
            return
        }
        _flagSetupBridge = true
        BridgeDelegateImpl.instance().addDelegate(delegate)
        innerRunOnMainThread {
            bridge()?.register(
                logType != IDOLogType.NONE,
                logType == IDOLogType.DEBUG,
                logType != IDOLogType.DEBUG
            ) {}
            plugin.tool()?.logNative("android native sdk: ${sdk.info.versionSdk} updateTime: ${sdk.info.updateTime}") { }
        }
    }

    override fun markOtaMode(
        macAddress: String,
        platform: Int,
        deviceId: Int,
        completion: (Boolean) -> Unit
    ) {
        innerRunOnMainThread {
            bridge()?.markOtaMode(macAddress, "", platform.toLong(), deviceId.toLong()) {
                completion(it)
            }
        }
    }

    //==============do not edit directly begin==============
    /*override*/ fun markConnectedDevice(
        uniqueId: String,
        otaType: IDOOtaType,
        isBinded: Boolean,
        deviceName: String?,
        completion: (Boolean) -> Unit
    ) {
        innerRunOnMainThread {
            bridge()?.markConnectedDevice(uniqueId, (otaType.raw).toLong(), isBinded, deviceName) {
                completion(it)
            }
        }
    }

    /*override*/ fun markDisconnectedDevice(macAddress: String?, uuid: String?, completion: (Boolean) -> Unit) {
        innerRunOnMainThread {
            bridge()?.markDisconnectedDevice(macAddress, uuid) {
                completion(it)
            }
        }
    }

    /*override*/ fun receiveDataFromBle(data: ByteArray, macAddress: String?, useSPP: Boolean) {
        val type = if (useSPP) 1 else 0
        innerRunOnMainThread {
            bridge()?.receiveDataFromBle(data, macAddress, type.toLong()) {}
        }
    }

    /*override*/ fun writeDataComplete() {
        innerRunOnMainThread {
            bridge()?.writeDataComplete {}
        }
    }
    //==============do not edit directly end==============

}