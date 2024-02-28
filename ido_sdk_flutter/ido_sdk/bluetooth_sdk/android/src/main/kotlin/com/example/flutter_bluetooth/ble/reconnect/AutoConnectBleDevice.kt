package com.example.flutter_bluetooth.ble.reconnect

import android.bluetooth.BluetoothAdapter
import android.os.Build
import com.example.flutter_bluetooth.ble.DeviceManager
import com.example.flutter_bluetooth.ble.device.AbsIDOBleDevice
import com.example.flutter_bluetooth.dfu.BLEDevice
import com.example.flutter_bluetooth.logger.Logger
import com.example.flutter_bluetooth.utils.OSUtil
import com.example.flutter_bluetooth.utils.PairedDeviceUtils


/**
 * @author tianwei
 * @date 2023/2/18
 * @time 15:21
 * 用途:
 */
open class AutoConnectBleDevice(deviceAddress: String) : AbsIDOBleDevice(deviceAddress) {
    /**
     * 自动重连中
     */
    private var mIsAutoConnecting = false

    /**
     * 调用连接接口前，是否已经扫描到了设备
     */
    private var mHasFindDevice = false

    /**
     * 是否已经尝试过连接不存在的设备
     */
    private var mHasTryConnectNotExistDevice = false

    /**
     * 是否主动断开的, 即调用disconnect方法
     */
    private var mIsInitiativeDisConnect = false

    /**
     * 断线之后是否自动连接
     */
    private val autoConnectIfBreak = true

    /**
     * 扫描到了设备，然后去连接，gatt 报错次数
     */
    private var mFindDeviceAndGattErrorTimes = 0

    /**
     * 本次连接是不是蓝牙开启触发
     */
    private var mIsConnectDueToPhoneBluetoothSwitch = false

    /**
     * 是否需要重置重连次数
     */
    private var mNeedResetReconnectTime = false

    /**
     * 自动连接
     */
    fun autoConnect(isDueToPhoneBluetoothSwitch: Boolean = false) {
        Logger.p("autoConnect($deviceAddress) , isDueToPhoneBluetoothSwitch = $isDueToPhoneBluetoothSwitch")

        mIsInitiativeDisConnect = false

        Logger.p("[AutoConnectBle] toConnectDevice()")

        if (isConnectedAndReady) {
            Logger.e("[AutoConnectBle] is on connected state, ignore this action!")
            callOnConnectedAndReady()
            return
        }

        //如果重启了蓝牙，则重置以下标志

        //如果重启了蓝牙，则重置以下标志
        if (isDueToPhoneBluetoothSwitch) {
            mHasTryConnectNotExistDevice = false
        }

        if (mIsAutoConnecting) {
            //先去取消扫描任务的延时器，如果取消失败，则再去取消重连任务的延时器
            if (!ScanTargetDeviceTask.cancelDelay()) {
                ReconnectTask.cancelDelay()
            }
            Logger.e("[AutoConnectBle] isAutoConnecting = true, ignore this action!")
            callOnConnecting()
            return
        }

        Logger.p("[AutoConnectBle] to connect device, macAddress is $deviceAddress")
        callOnConnectStart()

        mIsAutoConnecting = true

        ReconnectTask.stop()
        mIsConnectDueToPhoneBluetoothSwitch = isDueToPhoneBluetoothSwitch
        toConnect(false)
    }

    override fun toDisconnectDevice() {
        mIsInitiativeDisConnect = true
        Logger.p("[AutoConnectBle] to disconnect.");
        super.toDisconnectDevice()
    }

    private fun toConnect(isFindDevice: Boolean = false) {
        mHasFindDevice = isFindDevice
        connect()
    }

    private fun toConnect(mac: String) {
        mHasFindDevice = false;
        connect(mac)
    }

    override fun isConnecting(): Boolean {
        return mIsAutoConnecting || super.isConnecting()
    }

    override fun callOnInDfuMode() {
        super.callOnInDfuMode()
        Logger.p("[AutoConnectBle]  callOnInDfuMode")
        stopReconnect()
    }

    override fun callOnConnectedAndReady() {
        super.callOnConnectedAndReady()
        Logger.p("[AutoConnectBle]  callOnConnectedAndReady")
        stopReconnect()
    }

    override fun callOnConnectBreakByGATT(status: Int, newState: Int) {
        if (mIsAutoConnecting) {
            Logger.p("[AutoConnectBle]  callOnConnectBreakByGATT, autoConnectIfBreak = $autoConnectIfBreak, mIsInitiativeDisConnect = $mIsInitiativeDisConnect")
            //支持自动断线重连，并且不是主动断开
            if (autoConnectIfBreak && !mIsInitiativeDisConnect) {
                tryReconnect()
            } else {
                Logger.p("[AutoConnectBle]  isAutoConnectIfBreak = false")
                stopReconnect()
                super.callOnConnectBreakByGATT(status, newState)
            }
        } else {
            super.callOnConnectBreakByGATT(status, newState)
        }
    }

