package com.example.flutter_bluetooth.bt

import android.annotation.SuppressLint
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Handler
import android.os.Looper
import com.example.flutter_bluetooth.Config
import com.example.flutter_bluetooth.logger.Logger
import com.example.flutter_bluetooth.utils.PairedDeviceUtils


/**
 * @author tianwei
 * @date 2022/12/28
 * @time 9:14
 * 用途:配对管理
 */
@SuppressLint("MissingPermission")
open class BTPair(val deviceAddress: String?) {
    private var currentTryTimes = 0
    private val mainHandler = Handler(Looper.getMainLooper())
    private var bondStateListener: IBondStateListener? = null

    private fun logP(msg: String) {
        Logger.p("[$deviceAddress]$msg")
    }

    fun removePair(): Boolean {
        return PairedDeviceUtils.removeBondState(deviceAddress)
    }

    fun createPair(listener: IBondStateListener?) {
        bondStateListener = listener
        if (deviceAddress.isNullOrEmpty()) {
            logP("[BTConnectPresenter] connect deviceAddress is empty")
//            failed()
            return
        }
        currentTryTimes = 0
        realPair()
    }

    private fun realPair() {
        logP("[BTConnectPresenter] connect. currentTryTimes:$currentTryTimes, deviceAddress = $deviceAddress")
        if (PairedDeviceUtils.isPaired(deviceAddress)) {
            logP("[BTConnectPresenter] has paired.")
            success()
            return
        }
        if (pair(deviceAddress)) {
            logP("[BTConnectPresenter] pairing, wait user confirm!")
        }else{
            logP("[BTConnectPresenter] pair failed!")
        }
//        scanBtDevice(deviceAddress)
    }

    open fun pair(strAddr: String?): Boolean {
        val result = false
        logP("[BTConnectPresenter] pair start: $strAddr")
        //蓝牙设备适配器
        val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        val device = bluetoothAdapter?.getRemoteDevice(strAddr) ?: return false
        logP("[BTConnectPresenter] createBond: ${device.name}(${device.address})")
        PairedDeviceUtils.createBond(device)
        return result
    }

    private fun scanBtDevice(deviceAddress: String?) {
        logP("[BTConnectPresenter] scanBtDevice")
        BTDeviceScanManager.getManager().startScan(object : IBTScanListener {
            override fun onFind(device: BluetoothDevice) {
                connect(device)
            }

            override fun onNotFind() {
                logP("[BTConnectPresenter] scanBtDevice. not find device")
                failed()
            }
        }, deviceAddress)
    }

    private fun connect(device: BluetoothDevice) {
        logP("[BTConnectPresenter] scanBtDevice ok, connect " + device.name)
        // device.createBond();
        PairedDeviceUtils.createBond(device)
    }

    private fun repair() {
        realPair()
    }

    private fun failed() {
        logP("[BTConnectPresenter] failed.")
        if (currentTryTimes < maxTryTimes) {
            currentTryTimes++
            logP("[BTConnectPresenter] retry connect currentTryTimes:$currentTryTimes")
            mainHandler.postDelayed({ repair() }, 2000)
        } else {
            bondStateListener?.onBondFailed(deviceAddress, -1, "")
        }
    }

    private fun success() {
        logP("[BTConnectPresenter] success.")
        bondStateListener?.onBonded(deviceAddress)
    }

    private val mBondStateBroadcastReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val tempDevice = intent.getParcelableExtra<BluetoothDevice>(BluetoothDevice.EXTRA_DEVICE)
            val action = intent.action
            logP("onReceive mac is " + tempDevice!!.address + ";action=" + action)
            if (action == BluetoothDevice.ACTION_ACL_CONNECTED) {
                logP("onReceive ACTION_ACL_CONNECTED ")
            } else if (action == BluetoothDevice.ACTION_ACL_DISCONNECTED) {
                logP("onReceive ACTION_ACL_DISCONNECTED ")
            } else if (action == BluetoothDevice.ACTION_BOND_STATE_CHANGED) {
                val bondState = intent.getIntExtra(BluetoothDevice.EXTRA_BOND_STATE, -1)
                logP("onReceive bondState is $bondState")
                if (bondState == BluetoothDevice.BOND_BONDED) {
                    logP("createBond success, mac is" + tempDevice.address)
                    if (tempDevice.address == deviceAddress) {
                        success()
                    }
                }
            }
        }
    }

    init {
        val bondFilter = IntentFilter(BluetoothDevice.ACTION_BOND_STATE_CHANGED)
        bondFilter.addAction(BluetoothDevice.ACTION_ACL_CONNECTED)
        bondFilter.addAction(BluetoothDevice.ACTION_ACL_DISCONNECTED)
        Config.getApplication().registerReceiver(mBondStateBroadcastReceiver, bondFilter)
    }

    companion object {
        private const val maxTryTimes = 5 //总的重试次数
    }
}