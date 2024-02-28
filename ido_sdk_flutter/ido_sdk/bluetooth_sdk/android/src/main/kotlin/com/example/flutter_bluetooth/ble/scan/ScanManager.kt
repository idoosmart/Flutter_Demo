package com.example.flutter_bluetooth.ble.scan

import android.annotation.SuppressLint
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothProfile
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.content.Context
import android.os.Build
import android.os.ParcelUuid
import android.text.TextUtils
import com.example.flutter_bluetooth.Config
import com.example.flutter_bluetooth.IDOScanSettings
import com.example.flutter_bluetooth.ble.callback.BaseLeScanner
import com.example.flutter_bluetooth.ble.protocol.ProtoMaker
import com.example.flutter_bluetooth.logger.Logger
import com.example.flutter_bluetooth.utils.PairedDeviceUtils
import java.util.*

/**
 * @author tianwei
 * @date 2022/12/29
 * @time 17:13
 * 用途:
 */
@SuppressLint("MissingPermission")
class ScanManager() : BaseLeScanner() {

    /**
     * 是否允许重复
     */
    private var allowDuplicates = false

    /**
     * 是否过滤无名的设备
     */
    private var filterEmptyDeviceName = true

    /**
     * 扫描到的设备mac address
     */
    private var macDeviceScanned = arrayListOf<String>()

    private var scanLeCallback: ScanLeCallBack? = null
    private var mBluetoothManager: BluetoothManager? = null
    private var mBluetoothAdapter: BluetoothAdapter? = null
    private var scanSettings: IDOScanSettings? = null


    init {
        mBluetoothManager = Config.getApplication().getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager?
        mBluetoothAdapter = mBluetoothManager?.adapter
    }

    companion object {
        private var instance: ScanManager? = null
        fun getInstance(): ScanManager {
            if (instance == null) {
                instance = ScanManager()
            }
            return instance!!
        }
    }

    private var scanCallback21 = object : ScanCallback() {
        override fun onScanResult(callbackType: Int, result: ScanResult?) {
            super.onScanResult(callbackType, result)
            result?.let {
                val address = result.device?.address

                if (!TextUtils.isEmpty(scanSettings?.deviceAddress) && !scanSettings?.deviceAddress.equals(address, ignoreCase = true)) {
                    return@let
                }

                val name = result.device?.name ?: ""
                if (filterEmptyDeviceName && name.isEmpty()) return
                if (!allowDuplicates && !address.isNullOrEmpty()) {//过滤重复的
                    if (macDeviceScanned.contains(address)) return
                    macDeviceScanned.add(address)
                }
                callbackOnLeScan(ProtoMaker.makeScanResult(result.device, result))
            }
        }

        override fun onScanFailed(errorCode: Int) {
            super.onScanFailed(errorCode)
        }

        override fun onBatchScanResults(results: MutableList<ScanResult>?) {
            super.onBatchScanResults(results)
        }
    }

    private fun startScan(data: Map<String, Any?>?) {
        val deviceAddress = data?.get("macAddress") as String?
        val UUID = data?.get("UUID") as HashMap<String, Any?>?
        val serviceUUIDs = UUID?.get("UUID") as MutableList<String>?
        Logger.d("startScan , deviceAddress = $deviceAddress , serviceUUIDs = $serviceUUIDs")
        scanSettings = IDOScanSettings(serviceUUIDs, deviceAddress?.uppercase())
        macDeviceScanned.clear()
        startScan()
    }

    override fun startLeScan(data: Map<String, Any?>?, scanLeCallback: ScanLeCallBack?) {
        this.scanLeCallback = scanLeCallback
        startScan(data)
    }

    private fun createScanSetting(): ScanSettings? {
        val builder = ScanSettings.Builder() //设置高功耗模式
            .setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)
        //android 6.0添加设置回调类型、匹配模式等
        if (Build.VERSION.SDK_INT >= 23) {
            //定义回调类型
            builder.setCallbackType(ScanSettings.CALLBACK_TYPE_ALL_MATCHES)
            //设置蓝牙LE扫描滤波器硬件匹配的匹配模式
            builder.setMatchMode(ScanSettings.MATCH_MODE_AGGRESSIVE)
        }
        //芯片组支持批处理芯片上的扫描
        if (BluetoothAdapter.getDefaultAdapter().isOffloadedScanBatchingSupported) {
            //设置蓝牙LE扫描的报告延迟的时间（以毫秒为单位）
            //设置为0以立即通知结果
            builder.setReportDelay(0L)
        }
        return builder.build()
    }

    private fun startScan() {
        val scanner = mBluetoothAdapter?.bluetoothLeScanner
        if (scanner == null) {
            Logger.e("[ScanManager] BluetoothLeScanner is null!, please check is adapter on?")
            return
        }
        Logger.d("[ScanManager] startScan, settings = $scanSettings")
        val scanFilter = scanSettings?.serviceUuidsList?.map {
            val filter = ScanFilter.Builder().setServiceUuid(ParcelUuid.fromString(it))
            filter.build()
        }?.toMutableList() ?: mutableListOf()
        scanner.startScan(scanFilter, createScanSetting(), scanCallback21)
        Logger.p("[ScanManager] " + PairedDeviceUtils.getAllPairedDeviceInfo())
        Logger.d("[ScanManager] start scan...")
        getConnectedDevicesAndSendNotify()
    }

    /**
     * 获取当前手机已连上的手环设备（同一个手环，可以被同一个手机上的多个应用程序连接）
     */
    private fun getConnectedDevicesAndSendNotify() {
        val deviceList: List<BluetoothDevice>? = mBluetoothManager?.getConnectedDevices(BluetoothProfile.GATT)
        if (deviceList == null || deviceList.isEmpty()) {
            Logger.p("getConnectedDevicesAndSendNotify, empty connected devices!")
            return
        }
        var gattConnectedListInfo = ""
        for (device in deviceList) {
            gattConnectedListInfo += device.address + "/" + device.name
            if (!macDeviceScanned.contains(device.address)) {
                if (TextUtils.isEmpty(device.name)) {
                    continue
                }
                callbackOnLeScan(ProtoMaker.makeScanResult(device, null, -1))

            }
        }
        Logger.p("getConnectedDevicesAndSendNotify, $gattConnectedListInfo")
    }

    override fun stopLeScan() {
        Logger.d("[ScanManager] stop scan...")
        scanLeCallback = null
        mBluetoothAdapter?.bluetoothLeScanner?.stopScan(scanCallback21)
    }

    override fun callbackOnLeScan(scanResult: Map<String, Any?>) {
        Logger.d("[ScanManager] scanResult = $scanResult")
        scanLeCallback?.onScanLeResult(scanResult)
    }
}