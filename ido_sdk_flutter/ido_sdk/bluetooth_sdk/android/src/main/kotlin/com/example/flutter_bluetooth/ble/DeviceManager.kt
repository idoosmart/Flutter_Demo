package com.example.flutter_bluetooth.ble

import android.os.Handler
import android.os.Looper
import com.example.flutter_bluetooth.ble.callback.BluetoothCallback
import com.example.flutter_bluetooth.ble.callback.ConnectCallBack
import com.example.flutter_bluetooth.ble.callback.CustomCmdResponseCallback
import com.example.flutter_bluetooth.ble.callback.EnterDfuModeCallback
import com.example.flutter_bluetooth.ble.device.IDOBleDevice
import com.example.flutter_bluetooth.bt.IDOBTDevice
import com.example.flutter_bluetooth.dfu.BleDFUConstants
import com.example.flutter_bluetooth.logger.Logger
import java.util.concurrent.ConcurrentHashMap

/**
 * @author tianwei
 * @date 2023/2/1
 * @time 10:00
 * 用途:
 */
object DeviceManager {
    /**
     * 缓存连接的ble设备
     */
    private var mConnectedDevices = ConcurrentHashMap<String, IDOBleDevice>()

    /**
     * 缓存bt设备，与ble区分
     */
    private var mCacheBTDevices = ConcurrentHashMap<String, IDOBTDevice>()


    private var mainHandler = Handler(Looper.getMainLooper())

    /**
     * 全部断连，可在蓝牙关闭的时候调用
     */
    fun disconnectAll() {
        Logger.p("disconnectAll")
        mConnectedDevices.values.forEach {
            it.toDisconnectDevice()
        }
    }

    fun locateBTDevice(deviceAddress: String?): IDOBTDevice? {
        if (deviceAddress.isNullOrEmpty()) return null
        return mCacheBTDevices[deviceAddress]
    }

    fun createBTDevice(deviceAddress: String?): IDOBTDevice? {
        if (deviceAddress.isNullOrEmpty()) {
            Logger.p("createBTDevice failed, the deviceAddress is null or empty!")
            return null
        }
        var btDevice = mCacheBTDevices[deviceAddress]
        if (btDevice != null) {
            Logger.p("createBTDevice device $deviceAddress already exist!")
            return btDevice
        }
        Logger.p("createBTDevice $deviceAddress")
        btDevice = IDOBTDevice(deviceAddress)
        mCacheBTDevices[deviceAddress] = btDevice
        return btDevice
    }

    fun deleteBTDevice(deviceAddress: String?) {
        if (deviceAddress.isNullOrEmpty()) {
            Logger.p("deleteBTDevice failed, the deviceAddress is null or empty!")
            return
        }
        mCacheBTDevices.remove(deviceAddress)
    }

    /**
     * 获取缓存的设备对象
     */
    fun locateBleDevice(deviceAddress: String?): IDOBleDevice? {
        if (deviceAddress.isNullOrEmpty()) return null
        return mConnectedDevices[deviceAddress]
    }

    /**
     * 创建设备
     */
    fun createBleDevice(deviceAddress: String?, bluetoothCallback: BluetoothCallback): IDOBleDevice? {
        if (deviceAddress.isNullOrEmpty()) {
            Logger.p("createBleDevice failed, the deviceAddress is null or empty!")
            return null
        }
        var bleDevice = mConnectedDevices[deviceAddress]
        if (bleDevice != null) {
            Logger.p("createBleDevice device $deviceAddress already exist!")
            return bleDevice
        }
        Logger.p("createBleDevice $deviceAddress")
        bleDevice = IDOBleDevice(deviceAddress)
        bleDevice.mBluetoothCallback = bluetoothCallback
        mConnectedDevices[deviceAddress] = bleDevice
        return bleDevice
    }

    /**
     * 删除ble设备
     */
    fun deleteBleDevice(deviceAddress: String?) {
        if (deviceAddress.isNullOrEmpty()) {
            Logger.p("deleteBleDevice failed, the deviceAddress is null or empty!")
            return
        }
        mConnectedDevices.remove(deviceAddress)
    }

    /**
     * ble设备是否已连接
     */
    @JvmStatic
    fun isConnected(deviceAddress: String?): Boolean {
        return locateBleDevice(deviceAddress)?.isConnected() ?: false
    }

    @JvmStatic
    fun enterDfuMode(deviceAddress: String, callback: EnterDfuModeCallback.ICallBack?) {
        locateBleDevice(deviceAddress)?.writeCustomDataToDevice(BleDFUConstants.Cmd.ENTER_DFU_MODE, object : CustomCmdResponseCallback {
            override fun onResponse(byteArray: ByteArray) {
                callback?.let {
                    if (byteArray.size >= 3) {
                        when (byteArray[2].toInt()) {
                            0x00 -> {
                                it.onSuccess()
                            }
                            0x01 -> {
                                it.onError(EnterDfuModeCallback.DfuError.LOW_BATTERY)
                            }
                            0x02 -> {
                                it.onError(EnterDfuModeCallback.DfuError.DEVICE_NOT_SUPPORT)
                            }
                            0x03 -> {
                                it.onError(EnterDfuModeCallback.DfuError.PARA_ERROR)
                            }
                            else -> {
                                it.onError(EnterDfuModeCallback.DfuError.PARA_OTHER)
                            }
                        }
                    }
                }
            }
        })
    }

    @JvmStatic
    fun cancelEnterDfuMode(deviceAddress: String) {
        locateBleDevice(deviceAddress)?.giveUpCustomResult(BleDFUConstants.Cmd.ENTER_DFU_MODE)
    }

    @JvmStatic
    fun dfuConnect(deviceAddress: String, callBack: ConnectCallBack?) {
        //连接必须在主线程
        mainHandler.post {
            val device = locateBleDevice(deviceAddress)
            if (device != null) {
                if (callBack != null) {
                    device.registerConnectCallback(callBack)
                }
                device.toConnectDevice()
            } else {
                Logger.e("dfuConnect device is null!")
            }
        }
    }

    @JvmStatic
    fun cancelDufConnect(deviceAddress: String, callBack: ConnectCallBack?) {
        val device = locateBleDevice(deviceAddress)
        if (device != null) {
            if (callBack != null) {
                device.unregisterConnectCallback(callBack)
            }
        } else {
            Logger.e("cancelDufConnect device is null!")
        }
    }

    @JvmStatic
    fun disConnect(deviceAddress: String, callBack: ConnectCallBack?) {
//        locateBleDevice(deviceAddress)?.disConnect(callBack)
        mainHandler.post {
            val device = locateBleDevice(deviceAddress)
            if (device != null) {
                if (callBack != null) {
                    device.registerConnectCallback(callBack)
                }
                device.toDisconnectDevice()
            } else {
                Logger.e("disConnect device is null!")
            }
        }
    }

    @JvmStatic
    fun cancelDisconnect(deviceAddress: String, callBack: ConnectCallBack?) {
        val device = locateBleDevice(deviceAddress)
        if (device != null) {
            if (callBack != null) {
                device.unregisterConnectCallback(callBack)
            }
        } else {
            Logger.e("disConnect device is null!")
        }
    }
}