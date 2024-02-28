package com.example.flutter_bluetooth.bt

import android.bluetooth.BluetoothA2dp
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothProfile
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.text.TextUtils
import com.example.flutter_bluetooth.Config
import com.example.flutter_bluetooth.logger.Logger

/**
 * @author tianwei
 * @date 2023/11/16
 * @time 10:56
 * 用途:
 */
class A2dpConnectHelper(val deviceAddress: String) {

    private var hasChanged = false

    /**
     * 连接状态
     */
    var state: Int = -1

    var onA2dpConnectChangedListener: OnA2dpConnectChangedListener? = null

    constructor(deviceAddress: String, onA2dpConnectChangedListener: OnA2dpConnectChangedListener? = null) : this(deviceAddress) {
        this.onA2dpConnectChangedListener = onA2dpConnectChangedListener
    }

    private val mA2dpStateBroadcastReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val action = intent.action
            if (action == BluetoothA2dp.ACTION_CONNECTION_STATE_CHANGED) {
                val tempDevice = intent.getParcelableExtra<BluetoothDevice>(BluetoothDevice.EXTRA_DEVICE)
                if (!TextUtils.isEmpty(deviceAddress) && tempDevice?.address == deviceAddress) {
                    val a2dpPreviousState = intent.getIntExtra(BluetoothA2dp.EXTRA_PREVIOUS_STATE, 0)
                    val a2dpState = intent.getIntExtra(BluetoothA2dp.EXTRA_STATE, 0)
                    state = a2dpState
                    hasChanged = true
                    logP("onReceive device(${tempDevice?.address})'s A2dp state changed, previous = $a2dpPreviousState, newState = $a2dpState")
                    if (a2dpState == BluetoothA2dp.STATE_CONNECTED) {
                        logP("A2dp is connected!")
                    } else if (a2dpState == BluetoothA2dp.STATE_DISCONNECTED) {
                        logP("A2dp is disconnected!")
                    }
                    onA2dpConnectChangedListener?.onA2dpConnectChanged(deviceAddress, a2dpPreviousState, a2dpState)
                }
            }
        }
    }

    fun getA2dpState(): Int {
        if (state == -1 || !hasChanged) {//没有获取过，或没有收到过变动记录的，主动获取
            state = A2dpManager.instance.getA2dpState(deviceAddress)
            logP("first time to get a2dp state: $state")
        }
        return state
    }

    interface OnA2dpConnectChangedListener {
        /**
         * @param previousState
         * @param newState
         */
        fun onA2dpConnectChanged(deviceAddress: String, previousState: Int, newState: Int)
    }

    private fun logP(msg: String) {
        Logger.p("[A2DPConnectHelper]$msg")
    }

    fun destroy() {
        onA2dpConnectChangedListener = null
        Config.getApplication().unregisterReceiver(mA2dpStateBroadcastReceiver)
        hasChanged = false
    }

    init {
        logP("初始化")
        val bondFilter = IntentFilter(BluetoothA2dp.ACTION_CONNECTION_STATE_CHANGED)
        Config.getApplication().registerReceiver(mA2dpStateBroadcastReceiver, bondFilter)
    }
}