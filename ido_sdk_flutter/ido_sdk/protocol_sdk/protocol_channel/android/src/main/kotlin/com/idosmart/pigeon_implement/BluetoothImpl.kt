package com.idosmart.pigeon_implement

import com.idosmart.pigeongen.api_bluetooth.Bluetooth
import com.idosmart.pigeongen.api_bluetooth.DeviceModel
import com.idosmart.protocol_channel.plugin
import com.idosmart.protocol_sdk.*
import com.idosmart.tool.Help
import com.idosmart.model.*
import com.idosmart.enums.*
import com.idosmart.protocol_channel.innerRunOnMainThread


internal class BluetoothImpl internal constructor() : BleInterface {

    private var lastSelectDevice: IDOBleDeviceModel? = null

    init {
        BluetoothDelegateImpl.instance().callbackBleDeviceModel = {
            lastSelectDevice?.updateValues(it)
        }
    }

    private fun bluetooth(): Bluetooth? {
        return plugin.bluetooth()
    }

    override val bleDevice: IDOBleDeviceModel
        get() = BluetoothDelegateImpl.instance().bleDevice

//    override fun bluetoothRegister(outputToConsole: Boolean) {
//        bluetooth()?.register(0,outputToConsole){}
//    }


    override fun addBleDelegate(api: IDOBleDelegate?) {
        BluetoothDelegateImpl.instance().addDelegate(api)
    }

    override fun addDfuDelegate(api: IDODfuDelegate?) {
        BluetoothDelegateImpl.instance().addDfuDelegate(api)
    }


    override fun startScan(macAddress: String,
                           completion: (List<IDOBleDeviceModel>?) -> Unit) {
        innerRunOnMainThread {
            bluetooth()?.startScan(macAddress) {
                val deviceList = it?.let { it1 -> Help.getDeviceList(it1 as List<DeviceModel>) }
                completion(deviceList)
            }
        }
    }

    override fun scanFilter(
        deviceName: List<String>?,
        deviceID: List<Long>?,
        macAddress: List<String>?,
        uuid: List<String>?
    ) {
        innerRunOnMainThread {
            bluetooth()?.scanFilter(deviceName, deviceID, macAddress, uuid) {}
        }
    }

    override fun stopScan() {
        innerRunOnMainThread {
            bluetooth()?.stopScan {}
        }
    }

    override fun connect(device: IDOBleDeviceModel?) {
        innerRunOnMainThread {
            val apiDevice = Help.getApiDevice(device)
            lastSelectDevice = device
            bluetooth()?.connect(apiDevice) {}
        }
    }

    override fun autoConnect(device: IDOBleDeviceModel?) {
        innerRunOnMainThread {
            val apiDevice = Help.getApiDevice(device)
            lastSelectDevice = device
            bluetooth()?.autoConnect(apiDevice) {}
        }
    }

    override fun cancelConnect(macAddress: String?, completion: (Boolean) -> Unit) {
        innerRunOnMainThread {
            bluetooth()?.cancelConnect(macAddress,completion)
        }
    }

    override fun getBluetoothState(completion: (IDOBluetoothStateModel) -> Unit) {
        innerRunOnMainThread {
            bluetooth()?.getBluetoothState {
                val model = IDOBluetoothStateModel()
                model.type = IDOBluetoothStateType.values()[it.type?.raw ?: 0]
                model.scanType = IDOBluetoothScanType.values()[it.scanType?.raw ?: 0]
                completion(model)
            }
        }
    }

    override fun getDeviceState(
        device: IDOBleDeviceModel?,
        completion: (IDODeviceStateModel) -> Unit
    ) {
        innerRunOnMainThread {
            val apiDevice = Help.getApiDevice(device)
            bluetooth()?.getDeviceState(apiDevice) {
                val deviceState = IDODeviceStateModel()
                deviceState.uuid = it.uuid
                deviceState.macAddress = it.macAddress
                deviceState.state = IDODeviceStateType.values()[it.state?.raw ?: 0]
                deviceState.errorState = IDOConnectErrorType.values()[it.errorState?.raw ?: 0]
                completion(deviceState)
            }
        }
    }

    override fun setBtPair(device: IDOBleDeviceModel) {
        innerRunOnMainThread {
            val apiDevice = Help.getApiDevice(device)
            bluetooth()?.setBtPair(apiDevice) {}
        }
    }

    override fun cancelPair(device: IDOBleDeviceModel?) {
        innerRunOnMainThread {
            val apiDevice = Help.getApiDevice(device)
            bluetooth()?.cancelPair(apiDevice) {}
        }
    }

    override fun connectSPP(btMacAddress: String) {
        innerRunOnMainThread {
            bluetooth()?.connectSPP(btMacAddress) {}
        }
    }

    override fun disconnectSPP(btMacAddress: String) {
        innerRunOnMainThread {
            bluetooth()?.disconnectSPP(btMacAddress) {}
        }
    }

    override fun startNordicDFU(config: IDODfuConfig) {
        innerRunOnMainThread {
            val apiConfig = Help.getApiDfuConfig(config)
            bluetooth()?.startNordicDFU(apiConfig) {}
        }
    }

    override fun exportLog(completion: (String?) -> Unit) {
        innerRunOnMainThread {
            bluetooth()?.logPath(completion)
        }
    }

    override fun writeData(
        data: ByteArray,
        device: IDOBleDeviceModel,
        type: Int,
        platform: Int,
        completion: (IDOWriteStateModel) -> Unit
    ) {
        innerRunOnMainThread {
            val apiDevice = Help.getApiDevice(device)
            bluetooth()?.writeData(data, apiDevice, type.toLong(), platform.toLong()) {
                val writeState = IDOWriteStateModel()
                writeState.state = it.state
                writeState.uuid = it.uuid
                writeState.macAddress = it.macAddress
                writeState.type = IDOWriteType.values()[it.type?.raw ?: 0]
                completion(writeState)
            }
        }
    }

}