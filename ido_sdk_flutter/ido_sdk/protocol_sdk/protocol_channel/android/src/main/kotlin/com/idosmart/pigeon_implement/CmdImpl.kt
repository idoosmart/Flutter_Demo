package com.idosmart.pigeon_implement

import com.idosmart.pigeongen.api_bind.Bind
import com.idosmart.pigeongen.api_tools.Tool
import com.idosmart.protocol_channel.plugin
import com.idosmart.protocol_sdk.*
import com.idosmart.enums.*
import com.idosmart.model.IDORawDataSensorInfoReply
import com.idosmart.protocol_channel.innerRunOnMainThread

private fun bind(): Bind? {
    return plugin.bind()
}

private fun tool(): Tool? {
    return plugin.tool()
}

internal class CmdImpl : CmdInterface {

    var _isBinding: Boolean = false

    override val isBinding: Boolean
        get() = _isBinding

    override fun <T> make(anyCmd: AnyCmd<T>): AnyCmd<T> {
        return anyCmd
    }

    override fun bind(
        osVersion: Int,
        onDeviceInfo: ((DeviceInterface) -> Unit)?,
        onFuncTable: ((FuncTableInterface) -> Unit)?,
        completion: (IDOBindStatus) -> Unit
    ) {
        DeviceDelegateImpl.instance().callbackDeviceInfo = onDeviceInfo
        FuncTableDelegateImpl.instance().callbackFuncTable = onFuncTable
        _isBinding = true
        innerRunOnMainThread {
            bind()?.bind(osVersion.toLong()) {
                val status = IDOBindStatus.ofRaw(it.toInt()) ?: IDOBindStatus.FAILED
                _isBinding = false
                completion(status)
            }
        }
    }

    /**
     * APP下发绑定结果(仅限需要app确认绑定结果的设备使用)
     * ```
     * 注：当startBind(...) 返回BindStatus.needAuthByApp 时，APP需要发送
     * CmdEvtType.sendBindResult指令，在调用成功后，再调用appMarkBindResult方法
     * ```
     */
    override fun appMarkBindResult(success: Boolean) {
        innerRunOnMainThread {
            bind()?.appMarkBindResult(success) {}
        }
    }


    override fun cancelBind() {
        innerRunOnMainThread {
            bind()?.cancelBind {
                _isBinding = false
            }
        }
    }

    override fun unbind(macAddress: String, isForceRemove: Boolean, completion: (Boolean) -> Unit) {
        innerRunOnMainThread {
            bind()?.unbind(macAddress, isForceRemove, completion)
        }
    }

    override fun setAuthCode(code: String, osVersion: Int, completion: (Boolean) -> Unit) {
        innerRunOnMainThread {
            bind()?.setAuthCode(code, osVersion.toLong(), completion)
        }
    }

    override fun setV2CallEvt(
        contactText: String,
        phoneNumber: String,
        completion: (Boolean) -> Unit
    ) {
        innerRunOnMainThread {
            tool()?.setV2CallEvt(contactText, phoneNumber) {
                completion(it.toInt() == 0)
            }
        }
    }

    override fun setV2NoticeEvt(
        type: IDONoticeMessageType,
        contactText: String,
        phoneNumber: String,
        dataText: String,
        completion: (Boolean) -> Unit
    ) {
        innerRunOnMainThread {
            tool()?.setV2NoticeEvt(type.raw.toLong(), contactText, phoneNumber, dataText) {
                completion(it.toInt() == 0)
            }
        }
    }

    override fun stopV2CallEvt(completion: (Boolean) -> Unit) {
        innerRunOnMainThread {
            tool()?.stopV2CallEvt {
                completion(it.toInt() == 0)
            }
        }
    }

    override fun missedV2MissedCallEvt(completion: (Boolean) -> Unit) {
        innerRunOnMainThread {
            tool()?.missedV2MissedCallEvt {
                completion(it.toInt() == 0)
            }
        }
    }

    override fun listenReceiveAlgorithmRawData(rawDataReply: (IDORawDataSensorInfoReply) -> Unit) {
        BridgeDelegateImpl.instance().callbackRawDataSensorInfoReply = rawDataReply
    }


}