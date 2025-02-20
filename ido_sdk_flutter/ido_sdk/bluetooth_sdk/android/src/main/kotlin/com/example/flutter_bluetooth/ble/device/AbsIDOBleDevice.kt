package com.example.flutter_bluetooth.ble.device

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import com.example.flutter_bluetooth.ble.callback.BluetoothCallback
import com.example.flutter_bluetooth.ble.callback.ConnectCallBack
import com.example.flutter_bluetooth.ble.callback.CustomCmdResponseCallback
import com.example.flutter_bluetooth.dfu.BleDFUConfig
import com.example.flutter_bluetooth.dfu.BleDFUState
import com.example.flutter_bluetooth.dfu.ConnectFailedReason
import com.example.flutter_bluetooth.dfu.IDfu
import com.example.flutter_bluetooth.logger.Logger.p
import com.example.flutter_bluetooth.utils.ByteDataConvertUtil
import com.example.flutter_bluetooth.utils.Constants

/**
 * @author tianwei
 * @date 2023/2/1
 * @time 9:49
 * 用途:
 */
abstract class AbsIDOBleDevice(val deviceAddress: String) : BytesDataConnect(deviceAddress), IDfu {

    //目前只处理nordic平台
    private var dfu: NodicDFUManager = NodicDFUManager()

    /**
     * 自定义指令回调
     */
    private var mCustomCmdResponseCallbacks: HashMap<String, CustomCmdResponseCallback> = hashMapOf()

    /**
     * 蓝牙回调，供channel使用
     */
    var mBluetoothCallback: BluetoothCallback? = null

    /**
     * 连接回调，供内部调用
     */
    private var mConnectCallbacks: MutableList<ConnectCallBack> = mutableListOf()

    fun registerConnectCallback(callBack: ConnectCallBack) {
        mConnectCallbacks.add(callBack)
    }

    fun unregisterConnectCallback(callBack: ConnectCallBack) {
        val it = mConnectCallbacks.iterator()
        while (it.hasNext()) {
            val item = it.next()
            if (item == callBack) {
                it.remove()
            }
        }
    }

    override fun startDFU(config: BleDFUConfig, listener: BleDFUState.IListener): Boolean {
        return dfu.start(config, listener)
    }

    override fun cancelDFU() {
        dfu.cancel()
    }

    override fun isInDFU(): Boolean {
        return dfu.isDoing
    }

    fun toConnectDevice(isDueToPhoneBluetoothSwitch: Boolean) {
        connect()
    }

    fun toConnectDevice() {
        connect()
    }


    fun toConnectDevice(timeoutMills: Long) {
        connect(timeoutMills)
    }

    open fun toDisconnectDevice() {
        disConnect()
    }

    fun isConnected(): Boolean {
        return isConnectedAndReady
    }

    open fun isConnecting(): Boolean {
        return isGattConnecting
    }

    open fun getConnectState(): Int {
        return if (isConnected()) {
            Constants.BleConnectState.STATE_CONNECTED
        } else if (isConnecting()) {
            Constants.BleConnectState.STATE_CONNECTING
        } else {
            Constants.BleConnectState.STATE_DISCONNECTED
        }
    }

    fun writeDataToDevice(bytes: ByteArray,platform: Int) {
        val request = ByteDataRequest()
        request.sendData = bytes
        request.platform = platform
        addCmdData(request, false)
    }

    /**
     * 发送自定义的指令，目前不支持v3长包指令
     */
    fun writeCustomDataToDevice(bytes: ByteArray, callback: CustomCmdResponseCallback?) {
        if (!filterCustomData(bytes)) {
            p("writeCustomDataToDevice, ${ByteDataConvertUtil.bytesToHexString(bytes)} is not standard custom cmd!")
            return
        }
        if (callback != null) {
            mCustomCmdResponseCallbacks["${bytes[0]}${bytes[1]}"] = callback
        }
        p("writeCustomDataToDevice, ${ByteDataConvertUtil.bytesToHexString(bytes)}")
        writeDataToDevice(bytes,0)
    }

    /**
     * 放弃自定义指令结果
     */
    fun giveUpCustomResult(bytes: ByteArray) {
        if (filterCustomData(bytes)) {
            p("giveUpCustomResult, ${ByteDataConvertUtil.bytesToHexString(bytes)}")
            mCustomCmdResponseCallbacks.remove("${bytes[0]}${bytes[1]}")
        } else {
            p("giveUpCustomResult, ${ByteDataConvertUtil.bytesToHexString(bytes)} is not standard custom cmd!")
        }
    }

    /**
     * 过滤自定义指令
     */
    private fun filterCustomData(bytes: ByteArray?): Boolean {
        //目前先只过滤33的长包
        return bytes != null && bytes[0].toInt() != 0x33 && bytes.size >= 2
    }

