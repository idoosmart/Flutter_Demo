package com.idosmart.pigeon_implement

import com.idosmart.pigeongen.api_bluetooth.*
import com.idosmart.protocol_sdk.*
import com.idosmart.tool.Help
import com.idosmart.model.*
import com.idosmart.enums.*
import com.idosmart.protocol_channel.plugin
import com.idosmart.protocol_channel.innerRunOnMainThread

internal class BluetoothDelegateImpl: BluetoothDelegate {

    companion object {
        @Volatile
        private var instance: BluetoothDelegateImpl? = null
        fun instance(): BluetoothDelegateImpl {
            return instance ?: synchronized(this) {
                instance ?: BluetoothDelegateImpl().also { instance = it }
            }
        }
    }

    private var delegate: IDOBleDelegate? = null

    private var dfuDelegate: IDODfuDelegate? = null

    private val mapOnlyOnceCallbackStateBt = mutableMapOf<String, Boolean>()

    var callbackBleDeviceModel: ((DeviceModel) -> Unit)? = null

    internal val bleDevice: IDOBleDeviceModel by lazy {
        IDOBleDeviceModel()
    }

    private val bluetoothState: IDOBluetoothStateModel by lazy {
        IDOBluetoothStateModel()
    }
    private val deviceStateModel: IDODeviceStateModel by lazy {
        IDODeviceStateModel()
    }

    /**
    添加代理对象
     */
    fun addDelegate(api:IDOBleDelegate?) {
        delegate = api
    }

    /**
     * 添加升级代理对象
     */
    fun addDfuDelegate(api: IDODfuDelegate?) {
        dfuDelegate = api
    }

    override fun writeState(state: WriteStateModel) {
//        val  bleWrite = IDOWriteStateModel()
//        bleWrite.state = state.state
//        bleWrite.uuid = state.uuid
//        bleWrite.macAddress = state.macAddress
//        bleWrite.type = IDOWriteType.values()[(state.type?.raw?:0)]
//        this.delegate?.writeState(bleWrite)
    }

    override fun receiveData(data: ReceiveData) {
        val receive = IDOReceiveData()
        receive.macAddress = data.macAddress ?: ""
        receive.spp = data.spp ?: false
        receive.data = data.data?: ByteArray(0)
        receive.uuid = data.uuid ?: ""
        receive.platform = data.platform ?: 0
        this.delegate?.receiveData(receive)
    }

    override fun scanResult(list: List<DeviceModel>?) {
        val deviceList = list?.let { Help.getDeviceList(it) }
        this.delegate?.scanResult(deviceList)
    }

    override fun bluetoothState(state: BluetoothStateModel) {
        bluetoothState.type = IDOBluetoothStateType.values()[state.type?.raw ?:0]
        bluetoothState.scanType = IDOBluetoothScanType.values()[state.scanType?.raw ?:0]
        this.delegate?.bluetoothState(bluetoothState)
    }

    override fun deviceState(state: DeviceStateModel) {
        deviceStateModel.uuid = state.uuid ?: ""
        deviceStateModel.macAddress = state.macAddress ?: ""
        deviceStateModel.state = IDODeviceStateType.values()[state.state?.raw ?:0]
        bleDevice.state = deviceStateModel.state
        if (bluetoothState.type == IDOBluetoothStateType.POWEREDOFF) {
            deviceStateModel.errorState = IDOConnectErrorType.BLUETOOTHOFF
        }else {
            deviceStateModel.errorState = IDOConnectErrorType.values()[state.errorState?.raw ?:0]
        }
        this.delegate?.deviceState(deviceStateModel)
    }

    override fun stateSPP(state: SPPStateModel) {
        val spp = IDOSppStateModel()
        spp.type = IDOSppStateType.values()[state.type?.raw?:0]
        this.delegate?.stateSPP(spp)
    }

    override fun writeSPPCompleteState(btMacAddress: String) {
        this.delegate?.writeSPPCompleteState(btMacAddress)
    }

    override fun dfuComplete() {
        this.dfuDelegate?.dfuComplete()
    }

    override fun dfuError(error: String) {
        this.dfuDelegate?.dfuError(error)
    }

    override fun dfuProgress(progress: Long) {
        this.dfuDelegate?.dfuProgress(progress.toInt())
    }

    override fun changeCurrentDevice(device: DeviceModel) {
        //println("device.btMacAddress = ${device.btMacAddress}")
        bleDevice.macAddress = device.macAddress
        bleDevice.updateValues(device)

        // 清理非当前设备的bt配对状态
        if (!device.macAddress.isNullOrEmpty()) {
            val curValue = mapOnlyOnceCallbackStateBt[device.macAddress]
            mapOnlyOnceCallbackStateBt.clear()
            if (curValue != null) {
                mapOnlyOnceCallbackStateBt[device.macAddress] = curValue
            }
        }else {
            mapOnlyOnceCallbackStateBt.clear()
        }
    }

    /** 监听当前设备属性变更（目前针对btMacAddress 内部使用） */
    override fun onCurrentDeviceAttrValChange(device: DeviceModel) {
        val state = IDODeviceStateType.values()[device.state?.raw ?:0]
        //println("device.btMacAddress2 = ${device.btMacAddress}")
        bleDevice.macAddress = device.macAddress
        bleDevice.updateValues(device)
        callbackBleDeviceModel?.invoke(device)
    }

    override fun stateBt(isPair: Boolean) {
        printLog("stateBt - isPair: $isPair")
        if (bleDevice.macAddress.isNullOrEmpty()) {
            printLog("stateBt - macAddress is empty, return")
            return
        }

        // 过滤重复状态回调（原生android执行bt配对，当配对失败时，系统存在多次回调）
        val macAddress = bleDevice.macAddress!!
        if (!mapOnlyOnceCallbackStateBt.contains(macAddress) ||
            mapOnlyOnceCallbackStateBt[macAddress] != isPair) {
            this.delegate?.stateBT(isPair)
            mapOnlyOnceCallbackStateBt[bleDevice.macAddress!!] = isPair
            printLog("stateBt - call stateBT delegate")
        }else {
            printLog("stateBt - call stateBT delegate, ignore")
        }
    }

    private fun printLog(msg: String) {
        innerRunOnMainThread {
            plugin.tool()?.logNative(msg) { }
        }
    }
}