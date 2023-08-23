package com.example.flutter_bluetooth.ble.protocol

import android.annotation.TargetApi
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothProfile
import android.bluetooth.le.ScanResult
import com.example.flutter_bluetooth.utils.Constants
import com.example.flutter_bluetooth.dfu.BleDFUState
import com.example.flutter_bluetooth.dfu.parser.ScannerServiceParser


/**
 * @author tianwei
 * @date 2022/9/21
 * @time 10:36
 * 用途:
 */
object ProtoMaker {

    @TargetApi(21)
    fun makeScanResult(device: BluetoothDevice, scanResult: ScanResult): Map<String, Any?> {
        val scanRecord = scanResult.scanRecord
        val map = hashMapOf<String, Any?>()
        map["rssi"] = scanResult.rssi
        map["uuid"] = ""
        map["macAddress"] = device.address
        map["name"] = scanRecord?.deviceName ?: ""
        scanRecord?.let {
            val bytes = it.bytes
            var temp: ByteArray? = byteArrayOf()
            if (bytes != null) {
                temp = ScannerServiceParser.decodeManufacturer(it.bytes)
            }
            map["dataManufacturerData"] = temp ?: byteArrayOf()
            map["serviceUUIDs"] = it.serviceUuids?.map { uuid -> uuid.uuid.toString() } ?: arrayListOf<String>()
        }
        map["state"] = Constants.BleConnectState.STATE_DISCONNECTED
        return map
    }

    /**
     * 低版本，扫描结果
     */
    fun makeScanResult(
        device: BluetoothDevice, scanRecord: ByteArray?, rssi: Int
    ): Map<String, Any?> {
        val map = hashMapOf<String, Any?>()
        map["rssi"] = rssi
        map["uuid"] = ""
        map["macAddress"] = device.address
        map["name"] = device.name ?: ""
        map["state"] = Constants.BleConnectState.STATE_DISCONNECTED
        scanRecord?.let { it ->
            map["dataManufacturerData"] = ScannerServiceParser.decodeManufacturer(it) ?: byteArrayOf()
            map["serviceUUIDs"] = AdvParser.decodeServiceUUIDs(it)
        }

        return map
    }

    /**
     * 设备连接状态
     */
    fun makeConnectState(
        deviceAddress: String, status: Int, state: Int, error: Int = Constants.BleConnectFailedError.DEFAULT.ordinal
    ): Map<String, Any?> {
        val map = hashMapOf<String, Any?>()
        val resultState = when (state) {
            BluetoothProfile.STATE_CONNECTING -> Constants.BleConnectState.STATE_CONNECTING
            BluetoothProfile.STATE_CONNECTED -> Constants.BleConnectState.STATE_CONNECTED
            BluetoothProfile.STATE_DISCONNECTING -> Constants.BleConnectState.STATE_DISCONNECTING
            else -> Constants.BleConnectState.STATE_DISCONNECTED
        }
        map["uuid"] = ""
        map["macAddress"] = deviceAddress
        map["state"] = resultState
        map["errorState"] = error
        return map
    }

    /**
     * 数据发送结果
     */
    fun makeSendResult(status: Int, deviceAddress: String): Map<String, Any?> {
        val map = hashMapOf<String, Any?>()
        map["state"] = status == BluetoothGatt.GATT_SUCCESS
        map["macAddress"] = deviceAddress
        map["uuid"] = ""
        return map
    }

    /**
     * 收到的数据
     */
    fun makeReceiveData(
        device: BluetoothDevice, characteristic: BluetoothGattCharacteristic
    ): Map<String, Any?> {
        val map = hashMapOf<String, Any?>()
        map["macAddress"] = device.address
        map["data"] = characteristic.value
        map["spp"] = false
        map["uuid"] = ""
        return map
    }

    /**
     * 收到的数据
     */
    fun makeSPPReceiveData(
        device: String, data: ByteArray
    ): Map<String, Any?> {
        val map = hashMapOf<String, Any?>()
        map["macAddress"] = device
        map["data"] = data
        map["spp"] = true
        map["uuid"] = ""
        return map
    }

    /**
     * 未知，
    系统服务重启中，
    不支持，
    未授权，
    蓝牙关闭，
    蓝牙打开
     */
    fun makeBleState(state: Int): Map<String, Any?> {
        val result = when (state) {
            BluetoothAdapter.STATE_OFF -> {
                Constants.BluetoothState.OFF
            }

            BluetoothAdapter.STATE_ON -> {
                Constants.BluetoothState.ON
            }

            Constants.BluetoothState.NOT_SUPPORT.ordinal -> {
                Constants.BluetoothState.NOT_SUPPORT
            }

            else -> Constants.BluetoothState.UNKNOWN
        }
        val map = hashMapOf<String, Any?>()
        map["state"] = result.ordinal
        return map
    }

    /**
     * 解析服务列表
     */
    fun makeServiceList(deviceAddress: String, gatt: BluetoothGatt): Map<String, Any?> {
        val map = hashMapOf<String, Any?>()
        map["macAddress"] = deviceAddress
        map["servicesUUID"] = gatt.services?.map { it.uuid.toString() }?.toMutableList() ?: mutableListOf<String>()
        return map
    }

    fun makePairResult(deviceAddress: String, paired: Boolean): Map<String, Any?> {
        val map = hashMapOf<String, Any?>()
        map["macAddress"] = deviceAddress
        map["uuid"] = ""
        map["isPair"] = paired
        return map
    }

    /**
     * @param state 参考[BleDFUState]
     */
    fun makeDfuState(deviceAddress: String, state: Int, value: Any?): Map<String, Any?> {
        val map = hashMapOf<String, Any?>()
        map["macAddress"] = deviceAddress
        map["uuid"] = ""
        map["state"] = state
        map["error"] = state
        map["progress"] = state
        map["data"] = value
        return map
    }
}