    override fun callOnConnectFailedByBluetoothSwitchClosed() {
        mBluetoothCallback?.callOnConnectFailedByBluetoothSwitchClosed()
        mConnectCallbacks.forEach {
            it.onConnectFailed(ConnectFailedReason.BLUETOOTH_SWITCH_CLOSED)
        }
    }

    override fun callOnDiscoverServiceFailed() {
        mBluetoothCallback?.callOnDiscoverServiceFailed()
        mConnectCallbacks.forEach {
            it.onConnectFailed(ConnectFailedReason.DISCOVER_SERVICE_FAILED)
        }
    }

    override fun callOnConnectFailedByEncryptedFailed() {
        mBluetoothCallback?.callOnConnectFailedByEncryptedFailed()
        mConnectCallbacks.forEach {
            it.onConnectFailed(ConnectFailedReason.ENCRYPTED_FAILED)
        }
    }

    override fun callOnEnableNormalNotifyFailed() {
        mBluetoothCallback?.callOnEnableNormalNotifyFailed()
        mConnectCallbacks.forEach {
            it.onConnectFailed(ConnectFailedReason.ENABLE_NOTIFY_FAILED)
        }
    }

    override fun callOnConnectedAndReady(platform:Int) {
        mBluetoothCallback?.callOnConnectedAndReady(platform)
        mConnectCallbacks.forEach {
            it.onConnectSuccess()
        }
    }

    override fun callOnEnableHealthNotifyFailed() {
        mBluetoothCallback?.callOnEnableHealthNotifyFailed()
        mConnectCallbacks.forEach {
            it.onConnectFailed(ConnectFailedReason.ENABLE_NOTIFY_FAILED)
        }
    }

    override fun callOnConnectStart() {
        mBluetoothCallback?.callOnConnectStart()
        mConnectCallbacks.forEach {
            it.onConnectStart()
        }
    }

    override fun callOnConnectFailedByErrorMacAddress() {
        mBluetoothCallback?.callOnConnectFailedByErrorMacAddress()
        mConnectCallbacks.forEach {
            it.onConnectFailed(ConnectFailedReason.MAC_ADDRESS_INVALID)
        }
    }

    override fun callOnConnecting() {
        mBluetoothCallback?.callOnConnecting()
        mConnectCallbacks.forEach {
            it.onConnecting()
        }
    }

    override fun callOnConnectTimeOut() {
        super.callOnConnectTimeOut()
        mBluetoothCallback?.callOnConnectTimeOut()
        mConnectCallbacks.forEach {
            it.onConnectFailed(ConnectFailedReason.ERROR_OTHER)
        }
    }

    override fun callOnConnectBreakByGATT(status: Int, newState: Int,platform: Int) {
        super.callOnConnectBreakByGATT(status, newState,platform)
        mBluetoothCallback?.callOnConnectBreakByGATT(status, newState,platform)
        mConnectCallbacks.forEach {
            it.onConnectBreak()
        }
    }

    override fun callOnInDfuMode() {
        mBluetoothCallback?.callOnInDfuMode()
        mConnectCallbacks.forEach {
            it.onInDfuMode()
        }
    }

    override fun callOnConnectFailedByGATT(status: Int, newState: Int,platform: Int) {
        mBluetoothCallback?.callOnConnectFailedByGATT(status, newState,platform)
        mConnectCallbacks.forEach {
            it.onConnectFailed(ConnectFailedReason.SYSTEM_GATT_ERROR)
        }
    }

    override fun callOnCharacteristicWrite(gatt: BluetoothGatt?, characteristic: BluetoothGattCharacteristic?, status: Int) {
        super.callOnCharacteristicWrite(gatt, characteristic, status)
        mBluetoothCallback?.callOnCharacteristicWrite(gatt, characteristic, status)
    }

    override fun callOnCharacteristicChanged(gatt: BluetoothGatt?, characteristic: BluetoothGattCharacteristic?) {
        super.callOnCharacteristicChanged(gatt, characteristic)
        val bytes = characteristic?.value
        if (bytes == null || bytes.size < 1) {
            p("callOnCharacteristicChanged,characteristic?.value is empty")
            return
        }
        if (filterCustomData(characteristic?.value) && mCustomCmdResponseCallbacks.isNotEmpty() && mCustomCmdResponseCallbacks.containsKey("${bytes!![0]}${bytes[1]}")
        ) {
            //拦截自定义指令
            mCustomCmdResponseCallbacks.remove("${bytes!![0]}${bytes[1]}")?.onResponse(bytes)
        } else {
            mBluetoothCallback?.callOnCharacteristicChanged(gatt, characteristic)
        }
    }

    override fun callOnGattErrorAndNeedRebootBluetooth() {
    }

    override fun callOnConnectClosed() {
        super.callOnConnectClosed()
        mBluetoothCallback?.callOnConnectClosed()
    }


    override fun callOnServices(services: List<String>) {
        mBluetoothCallback?.callOnServices(services)
    }

}