    override fun callOnConnectFailedByGATT(status: Int, newState: Int) {
        Logger.p("[AutoConnectBle]  callOnConnectFailedByGATT, mIsAutoConnecting = $mIsAutoConnecting, mHasFindDevice = $mHasFindDevice,  mIsConnectDueToPhoneBluetoothSwitch = $mIsConnectDueToPhoneBluetoothSwitch, status = $status, newState = $newState")
        if (mIsAutoConnecting) {
            if (mHasFindDevice) {
                mFindDeviceAndGattErrorTimes++
                Logger.p("[AutoConnectBle]  mFindDeviceAndGattErrorTimes = $mFindDeviceAndGattErrorTimes")
                mBluetoothCallback?.callOnGattErrorAndNeedRebootBluetooth()
            }
            if (tryConnectNotExistDeviceByGattError()) {
                return
            }
            tryReconnect();
        } else {
            super.callOnConnectFailedByGATT(status, newState)
        }
    }

    override fun callOnConnectFailedByErrorMacAddress() {
        stopReconnect()
        super.callOnConnectFailedByErrorMacAddress()
    }

    override fun callOnConnectFailedByBluetoothSwitchClosed() {
        stopReconnect()
        super.callOnConnectFailedByBluetoothSwitchClosed()
    }

    override fun callOnDiscoverServiceFailed() {
        Logger.e("[AutoConnectBle]  callOnDiscoverServiceFailed mIsAutoConnecting = $mIsAutoConnecting")
        if (mIsAutoConnecting) {
            tryReconnect()
        } else {
            super.callOnDiscoverServiceFailed()
        }
    }

    override fun callOnEnableHealthNotifyFailed() {
        Logger.e("[AutoConnectBle]  callOnEnableHealthNotifyFailed mIsAutoConnecting = $mIsAutoConnecting")
        if (mIsAutoConnecting) {
            tryReconnect()
        } else {
            super.callOnEnableHealthNotifyFailed()
        }
    }

    override fun callOnEnableNormalNotifyFailed() {
        Logger.e("[AutoConnectBle]  callOnEnableNormalNotifyFailed mIsAutoConnecting = $mIsAutoConnecting")
        if (mIsAutoConnecting) {
            tryReconnect()
        } else {
            super.callOnEnableNormalNotifyFailed()
        }
    }

    override fun callOnConnectTimeOut() {
        Logger.e("[AutoConnectBle]  callOnConnectTimeOut mIsAutoConnecting = $mIsAutoConnecting")
        if (mIsAutoConnecting) {
            if (tryConnectNotExistDevice()) {
                return;
            }
            tryReconnect()
        } else {
            super.callOnConnectTimeOut()
        }
    }


    private fun stopReconnect() {
        if (mIsAutoConnecting) {
            Logger.e("[AutoConnectBle]  stop reconnect task")
            mIsAutoConnecting = false
            mIsInitiativeDisConnect = false
            mFindDeviceAndGattErrorTimes = 0
            mIsConnectDueToPhoneBluetoothSwitch = false
            ReconnectTask.stop()
            ScanTargetDeviceTask.stop()
            ScanManager.getManager().stopScanDevices()
        }
    }

    private fun tryReconnect() {
        Logger.p("[AutoConnectBle]  tryReconnect start, reset = $mNeedResetReconnectTime")
        if (mIsInitiativeDisConnect) {
            Logger.e("[AutoConnectBle]  tryReconnect() is refused, mIsInitiativeDisConnect = true")
            stopReconnect()
            return
        }
        if (isInDFU()) {
            Logger.e("[AutoConnectBle]  tryReconnect() is refused, dfu task is doing.")
            stopReconnect()
            return
        }
        ReconnectTask.start(object : ReconnectTask.IStateChangeListener {
            override fun onTry(count: Int) {
                if (count < 2) {
                    Logger.e("[AutoConnectBle] ontry:$count, connect direct")
                    connect()
                } else {
                    scanTargetDevice()
                }
            }

            override fun onOutOfMaxRtyTimes() {
                Logger.e("[AutoConnectBle] failed, onOutOfMaxRtyTimes")
                stopReconnect()
            }
        })
    }

