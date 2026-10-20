package com.idosmart.bluetooth.ble.device

import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import com.idosmart.bluetooth.ble.callback.BluetoothCallback
import com.idosmart.bluetooth.ble.callback.ConnectCallBack
import com.idosmart.bluetooth.ble.callback.CustomCmdResponseCallback
import com.idosmart.bluetooth.dfu.BleDFUConfig
import com.idosmart.bluetooth.dfu.BleDFUState
import com.idosmart.bluetooth.dfu.ConnectFailedReason
import com.idosmart.bluetooth.dfu.IDfu
import com.idosmart.bluetooth.logger.Logger.p
import com.idosmart.bluetooth.utils.ByteDataConvertUtil
import com.idosmart.bluetooth.utils.Constants

/**
 * @author tianwei
 * @date 2023/2/1
 * @time 9:49
 * 用途:
 */
abstract class AbsIDOBleDevice(val deviceAddress: String) : BytesDataConnect(deviceAddress), IDfu {

    companion object {
        /** Nordic DFU 库代表性类；compileOnly 下须在创建 NodicDFUManager 前探测。 */
        private const val NORDIC_DFU_STARTER_CLASS =
            "no.nordicsemi.android.dfu.DfuServiceInitiator"
    }

    /**
     * Nordic 传统 DFU。懒加载：避免普通连设备时加载 nordicsemi 类（App 可能未声明 dfu 依赖）。
     */
    private var dfu: NodicDFUManager? = null

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

    private fun isNordicDfuLibAvailable(): Boolean {
        return try {
            Class.forName(NORDIC_DFU_STARTER_CLASS)
            true
        } catch (_: ClassNotFoundException) {
            false
        } catch (_: NoClassDefFoundError) {
            false
        }
    }

    private fun ensureDfuManager(): NodicDFUManager? {
        dfu?.let { return it }
        if (!isNordicDfuLibAvailable()) {
            return null
        }
        return NodicDFUManager().also { dfu = it }
    }

    override fun startDFU(config: BleDFUConfig, listener: BleDFUState.IListener): Boolean {
        val manager = ensureDfuManager()
        if (manager == null) {
            p(
                "Nordic DFU lib missing: add implementation " +
                    "'no.nordicsemi.android:dfu:2.5.0' to the app build.gradle"
            )
            listener.onDfuFailed(BleDFUState.FailReason.OTHER, config.macAddress ?: deviceAddress)
            return false
        }
        return manager.start(config, listener)
    }

    override fun cancelDFU() {
        dfu?.cancel()
    }

    override fun isInDFU(): Boolean {
        return dfu?.isDoing == true
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
            p("writeCustomDataToDevice, ${ByteDataConvertUtil.bytesToHexString(bytes, ByteDataConvertUtil.LIMITHEXLEN)} is not standard custom cmd!")
            return
        }
        if (callback != null) {
            mCustomCmdResponseCallbacks["${bytes[0]}${bytes[1]}"] = callback
        }
        p("writeCustomDataToDevice, ${ByteDataConvertUtil.bytesToHexString(bytes, ByteDataConvertUtil.LIMITHEXLEN)}")
        writeDataToDevice(bytes,0)
    }

    /**
     * 放弃自定义指令结果
     */
    fun giveUpCustomResult(bytes: ByteArray) {
        if (filterCustomData(bytes)) {
            p("giveUpCustomResult, ${ByteDataConvertUtil.bytesToHexString(bytes, ByteDataConvertUtil.LIMITHEXLEN)}")
            mCustomCmdResponseCallbacks.remove("${bytes[0]}${bytes[1]}")
        } else {
            p("giveUpCustomResult, ${ByteDataConvertUtil.bytesToHexString(bytes, ByteDataConvertUtil.LIMITHEXLEN)} is not standard custom cmd!")
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

    override fun callOnDeviceHasBeenReset() {
        mBluetoothCallback?.callOnDeviceHasBeenReset()
    }

    override fun callOnDeviceAlreadyBindAndNotSupportRebind() {
        mBluetoothCallback?.callOnDeviceAlreadyBindAndNotSupportRebind()
    }

    override fun callOnConnectTerminated() {
        mBluetoothCallback?.callOnConnectTerminated()
    }
}