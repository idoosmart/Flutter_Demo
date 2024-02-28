package com.example.flutter_bluetooth.bt

import android.annotation.SuppressLint
import android.bluetooth.BluetoothA2dp
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothProfile
import com.example.flutter_bluetooth.Config
import com.example.flutter_bluetooth.logger.Logger
import com.example.flutter_bluetooth.utils.IDOPermission

/**
 * @author tianwei
 * @date 2023/11/16
 * @time 12:28
 * 用途:
 */
class A2dpManager {
    @Volatile
    private var mA2dp: BluetoothA2dp? = null
    private var mAdapter: BluetoothAdapter? = BluetoothAdapter.getDefaultAdapter()

    @Volatile
    private var mAlreadyRegistered = false

    object Holder {
        val manager = A2dpManager()
    }

    companion object {
        @JvmStatic
        val instance = Holder.manager
    }

    fun initA2dpListener(): Boolean {
        try {
            if (mAlreadyRegistered) {
                return true
            }
            if (IDOPermission.hasOnlyBlePermission(Config.getApplication())) {
                mAdapter?.getProfileProxy(Config.getApplication(), MyProfileServiceListener(), BluetoothProfile.A2DP)
                logP("registerA2DPStateListener success")
                mAlreadyRegistered = true
                return true
            } else {
                logP("registerA2DPStateListener, no ble permission")
            }
        } catch (e: Exception) {
            logP("registerA2DPStateListener error: $e")
        }
        return false
    }

    /**
     * 获取设备的a2dp连接状态
     */
    @SuppressLint("MissingPermission")
    fun getA2dpState(deviceAddress: String): Int {
        var state = BluetoothProfile.STATE_DISCONNECTED
        if (IDOPermission.hasOnlyBlePermission(Config.getApplication())) {
            if (mA2dp != null) {
                state = mA2dp!!.getConnectionState(BluetoothAdapter.getDefaultAdapter().getRemoteDevice(deviceAddress))
                logP("getA2dpState state = $state")
            } else {
                state = BluetoothAdapter.getDefaultAdapter().getProfileConnectionState(BluetoothProfile.A2DP)
                logP("getA2dpState use default state = $state")
            }
        } else {
            logP("getA2dpState no ble permission")
        }
        return state
    }


    private inner class MyProfileServiceListener : BluetoothProfile.ServiceListener {
        @SuppressLint("MissingPermission")
        override fun onServiceConnected(profile: Int, proxy: BluetoothProfile?) {
            if (profile == BluetoothProfile.A2DP) {
                logP("onServiceConnected, A2DP service connected")
                mA2dp = proxy as BluetoothA2dp?
            }
        }

        override fun onServiceDisconnected(profile: Int) {
            if (profile == BluetoothProfile.A2DP) {
                logP("onServiceConnected, A2DP service disconnected")
                mA2dp = null
            }
        }

    }

    private fun logP(msg: String) {
        Logger.p("[A2dpManager]$msg")
    }
}