package com.idosmart.pigeon_implement

import com.idosmart.pigeongen.api_bridge.*
import com.idosmart.protocol_sdk.*
import com.idosmart.model.*
import com.idosmart.enums.*
import io.flutter.BuildConfig
import com.idosmart.pigeon_implement.logNative

import com.google.gson.Gson

internal class BridgeDelegateImpl: BridgeDelegate {

    companion object {
        @Volatile
        private var instance: BridgeDelegateImpl? = null
        fun instance(): BridgeDelegateImpl {
            return instance ?: synchronized(this) {
                instance ?: BridgeDelegateImpl().also { instance = it }
            }
        }
    }

    private var delegate: IDOBridgeDelegate? = null
    private val gson = Gson()
    var callbackRawDataSensorInfoReply: ((IDORawDataSensorInfoReply) -> Unit)? = null

    fun addDelegate(api:IDOBridgeDelegate?) {
        delegate = api
    }

    internal val protocolDevice: IDOProtocolState by lazy {
        IDOProtocolState()
    }

    override fun registerWriteDataToBle(bleData: BleData) {
        //==============do not edit directly begin==============
        /*val data = bleData.data ?: byteArrayOf(0)
        val type = (bleData.type ?: 0).toInt()
        val macAddress = protocolDevice.macAddress
        val request = IDOBleDataRequest(data,type,macAddress)
        this.delegate?.writeDataToBle(request)*/
        //==============do not edit directly end==============
    }

    override fun listenStatusNotification(status: StatusNotification) {
        val raw = status.raw
        val notify = IDOStatusNotification.ofRaw(raw) ?: IDOStatusNotification.PROTOCOLCONNECTCOMPLETED
        this.delegate?.listenStatusNotification(notify)
    }

    override fun listenDeviceNotification(model: DeviceNotificationModel) {
        val dataType = (model.dataType ?: 0).toInt()
        val notifyType = (model.notifyType ?: 0).toInt()
        val msgId = (model.msgId ?: 0).toInt()
        val msgNotice = (model.msgNotice ?: 0).toInt()
        val errorIndex = (model.errorIndex ?: 0).toInt()
        val controlEvt = (model.controlEvt ?: 0).toInt()
        val controlJson = model.controlJson ?: ""
        val notify = IDODeviceNotificationModel(dataType,notifyType,msgId,msgNotice,errorIndex,controlEvt,controlJson)
        this.delegate?.listenDeviceNotification(notify)
    }

    override fun listenProtocolStateChanged(protocolState: ProtocolState) {
        val isConnected = protocolState.isConnected ?: false
        val isConnecting = protocolState.isConnecting ?: false
        val isBinding = protocolState.isBinding ?: false
        val isFastSynchronizing = protocolState.isFastSynchronizing ?: false
        val otaRaw = (protocolState.otaType ?: 0).toInt()
        val otaType = IDOOtaType.ofRaw(otaRaw) ?: IDOOtaType.NONE
        val macAddress = protocolState.macAddress ?: ""
        protocolDevice.isConnected = isConnected
        protocolDevice.isConnecting = isConnecting
        protocolDevice.isBinding = isBinding
        protocolDevice.isFastSynchronizing = isFastSynchronizing
        protocolDevice.otaType = otaType
        protocolDevice.macAddress = macAddress
        if (BuildConfig.DEBUG) {
            println("listenProtocolStateChanged: $protocolDevice")
        }
    }

    override fun checkDeviceBindState(macAddress: String): Boolean {
        return this.delegate?.checkDeviceBindState(macAddress) ?: false
    }

    override fun listenWaitingOtaDevice(otaDevice: OtaDeviceModel) {
        println(" kt listenWaitingOtaDevice $otaDevice");
        val otaDevice = IDOOtaDeviceModel(
            rssi = (otaDevice.rssi ?: 0).toInt(),
            name = otaDevice.name,
            uuid = otaDevice.uuid,
            macAddress = otaDevice.macAddress,
            otaMacAddress = otaDevice.otaMacAddress,
            btMacAddress = otaDevice.btMacAddress,
            deviceId = (otaDevice.deviceId ?: 0).toInt(),
            deviceType = (otaDevice.deviceType ?: 0).toInt(),
            isOta = otaDevice.isOta ?: false,
            isTlwOta = otaDevice.isTlwOta ?: false,
            bltVersion = (otaDevice.bltVersion ?: 0).toInt(),
            isPair = otaDevice.isPair ?: false,
            platform = (otaDevice.platform ?: 0).toInt(),
        )
        this.delegate?.listenWaitingOtaDevice(otaDevice)
    }

    override fun listenDeviceRawDataReport(dataType: Long, jsonStr: String) {
        if (dataType == 1L && jsonStr.length > 2) {
            try {
                val obj = gson.fromJson(jsonStr, IDORawDataSensorInfoReply::class.java)
                callbackRawDataSensorInfoReply?.invoke(obj)
            } catch (e: Exception) {
                println("error json:$jsonStr") // 仅用于临时调试，或使用更通用的日志库
                logNative("listenDeviceRawDataReport - error json: $jsonStr, exception: $e")
            }
        }
    }
}