    /**
     * 扫描目标设备（必须要在主线程调用该方法）
     */
    private fun scanTargetDevice() {
        Logger.p("[AutoConnectBle] scanTargetDevice(), address is $deviceAddress")
        if (isConnectedAndReady) {
            Logger.e("[AutoConnectBle] scanTargetDevice() is refused, already connected to device")
            stopReconnect()
            return
        }
//        if (!DeviceManager.isBind()) {
//            Logger.e("[AutoConnectBle]  failed, scanTargetDevice() is refused, not bind")
//            stopReconnect()
//            return
//        }
        if (!BluetoothAdapter.getDefaultAdapter().isEnabled) {
            Logger.e("[AutoConnectBle]  failed,   scanTargetDevice() is refused, bluetooth switch is off")
            callOnConnectFailedByBluetoothSwitchClosed()
            return
        }
        if (!BluetoothAdapter.checkBluetoothAddress(deviceAddress)) {
            Logger.e("[AutoConnectBle]  failed,   scanTargetDevice() is refused, address is invalid")
            callOnConnectFailedByErrorMacAddress()
            return
        }
        Logger.p("[AutoConnectBle] scanTargetDevice...")
        ScanTargetDeviceTask.start(deviceAddress, object : ScanTargetDeviceTask.IStateChangeListener {
            override fun onFind(bleDevice: BLEDevice) {
                /*    if (bleDevice.mIsInDfuMode){
                    callOnInDfuMode(bleDevice);
                }else {*/
                Logger.p("[AutoConnectBle] find target device: $bleDevice")
                if (bleDevice.mIsInDfuMode) {
                    callOnInDfuMode()
                } else {
                    toConnect(true)
                }
                //       }
            }

            override fun onNotFind() {
                callOnGattErrorAndNeedRebootBluetooth()
            }

            override fun tryConnectDirect(macAddress: String): Boolean {
                return tryToConnectDirect()
            }

            override fun onStopByPhoneBluetoothSwitchClosed() {
                Logger.e("[AutoConnectBle] failed, onStopByPhoneBluetoothSwitchClosed")
                callOnConnectFailedByBluetoothSwitchClosed()
            }

            override fun onInConnectState() {
                stopReconnect()
            }
        })
    }

    private fun tryToConnectDirect(): Boolean {
        Logger.p("[AutoConnectBle] try To Connect Direct")
        toConnect(false)
        return true
    }

    /**
     * 有些 android 9,10 手机的蓝牙有一些bug，如果一直连接某个设备失败，
     * 则需connect一下别的设备，然后再回来连接目标设备
     * 否则会一直失败
     */
    private fun tryConnectNotExistDevice(): Boolean {
        Logger.p("[AutoConnectBle] tryConnectNotExistDevice, errorTimes = $mFindDeviceAndGattErrorTimes, mHasTryConnectNotExistDevice = $mHasTryConnectNotExistDevice")

        if (mFindDeviceAndGattErrorTimes <= 3) {
            return false
        }
        if (!BluetoothAdapter.getDefaultAdapter().isEnabled) {
            return false
        }
        if (Build.VERSION.SDK_INT < 28) {
            return false
        }

        if (mHasTryConnectNotExistDevice) {
            return false
        }
        mHasTryConnectNotExistDevice = true

        Logger.p("[AutoConnectBle] try To Connect not exist device...")
        //连接一个不存在的设备
        toConnect("AA:BB:CC:DD:EE:FF")
        return true
    }

    /**
     * 有些 android 9,10 手机的蓝牙有一些bug，如果一直连接某个设备失败，
     * 则需connect一下别的设备，然后再回来连接目标设备
     * 否则会一直失败
     *
     * 该方法是在重连时，连续两次直连后还是失败，则会扫描设备，如果扫描出来设备重连还是报133，则会尝试调用该方法
     */
    private fun tryConnectNotExistDeviceByGattError(): Boolean {
        val isNeedUnPair = OSUtil.isMagicOS() && mIsConnectDueToPhoneBluetoothSwitch
        Logger.p("[AutoConnectBle] gatt error, isNeedUnPair = $isNeedUnPair, errorTimes = $mFindDeviceAndGattErrorTimes, tried = $mHasTryConnectNotExistDevice")
        //magicos 出现133时，如果是因为开关蓝牙，则直接解除配对后重新连接
        // 因为这里已经经历了两次直连和一次扫描连接了，没必要再重试了
        if (isNeedUnPair) {
            if (mFindDeviceAndGattErrorTimes < 1) {
                return false
            }
        } else if (mFindDeviceAndGattErrorTimes <= 3) {
            return false
        }

        if (!BluetoothAdapter.getDefaultAdapter().isEnabled) {
            return false
        }
        if (Build.VERSION.SDK_INT < 28) {
            return false
        }

        try {
            if (isNeedUnPair) {
                val isBtPaired = PairedDeviceUtils.isPaired(deviceAddress)
                if (isBtPaired) {
                    Logger.p("[AutoConnectBle] Magic OS & bt is paired, now unpair it and reconnect!")
                    PairedDeviceUtils.removeBondState(deviceAddress)
//                    mNeedResetReconnectTime = true
                    return false
                } else {
                    Logger.p("[AutoConnectBle] Magic OS but bt is not paired")
                }
            }
        } catch (e: Exception) {
            Logger.p("[AutoConnectBle] Magic OS process error: $e")
        }

        if (mHasTryConnectNotExistDevice) {
            return false
        }
        mHasTryConnectNotExistDevice = true


        Logger.p("[AutoConnectBle] try To Connect not exist device...")
        //连接一个不存在的设备
        toConnect("AA:BB:CC:DD:EE:FF")
        return true
    }
}